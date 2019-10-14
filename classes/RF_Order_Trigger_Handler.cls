/**
 * Created by BRITENET on 12.10.2019.
 */

public with sharing class RF_Order_Trigger_Handler implements RF_ITrigger {
    List<Order> orders;

    public void bulkBefore() {

    }

    public void bulkAfter() {

    }

    public void beforeInsert(List<SObject> newlstObj) {
        orders = (List<Order>) newlstObj;
        for(Order o: orders) {
            Contract contract = new Contract();
            contract.AccountId = o.AccountId;
            contract.StartDate = o.EffectiveDate;
            contract.Status = 'Draft';
            contract.ContractTerm = o.EffectiveDate.monthsBetween(o.EndDate);
            insert contract;
            o.ContractId = contract.Id;
        }
    }
    public void beforeUpdate(List<SObject> newlstObj,List<SObject> oldlstObj,Map<Id,SObject> newMapObj, Map<Id,SObject> oldMapObj) {

    }

    public void beforeDelete(List<SObject> oldlstObj,Map<Id,SObject> oldMapObj) {

    }

    public void afterInsert(List<SObject> newlstObj,Map<Id,SObject> newMapObj) {

    }

    public void afterUpdate(List<SObject> newlstObj,List<SObject> oldlstObj,Map<Id,SObject> newMapObj, Map<Id,SObject> oldMapObj) {

    }

    public void afterDelete(List<SObject> oldlstObj,Map<Id,SObject> oldMapObj) {

    }

    public void andFinally() {

    }

}