/**
 * Created by BRITENET on 23.10.2019.
 */

public with sharing class RF_Utils {

    public static String getAccountIdForCurrentUser() {
        return getCurrentUser().AccountId;
    }

    public static String getOrderStatusForCurrentUser() {
        return getOrderStatus(getCurrentUser().Id);
    }

    public static String getContractStatusForCurrentUser() {
        return getContractStatus(getCurrentUser().Id);
    }

    public static String getCaseStatusForCurrentUser() {
        return getCaseStatus(getCurrentUser().Id);
    }

    public static String getCaseOriginForCurrentUser() {
        return getCaseOrigin(getCurrentUser().Id);
    }

    public static String getCasePriorityForCurrentUser() {
        return getCasePriority(getCurrentUser().Id);
    }

    public static User getCurrentUser() {
        if (Cache.Session.contains('local.RentFlat.User')) {
            return (User) Cache.Session.get('local.RentFlat.User');
        }
        return getUser(UserInfo.getUserId());
    }

    public static User getUser(String userId) {
        List<User> users = [SELECT Id, Email, Country, AccountId, ContactId FROM User WHERE Id = :userId];
        if(users.isEmpty()) {
            return null;
        }
        Cache.Session.put('local.RentFlat.User', users[0]);
        return users[0];
    }

    public static String getContractStatus(String userId) {
        RentFlat__c contract = RentFlat__c.getInstance(userId);
        if(contract == null){
            return RentFlat__c.getOrgDefaults().ContractStatus__c;
        }
        return contract.ContractStatus__c;
    }

    public static String getOrderStatus(String userId) {
        RentFlat__c order = RentFlat__c.getInstance(userId);
        if(order == null){
            return RentFlat__c.getOrgDefaults().OrderStatus__c;
        }
        return order.OrderStatus__c;
    }

    public static String getAccountName(String userId) {
        RentFlat__c account = RentFlat__c.getInstance(userId);
        if(account == null){
            return RentFlat__c.getOrgDefaults().AccountName__c;
        }
        return account.AccountName__c;
    }

    public static String getCaseStatus(String userId) {
        RentFlat__c caseItem = RentFlat__c.getInstance(userId);
        if(caseItem == null){
            return RentFlat__c.getOrgDefaults().CaseStatus__c;
        }
        return caseItem.CaseStatus__c;
    }

    public static String getCasePriority(String userId) {
        RentFlat__c caseItem = RentFlat__c.getInstance(userId);
        if(caseItem == null){
            return RentFlat__c.getOrgDefaults().CasePriority__c;
        }
        return caseItem.CasePriority__c;
    }

    public static String getCaseOrigin(String userId) {
        RentFlat__c caseItem = RentFlat__c.getInstance(userId);
        if(caseItem == null){
            return RentFlat__c.getOrgDefaults().CaseOrigin__c;
        }
        return caseItem.CaseOrigin__c;
    }
}
