/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Test class for SQLSyncProcess / SQLSyncBase
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
@isTest
public class SQLSyncProcessesTest {

    public static testMethod void TestSync() {
        
        // Setup data
        Process__c p1 = new Process__c();
        p1.Name = 'Process298461';
        p1.Synchro_Index__c = 1;
        insert p1;
        
        Test.setMock(WebServiceMock.class, new SQLSyncProcessesMock());
        
        // Run the code
        Test.startTest();
        SQLSyncProcess ctrl = new SQLSyncProcess();
        ctrl.execute(null);
        Test.stopTest();
        
        // Verify results
        p1 = [SELECT Description__c FROM Process__c WHERE Id = :p1.Id];
        Process__c p2 = [SELECT Description__c FROM Process__c WHERE Id != :p1.Id LIMIT 1];
        System.assertEquals('Description1', p1.Description__c);
        System.assertEquals('Description2', p2.Description__c);
    }

}