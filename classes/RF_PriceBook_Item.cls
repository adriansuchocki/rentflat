/**
 * Created by BRITENET on 23.10.2019.
 */

public with sharing class RF_PriceBook_Item {
    @AuraEnabled
    public RF_Flat flat { get; set; }
    @AuraEnabled
    public Decimal unitPrice { get; set; }
    @AuraEnabled
    public Decimal newUnitPrice { get; set; }
    @AuraEnabled
    public Decimal newGroupUnitPrice { get; set; }
    @AuraEnabled
    public String priceBookEntryId { get; set; }

    public RF_PriceBook_Item(RF_Flat flat, Decimal unitPrice, Decimal newUnitPrice, Decimal newGroupUnitPrice, String priceBookEntryId){
        this.flat = flat;
        this.unitPrice = unitPrice;
        this.newUnitPrice = newUnitPrice;
        this.newGroupUnitPrice = newGroupUnitPrice;
        this.priceBookEntryId = priceBookEntryId;
    }

    public RF_PriceBook_Item(){

    }
}