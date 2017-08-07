/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Utility Class to help abstract the metal rates ranges and yields from Product Category
* and calculate the final metal cost based on custom rules
* covered by Product_Config_Triggers_Test
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Initial implementation
* @author       Jason Sun (jason@cloudmineconsulting.com)
* @created      2017-02-10
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Changes
* ─────────────────────────────────────────────────────────────────────────────────────────────────
*/
public class Metal_Rates_Utility {

    //inputs from Product Category Data
	private Id ProductCategoryId;
    private decimal cost;
	private decimal rate1;
	private decimal rate2;
	private decimal rate3;
	private decimal rate4;
	private decimal rate5;
	private decimal rate6;    
    private decimal range1;
    private decimal range2;
    private decimal range3;
    private decimal range4;
    private decimal range5;
    private decimal range6;
    private decimal netWeight;
    
    //calculated values
    private decimal band;
    private boolean nonFerrous;
    private boolean kg150_750;
    private boolean BMD;
    private boolean Job_Bott_Pour;

    public Metal_Rates_Utility(Id Product_Category_Id){
        List<Product_Category__c> prodCatList = [SELECT Name, Cost__c, Rate1__c, Rate2__c, Rate3__c, Rate4__c, Rate5__c, Rate6__c,
                                              Range1__c, Range2__c, Range3__c, Range4__c, Range5__c, Range6__c 
                                              FROM Product_Category__c WHERE Id =:Product_Category_Id LIMIT 1];
        if(!prodCatList.isEmpty()){
            this.ProductCategoryId = prodCatList[0].Id;
            this.cost = prodCatList[0].Cost__c;
            this.rate1 = prodCatList[0].Rate1__c;
            this.rate2 = prodCatList[0].Rate2__c;
            this.rate3 = prodCatList[0].Rate3__c;
            this.rate4 = prodCatList[0].Rate4__c;
            this.rate5 = prodCatList[0].Rate5__c;
            this.rate6 = prodCatList[0].Rate6__c;
			
            this.range1 = getFormattedRange(prodCatList[0].Range1__c);
            this.range2 = getFormattedRange(prodCatList[0].Range2__c);
            this.range3 = getFormattedRange(prodCatList[0].Range3__c);
            this.range4 = getFormattedRange(prodCatList[0].Range4__c);
            this.range5 = getFormattedRange(prodCatList[0].Range5__c);
            this.range6 = getFormattedRange(prodCatList[0].Range6__c);    
			
            string metalName = prodCatList[0].Name;
            this.nonFerrous = (metalName.containsIgnoreCase('AL') || metalName.containsIgnoreCase('CU') ) ? true : false;
            this.kg150_750 = (metalName.containsIgnoreCase('150kg') || metalName.containsIgnoreCase('750kg') ) ? true : false;
    		this.BMD = (metalName.containsIgnoreCase('BMD')) ? true : false;
			this.Job_Bott_Pour = (metalName.containsIgnoreCase('Job') || metalName.containsIgnoreCase('Bott') ) ? true : false;
        }        
    }
    
    //Main method we'll use to set the price
    public decimal getMetalPrice(decimal yield, decimal netWeight){
        setBand(yield);
        setNetWeight(netWeight);
        
        return getNonFerrousPrice() + get150_750kg_Price() + getBMDPrice() + getJob_Bott_Price();
    }
    
    private decimal getNonFerrousPrice(){
        if(this.nonFerrous){
            return this.band;
        }
        return 0;
    }
    
    private decimal get150_750kg_Price(){
        if(this.kg150_750){
            //get the weight bands from custom settings by increasing net weight
            List<Metal_Price_Adjust_Factors__c > weightBands = [SELECT Net_Weight__c, Band_Adj_Factor__c FROM Metal_Price_Adjust_Factors__c  WHERE Type__c = '150_750kg' ORDER BY Net_Weight__c ASC];
			//loop through and use the first instance the net weight setting
			//exceeds or equals the metal's net weight
            for(Metal_Price_Adjust_Factors__c band: weightBands){
                if(band.Net_Weight__c >= this.netWeight ){
                    return (this.band * band.Band_Adj_Factor__c);
                }
            }
        }   
        return 0;
    }   
    
    private decimal getBMDPrice(){
        if(this.BMD){
            //get the weight bands from custom settings by increasing net weight
            List<Metal_Price_Adjust_Factors__c > weightBands = [SELECT Net_Weight__c, Band_Adj_Factor__c FROM Metal_Price_Adjust_Factors__c  WHERE Type__c = 'BMD' ORDER BY Net_Weight__c ASC];
			//loop through and use the first instance the net weight setting
			//exceeds or equals the metal's net weight
            for(Metal_Price_Adjust_Factors__c band: weightBands){
                if(band.Net_Weight__c >= this.netWeight ){
                    return (this.band * band.Band_Adj_Factor__c);
                }
            }			            
        }   
        return 0;
    }
    
    private decimal getJob_Bott_Price(){
        if(this.Job_Bott_Pour){
			//get the weight bands from custom settings by increasing net weight
            List<Metal_Price_Adjust_Factors__c > weightBands = [SELECT Net_Weight__c, Band_Adj_Factor__c FROM Metal_Price_Adjust_Factors__c  WHERE Type__c = 'JobBott' ORDER BY Net_Weight__c ASC];
			//loop through and use the first instance the net weight setting
			//exceeds or equals the metal's net weight
            for(Metal_Price_Adjust_Factors__c band: weightBands){
                if(band.Net_Weight__c >= this.netWeight ){
                    return (this.band * band.Band_Adj_Factor__c);
                }
            }            
        } 
        return 0;
    }
    
    private void setNetWeight(decimal netWeight){
        this.netWeight = (netWeight != NULL) ? netWeight : 0;
    }
    
    //Takes a range in the form of '60/40' and returns the first part
    private decimal getFormattedRange(String Range){
        return decimal.valueOf(Range.mid(0,range.indexOf('/')));
    }
    
    //takes a Yield and returns a metal price
    private void setBand(decimal yield){
        if(yield < 1){
            yield = yield*100;
        }

        if(yield < this.range1){
            this.band = this.cost;
        }
        else if(yield < this.range2){
            this.band = this.rate1;
        }
        else if(yield < this.range3){
            this.band = this.rate2;
        }
        else if(yield < this.range4){
            this.band = this.rate3;
        }
        else if(yield < this.range5){
            this.band = this.rate4;
        }
        else if(yield < this.range6){
            this.band = this.rate5;
        }        
        else{
            this.band = this.rate6;            
        }
    }
    
}