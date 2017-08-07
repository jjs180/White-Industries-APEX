/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Product Configuration Triggers
* covered by Product_Config_Triggers_Test
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Initial implementation
* @author       Jason Sun (jason@cloudmineconsulting.com)
* @created      2017-2-10
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Changes
* ─────────────────────────────────────────────────────────────────────────────────────────────────
*/
trigger Product_Config_Triggers on Product_Configuration__c (before insert, before update) {

    if(trigger.isbefore){
        if(trigger.isInsert){
            Product_Config_Trigger_Handlers.beforeInsertHandler(trigger.new);
        }
        else if(trigger.isUpdate){
            Product_Config_Trigger_Handlers.beforeUpdateHandler(trigger.newMap, trigger.oldMap);
        }
    }
    
}