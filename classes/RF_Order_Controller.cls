/**
 * Created by BRITENET on 23.10.2019.
 */

public with sharing class RF_Order_Controller {

    @AuraEnabled
    public static List<Order> getUserOrders(){
        List<Order> orders = [SELECT Id, EffectiveDate, EndDate, OrderNumber, TotalAmount, Contract.ContractNumber, (SELECT Id, Quantity, UnitPrice, ServiceDate, EndDate, TotalPrice, Product2.Name, IsPast__c, Complained__c FROM OrderItems) FROM Order WHERE CreatedById = :RF_Utils.getCurrentUser().Id ORDER BY CreatedDate DESC];
        return orders;
    }
}