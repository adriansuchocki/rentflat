/**
 * Created by BRITENET on 23.10.2019.
 */

public with sharing class RF_Follow_Helper {
    public static List<RF_Flat> getFollowFlat() {
        List<RF_Flat> flatList = new List<RF_Flat>();
        List<Product2> products = new List<Product2>();
        User user = RF_Utils.getCurrentUser();
        products = [SELECT Id, Name, Size__c, Rooms__c, Bedrooms__c, Baths__c, (SELECT Id, Rating__c FROM RF_Comments__r),
        (SELECT Id, UnitPrice, Pricebook2.IsStandard FROM PricebookEntries WHERE (Pricebook2.IsStandard = true) OR (Pricebook2.StartDate__c <= TODAY AND Pricebook2.End_Date__c >= TODAY)),
        (SELECT Id, CreatedById FROM RF_Favourites__r) FROM Product2 WHERE Id IN (SELECT Product__c FROM RF_Favourite__c WHERE
                CreatedById = :user.Id)];
        for(Product2 p: products) {
            RF_Flat flat = new RF_Flat(p);
            flatList.add(flat);
        }
        return flatList;
    }

    public static RF_Response_Message addToFollow(String recordId){
        try {
            RF_Favourite__c favourite = new RF_Favourite__c();
            favourite.Product__c = recordId;
            Database.insert(favourite);
        } catch(Exception e) {
            return new RF_Response_Message(Label.MESSAGE_ERROR_CODE, Label.MESSAGE_ERROR, e.getMessage());
        }
        return new RF_Response_Message(Label.MESSAGE_SUCCESS_CODE, Label.MESSAGE_SUCCESS, Label.MESSAGE_SUCCESS_ADD_TO_FOLLOW);
    }

    public static RF_Response_Message removeFromFollow(String recordId){
        try {
            RF_Favourite__c favourite = [SELECT Id FROM RF_Favourite__c WHERE Product__c = :recordId AND CreatedById = :UserInfo.getUserId() LIMIT 1];
            Database.delete(favourite);
        } catch(Exception e) {
            return new RF_Response_Message(Label.MESSAGE_ERROR_CODE, Label.MESSAGE_ERROR, e.getMessage());
        }
        return new RF_Response_Message(Label.MESSAGE_SUCCESS_CODE, Label.MESSAGE_SUCCESS, Label.MESSAGE_SUCCESS_REMOVE_FROM_FOLLOW);
    }

    public static Boolean isFavourite(List<RF_Favourite__c> favourites){
        User user = RF_Utils.getCurrentUser();
        for(RF_Favourite__c f: favourites){
            if(f.CreatedById == user.Id){
                return true;
            }
        }
        return false;
    }
}