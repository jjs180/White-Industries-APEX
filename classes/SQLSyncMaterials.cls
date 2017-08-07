/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Scheduled class that starts the sync process for Materials
* Covered by SQLSyncMaterialsTest
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
global class SQLSyncMaterials implements Schedulable  {
    
    global void execute(SchedulableContext sc){
        
        System.enqueueJob(new SQLSyncBase('Materials'));
        
    }

}