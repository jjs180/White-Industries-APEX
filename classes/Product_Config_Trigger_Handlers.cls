/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Handler Class for Product Configuration Triggers --- Mainly used for Metal Yield/Price calculations
* covered by Product_Config_Triggers_Test
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Initial implementation
* @author       Jason Sun (jason@cloudmineconsulting.com)
* @created      2017-02-10
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Changes
* ─────────────────────────────────────────────────────────────────────────────────────────────────
*/
public class Product_Config_Trigger_Handlers {

    private static Set<Id> processedProdConfigIds = new Set<Id>();
    
    public static void beforeInsertHandler(List<Product_Configuration__c> newProdConfigList){
        List<Product_Configuration__c> prodConfigsToProcess = new List<Product_Configuration__c>();
        
        for(Product_Configuration__c pc: newProdConfigList){
            if(!processedProdConfigIds.contains(pc.Id) && pc.Product_Category__c != NULL ){
                prodConfigsToProcess.add(pc);
            }
        }
        if(!prodConfigsToProcess.isEmpty()){
            calcMetalPriceandUpdate(prodConfigsToProcess);
        }
    }
    
    public static void beforeUpdateHandler(Map<Id,Product_Configuration__c> newProdConfigMap, Map<Id,Product_Configuration__c> oldProdConfigMap){
        List<Product_Configuration__c> prodConfigsToProcess = new List<Product_Configuration__c>();
        
        for(Product_Configuration__c pc: newProdConfigMap.values()){
            if(!processedProdConfigIds.contains(pc.Id) && pc.Product_Category__c != NULL &&
              (pc.Product_Category__c != oldProdConfigMap.get(pc.Id).Product_Category__c ||
               pc.Yield__c != oldProdConfigMap.get(pc.Id).Yield__c ||
               pc.Net_Wt__c != oldProdConfigMap.get(pc.Id).Net_Wt__c) ){
                prodConfigsToProcess.add(pc);
            }
        }
        if(!prodConfigsToProcess.isEmpty()){
            calcMetalPriceandUpdate(prodConfigsToProcess);
        }        
    } 
    
    private static void calcMetalPriceandUpdate(List<Product_Configuration__c> prodConfigList){
        for(Product_Configuration__c pc: prodConfigList){
            if(pc.Yield__c != NULL && pc.Net_Wt__c != NULL){
                Metal_Rates_Utility utility = new Metal_Rates_Utility(pc.Product_Category__c);
                pc.Actual_Product_Category_Cost__c = utility.getMetalPrice(pc.Yield__c, pc.Net_Wt__c);
            }
        }
    }

    
}