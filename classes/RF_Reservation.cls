/**
 * Created by BRITENET on 23.10.2019.
 */

public with sharing class RF_Reservation {
    @AuraEnabled
    public String recordId { get; set; }
    @AuraEnabled
    public String title { get; set; }
    @AuraEnabled
    public String link { get; set; }
    @AuraEnabled
    public Date reservationFrom { get; set; }
    @AuraEnabled
    public Date reservationTo { get; set; }
    @AuraEnabled
    public Integer reservationDays { get; set; }
    @AuraEnabled
    public String priceBookId { get; set; }
    @AuraEnabled
    public String priceBookValue { get; set; }
}