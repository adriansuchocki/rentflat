/**
 * Created by BRITENET on 24.10.2019.
 */

public with sharing class RF_Case_Helper {

    public static RF_Response_Message createCase(String recordId, String subject, String description){
        Savepoint sp = Database.setSavepoint();
        User user = RF_Utils.getCurrentUser();
        List<OrderItem> orderItems = [SELECT Id, Product2Id FROM OrderItem WHERE Id = :recordId AND CreatedById = :user.Id LIMIT 1];
        Case caseItem = new Case();
        for(OrderItem orderItem: orderItems){
            caseItem = generateOrderItem(user, orderItem, subject, description);
            orderItem.Complained__c = true;
        }
        try{
            Database.insert(caseItem);
            Database.update(orderItems);
        } catch (Exception e){
            Database.rollback(sp);
            return new RF_Response_Message(Label.MESSAGE_ERROR_CODE, Label.MESSAGE_ERROR, e.getMessage());
        }
        String result = Label.MESSAGE_SUCCESS_CREATE_CASE_FIRST + ' ' + caseItem.Id + ' ' + Label.MESSAGE_SUCCESS_CREATE_SECOND;
        return new RF_Response_Message(Label.MESSAGE_SUCCESS_CODE, Label.MESSAGE_SUCCESS, result);
    }

    public static Case generateOrderItem(User user, OrderItem orderItem, String subject, String description){
        Case caseItem = new Case();
        caseItem.Product__c = orderItem.Product2Id;
        caseItem.Status = RF_Utils.getCaseStatusForCurrentUser();
        caseItem.Origin = RF_Utils.getCaseOriginForCurrentUser();
        caseItem.ContactId = user.ContactId;
        caseItem.AccountId = user.AccountId;
        caseItem.Priority = RF_Utils.getCasePriorityForCurrentUser();
        caseItem.Subject = subject;
        caseItem.Description = description;
        return caseItem;
    }

    public static List<Case> getCases(){
        List<Case> cases = [SELECT Id, Subject, Description, Status, Product__r.Name, CreatedDate FROM Case WHERE ContactId = :RF_Utils.getCurrentUser().ContactId];
        return cases;
    }
}