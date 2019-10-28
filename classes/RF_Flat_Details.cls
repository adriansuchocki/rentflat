/**
 * Created by BRITENET on 08.10.2019.
 */

public with sharing class RF_Flat_Details {
//    public class ContentDoc{
//        @AuraEnabled
//        public String link { get; set; }
//    }
//    public class Rating{
//        @AuraEnabled
//        public Decimal rating { get; set; }
//        @AuraEnabled
//        public Integer numberOfRating { get; set; }
//    }
//
//    public class PriceBook{
//        @AuraEnabled
//        public String id { get; set; }
//        @AuraEnabled
//        public Decimal standardValue { get; set; }
//        @AuraEnabled
//        public Decimal value { get; set; }
//    }
//
//    public class Reservation{
//        @AuraEnabled
//        public String recordId { get; set; }
//        @AuraEnabled
//        public String title { get; set; }
//        @AuraEnabled
//        public String link { get; set; }
//        @AuraEnabled
//        public Date reservationFrom { get; set; }
//        @AuraEnabled
//        public Date reservationTo { get; set; }
//        @AuraEnabled
//        public Integer reservationDays { get; set; }
//        @AuraEnabled
//        public String priceBookId { get; set; }
//        @AuraEnabled
//        public String priceBookValue { get; set; }
//
//    }
//
//    public class FlatSearchItem{
//        @AuraEnabled
//        public String id { get; set; }
//        @AuraEnabled
//        public String title { get; set; }
//        @AuraEnabled
//        public String link { get; set; }
//        @AuraEnabled
//        public PriceBook price { get; set; }
//        @AuraEnabled
//        public Decimal size { get; set; }
//        @AuraEnabled
//        public String rooms { get; set; }
//        @AuraEnabled
//        public String bathrooms { get; set; }
//        @AuraEnabled
//        public String bedrooms { get; set; }
//        @AuraEnabled
//        public String description { get; set; }
//        @AuraEnabled
//        public String floorNo { get; set; }
//        @AuraEnabled
//        public String family { get; set; }
//        @AuraEnabled
//        public String city { get; set; }
//        @AuraEnabled
//        public String country { get; set; }
//        @AuraEnabled
//        public Boolean garage { get; set; }
//        @AuraEnabled
//        public Boolean garden { get; set; }
//        @AuraEnabled
//        public Boolean groundFloor { get; set; }
//        @AuraEnabled
//        public Boolean gymInBuilding { get; set; }
//        @AuraEnabled
//        public Boolean lift { get; set; }
//        @AuraEnabled
//        public Boolean mezzanine { get; set; }
//        @AuraEnabled
//        public Boolean nearMetro { get; set; }
//        @AuraEnabled
//        public Boolean nearPark { get; set; }
//        @AuraEnabled
//        public Boolean nearPubsRestaurants { get; set; }
//        @AuraEnabled
//        public Boolean nearTramBus { get; set; }
//        @AuraEnabled
//        public Boolean parkView { get; set; }
//        @AuraEnabled
//        public Boolean parkingGarage { get; set; }
//        @AuraEnabled
//        public Boolean riverView { get; set; }
//        @AuraEnabled
//        public Boolean lastFloor { get; set; }
//        @AuraEnabled
//        public String streetName { get; set; }
//        @AuraEnabled
//        public Boolean terrace { get; set; }
//        @AuraEnabled
//        public Boolean wcSeparated { get; set; }
//        @AuraEnabled
//        public Boolean wheelchairAccess { get; set; }
//        @AuraEnabled
//        public String yearBuilding { get; set; }
//        @AuraEnabled
//        public Boolean balcony { get; set; }
//        @AuraEnabled
//        public Boolean cameraSecurityFenced { get; set; }
//        @AuraEnabled
//        public Decimal rating { get; set; }
//        @AuraEnabled
//        public Integer numberOfRating { get; set; }
//        @AuraEnabled
//        public Integer numberOfViews { get; set; }
//        @AuraEnabled
//        public List<ContentDoc> contents { get; set; }
//        @AuraEnabled
//        public PriceBook priceBook { get; set; }
//        @AuraEnabled
//        public List<RF_Comments__c> comments { get; set; }
//        @AuraEnabled
//        public Boolean follow { get; set; }
//
//    }
//
//    public class Product{
//        @AuraEnabled
//        public String id { get; set; }
//        @AuraEnabled
//        public String priceBookEntryId { get; set; }
//        @AuraEnabled
//        public String title { get; set; }
//        @AuraEnabled
//        public String family { get; set; }
//        @AuraEnabled
//        public String country { get; set; }
//        @AuraEnabled
//        public String city { get; set; }
//        @AuraEnabled
//        public Decimal unitPrice { get; set; }
//        @AuraEnabled
//        public Decimal newUnitPrice { get; set; }
//        @AuraEnabled
//        public Decimal newGroupUnitPrice { get; set; }
//    }
//
//    public class ProductPriceBook{
//        @AuraEnabled
//        public String priceBookName { get; set; }
//        @AuraEnabled
//        public Date startDate { get; set; }
//        @AuraEnabled
//        public Date endDate { get; set; }
//        @AuraEnabled
//        public String priceBookId { get; set; }
//        @AuraEnabled
//        public Boolean isStandard { get; set; }
//        @AuraEnabled
//        public List<Product> productNewPriceBookList { get; set; }
//    }

//    @AuraEnabled
//    public static PriceBook getPriceBookValue(String parentId){
//        PriceBook priceBook = new PriceBook();
//        List<PricebookEntry> priceBooks = [SELECT Id, UnitPrice, Pricebook2.IsStandard FROM PricebookEntry WHERE Product2Id = :parentId];
//        for(PricebookEntry p: priceBooks) {
//            if(p.Pricebook2.IsStandard) {
//                priceBook.standardValue = p.UnitPrice;
//            }
//            if(priceBook.value == null) {
//                priceBook.id = p.Id;
//                priceBook.value = p.UnitPrice;
//            } else if(priceBook.value > p.UnitPrice) {
//                priceBook.id = p.Id;
//                priceBook.value = p.UnitPrice;
//            }
//        }
//        return priceBook;
//    }

    @AuraEnabled
    public static List<RF_Flat> getResultList(Integer page, String title){
        Map<String, String> parameters = new Map<String, String>();
        if(!String.isEmpty(title)){
            parameters.put('Name', title);
        }
        return RF_Flat_Search_Handler.getFlats(parameters, page);
    }

    @AuraEnabled
    public static RF_Response_Message addToFollow(String recordId){
        return RF_Follow_Helper.addToFollow(recordId);
    }

    @AuraEnabled
    public static RF_Response_Message removeFromFollow(String recordId){
        return RF_Follow_Helper.removeFromFollow(recordId);
    }

//    @AuraEnabled
//    public static RF_Rataing getRating(String productId){
//        return RF_Flat_Search_Handler.getFlatRating(productId);
//    }

    @AuraEnabled
    public static RF_Flat getFlat(String productId){
        return RF_Flat_Search_Handler.getFlat(productId);
    }

    @AuraEnabled
    public static void increaseNumberOfViews(String recordId){
        RF_Flat_Search_Handler.increaseNumberOfViews(recordId);
    }
//
//    @AuraEnabled
//    public static String createCase(String recordId, String subject, String description){
//        Savepoint sp = Database.setSavepoint();
//        User user = RF_Utils.getCurrentUser();
//        List<OrderItem> orderItems = [SELECT Id, Product2Id FROM OrderItem WHERE Id = :recordId AND CreatedById = :user.Id LIMIT 1];
//        Case caseItem = new Case();
//        for(OrderItem orderItem: orderItems){
//            caseItem.Product__c = orderItem.Product2Id;
//            caseItem.Status = RF_Utils.getCaseStatusForCurrentUser();
//            caseItem.Origin = RF_Utils.getCaseOriginForCurrentUser();
//            caseItem.ContactId = user.ContactId;
//            caseItem.AccountId = user.AccountId;
//            caseItem.Priority = RF_Utils.getCasePriorityForCurrentUser();
//            caseItem.Subject = subject;
//            caseItem.Description = description;
//            orderItem.Complained__c = true;
//        }
//        try{
//            Database.insert(caseItem);
//            Database.update(orderItems);
//        } catch (Exception e){
//            Database.rollback(sp);
//            throw new ExternalObjectException(e.getMessage());
//        }
//        return 'Case ' + caseItem.Id + ' created successful';
//    }

//    @AuraEnabled
//    public static List<Case> getCases(){
//        List<Case> cases = [SELECT Id, Subject, Description, Status, Product__r.Name, CreatedDate FROM Case WHERE ContactEmail = :UserInfo.getUserEmail()];
//        return cases;
//    }

//    @AuraEnabled
//    public static List<Product> getAllResultList(String text, List<Product> inNewPriceBook){
//        text = '%' + text + '%';
//        List<String> ids = new List<String>();
//        for(Product productBook: inNewPriceBook){
//            ids.add(productBook.id);
//        }
//        List<Product2> products = [SELECT Id, Name, Family, Country__c, City__c, (SELECT Id, UnitPrice FROM PricebookEntries WHERE IsActive = true AND Pricebook2.IsStandard = true) FROM Product2 WHERE IsActive = true AND Id NOT IN :ids AND Name like :text];
//        List<Product> ppb = new List<Product>();
//        for(Product2 p: products) {
//            Product product = new Product();
//            product.id = p.Id;
//            product.title = p.Name;
//            product.family = p.Family;
//            product.country = p.Country__c;
//            product.city = p.City__c;
//            product.unitPrice = p.PricebookEntries.get(0).UnitPrice;
//            product.newUnitPrice = 0.0;
//            product.newGroupUnitPrice = 0.0;
//            ppb.add(product);
//        }
//        return ppb;
//    }

//    @AuraEnabled
//    public static ProductPriceBook getPriceBookDetails(String recordId){
//        ProductPriceBook ppb = new ProductPriceBook();
//        List<Product> productList = new List<Product>();
//        if(!String.isBlank(recordId)){
//            List<Product2> products = [SELECT Id, Name, Family, Country__c, City__c, (SELECT Id, UnitPrice, Pricebook2.Name, Pricebook2.IsStandard, Pricebook2.StartDate__c, Pricebook2.End_Date__c FROM PricebookEntries WHERE IsActive = true AND  Pricebook2Id = :recordId) FROM Product2 WHERE IsActive = true AND Id IN (SELECT Product2Id FROM PricebookEntry WHERE Pricebook2Id = :recordId)];
//            for(Product2 p: products){
//                Product product = new Product(); //zmienic na konstruktor
//                product.id = p.Id;
//                product.title = p.Name;
//                product.family = p.Family;
//                product.country = p.Country__c;
//                product.city = p.City__c;
//                product.unitPrice = p.PricebookEntries.get(0).UnitPrice;
//                product.newUnitPrice = 0.0;
//                product.newGroupUnitPrice = 0.0;
//                product.priceBookEntryId = p.PricebookEntries.get(0).Id;
//                productList.add(product);
//            }
//            ppb.priceBookId = recordId;
//            ppb.isStandard = products.get(0).PricebookEntries.get(0).Pricebook2.IsStandard;
//            ppb.priceBookName = products.get(0).PricebookEntries.get(0).Pricebook2.Name;
//            ppb.startDate = products.get(0).PricebookEntries.get(0).Pricebook2.StartDate__c;
//            ppb.endDate = products.get(0).PricebookEntries.get(0).Pricebook2.End_Date__c;
//            ppb.productNewPriceBookList = productList;
//        }
//        return ppb;
//    }

//    @AuraEnabled
//    public static String upsertPriceBook(ProductPriceBook productPriceBook){
//        Savepoint sp = Database.setSavepoint();
//        List<Product> products = productPriceBook.productNewPriceBookList;
//        List<String> productEntryIds = new List<String>();
//        List<PricebookEntry> priceBookEntries = new List<PricebookEntry>();
//        Pricebook2 pricebook = new Pricebook2();
//        try {
//            Map<String, Product2> productMap = new Map<String, Product2>([Select Id From Product2]);//dodanie set z Id produktow
//            if (!String.isBlank(productPriceBook.priceBookId)) {
//                pricebook.Id = productPriceBook.priceBookId;
//            }
//            pricebook.Name = productPriceBook.priceBookName;
//            pricebook.StartDate__c = productPriceBook.startDate;
//            pricebook.End_Date__c = productPriceBook.endDate;
//            pricebook.IsActive = true;
//            Database.upsert(pricebook);
//            for (Product p: products) {
//                PricebookEntry pricebookEntry = new PricebookEntry();
//                if (!String.isBlank(p.priceBookEntryId)) {
//                    productEntryIds.add(p.priceBookEntryId);
//                    pricebookEntry.Id = p.priceBookEntryId;
//                } else {
//                    pricebookEntry.Pricebook2Id = pricebook.Id;
//                    pricebookEntry.Pricebook2 = pricebook;
//                    pricebookEntry.Product2Id = p.id;
//                    pricebookEntry.Product2 = productMap.get(p.id);
//                }
//                pricebookEntry.UnitPrice = p.unitPrice;
//                pricebookEntry.IsActive = true;
//                if(p.newUnitPrice > 0) {
//                    pricebookEntry.UnitPrice = p.newUnitPrice;
//                }
//                if (p.newGroupUnitPrice > 0 && (p.newGroupUnitPrice < p.newUnitPrice || p.newUnitPrice == 0)) {
//                    pricebookEntry.UnitPrice = p.newGroupUnitPrice;
//                }
//                priceBookEntries.add(pricebookEntry);
//            }
//            List<PricebookEntry> pricebookToDelete = [SELECT Id FROM PricebookEntry WHERE Id NOT IN :productEntryIds AND Pricebook2Id = :pricebook.Id];
//            Database.delete(pricebookToDelete);
//            List<Database.UpsertResult> sr = Database.upsert(priceBookEntries);
//        } catch (Exception e){
//            Database.rollback(sp);
//            throw new ExternalObjectException(e.getMessage());
//        }
//        return 'PriceBook ' + pricebook.Id + ' update successful';
//    }


//    @AuraEnabled
//    public static List<Pricebook2> getAllPriceBooks(String recordId){
//        List<Pricebook2> pricebooks = [SELECT Id, Name, StartDate__c, End_Date__c, IsStandard FROM Pricebook2 WHERE IsActive = true];
//        return pricebooks;
//    }

//    @AuraEnabled
//    public static String removeFromPriceBook(String recordId){
//        Savepoint sp = Database.setSavepoint();
//        try {
//            List<Pricebook2> pricebooks = [SELECT Id, (SELECT Id FROM PricebookEntries) FROM Pricebook2 WHERE Id = :recordId];
//            for(Pricebook2 p: pricebooks){
//                List<PricebookEntry> pricebookEntries = p.PricebookEntries;
//                System.debug(pricebookEntries.size());
//                Database.delete(pricebookEntries);
//            }
//            System.debug(pricebooks.size());
//            Database.delete(pricebooks);
//        } catch(Exception e) {
//            Database.rollback(sp);
//            throw new ExternalObjectException(e.getMessage());
//        }
//        return 'Pricebook removed from Pricebook list';
//    }
}