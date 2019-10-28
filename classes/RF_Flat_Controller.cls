/**
 * Created by BRITENET on 25.10.2019.
 */

public with sharing class RF_Flat_Controller {

    @AuraEnabled
    public static List<RF_Flat> getResultList(Integer page, String title){
        Map<String, String> parameters = new Map<String, String>();
        if(!String.isEmpty(title)){
            parameters.put('Name', title);
        }
        return RF_Flat_Search_Handler.getFlats(parameters, page);
    }

    @AuraEnabled
    public static RF_Response_Message addToFollow(String recordId){
        return RF_Follow_Helper.addToFollow(recordId);
    }

    @AuraEnabled
    public static RF_Response_Message removeFromFollow(String recordId){
        return RF_Follow_Helper.removeFromFollow(recordId);
    }

    @AuraEnabled
    public static RF_Flat getFlat(String productId){
        return RF_Flat_Search_Handler.getFlat(productId);
    }

    @AuraEnabled
    public static void increaseNumberOfViews(String recordId){
        RF_Flat_Search_Handler.increaseNumberOfViews(recordId);
    }
}