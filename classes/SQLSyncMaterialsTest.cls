/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Test class for SQLSyncMaterials / SQLSyncBase
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
public class SQLSyncMaterialsTest {

    public static testMethod void TestSync() {
        
        // Setup data
        Material__c m1 = new Material__c();
        m1.Name = 'Material298461';
        m1.Synchro_Index__c = 1;
        insert m1;
        
        Test.setMock(WebServiceMock.class, new SQLSyncMaterialsMock());
        
        // Run the code
        Test.startTest();
        SQLSyncMaterials ctrl = new SQLSyncMaterials();
        ctrl.execute(null);
        Test.stopTest();
        
        // Verify results
        m1 = [SELECT Description__c FROM Material__c WHERE Id = :m1.Id];
        Material__c m2 = [SELECT Description__c FROM Material__c WHERE Id != :m1.Id LIMIT 1];
        System.assertEquals('Description1', m1.Description__c);
        System.assertEquals('Description2', m2.Description__c);
    }
    
}