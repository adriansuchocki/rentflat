/**
 * Created by BRITENET on 08.10.2019.
 */

public with sharing class RF_Flat_Details {
    public class ContentDoc{
        @AuraEnabled
        public String link{ get; set; }
    }

    public class PriceBook{
        @AuraEnabled
        public Decimal standardValue { get; set; }
        @AuraEnabled
        public Decimal value { get; set; }
    }

    public class Reservation{
        @AuraEnabled
        public String recordId { get; set; }
        @AuraEnabled
        public Date reservationFrom { get; set; }
        @AuraEnabled
        public Date reservationTo { get; set; }
    }

    public class FlatSearchItem{
        @AuraEnabled
        public String title { get; set; }
        @AuraEnabled
        public String link { get; set; }
        @AuraEnabled
        public Decimal price { get; set; }
        @AuraEnabled
        public Decimal size { get; set; }
        @AuraEnabled
        public String rooms { get; set; }
        @AuraEnabled
        public String bathrooms { get; set; }
        @AuraEnabled
        public String bedrooms { get; set; }
    }

    @AuraEnabled
    public static PriceBook getPriceBookValue(String parentId){
        PriceBook priceBook = new PriceBook();
        List<PricebookEntry> priceBooks = [SELECT Id, UnitPrice, Pricebook2.IsStandard FROM PricebookEntry WHERE Product2Id = :parentId];
        for(PricebookEntry p: priceBooks) {
            if(p.Pricebook2.IsStandard) {
                priceBook.standardValue = p.UnitPrice;
            }
            if(priceBook.value == null) {
                priceBook.value = p.UnitPrice;
            } else if(priceBook.value > p.UnitPrice) {
                priceBook.value = p.UnitPrice;
            }
        }
        return priceBook;
    }

    @AuraEnabled
    public static List<ContentDoc> getContentDocuments(String parentId){
        List<ContentDoc> contentDocs = new List<RF_Flat_Details.ContentDoc>();
        Set<Id> idList = new Set<Id>();
        Set<Id> versionContentList = new Set<Id>();
        List<ContentDocumentLink> contententDocumentLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :parentId order by Id desc];
        for(ContentDocumentLink c: contententDocumentLinks) {
            idList.add(c.ContentDocumentId);
        }
        List<ContentVersion> ver = [SELECT Id FROM ContentVersion Where ContentDocumentId IN :idList];
        for(ContentVersion e: ver){
            versionContentList.add(e.Id);
        }
        List<ContentDistribution> contentDistributions = [SELECT Id, ContentDownloadUrl FROM ContentDistribution  Where ContentVersionId IN :versionContentList];
        for(ContentDistribution cd: contentDistributions){
            ContentDoc contentDoc = new ContentDoc();
            contentDoc.link = cd.ContentDownloadUrl;
            contentDocs.add(contentDoc);
        }
        return contentDocs;
    }

    @AuraEnabled
    public static List<Reservation> getReservedDate(String productId){
        List<Reservation> reservedList = new List<Reservation>();
        List<RF_Flat_Reservation__c> reservations = [SELECT Id, Reservation_from__c, Reservation_to__c FROM RF_Flat_Reservation__c WHERE Product__c = :productId AND Reservation_to__c > TODAY ORDER BY Reservation_from__c ASC];
        System.debug(reservations.size());
        for(RF_Flat_Reservation__c r: reservations){
            Reservation res = new Reservation();
            res.reservationFrom = r.Reservation_from__c;
            res.reservationTo = r.Reservation_to__c;
            reservedList.add(res);
        }
        return reservedList;
    }

    @AuraEnabled
    public static String reserveFlat(List<Reservation> reservationList){
        Savepoint sp = Database.setSavepoint();
        List<RF_Flat_Reservation__c> resList = new List<RF_Flat_Reservation__c>();
        for(Reservation r: reservationList) {
            RF_Flat_Reservation__c reservation = new RF_Flat_Reservation__c();
            reservation.Product__c = r.recordId;
            reservation.Reservation_from__c = r.reservationFrom;
            reservation.Reservation_to__c = r.reservationTo;
            resList.add(reservation);
        }
        try{
            Database.insert(resList);
        } catch (Exception e) {
            Database.rollback(sp);
            String message = e.getMessage().split('ERRORMESSAGE').get(1).substring(0, 55);
            message += '...';
            throw new RF_Flat_Reservation_Exception (message);
        }
        return 'Flats reserved successful';
      
    public static List<FlatSearchItem> getResultList(String title){
        List<FlatSearchItem> flatList = new List<RF_Flat_Details.FlatSearchItem>();
        Map<String, String> parameters = new Map<String, String>();
        System.debug(title);
        if(!String.isEmpty(title)){
            parameters.put('Name', title);

        }
        List<Product2> products = new List<Product2>();
        String query = RF_Flat_Search_Handler.generateSearchQuery(parameters);
        System.debug(query);
        products = Database.query(query);
        System.debug(products.size());
        for(Product2 p: products) {
            FlatSearchItem flat = new FlatSearchItem();
            flat.title = p.Name;
            flat.size = p.Size__c;
            flat.rooms = p.Rooms__c;
            flat.bedrooms = p.Bedrooms__c;
            flat.bathrooms = p.Baths__c;
            List<RF_Flat_Details.ContentDoc> contentList = getContentDocuments(p.Id);
            flat.link = '';
            if(!contentList.isEmpty()){
                flat.link = contentList.get(0).link;
            }
            flatList.add(flat);
        }
        return flatList;
    }
}