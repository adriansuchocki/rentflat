/**
 * Created by BRITENET on 23.10.2019.
 */

public with sharing class RF_Discount_Manager_Controller {

    @AuraEnabled
    public static List<RF_PriceBook_Item> getAllResultList(String text, List<RF_PriceBook_Item> newFlatList){
        text = '%' + text + '%';
        List<String> ids = new List<String>();
        for(RF_PriceBook_Item flat: newFlatList){
            ids.add(flat.flat.product.Id);
        }
        return RF_Discount_Manager_Helper.getAllResultList(text, ids);
    }

    @AuraEnabled
    public static List<Pricebook2> getAllPriceBooks(String recordId){
        return RF_Discount_Manager_Helper.getAllPriceBooks(recordId);
    }

    @AuraEnabled
    public static RF_PriceBook getPriceBookDetails(String recordId){
        return RF_Discount_Manager_Helper.getPriceBookDetails(recordId);
    }

    @AuraEnabled
    public static RF_Response_Message upsertPriceBook(RF_PriceBook priceBook){
        return RF_Discount_Manager_Helper.upsertPriceBook(priceBook);
    }

    @AuraEnabled
    public static RF_Response_Message removeFromPriceBook(String recordId){
        return RF_Discount_Manager_Helper.removeFromPriceBook(recordId);
    }
}