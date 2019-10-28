/**
 * Created by BRITENET on 23.10.2019.
 */

public with sharing class RF_Comments_Helper {
    public static List<RF_Comments__c> getFlatComments(String recordId){
        List<RF_Comments__c> comments = [SELECT Id, Comment__c, Rating__c, CreatedBy.FirstName, CreatedBy.LastName, CreatedBy.Name, LastModifiedDate FROM RF_Comments__c WHERE Product__c = :recordId ORDER BY CreatedDate ASC];
        return comments;
    }

    public static RF_Response_Message addCommentAndRating(String recordId, String description, String rating){
        RF_Comments__c comment = new RF_Comments__c();
        List<RF_Comments__c> comments = [SELECT Id FROM RF_Comments__c WHERE Product__c = :recordId AND OwnerId = :RF_Utils.getCurrentUser().Id LIMIT 1];
        if(!comments.isEmpty()){
            comment = comments.get(0);
        }
        comment.Product__c = recordId;
        comment.Comment__c = description;
        comment.Rating__c = Integer.valueOf(rating);
        try {
            Database.upsert(comment);
        } catch (Exception e) {
            return new RF_Response_Message(Label.MESSAGE_ERROR_CODE, Label.MESSAGE_ERROR, e.getMessage());
        }
        return new RF_Response_Message(Label.MESSAGE_SUCCESS_CODE, Label.MESSAGE_SUCCESS, Label.MESSAGE_SUCCESS_ADD_COMMENT);
    }
}