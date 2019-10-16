/**
 * Created by BRITENET on 08.10.2019.
 */

public with sharing class RF_Flat_Details {
    public class ContentDoc{
        @AuraEnabled
        public String link { get; set; }
    }
    public class Rating{
        @AuraEnabled
        public Decimal rating { get; set; }
        @AuraEnabled
        public Integer numberOfRating { get; set; }
    }

    public class PriceBook{
        @AuraEnabled
        public String id { get; set; }
        @AuraEnabled
        public Decimal standardValue { get; set; }
        @AuraEnabled
        public Decimal value { get; set; }
    }

    public class Reservation{
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

    public class FlatSearchItem{
        @AuraEnabled
        public String id { get; set; }
        @AuraEnabled
        public String title { get; set; }
        @AuraEnabled
        public String link { get; set; }
        @AuraEnabled
        public PriceBook price { get; set; }
        @AuraEnabled
        public Decimal size { get; set; }
        @AuraEnabled
        public String rooms { get; set; }
        @AuraEnabled
        public String bathrooms { get; set; }
        @AuraEnabled
        public String bedrooms { get; set; }
        @AuraEnabled
        public String description { get; set; }
        @AuraEnabled
        public String floorNo { get; set; }
        @AuraEnabled
        public String family { get; set; }
        @AuraEnabled
        public String city { get; set; }
        @AuraEnabled
        public String country { get; set; }
        @AuraEnabled
        public Boolean garage { get; set; }
        @AuraEnabled
        public Boolean garden { get; set; }
        @AuraEnabled
        public Boolean groundFloor { get; set; }
        @AuraEnabled
        public Boolean gymInBuilding { get; set; }
        @AuraEnabled
        public Boolean lift { get; set; }
        @AuraEnabled
        public Boolean mezzanine { get; set; }
        @AuraEnabled
        public Boolean nearMetro { get; set; }
        @AuraEnabled
        public Boolean nearPark { get; set; }
        @AuraEnabled
        public Boolean nearPubsRestaurants { get; set; }
        @AuraEnabled
        public Boolean nearTramBus { get; set; }
        @AuraEnabled
        public Boolean parkView { get; set; }
        @AuraEnabled
        public Boolean parkingGarage { get; set; }
        @AuraEnabled
        public Boolean riverView { get; set; }
        @AuraEnabled
        public Boolean lastFloor { get; set; }
        @AuraEnabled
        public String streetName { get; set; }
        @AuraEnabled
        public Boolean terrace { get; set; }
        @AuraEnabled
        public Boolean wcSeparated { get; set; }
        @AuraEnabled
        public Boolean wheelchairAccess { get; set; }
        @AuraEnabled
        public String yearBuilding { get; set; }
        @AuraEnabled
        public Boolean balcony { get; set; }
        @AuraEnabled
        public Boolean cameraSecurityFenced { get; set; }
        @AuraEnabled
        public Decimal rating { get; set; }
        @AuraEnabled
        public Integer numberOfRating { get; set; }
        @AuraEnabled
        public List<ContentDoc> contents { get; set; }
        @AuraEnabled
        public PriceBook priceBook { get; set; }
        @AuraEnabled
        public List<RF_Comments__c> comments { get; set; }
        @AuraEnabled
        public Boolean follow { get; set; }

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
                priceBook.id = p.Id;
                priceBook.value = p.UnitPrice;
            } else if(priceBook.value > p.UnitPrice) {
                priceBook.id = p.Id;
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
        List<ContentDocumentLink> contententDocumentLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE ContentDocumentId = :parentId order by Id desc];
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
    public static String reserveFlatFromCart() {
        String message = '';
        try{
            List<Reservation> reservations = getCart();
            message = reserveFlat(reservations);
            clearCart();
        } catch(Exception e) {
            throw new RF_Flat_Reservation_Exception(e.getMessage());
        }
        return message;
    }

    @AuraEnabled
    public static String reserveFlat(List<Reservation> reservationList) {
        Savepoint sp = Database.setSavepoint();
        try {
            List<String> productsId = new List<String>();
            List<OrderItem> orderItems = new List<OrderItem>();
            Order order = new Order();
            Date startDate;
            Date endDate;
            for (Reservation r : reservationList) {
                productsId.add(r.recordId);
            }
            List<Product2> products = [SELECT Id, (SELECT Id, UnitPrice, Pricebook2.IsStandard FROM PricebookEntries) FROM Product2 WHERE Id IN :productsId];
            List<Account> accounts = [SELECT Id FROM Account WHERE Name = 'Customers'];
            for(Product2 p: products) {
                for (Reservation r : reservationList) {
                    OrderItem oi = new OrderItem();
                    oi.Product2 = p;
                    if (r.recordId == p.Id) {
                        oi.ServiceDate = r.reservationFrom;
                        oi.EndDate = r.reservationTo;
                        oi.Quantity = r.reservationFrom.daysBetween(r.reservationTo) + 1;
                        if(startDate == null){
                            startDate =  r.reservationFrom;
                            endDate =  r.reservationTo;
                        }
                        if(startDate > r.reservationFrom){
                            startDate =  r.reservationFrom;
                        }
                        if(endDate < r.reservationTo){
                            endDate =  r.reservationTo;
                        }
                        for(PricebookEntry pe: p.PricebookEntries) {
                            if(r.priceBookId == pe.Id) {
                                oi.PricebookEntry = pe;
                                oi.PricebookEntryId = pe.Id;
                                oi.UnitPrice = pe.UnitPrice;
                                order.Pricebook2Id = pe.Pricebook2Id;
                                order.Pricebook2 = pe.Pricebook2;
                            }
                        }
                    }
                    orderItems.add(oi);
                }
            }
            order.AccountId = accounts.get(0).Id;
            order.EffectiveDate = startDate;
            order.EndDate = endDate;
            order.Status = 'Draft';
            Contract contract = new Contract();
            contract.AccountId = accounts.get(0).Id;
            contract.StartDate = startDate;
            contract.Status = 'Draft';
            contract.ContractTerm =  startDate.monthsBetween(endDate) + 1;
            Database.insert(contract);
            order.ContractId = contract.Id;
            Database.insert(order);
            System.debug(orderItems.size());
            for(OrderItem oi: orderItems){
                oi.Order = order;
                oi.OrderId = order.Id;
            }
//            order.OrderItems.addAll(orderItems);
            Database.insert(orderItems);
        } catch (Exception e) {
            Database.rollback(sp);
            throw new RF_Flat_Reservation_Exception (e.getMessage());
        }
        return 'Flats reserved successful';
    }

    @AuraEnabled
    public static List<Reservation> getCart(){
        List<Reservation> resList = new List<Reservation>();
        if (Cache.Session.contains('local.RentFlat.CartList')) {
            resList = (List<Reservation>) Cache.Session.get('local.RentFlat.CartList');
        }
        for(Reservation r: resList){
            if(r.reservationDays == null){
                r.reservationDays = r.reservationFrom.daysBetween(r.reservationTo) + 1;
            }
        }
        return resList;
    }

    @AuraEnabled
    public static String addToCart(List<Reservation> reservationList){
        if (Cache.Session.contains('local.RentFlat.CartList')) {
            List<Reservation> resList = (List<Reservation>) Cache.Session.get('local.RentFlat.CartList');
            resList.addAll(reservationList);
            Cache.Session.put('local.RentFlat.CartList', resList);
        } else {
            Cache.Session.put('local.RentFlat.CartList', reservationList);
        }
        return 'Flat added to the Cart';
    }

    @AuraEnabled
    public static void clearCart(){
        List<Reservation> resList = new List<Reservation>();
        Cache.Session.put('local.RentFlat.CartList', resList);
    }

    @AuraEnabled
    public static String removeElementFromCartList(Integer index){
        if (Cache.Session.contains('local.RentFlat.CartList')) {
            List<Reservation> resList = (List<Reservation>) Cache.Session.get('local.RentFlat.CartList');
            resList.remove(index);
            Cache.Session.put('local.RentFlat.CartList', resList);
        }
        return 'Flat removed successful';
    }

    @AuraEnabled
    public static List<FlatSearchItem> getResultList(Integer page, String title){
        List<FlatSearchItem> flatList = new List<RF_Flat_Details.FlatSearchItem>();
        Map<String, String> parameters = new Map<String, String>();
        if(!String.isEmpty(title)){
            parameters.put('Name', title);
        }
        return RF_Flat_Search_Handler.getFlats(parameters, page);
    }

    @AuraEnabled
    public static List<RF_Comments__c> getFlatComments(String recordId){
        List<RF_Comments__c> comments = [SELECT Id, Comment__c, Rating__c, CreatedBy.FirstName, CreatedBy.LastName, CreatedBy.Name, LastModifiedDate FROM RF_Comments__c WHERE Product__c = :recordId ORDER BY CreatedDate ASC];
        return comments;
    }

    @AuraEnabled
    public static String addCommentAndRating(String recordId, String description, String rating){
        RF_Comments__c comment = new RF_Comments__c();
        List<RF_Comments__c> comments = [SELECT Id FROM RF_Comments__c WHERE Product__c = :recordId AND OwnerId = :UserInfo.getUserId()];
        if(!comments.isEmpty()){
            comment = comments.get(0);
        }
        comment.Product__c = recordId;
        comment.Comment__c = description;
        comment.Rating__c = Integer.valueOf(rating);
        try {
            Database.upsert(comment);
        } catch (Exception e) {
            throw e;
        }
        return 'Comment added successful';
    }

    @AuraEnabled
    public static String addToFollow(String recordId){
        try {
            RF_Favourite__c favourite = new RF_Favourite__c();
            favourite.Product__c = recordId;
            Database.insert(favourite);
        } catch(Exception e) {
            throw new RF_Flat_Reservation_Exception(e.getMessage());
        }
        return 'Flat added to follow';
    }

    @AuraEnabled
    public static String removeFromFollow(String recordId){
        try {
            RF_Favourite__c favourite = [SELECT Id FROM RF_Favourite__c WHERE Product__c = :recordId AND CreatedById = :UserInfo.getUserId()];
            Database.delete(favourite);
        } catch(Exception e) {
            throw new RF_Flat_Reservation_Exception(e.getMessage());
        }
        return 'Flat removed from follow';
    }

    @AuraEnabled
    public static Rating getRating(String productId){
        List<AggregateResult> comments = [SELECT Product__c, SUM(Rating__c) sumRating, COUNT(Rating__c) numberOfRating FROM RF_Comments__c GROUP BY Product__c];
        Rating r = new Rating();
        r.rating = 0.00;
        r.numberOfRating = 0;
        for(AggregateResult a: comments){
            if(a.get('Product__c').equals(productId)) {
                Integer numberOfRating = (Integer) comments[0].get('numberOfRating');
                r.rating = ((Decimal) comments[0].get('sumRating')) / numberOfRating ;
                r.numberOfRating = numberOfRating;
            }
        }
        return r;
    }

    @AuraEnabled
    public static FlatSearchItem getFlat(String productId){
        return RF_Flat_Search_Handler.getFlat(productId);
    }

    @AuraEnabled
    public static List<Order> getUserOrders(){
        List<Order> orders = [SELECT Id, EffectiveDate, EndDate, OrderNumber, TotalAmount, Contract.ContractNumber, (SELECT Id, Quantity, UnitPrice, ServiceDate, EndDate, TotalPrice, Product2.Name FROM OrderItems) FROM Order WHERE CreatedById = :UserInfo.getUserId() ORDER BY CreatedDate DESC];
        return orders;
    }

    @AuraEnabled
    public static List<FlatSearchItem> getFollowFlat(){
        return RF_Flat_Search_Handler.getFollowFlat();
    }

}