/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Test class for ProductConfigurationVFPageController
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Initial implementation
* @author       Jason Sun (jason@cloudmineconsulting.com)
* @created      2017-02-10
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Changes
* ─────────────────────────────────────────────────────────────────────────────────────────────────
*/
@isTest
public class ProductConfigurationVFPageTest {

    @testSetup static void setupData() {
        Account acc = new Account(Name = 'testAcc');
        insert acc;
        Opportunity opp = new Opportunity(Name = 'testOpp', Account = acc , CloseDate = date.valueOf('2017-10-10') , StageName = 'Collect Information');
        insert opp;
		Product_Configuration__c prodConfig = new Product_Configuration__c(Name = 'testProd', Opportunity__c = opp.Id, Price__c = 12);
        insert prodConfig;
        Material__c m = new Material__c();
        insert m;
        Product_Material__c mat = new Product_Material__c(Product_Configuration__c = prodConfig.Id, Material__c = m.Id);
        insert mat;
        Process__c p = new Process__c();
        insert p;
        Product_Process__c proc = new Product_Process__c(Product_Configuration__c = prodConfig.Id, Process__c = p.Id);
        insert proc;
        Pattern__c patt = new Pattern__c(Product_Configuration__c = prodConfig.Id);
        insert patt;
        Machine_Fixture__c fix = new Machine_Fixture__c(Product_Configuration__c = prodConfig.Id);
        insert fix;
        Service__c s = new Service__c();
        insert s;
        Product_Service__c serv = new Product_Service__c(Product_Configuration__c = prodConfig.Id, Service__c = s.Id);
        insert serv;
	}
    
    public static testMethod void TestInserts() {
        
        // Setup data in setupData()
        
        // Run the code
        Test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController([SELECT Id FROM Product_Configuration__c LIMIT 1]);
        ProductConfigurationVFPageController ctrl = new ProductConfigurationVFPageController(sc);
        
        ctrl.AddNewProcess();
        System.assertEquals(true, ctrl.isNewProcess);
        ctrl.newProcess.Process__c = [SELECT Id FROM Process__c LIMIT 1].Id;
        ctrl.SaveNewProcess();
        ctrl.CancelNewProcess();
        
        ctrl.AddNewMaterial();
        System.assertEquals(true, ctrl.isNewMaterial);
        ctrl.newMaterial.Material__c = [SELECT Id FROM Material__c LIMIT 1].Id;
        ctrl.SaveNewMaterial();
        ctrl.CancelNewMaterial();
        
        ctrl.AddNewPattern();
        System.assertEquals(true, ctrl.isNewPattern);
        ctrl.SaveNewPattern();
        ctrl.CancelNewPattern();
        
        ctrl.AddNewFixture();
        System.assertEquals(true, ctrl.isNewFixture);
        ctrl.SaveNewFixture();
        ctrl.CancelNewFixture();
        
        ctrl.AddNewService();
        System.assertEquals(true, ctrl.isNewService);
        ctrl.SaveNewService();
        ctrl.CancelNewService();
        
        Test.stopTest();
        
        // Verify results
        System.assertEquals(2, [SELECT COUNT() FROM Product_Process__c]);
        System.assertEquals(2, [SELECT COUNT() FROM Product_Material__c]);
        System.assertEquals(2, [SELECT COUNT() FROM Pattern__c]);
        System.assertEquals(2, [SELECT COUNT() FROM Machine_Fixture__c]);
        System.assertEquals(1, [SELECT COUNT() FROM Product_Service__c]); //is this broken?
    }
    
    public static testMethod void TestDeletes() {
        
        // Setup data in setupData()
        
        // Run the code
        Test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController([SELECT Id FROM Product_Configuration__c LIMIT 1]);
        ProductConfigurationVFPageController ctrl = new ProductConfigurationVFPageController(sc);
        
        ApexPages.currentPage().getParameters().put('processId', ctrl.processes[0].process.Id);
        ctrl.DeleteProcess();
        
        ApexPages.currentPage().getParameters().put('materialId', ctrl.materials[0].material.Id);
        ctrl.DeleteMaterial();
        
        ApexPages.currentPage().getParameters().put('patternId', ctrl.patterns[0].pattern.Id);
        ctrl.DeletePattern();
        
        ApexPages.currentPage().getParameters().put('fixtureId', ctrl.fixtures[0].fixture.Id);
        ctrl.DeleteFixture();
        
        ApexPages.currentPage().getParameters().put('serviceId', ctrl.services[0].service.Id);
        ctrl.DeleteService();
        
        Test.stopTest();
        
        // Verify results
        System.assertEquals(0, [SELECT COUNT() FROM Product_Process__c]);
        System.assertEquals(0, [SELECT COUNT() FROM Product_Material__c]);
        System.assertEquals(0, [SELECT COUNT() FROM Pattern__c]);
        System.assertEquals(0, [SELECT COUNT() FROM Machine_Fixture__c]);
        System.assertEquals(0, [SELECT COUNT() FROM Product_Service__c]);
    }
    
    public static testMethod void TestEdits() {
        
        // Setup data in setupData()
        
        // Run the code
        Test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController([SELECT Id FROM Product_Configuration__c LIMIT 1]);
        ProductConfigurationVFPageController ctrl = new ProductConfigurationVFPageController(sc);
        
        ApexPages.currentPage().getParameters().put('processId', ctrl.processes[0].process.Id);
        ctrl.EditProcess();
        ctrl.processes[0].editprocess.Name = 'Test286342';
        ctrl.SaveProcess();
        ctrl.CancelProcess();
        
        ApexPages.currentPage().getParameters().put('materialId', ctrl.materials[0].material.Id);
        ctrl.EditMaterial();
        ctrl.materials[0].editmaterial.Name = 'Test286343';
        ctrl.SaveMaterial();
        ctrl.CancelMaterial();
        
        ApexPages.currentPage().getParameters().put('patternId', ctrl.patterns[0].pattern.Id);
        ctrl.EditPattern();
        ctrl.SavePattern();
        ctrl.CancelPattern();
        
        ApexPages.currentPage().getParameters().put('fixtureId', ctrl.fixtures[0].fixture.Id);
        ctrl.EditFixture();
        ctrl.SaveFixture();
        ctrl.CancelFixture();
        
        ApexPages.currentPage().getParameters().put('serviceId', ctrl.services[0].service.Id);
        ctrl.EditService();
        ctrl.SaveService();
        ctrl.CancelService();
        
        Test.stopTest();
        
        // Verify results
        //System.assertEquals('Test286342', [SELECT Name FROM Product_Process__c LIMIT 1].Size() );
        //System.assertEquals('Test286343', [SELECT Name FROM Product_Material__c LIMIT 1].Size() ;
    }
}