/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Base class for the sync process - generalized to handle any table / fields based on custom metadata
* Covered by SQLSyncBaseTest, SQLSyncMaterialsTest, SQLSyncProcessesTest
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Initial implementation
* @author		Lucian Ciobanu <lucian@cloudmineconsulting.com>
* @created		2017-03-31
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Changes
*
*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
*/
public class SQLSyncBase implements Queueable, Database.AllowsCallouts {
    
    public integer offset;
    public string tableName;
    public integer noTries;
    public string errorMessage;
    
    public SQLSyncBase(string t) {
        tableName = t;
        offset = 0;
        noTries = 0;
    }
    
    public SQLSyncBase(string t, integer o) {
        tableName = t;
        offset = o;
        noTries = 0;
    }
    
    public SQLSyncBase(string t, integer o, integer n) {
        tableName = t;
        offset = o;
        noTries = n;
    }
    
    public void execute(QueueableContext context) {
	    
        Sync_Setting__mdt settings = [SELECT SQL_Server_Database__c, SQL_Connection_Username__c, SQL_Connection_Password__c, Error_Email_Addresses__c FROM Sync_Setting__mdt LIMIT 1];
        
        integer recs = SyncTable(settings);
        
        // If recs is 100, it means there are probably more, let's queue another one with a higher offset
        if (recs == 100) {
            System.enqueueJob(new SQLSyncBase(tableName, offset + 100));
            return;
        }
        
        // If recs is -1, there's an error
        if (recs == -1) {
            noTries++;
            if (noTries < 3 && !Test.isRunningTest()) {
                // Let's try again with the same offset
                System.enqueueJob(new SQLSyncBase(tableName, offset, noTries));
                return;
            } else {
                // If it failed 3 times, just stop and send an email to admin
                Messaging.reserveSingleEmailCapacity(1);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<String> emailAddresses = new List<String>();
                for (String emailAddress : settings.Error_Email_Addresses__c.split(',')) {
                    emailAddresses.add(emailAddress.trim());
                }
                mail.setToAddresses(emailAddresses);
                mail.setSenderDisplayName('Salesforce - SQL Sync Integration');
                mail.setSubject('SQL Sync Integration Error');
                mail.setUseSignature(false);
                mail.setHtmlBody(errorMessage);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
        
        // Otherwise it's the end of the list, don't enqueue another one
	}
    
    public integer SyncTable(Sync_Setting__mdt settings) {
        
        try {
            Sync_Table__mdt table = [SELECT Salesforce_Table__c, SQL_Table__c, Salesforce_Index_Field__c, SQL_Index_Field__c FROM Sync_Table__mdt WHERE DeveloperName = :tableName LIMIT 1];
            
            Map<string, string> sqlTosfdcColumns = new Map<string, string>();
            //Jason - added index fields to mapping
            sqlTosfdcColumns.put(table.SQL_Index_Field__c, table.Salesforce_Index_Field__c);
            
            string sqlQuery = 'SELECT [' + table.SQL_Index_Field__c + ']';            
            for (Sync_Field__mdt s : [SELECT Salesforce_Field__c, SQL_Field__c FROM Sync_Field__mdt WHERE Sync_Table__c = :table.Id]) {
                sqlQuery += ', [' + s.SQL_Field__c + ']';
                sqlTosfdcColumns.put(s.SQL_Field__c, s.Salesforce_Field__c);
            }
            sqlQuery += ' FROM [' + settings.SQL_Server_Database__c + '].[dbo].[' + table.SQL_Table__c + ']';
            sqlQuery += '  ORDER BY [' + table.SQL_Index_Field__c + '] DESC OFFSET ' + offset + ' ROWS FETCH NEXT 100 ROWS ONLY';
            System.debug(sqlQuery);            

            
            DotNetConnection.ConnectionSoap conn = new dotNetConnection.ConnectionSoap();
            DotNetConnection.QueryRequest req = new dotNetConnection.QueryRequest();
            req.Username = settings.SQL_Connection_Username__c;
            req.Password = settings.SQL_Connection_Password__c;
            req.Query = sqlQuery;
            DotNetConnection.QueryResponse response;
            
            response = conn.Query(req);
            
            if (response.Success == 'true') {
            
                List<sObject> recordsToInsert = new List<sObject>();
                List<sObject> recordsToUpdate = new List<sObject>();
                
                Set<Decimal> soqlIds = new Set<Decimal>();
                for (Integer i = 0; i < response.rows.ArrayOfString.size(); i++) {
                    List<String> row = response.rows.ArrayOfString[i].string_x;
                    soqlIds.add(decimal.valueOf(row[0]));
                }
                
                Map<Decimal, Id> externalToIdMap = new Map<Decimal, Id>();
                String querySOQLString = 'SELECT Id, ' + table.Salesforce_Index_Field__c + ' FROM ' + table.Salesforce_Table__c + ' WHERE ' + table.Salesforce_Index_Field__c + ' IN : soqlIds';
                for (sObject so : Database.query(querySOQLString)) {
                    externalToIdMap.put((decimal)so.get(table.Salesforce_Index_Field__c), so.Id);
                }
                
                Schema.SObjectType t = Schema.getGlobalDescribe().get(table.Salesforce_Table__c); 
                Schema.DescribeSObjectResult r = t.getDescribe();
                Map<string, Schema.SObjectField> fieldsMap = r.fields.getMap();
                
                for (Integer i = 0; i < response.rows.ArrayOfString.size(); i++) {
                    List<String> row = response.rows.ArrayOfString[i].string_x;
                    sObject obj = t.newSObject();
                    if (externalToIdMap.containsKey(decimal.valueOf(row[0]))) {
                        obj.Id = externalToIdMap.get(decimal.valueOf(row[0]));
                        recordsToUpdate.add(obj);
                    } else {
                        recordsToInsert.add(obj);
                    }
                    
                    for(Integer j = 0; j < response.columns.string_x.size(); j++) {
                        string sqlColumn = response.columns.string_x[j];
                        if (sqlTosfdcColumns.containsKey(sqlColumn)) {
                            string sfdcColumn = sqlTosfdcColumns.get(sqlColumn);
                            if (fieldsMap.containsKey(sfdcColumn)) {
                                Schema.DescribeFieldResult field = r.fields.getMap().get(sfdcColumn).getDescribe();
                                if (field.getType() == Schema.DisplayType.Double || field.getType() == Schema.DisplayType.Percent || field.getType() == Schema.DisplayType.Currency) {
                                    obj.put(sfdcColumn, Decimal.valueOf(row[j]));
                                } else if (field.getType() == Schema.DisplayType.DATETIME) {
                                    obj.put(sfdcColumn, DateTime.valueOf(row[j]));
                                } else if (field.getType() == Schema.DisplayType.DATE) {
                                    obj.put(sfdcColumn, Date.valueOf(row[j].substring(0,10)));
                                } else {
                                    obj.put(sfdcColumn, row[j]);
                                }
                            }
                        }
                    }
                }
                
                system.debug('records to Insert----' + recordsToInsert);
                system.debug('records to Update----' + recordsToUpdate);
                
                insert recordsToInsert;
                update recordsToUpdate;
                
                return response.rows.ArrayOfString.size();
            } else {
                // -1 represents error and it should try again
                errorMessage = response.ErrorMessage;
                return -1;
            }
        } catch (Exception ex) {
            // -1 represents error and it should try again
            errorMessage = ex.getMessage() + 'Stack Trace: ' + ex.getStackTraceString();
            return -1;
        }

	}
    
}