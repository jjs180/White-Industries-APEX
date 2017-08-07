/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Mock class used by SQLSyncBaseTest
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
@isTest
global class SQLSyncFailMock implements WebServiceMock {
    
   global void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
               
       response.put('response_x', null);
   }
}