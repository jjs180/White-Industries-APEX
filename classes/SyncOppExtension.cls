/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Controller for the VF page that Syncs the Product Confguration with the Opportunity
* Covered by SyncOppExtensionTestClass
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
public with Sharing class SyncOppExtension {

    public Id prodConfigId {get; set;}

    public SyncOppExtension(ApexPages.StandardController sc){
        prodConfigId = sc.getId();
    }
    
    public PageReference Sync() {   
    	if (prodConfigId == null) {
        	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'No Product Configuration Id provided.');
     		ApexPages.addMessage(myMsg);
            return null;
        }

        List<Product_Configuration__c> prodConfigList = [SELECT Id, Order_Total__c, Opportunity__c FROM Product_Configuration__c WHERE Id =: prodConfigId LIMIT 1];        
        Product_Configuration__c prodConfig = null;
        if (prodConfigList.size() != 0) {
            prodConfig = prodConfigList.get(0);
        }
        if (prodConfig == null) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Product Configuration with id ' + prodConfigId + ' not found.');
            ApexPages.addMessage(msg);
            return null;
        }
        
        if (prodConfig.Opportunity__c == null) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'This Product Configuration record does not have an Opportunity attached to id.');
            ApexPages.addMessage(msg);
            return null;
        }
        Opportunity opp = [SELECT Id, Synced_Product_Quote__c FROM Opportunity Where ID = :prodConfig.Opportunity__c LIMIT 1];
        
        opp.Synced_Product_Quote__c = prodConfig.Id;
        opp.Amount = prodConfig.Order_Total__c;
               
        try {
            update opp;
        } catch (Exception ex) {
            ApexPages.addMessages(ex);
            return null;
        }

        PageReference pageRef = new PageReference('/' + prodConfig.Id);
        pageRef.setRedirect(true);
        return pageref;
    }
    
    public PageReference GoBack() {
        if (prodConfigId == null) {
            PageReference pageRef = new PageReference('/' + Product_Configuration__c.sObjectType.getDescribe().getKeyPrefix());
            pageRef.setRedirect(true);
            return pageref;
        } else {
            PageReference pageRef = new PageReference('/' + prodConfigId);
            pageRef.setRedirect(true);
            return pageref; 
        }
    }

}