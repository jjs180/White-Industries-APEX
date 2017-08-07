/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Controller class for the custom Product Configuration VF page
* covered by ProductConfigurationVFPageTest
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Initial implementation
* @author       Jason Sun (jason@cloudmineconsulting.com)
* @created      2017-02-10
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Changes		Jason Sun - 2017-03-28:  Added logic and member variables for paint and certification presence
* ─────────────────────────────────────────────────────────────────────────────────────────────────
*/
global without sharing class ProductConfigurationVFPageController {
    
    public Id prodConfigId { get; set; }
    public boolean hasPattern {get;set;}
    public boolean hasMachineFixture {get;set;}
    
    public ProductConfigurationVFPageController(ApexPages.StandardController sc){
        prodConfigId = sc.getId();
        String query;
        
        processes = new List<ProductProcessWrapper>();
        query = getQuery('Product_Process__c', SObjectType.Product_Process__c.FieldSets.Mass_Edit_Fields.getFields());
        for(Product_Process__c proc : Database.query(query)){
            ProductProcessWrapper p = new ProductProcessWrapper(proc); 
            processes.add(new ProductProcessWrapper(proc));
        }
        
        materials = new List<ProductMaterialWrapper>();
        query = getQuery('Product_Material__c', SObjectType.Product_Material__c.FieldSets.Mass_Edit_Fields.getFields());
        for(Product_Material__c mat : Database.query(query)){
            materials.add(new ProductMaterialWrapper(mat));
        }
        
        patterns = new List<PatternWrapper>();
        query = getQuery('Pattern__c', SObjectType.Pattern__c.FieldSets.Mass_Edit_Fields.getFields());
        for(Pattern__c mat : Database.query(query)){
            patterns.add(new PatternWrapper(mat));
            hasPattern = true;
        }
        
        fixtures = new List<FixtureWrapper>();
        query = getQuery('Machine_Fixture__c', SObjectType.Machine_Fixture__c.FieldSets.Mass_Edit_Fields.getFields());
        for(Machine_Fixture__c mat : Database.query(query)){
            fixtures.add(new FixtureWrapper(mat));
            hasMachineFixture = true;
        }
        
        services = new List<ProductServiceWrapper>();
        query = getQuery('Product_Service__c', SObjectType.Product_Service__c.FieldSets.Mass_Edit_Fields.getFields());
        for(Product_Service__c mat : Database.query(query)){
            services.add(new ProductServiceWrapper(mat));
        }
    }
    
    public string getPainted(){
        for(Product_Process__c pp: [SELECT Process__r.Name FROM Product_Process__c WHERE Product_Configuration__c =:prodConfigId] ){
            if(pp.Process__r.Name == 'PAINT'){
                return 'Painted';
            }
        }
        return 'Unpainted';
    }
    
    public boolean getHasCertification(){
        for(Product_Service__c ps: [SELECT Service__r.Service_Family__c FROM Product_Service__c WHERE Product_Configuration__c =:prodConfigId] ){
            if(ps.Service__r.Service_Family__c == 'Certification'){
                return true;
            }
        }
        return false;
    }    
    
    private string getQuery(string objectName, List<Schema.FieldSetMember> fields) {
        string query = 'SELECT Id';
        for (Schema.FieldSetMember f : fields) {
            query += ', ' + f.getFieldPath();
        }
        query += ' FROM ' + objectName + ' WHERE Product_Configuration__c = :prodConfigId';
        return query;
    }
    
    // Processes
    public List<ProductProcessWrapper> processes { get; set; }
    public Product_Process__c newProcess{ get; set; }
    public boolean isNewProcess {
        get {
            return newProcess != null;
        }
    }
    
    public void AddNewProcess(){
        newProcess = new Product_Process__c();
    }
    
    public void SaveNewProcess(){
        if(newProcess != null){
            try{
                newProcess.Product_Configuration__c = prodConfigId;
                insert newProcess;   
                processes.add(new ProductProcessWrapper(newProcess));
                newProcess = null;
            }
            catch(Exception ex){
                ApexPages.addMessages(ex);
            }
        }
    }
    
    public void CancelNewProcess(){
        newProcess = null;
    }
    
    public void EditProcess(){
        Id processId = ApexPages.currentPage().getParameters().get('processId');
        CancelProcess();
        for(ProductProcessWrapper p : processes){
            if(p.process.Id == processId ){
                p.editmode = true;
                p.editProcess = p.process.clone();
            }
        }
    }
    
    public void SaveProcess(){
        for(ProductProcessWrapper pm : processes){
            if(pm.editmode){
                try{
                    Map<String, Schema.SObjectField> fieldmap = Schema.SObjectType.Product_Process__c.fields.getMap();
                    for (Schema.FieldSetMember f : SObjectType.Product_Process__c.FieldSets.Mass_Edit_Fields.getFields()) {
                        if (fieldmap.get(f.getFieldPath()).getDescribe().isUpdateable()) {
                        	pm.process.put(f.getFieldPath(), pm.editProcess.get(f.getFieldPath()));
                        }
                    }
                    update pm.process;                   
                    pm.editmode = false;
                }
                catch(Exception ex){
                    ApexPages.addMessages(ex);
                }
            }
        }
    }
    
    public void CancelProcess(){
        for(ProductProcessWrapper pm : processes){
            pm.editmode = false;
        }
    }
    
    public void DeleteProcess(){
        Id processId = ApexPages.currentPage().getParameters().get('processId');
        CancelProcess();
        integer i = 0;
        for(ProductProcessWrapper p : processes){
            if(p.process.Id == processId){
            	delete p.process;                
            	processes.remove(i);
                return;
            }
            i++;
        }
    }
    
	public class ProductProcessWrapper{
        public Product_Process__c process {get; set;}
        public Product_Process__c editProcess {get; set;}
        public boolean editmode {get; set;}
        public ProductProcessWrapper(Product_Process__c p){
            process = p;
            editmode = false;
        }
	}
    
    // Materials
    public List<ProductMaterialWrapper> materials { get; set; }
	public Product_Material__c newMaterial{ get; set; }
    public boolean isNewMaterial {
        get {
            return newMaterial != null;
        }
    }
    
    public void AddNewMaterial(){
        newMaterial = new Product_Material__c();
    }
    
    public void SaveNewMaterial(){
        if(newMaterial != null){
            try{
                newMaterial.Product_Configuration__c = prodConfigId;
                insert newMaterial;
                materials.add(new ProductMaterialWrapper(newMaterial));
                newMaterial = null;
            }
            catch(Exception ex){
                ApexPages.addMessages(ex);
            }
        }
    }
    
    public void CancelNewMaterial(){
        newMaterial = null;
    }
    
    public void EditMaterial(){
        Id materialId = ApexPages.currentPage().getParameters().get('materialId');
        CancelMaterial();
        for(ProductMaterialWrapper p : materials){
            if(p.material.Id == materialId ){
                p.editmode = true;
                p.editMaterial = p.material.clone();
            }
        }
    }
    
    public void SaveMaterial(){
        for(ProductMaterialWrapper pm : materials){
            if(pm.editmode){
                try {
                    Map<String, Schema.SObjectField> fieldmap = Schema.SObjectType.Product_Material__c.fields.getMap();
                    for (Schema.FieldSetMember f : SObjectType.Product_Material__c.FieldSets.Mass_Edit_Fields.getFields()) {
                        if (fieldmap.get(f.getFieldPath()).getDescribe().isUpdateable()) {
                        	pm.material.put(f.getFieldPath(), pm.editMaterial.get(f.getFieldPath()));
                        }
                    }
                    update pm.material;                   
                    pm.editmode = false;
                }
                catch(Exception ex){
                    ApexPages.addMessages(ex);
                }
            }
        }
    }
    
    public void CancelMaterial(){
        for(ProductMaterialWrapper pm : materials){
            pm.editmode = false;
        }
    }
    
    public void DeleteMaterial(){
        Id materialId = ApexPages.currentPage().getParameters().get('materialId');
        CancelMaterial();
        integer i = 0;
        for(ProductMaterialWrapper p : materials){
            if(p.material.Id == materialId){
            	delete p.material;                
            	materials.remove(i);
                return;
            }
            i++;
        }
    }
    
	class ProductMaterialWrapper{
        public Product_Material__c material {get; set;}
        public Product_Material__c editMaterial {get; set;}
        public boolean editmode {get; set;}
        public ProductMaterialWrapper(Product_Material__c m){
             material = m;
             editmode = false;
        }
    }    
    
    // Patterns
    public List<PatternWrapper> patterns { get; set; }
	public Pattern__c newPattern{ get; set; }
    public boolean isNewPattern {
        get {
            return newPattern != null;
        }
    }
    
    public void AddNewPattern(){
        newPattern = new Pattern__c();
    }
    
    public void SaveNewPattern(){
        if(newPattern != null){
            try{
                newPattern.Product_Configuration__c = prodConfigId;
                insert newPattern;
                patterns.add(new PatternWrapper(newPattern));
                newPattern = null;
            }
            catch(Exception ex){
                ApexPages.addMessages(ex);
            }
        }
    }
    
    public void CancelNewPattern(){
        newPattern = null;
    }
    
    public void EditPattern(){
        Id patternId = ApexPages.currentPage().getParameters().get('patternId');
        CancelPattern();
        for(PatternWrapper p : patterns){
            if(p.pattern.Id == patternId ){
                p.editmode = true;
                p.editPattern = p.pattern.clone();
            }
        }
    }
    
    public void SavePattern(){
        for(PatternWrapper pm : patterns){
            if(pm.editmode){
                try {
                    Map<String, Schema.SObjectField> fieldmap = Schema.SObjectType.Pattern__c.fields.getMap();
                    for (Schema.FieldSetMember f : SObjectType.Pattern__c.FieldSets.Mass_Edit_Fields.getFields()) {
                        if (fieldmap.get(f.getFieldPath()).getDescribe().isUpdateable()) {
                        	pm.pattern.put(f.getFieldPath(), pm.editPattern.get(f.getFieldPath()));
                        }
                    }
                    update pm.pattern;                   
                    pm.editmode = false;
                }
                catch(Exception ex){
                    ApexPages.addMessages(ex);
                }
            }
        }
    }
    
    public void CancelPattern(){
        for(PatternWrapper pm : patterns){
            pm.editmode = false;
        }
    }
    
    public void DeletePattern(){
        Id patternId = ApexPages.currentPage().getParameters().get('patternId');
        CancelPattern();
        integer i = 0;
        for(PatternWrapper p : patterns){
            if(p.pattern.Id == patternId){
            	delete p.pattern;                
            	patterns.remove(i);
                return;
            }
            i++;
        }
    }
    
	class PatternWrapper{
        public Pattern__c pattern {get; set;}
        public Pattern__c editPattern {get; set;}
        public boolean editmode {get; set;}
        public PatternWrapper(Pattern__c m){
             pattern = m;
             editmode = false;
        }
    }  
    
    // Machine Fixtures
    public List<FixtureWrapper> fixtures { get; set; }
	public Machine_Fixture__c newFixture{ get; set; }
    public boolean isNewFixture {
        get {
            return newFixture != null;
        }
    }
    
    public void AddNewFixture(){
        newFixture = new Machine_Fixture__c();
    }
    
    public void SaveNewFixture(){
        if(newFixture != null){
            try{
                newFixture.Product_Configuration__c = prodConfigId;
                insert newFixture;
                fixtures.add(new FixtureWrapper(newFixture));
                newFixture = null;
            }
            catch(Exception ex){
                ApexPages.addMessages(ex);
            }
        }
    }
    
    public void CancelNewFixture(){
        newFixture = null;
    }
    
    public void EditFixture(){
        Id fixtureId = ApexPages.currentPage().getParameters().get('fixtureId');
        CancelFixture();
        for(FixtureWrapper p : fixtures){
            if(p.fixture.Id == fixtureId ){
                p.editmode = true;
                p.editFixture = p.fixture.clone();
            }
        }
    }
    
    public void SaveFixture(){
        for(FixtureWrapper pm : fixtures){
            if(pm.editmode){
                try {
                    Map<String, Schema.SObjectField> fieldmap = Schema.SObjectType.Machine_Fixture__c.fields.getMap();
                    for (Schema.FieldSetMember f : SObjectType.Machine_Fixture__c.FieldSets.Mass_Edit_Fields.getFields()) {
                        if (fieldmap.get(f.getFieldPath()).getDescribe().isUpdateable()) {
                        	pm.fixture.put(f.getFieldPath(), pm.editFixture.get(f.getFieldPath()));
                        }
                    }
                    update pm.fixture;                   
                    pm.editmode = false;
                }
                catch(Exception ex){
                    ApexPages.addMessages(ex);
                }
            }
        }
    }
    
    public void CancelFixture(){
        for(FixtureWrapper pm : fixtures){
            pm.editmode = false;
        }
    }
    
    public void DeleteFixture(){
        Id fixtureId = ApexPages.currentPage().getParameters().get('fixtureId');
        CancelFixture();
        integer i = 0;
        for(FixtureWrapper p : fixtures){
            if(p.fixture.Id == fixtureId){
            	delete p.fixture;                
            	fixtures.remove(i);
                return;
            }
            i++;
        }
    }
    
	class FixtureWrapper{
        public Machine_Fixture__c fixture {get; set;}
        public Machine_Fixture__c editFixture {get; set;}
        public boolean editmode {get; set;}
        public FixtureWrapper(Machine_Fixture__c m){
             fixture = m;
             editmode = false;
        }
    }  
    
    // Product Services
    public List<ProductServiceWrapper> services { get; set; }
	public Product_Service__c newService{ get; set; }
    public boolean isNewService {
        get {
            return newService != null;
        }
    }
    
    public void AddNewService(){
        newService = new Product_Service__c();
    }
    
    public void SaveNewService(){
        if(newService != null){
            try{
                newService.Product_Configuration__c = prodConfigId;
                insert newService;
                services.add(new ProductServiceWrapper(newService));
                newService = null;
            }
            catch(Exception ex){
                ApexPages.addMessages(ex);
            }
        }
    }
    
    public void CancelNewService(){
        newService = null;
    }
    
    public void EditService(){
        Id serviceId = ApexPages.currentPage().getParameters().get('serviceId');
        CancelService();
        for(ProductServiceWrapper p : services){
            if(p.service.Id == serviceId ){
                p.editmode = true;
                p.editService = p.service.clone();
            }
        }
    }
    
    public void SaveService(){
        for(ProductServiceWrapper pm : services){
            if(pm.editmode){
                try {
                    Map<String, Schema.SObjectField> fieldmap = Schema.SObjectType.Product_Service__c.fields.getMap();
                    for (Schema.FieldSetMember f : SObjectType.Product_Service__c.FieldSets.Mass_Edit_Fields.getFields()) {
                        if (fieldmap.get(f.getFieldPath()).getDescribe().isUpdateable()) {
                        	pm.service.put(f.getFieldPath(), pm.editService.get(f.getFieldPath()));
                        }
                    }
                    update pm.service;                   
                    pm.editmode = false;
                }
                catch(Exception ex){
                    ApexPages.addMessages(ex);
                }
            }
        }
    }
    
    public void CancelService(){
        for(ProductServiceWrapper pm : services){
            pm.editmode = false;
        }
    }
    
    public void DeleteService(){
        Id serviceId = ApexPages.currentPage().getParameters().get('serviceId');
        CancelService();
        integer i = 0;
        for(ProductServiceWrapper p : services){
            if(p.service.Id == serviceId){
            	delete p.service;                
            	services.remove(i);
                return;
            }
            i++;
        }
    }
    
	class ProductServiceWrapper{
        public Product_Service__c service {get; set;}
        public Product_Service__c editService {get; set;}
        public boolean editmode {get; set;}
        public ProductServiceWrapper(Product_Service__c m){
             service = m;
             editmode = false;
        }
    }  
}