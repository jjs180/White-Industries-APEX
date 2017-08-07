/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Test class for CloneProductConfiguration
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Initial implementation
* @author		Lucian Ciobanu <lucian.ciobanu@deutoria.com>
* @created		2017-02-10
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Changes
*
*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
*/
@isTest
public class CloneProductConfigurationTest {

    public static testMethod void TestClone() {
        
        // Setup data
        Account acc = new Account(Name = 'testAcc');
        insert acc;
        Opportunity opp = new Opportunity(Name = 'testOpp', Account = acc , CloseDate = date.valueOf('2017-10-10') , StageName = 'Collect Information');
        insert opp;
		Product_Configuration__c prodConfig = new Product_Configuration__c(Name = 'testProd', Opportunity__c = opp.Id, Price__c = 12);
        insert prodConfig;
        Material__c m = new Material__c();
        insert m;
        Product_Material__c mat = new Product_Material__c(Product_Configuration__c = prodConfig.Id, Material__c = m.Id);
        insert mat;
        Process__c p = new Process__c();
        insert p;
        Product_Process__c proc = new Product_Process__c(Product_Configuration__c = prodConfig.Id, Process__c = p.Id);
        insert proc;
        Pattern__c patt = new Pattern__c(Product_Configuration__c = prodConfig.Id);
        insert patt;
        Machine_Fixture__c fix = new Machine_Fixture__c(Product_Configuration__c = prodConfig.Id);
        insert fix;
        Service__c s = new Service__c();
        insert s;
        Product_Service__c serv = new Product_Service__c(Product_Configuration__c = prodConfig.Id, Service__c = s.Id);
        insert serv;
        
        
        // Run the code
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(prodConfig);
        CloneProductConfiguration ctrl = new CloneProductConfiguration(sc);
        ctrl.clone.Name = 'testProd2';
        ctrl.CloneRecord();
        ctrl.GoBack();
        Test.stopTest();
        
        // Verify results
        System.assertEquals(2, [SELECT COUNT() FROM Product_Configuration__c]);
        System.assertEquals(2, [SELECT COUNT() FROM Product_Material__c]);
        System.assertEquals(2, [SELECT COUNT() FROM Product_Process__c]);
        System.assertEquals(2, [SELECT COUNT() FROM Pattern__c]);
        System.assertEquals(2, [SELECT COUNT() FROM Machine_Fixture__c]);
        System.assertEquals(2, [SELECT COUNT() FROM Product_Service__c]);
    }
    
}