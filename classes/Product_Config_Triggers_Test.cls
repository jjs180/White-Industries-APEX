/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Test class for Product_Config_Triggers, Metal_Rates_Utility & Product_Config_Trigger_Handlers
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Initial implementation
* @author       Jason Sun (jason@cloudmineconsulting.com)
* @created      2017-2-10
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Changes
* ─────────────────────────────────────────────────────────────────────────────────────────────────
*/
@isTest
public class Product_Config_Triggers_Test {

    public static testMethod void Test1() {
        
        // Setup data
        Metal_Price_Adjust_Factors__c factor1 = new Metal_Price_Adjust_Factors__c(Name = '150_750kg', Type__c = '150_750kg', Net_Weight__c = 5, Band_Adj_Factor__c = 1);
        Metal_Price_Adjust_Factors__c factor2 = new Metal_Price_Adjust_Factors__c(Name = 'JobBott', Type__c = 'JobBott', Net_Weight__c =  10, Band_Adj_Factor__c = 1);
        Metal_Price_Adjust_Factors__c factor3 = new Metal_Price_Adjust_Factors__c(Name = 'BMD', Type__c = 'BMD', Net_Weight__c =  15, Band_Adj_Factor__c = 1);
        insert new List<Metal_Price_Adjust_Factors__c> { factor1, factor2 };
            
        Account acc = new Account(Name = 'testAcc');
        insert acc;
        Opportunity opp = new Opportunity(Name = 'testOpp', Account = acc , CloseDate = date.valueOf('2017-10-10') , StageName = 'Collect Information');
        insert opp;
        Product_Category__c pc1 = new Product_Category__c(Name = '150kg BMD', Range1__c = '40/60', Range2__c = '50/50', Range3__c = '60/40', Range4__c = '70/30', Range5__c = '80/20', Range6__c = '90/10',
                                                         Rate1__c = 4, Rate2__c = 5, Rate3__c = 6, Rate4__c = 7, Rate5__c = 8, Rate6__c = 9, Cost__c = 10);
        insert pc1;
        Product_Category__c pc2 = new Product_Category__c(Name = 'Job', Range1__c = '40/60', Range2__c = '50/50', Range3__c = '60/40', Range4__c = '70/30', Range5__c = '80/20', Range6__c = '90/10',
                                                         Rate1__c = 4, Rate2__c = 5, Rate3__c = 6, Rate4__c = 7, Rate5__c = 8, Rate6__c = 9, Cost__c = 10);
        insert pc2;          
        
        // Run the code
        Test.startTest();
		
        Product_Configuration__c prodConfig = new Product_Configuration__c(Name = 'testProd', Opportunity__c = opp.Id, Price__c = 12, Product_Category__c = pc1.Id, Yield__c = 0.40, Net_Wt__c = 10);
        insert prodConfig;
        
        Product_Configuration__c prodConfig2 = new Product_Configuration__c(Name = 'testProd2', Opportunity__c = opp.Id, Price__c = 12, Product_Category__c = pc1.Id, Yield__c = 0.50, Net_Wt__c = 10);
        insert prodConfig2;
        
        prodConfig.Product_Category__c = pc2.Id;
        update prodConfig;
        
        Test.stopTest();
        
        // Verify results
        prodConfig = [SELECT Actual_Product_Category_Cost__c FROM Product_Configuration__c WHERE Id = :prodConfig.Id];
        system.debug(prodConfig.Actual_Product_Category_Cost__c);
        System.assertEquals(4, prodConfig.Actual_Product_Category_Cost__c);
    }
    
}