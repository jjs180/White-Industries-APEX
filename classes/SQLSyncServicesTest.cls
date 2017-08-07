/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Test class for SQLSyncServices / SQLSyncBase
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Initial implementation
* @author		Lucian Ciobanu <lucian@cloudmineconsulting.com>
* @created		2017-04-11
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Changes
*
*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
*/
@isTest
public class SQLSyncServicesTest {

    public static testMethod void TestSync() {
        
        // Setup data
        Service__c m1 = new Service__c();
        m1.Name = 'Service298461';
        m1.Synchro_Index__c = 1;
        insert m1;
        
        Test.setMock(WebServiceMock.class, new SQLSyncServicesMock());
        
        // Run the code
        Test.startTest();
        SQLSyncServices ctrl = new SQLSyncServices();
        ctrl.execute(null);
        Test.stopTest();
        
        // Verify results
        m1 = [SELECT Price__c FROM Service__c WHERE Id = :m1.Id];
        Service__c m2 = [SELECT Price__c FROM Service__c WHERE Id != :m1.Id LIMIT 1];
        System.assertEquals(100, m1.Price__c);
        System.assertEquals(200, m2.Price__c);
    }
    
}