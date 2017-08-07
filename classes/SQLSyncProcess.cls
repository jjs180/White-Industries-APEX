/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Scheduled class that starts the sync process for Processes
* Covered by SQLSyncProcessesTest
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
global class SQLSyncProcess implements Schedulable {
    
    global void execute(SchedulableContext sc){
        
        System.enqueueJob(new SQLSyncBase('Processes'));
        
    }

}