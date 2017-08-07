/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Mock class used by SQLSyncMaterialsTest
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
global class SQLSyncMaterialsMock implements WebServiceMock {
    
   global void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
               
       DotNetConnection.QueryResponse_element respElement = new DotNetConnection.QueryResponse_element();
       respElement.QueryResult = new DotNetConnection.QueryResponse();
       respElement.QueryResult.Success = 'true';
       respElement.QueryResult.columns = new DotNetConnection.ArrayOfString();
       respElement.QueryResult.columns.string_x = new String[] { 'Index', 'Name', 'Description' };
       respElement.QueryResult.rows = new DotNetConnection.ArrayOfArrayOfString();
       DotNetConnection.ArrayOfString a1 = new DotNetConnection.ArrayOfString();
       a1.string_x = new String[] { '1', 'Name1', 'Description1' };
       DotNetConnection.ArrayOfString a2 = new DotNetConnection.ArrayOfString();
       a2.string_x = new String[] { '2', 'Name2', 'Description2' };
       respElement.QueryResult.rows.ArrayOfString = new DotNetConnection.ArrayOfString[]{ a1, a2 };
       response.put('response_x', respElement);
   }
}