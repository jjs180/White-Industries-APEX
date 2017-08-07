/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Test class for SyncOppExtension
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Initial implementation
* @author		Lucian Ciobanu <lucian.ciobanu@deutoria.com>
* @created		2017-02-08
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Changes
*
*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
*/
@isTest
public class SyncOppExtensionTestClass {
    
    @isTest
    private static void TestSyncOppValid(){
        
        // Setup data
        Account acc = new Account(Name = 'testAcc');
        insert acc;
        Opportunity opp = new Opportunity(Name = 'testOpp', Account = acc , CloseDate = date.valueOf('2017-10-10') , StageName = 'Collect Information');
        insert opp;
		Product_Configuration__c prodConfig = new Product_Configuration__c(Name = 'testProd', Opportunity__c = opp.Id, Price__c = 12, Order_Qty__c = 1);
        insert prodConfig;
        ApexPages.StandardController sc = new ApexPages.StandardController(prodConfig);
        SyncOppExtension syncOpp = new SyncOppExtension(sc);
        
        // Run the code
        Test.startTest();
        PageReference pageRef = syncOpp.Sync();
        Test.stopTest();
        
        // Verify results
        opp = [SELECT Id, Synced_Product_Quote__c, Amount FROM Opportunity LIMIT 1];
        System.assertEquals(prodConfig.Id, opp.Synced_Product_Quote__c);
        System.assertEquals(12, opp.Amount);
        
    }
    
    @isTest
    private static void TestSyncOppValid2(){
        
        // Setup data
        Account acc = new Account(Name = 'testAcc');
        insert acc;
        Opportunity opp = new Opportunity(Name = 'testOpp', Account = acc , CloseDate = date.valueOf('2017-10-10') , StageName = 'Collect Information');
        insert opp;
		Product_Configuration__c prodConfig = new Product_Configuration__c(Name = 'testProd', Opportunity__c = opp.Id, Price__c = 12, Order_Qty__c = 1);
        insert prodConfig;
        ApexPages.StandardController sc = new ApexPages.StandardController(prodConfig);
        SyncOppExtension syncOpp = new SyncOppExtension(sc);
        
        // Run the code
        Test.startTest();
        PageReference pageRef = syncOpp.GoBack();        
        Test.stopTest();

        // Verify results
        System.assertEquals('/' + prodConfig.Id, pageRef.getUrl());
        
    }
    
    @isTest
    private static void TestSyncOppInvalid1(){
		
        // Setup data
        Product_Configuration__c prodConfig = new Product_Configuration__c();
        ApexPages.StandardController sc = new ApexPages.StandardController(prodConfig);
        SyncOppExtension syncOpp = new SyncOppExtension(sc);
        
        // Run the code
        Test.startTest();
        PageReference pageRef = syncOpp.Sync();
        syncOpp.GoBack();
        Test.stopTest();
        
		// Verify results
        System.assertEquals(null, pageRef);
        
    }
    
    @isTest
    private static void TestSyncOppInvalid2(){
		
        // Setup data
        Account acc = new Account(Name = 'testAcc');
        insert acc;
        Opportunity opp = new Opportunity(Name = 'testOpp', Account = acc , CloseDate = date.valueOf('2017-10-10') , StageName = 'Collect Information');
        insert opp;
		Product_Configuration__c prodConfig = new Product_Configuration__c(Name = 'testProd', Price__c = 12, Order_Qty__c = 1);
        insert prodConfig;
        ApexPages.StandardController sc = new ApexPages.StandardController(prodConfig);
        SyncOppExtension syncOpp = new SyncOppExtension(sc);
        
        // Run the code
        Test.startTest();
        PageReference pageRef = syncOpp.Sync();
        syncOpp.GoBack();
        Test.stopTest();
        
        // Verify results
        System.assertEquals(null, pageRef);        
    }

}