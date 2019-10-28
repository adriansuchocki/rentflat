/**
 * Created by BRITENET on 23.10.2019.
 */

public with sharing class RF_Comments_Controller {
    @AuraEnabled
    public static List<RF_Comments__c> getFlatComments(String recordId){
        return RF_Comments_Helper.getFlatComments(recordId);
    }

    @AuraEnabled
    public static RF_Response_Message addCommentAndRating(String recordId, String description, String rating){
        return RF_Comments_Helper.addCommentAndRating(recordId, description, rating);
    }
}