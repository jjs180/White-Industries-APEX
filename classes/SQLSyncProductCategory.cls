/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Scheduled class that starts the sync process for Services
* Covered by SQLSyncProductCategoryTest
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Initial implementation
* @author       Lucian Ciobanu <lucian@cloudmineconsulting.com>
* @created      2017-04-11
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Changes
*
*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
*/
global class SQLSyncProductCategory implements Schedulable  {
    
    global void execute(SchedulableContext sc){
        
        System.enqueueJob(new SQLSyncBase('Product_Categories'));
        
    }

}