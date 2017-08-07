/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Controller for the VF page that clones the Product Confguration with its children
* Covered by CloneProductConfigurationTest
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Initial implementation
* @author		Lucian Ciobanu <lucian.ciobanu@deutoria.com>
* @created		2017-02-10
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Changes
*
*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
*/
public with Sharing class CloneProductConfiguration {

    public Id prodConfigId {get; set;}
    public Product_Configuration__c prodConfig { get; set; }
    public Product_Configuration__c clone { get; set; }

    public CloneProductConfiguration(ApexPages.StandardController sc){
        prodConfigId = sc.getId();
        
        if (prodConfigId == null) {
        	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'No Product Configuration Id provided.');
     		ApexPages.addMessage(myMsg);
            return;
        }

        string query = getCreatableFieldsSOQL('Product_Configuration__c', 'Id = :prodConfigId') + ' LIMIT 1';
        List<Product_Configuration__c> prodConfigList = Database.query(query);
        if (prodConfigList.size() != 0) {
            prodConfig = prodConfigList.get(0);
        }
        if (prodConfig == null) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Product Configuration with id ' + prodConfigId + ' not found.');
            ApexPages.addMessage(msg);
            return;
        }
        
        clone = prodConfig.clone();
    }
    
    public PageReference CloneRecord() {   
    	
        Savepoint sp = Database.setSavepoint();
        try {
            insert clone;
            string query;
            // Product Materials
            query = getCreatableFieldsSOQL('Product_Material__c', 'Product_Configuration__c = :prodConfigId');
            List<Product_Material__c> childMaterials = new List<Product_Material__c>();
            for (Product_Material__c record : Database.query(query)) {
                Product_Material__c cloneChild = record.clone();
                cloneChild.Product_Configuration__c = clone.Id;
                childMaterials.add(cloneChild);
            }
            insert childMaterials;
            // Product Processes
            query = getCreatableFieldsSOQL('Product_Process__c', 'Product_Configuration__c = :prodConfigId');
            List<Product_Process__c> childProcesses = new List<Product_Process__c>();
            for (Product_Process__c record : Database.query(query)) {
                Product_Process__c cloneChild = record.clone();
                cloneChild.Product_Configuration__c = clone.Id;
                childProcesses.add(cloneChild);
            }
            insert childProcesses;
            // Patterns
            query = getCreatableFieldsSOQL('Pattern__c', 'Product_Configuration__c = :prodConfigId');
            List<Pattern__c> childPatterns = new List<Pattern__c>();
            for (Pattern__c record : Database.query(query)) {
                Pattern__c cloneChild = record.clone();
                cloneChild.Product_Configuration__c = clone.Id;
                childPatterns.add(cloneChild);
            }
            insert childPatterns;
            // Machine Fixtures
            query = getCreatableFieldsSOQL('Machine_Fixture__c', 'Product_Configuration__c = :prodConfigId');
            List<Machine_Fixture__c> childFixtures = new List<Machine_Fixture__c>();
            for (Machine_Fixture__c record : Database.query(query)) {
                Machine_Fixture__c cloneChild = record.clone();
                cloneChild.Product_Configuration__c = clone.Id;
                childFixtures.add(cloneChild);
            }
            insert childFixtures;
            // Product Services
            query = getCreatableFieldsSOQL('Product_Service__c', 'Product_Configuration__c = :prodConfigId');
            List<Product_Service__c> childServices = new List<Product_Service__c>();
            for (Product_Service__c record : Database.query(query)) {
                Product_Service__c cloneChild = record.clone();
                cloneChild.Product_Configuration__c = clone.Id;
                childServices.add(cloneChild);
            }
            insert childServices;
        } catch (Exception ex) {
			Database.rollback(sp);
            ApexPages.addMessages(ex);
            return null;
        }

        PageReference pageRef = new PageReference('/' + clone.Id);
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
    
    // Returns a dynamic SOQL statement for the whole object, includes only creatable fields since we will be inserting a cloned result of this query
	private string getCreatableFieldsSOQL(String objectName, String whereClause){
	 
        String selects = '';
         
        if (whereClause == null || whereClause == ''){ return null; }
         
        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
         
        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                if (fd.isCreateable()){ // field is creatable
                    selectFields.add(fd.getName());
                }
            }
        }
         
        if (!selectFields.isEmpty()){
            for (string s:selectFields){
                selects += s + ',';
            }
            if (selects.endsWith(',')){selects = selects.substring(0,selects.lastIndexOf(','));}
             
        }
         
        return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;
         
    }

}