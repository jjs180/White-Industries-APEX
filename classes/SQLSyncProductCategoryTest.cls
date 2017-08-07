/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Test class for SQLSyncProductCategory / SQLSyncBase
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
public class SQLSyncProductCategoryTest {

    public static testMethod void TestSync() {
        
        // Setup data
        Product_Category__c m1 = new Product_Category__c();
        m1.Name = 'Service298461';
        m1.Synchro_Index__c = 1;
        insert m1;
        
        Test.setMock(WebServiceMock.class, new SQLSyncProductCategoryMock());
        
        // Run the code
        Test.startTest();
        SQLSyncProductCategory ctrl = new SQLSyncProductCategory();
        ctrl.execute(null);
        Test.stopTest();
        
        // Verify results
        m1 = [SELECT Description__c FROM Product_Category__c WHERE Id = :m1.Id];
        Product_Category__c m2 = [SELECT Description__c FROM Product_Category__c WHERE Id != :m1.Id LIMIT 1];
        System.assertEquals('100', m1.Description__c);
        System.assertEquals('200', m2.Description__c);
    }
    
}