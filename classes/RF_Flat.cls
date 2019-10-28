/**
 * Created by BRITENET on 23.10.2019.
 */

public with sharing class RF_Flat {
    @AuraEnabled
    public Product2 product { get; set; }
    @AuraEnabled
    public List<RF_Comments__c> comments { get; set; }
    @AuraEnabled
    public Boolean follow { get; set; }
    @AuraEnabled
    public Decimal standardValue { get; set; }
    @AuraEnabled
    public PricebookEntry priceBookEntryValue { get; set; }
    @AuraEnabled
    public List<String> photos { get; set; }
    @AuraEnabled
    public Decimal rating { get; set; }
    @AuraEnabled
    public Integer numberOfRating { get; set; }
    @AuraEnabled
    public Integer numberOfViews { get; set; }
    @AuraEnabled
    public Decimal unitPrice { get; set; }
    @AuraEnabled
    public Decimal newUnitPrice { get; set; }
    @AuraEnabled
    public Decimal newGroupUnitPrice { get; set; }

    public RF_Flat() {

    }

    public RF_Flat(Product2 product) {
        this.product = product;
        getRating();
        isFavourite();
        setPriceValue();
    }

    public void setPriceValue(){
        List<PricebookEntry> priceBooks = [SELECT Id, UnitPrice, Pricebook2.IsStandard FROM PricebookEntry WHERE Product2Id = :product.Id];
        for(PricebookEntry p: priceBooks) {
            if(p.Pricebook2.IsStandard) {
               standardValue = p.UnitPrice;
            }
            if(priceBookEntryValue == null) {
//                priceBook.id = p.Id;
                priceBookEntryValue = p;
            } else if(priceBookEntryValue.UnitPrice > p.UnitPrice) {
//                priceBook.id = p.Id;
                priceBookEntryValue = p;
            }
        }
    }

    public void getRating(){
        List<RF_Comments__c> comments = product.RF_Comments__r;
        Decimal ratingSum = 0;
        for(RF_Comments__c c: comments){
            ratingSum += c.Rating__c;
        }
        if(comments.isEmpty()){
            rating = 0.00;
            numberOfRating = 0;
        } else {
            rating = ratingSum/comments.size();
            rating = rating.setScale(2);
            numberOfRating = comments.size();
        }
    }

    public void isFavourite(){
        follow = RF_Follow_Helper.isFavourite(product.RF_Favourites__r);
    }

    public void setPriceBookDetails(Product2 p){
        unitPrice = p.PricebookEntries.get(0).UnitPrice;
        newUnitPrice = 0.0;
        newGroupUnitPrice = 0.0;
    }
}