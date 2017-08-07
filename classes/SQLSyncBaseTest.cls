/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Test class for SQLSyncBase (failure)
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
public class SQLSyncBaseTest {

    public static testMethod void TestSyncFail() {
        
        // Setup data
        
        Test.setMock(WebServiceMock.class, new SQLSyncFailMock());
        
        // Run the code
        Test.startTest();
        SQLSyncMaterials ctrl = new SQLSyncMaterials();
        ctrl.execute(null);
        Test.stopTest();
        
        // Verify results
    }

}