/**
 * Created by BRITENET on 11.10.2019.
 */

trigger RF_Flat_Reservation_Trigger on RF_Flat_Reservation__c (before insert) {
    RF_TriggerFactory.createHandler(RF_Flat_Reservation__c.sobjectType);
}