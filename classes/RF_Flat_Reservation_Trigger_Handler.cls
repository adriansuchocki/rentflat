/**
 * Created by BRITENET on 11.10.2019.
 */

public with sharing class RF_Flat_Reservation_Trigger_Handler implements RF_ITrigger {
    List<String> products = new List<Id>();
    List<RF_Flat_Reservation__c> reservationsNew;
    List<RF_Flat_Reservation__c> reservationListFromDatabase;

    public void bulkBefore() {

    }

    public void bulkAfter() {

    }

    public void beforeInsert(List<SObject> newlstObj) {

        reservationsNew = (List<RF_Flat_Reservation__c>) newlstObj;

        for(RF_Flat_Reservation__c newReservation: reservationsNew) {
            products.add(newReservation.Product__c);
        }

        reservationListFromDatabase = [SELECT Id, Product__r.Name, Reservation_from__c, Reservation_to__c FROM RF_Flat_Reservation__c WHERE Product__c IN :products];

        String error = '';
        for(RF_Flat_Reservation__c newReservation: reservationsNew){
            error = '';
            for(RF_Flat_Reservation__c reservation: reservationListFromDatabase) {
                if((newReservation.Reservation_from__c == null && newReservation.Reservation_to__c == null) ||
                        (newReservation.Reservation_from__c >= reservation.Reservation_from__c && newReservation.Reservation_from__c <= reservation.Reservation_to__c) ||
                        (newReservation.Reservation_to__c >= reservation.Reservation_from__c && newReservation.Reservation_to__c <= reservation.Reservation_to__c) ||
                        (newReservation.Reservation_from__c >= reservation.Reservation_from__c && newReservation.Reservation_to__c <= reservation.Reservation_to__c) ) {
                    error = 'ERRORMESSAGEError during reservation flat: ' + reservation.Product__r.Name;
                    newReservation.addError(error, false);
                }
            }
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