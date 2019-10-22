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
        public Integer numberOfViews { get; set; }
        @AuraEnabled
        public List<ContentDoc> contents { get; set; }
        @AuraEnabled
        public PriceBook priceBook { get; set; }
        @AuraEnabled
        public List<RF_Comments__c> comments { get; set; }
        @AuraEnabled
        public Boolean follow { get; set; }

    }

    public class Product{
        @AuraEnabled
        public String id { get; set; }
        @AuraEnabled
        public String priceBookEntryId { get; set; }
        @AuraEnabled
        public String title { get; set; }
        @AuraEnabled
        public String family { get; set; }
        @AuraEnabled
        public String country { get; set; }
        @AuraEnabled
        public String city { get; set; }
        @AuraEnabled
        public Decimal unitPrice { get; set; }
        @AuraEnabled
        public Decimal newUnitPrice { get; set; }
        @AuraEnabled
        public Decimal newGroupUnitPrice { get; set; }
    }

    public class ProductPriceBook{
        @AuraEnabled
        public String priceBookName { get; set; }
        @AuraEnabled
        public Date startDate { get; set; }
        @AuraEnabled
        public Date endDate { get; set; }
        @AuraEnabled
        public String priceBookId { get; set; }
        @AuraEnabled
        public Boolean isStandard { get; set; }
        @AuraEnabled
        public List<Product> productNewPriceBookList { get; set; }
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
            List<Product2> products = [SELECT Id, (SELECT Id, UnitPrice, Pricebook2.IsStandard FROM PricebookEntries WHERE Pricebook2.IsActive = true ) FROM Product2 WHERE Id IN :productsId AND IsActive = true];
            List<Account> accounts = [SELECT Id FROM Account WHERE Name = 'Customers'];
            for(Product2 p: products) {
                for (Reservation r : reservationList) {
                    if (r.recordId == p.Id) {
                        OrderItem oi = new OrderItem();
                        oi.Product2 = p;
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
                                oi.UnitPrice = pe.UnitPrice;
                                System.debug(oi.UnitPrice);
                            }
                            if(pe.Pricebook2.IsStandard){
                                oi.PricebookEntry = pe;
                                oi.PricebookEntryId = pe.Id;
                                order.Pricebook2Id = pe.Pricebook2Id;
                                order.Pricebook2 = pe.Pricebook2;
                            }
                        }
                        orderItems.add(oi);
                    }
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
            System.debug('Order size ' + orderItems.size());
            for(OrderItem oi: orderItems){
                oi.Order = order;
                oi.OrderId = order.Id;
            }
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
        List<Order> orders = [SELECT Id, EffectiveDate, EndDate, OrderNumber, TotalAmount, Contract.ContractNumber, (SELECT Id, Quantity, UnitPrice, ServiceDate, EndDate, TotalPrice, Product2.Name, IsPast__c, Complained__c FROM OrderItems) FROM Order WHERE CreatedById = :UserInfo.getUserId() ORDER BY CreatedDate DESC];
        return orders;
    }

    @AuraEnabled
    public static List<FlatSearchItem> getFollowFlat(){
        return RF_Flat_Search_Handler.getFollowFlat();
    }

    @AuraEnabled
    public static void increaseNumberOfViews(String recordId){
        List<Product2> product = [SELECT Id, Number_of_view__c FROM Product2 WHERE Id = :recordId];
        if(!product.isEmpty()){
            product.get(0).Number_of_view__c ++;
            Database.update(product);
        }
    }

    @AuraEnabled
    public static String createCase(String recordId, String subject, String description){
        Savepoint sp = Database.setSavepoint();
        List<OrderItem> orderItems = [SELECT Id, Product2Id FROM OrderItem WHERE Id = :recordId AND CreatedById = :UserInfo.getUserId()];
        List<Contact> contacts = [SELECT Id, AccountId FROM Contact WHERE Email = :UserInfo.getUserEmail()];
        Case caseItem = new Case();
        for(OrderItem orderItem: orderItems){
            caseItem.Product__c = orderItem.Product2Id;
            caseItem.Status = 'New';
            caseItem.Origin = 'Web';
            caseItem.ContactId = contacts.get(0).Id;
            caseItem.AccountId = contacts.get(0).AccountId;
            caseItem.Priority = 'Medium';
            caseItem.Subject = subject;
            caseItem.Description = description;
            orderItem.Complained__c = true;
        }
        try{
            Database.insert(caseItem);
            Database.update(orderItems);
        } catch (Exception e){
            Database.rollback(sp);
            throw new ExternalObjectException(e.getMessage());
        }
        return 'Case ' + caseItem.Id + ' created successful';
    }

    @AuraEnabled
    public static List<Case> getCases(){
        List<Case> cases = [SELECT Id, Subject, Description, Status, Product__r.Name, CreatedDate FROM Case WHERE ContactEmail = :UserInfo.getUserEmail()];
        return cases;
    }

    @AuraEnabled
    public static List<Product> getAllResultList(String text, List<Product> inNewPriceBook){
        text = '%' + text + '%';
        List<String> ids = new List<String>();
        for(Product productBook: inNewPriceBook){
            ids.add(productBook.id);
        }
        List<Product2> products = [SELECT Id, Name, Family, Country__c, City__c, (SELECT Id, UnitPrice FROM PricebookEntries WHERE IsActive = true AND Pricebook2.IsStandard = true) FROM Product2 WHERE IsActive = true AND Id NOT IN :ids AND Name like :text];
        List<Product> ppb = new List<Product>();
        for(Product2 p: products) {
            Product product = new Product();
            product.id = p.Id;
            product.title = p.Name;
            product.family = p.Family;
            product.country = p.Country__c;
            product.city = p.City__c;
            product.unitPrice = p.PricebookEntries.get(0).UnitPrice;
            product.newUnitPrice = 0.0;
            product.newGroupUnitPrice = 0.0;
            ppb.add(product);
        }
        return ppb;
    }

    @AuraEnabled
    public static ProductPriceBook getPriceBookDetails(String recordId){
        ProductPriceBook ppb = new ProductPriceBook();
        List<Product> productList = new List<Product>();
        if(!String.isBlank(recordId)){
            List<Product2> products = [SELECT Id, Name, Family, Country__c, City__c, (SELECT Id, UnitPrice, Pricebook2.Name, Pricebook2.IsStandard, Pricebook2.StartDate__c, Pricebook2.End_Date__c FROM PricebookEntries WHERE IsActive = true AND  Pricebook2Id = :recordId) FROM Product2 WHERE IsActive = true AND Id IN (SELECT Product2Id FROM PricebookEntry WHERE Pricebook2Id = :recordId)];
            for(Product2 p: products){
                Product product = new Product();
                product.id = p.Id;
                product.title = p.Name;
                product.family = p.Family;
                product.country = p.Country__c;
                product.city = p.City__c;
                product.unitPrice = p.PricebookEntries.get(0).UnitPrice;
                product.newUnitPrice = 0.0;
                product.newGroupUnitPrice = 0.0;
                product.priceBookEntryId = p.PricebookEntries.get(0).Id;
                productList.add(product);
            }
            ppb.priceBookId = recordId;
            ppb.isStandard = products.get(0).PricebookEntries.get(0).Pricebook2.IsStandard;
            ppb.priceBookName = products.get(0).PricebookEntries.get(0).Pricebook2.Name;
            ppb.startDate = products.get(0).PricebookEntries.get(0).Pricebook2.StartDate__c;
            ppb.endDate = products.get(0).PricebookEntries.get(0).Pricebook2.End_Date__c;
            ppb.productNewPriceBookList = productList;
        }
        return ppb;
    }

    @AuraEnabled
    public static String upsertPriceBook(ProductPriceBook productPriceBook){
        Savepoint sp = Database.setSavepoint();
        List<Product> products = productPriceBook.productNewPriceBookList;
        List<String> productEntryIds = new List<String>();
        List<PricebookEntry> priceBookEntries = new List<PricebookEntry>();
        Pricebook2 pricebook = new Pricebook2();
        try {
            Map<String, Product2> productMap = new Map<String, Product2>([Select Id From Product2]);
            if (!String.isBlank(productPriceBook.priceBookId)) {
                pricebook.Id = productPriceBook.priceBookId;
            }
            pricebook.Name = productPriceBook.priceBookName;
            pricebook.StartDate__c = productPriceBook.startDate;
            pricebook.End_Date__c = productPriceBook.endDate;
            pricebook.IsActive = true;
            Database.upsert(pricebook);
            for (Product p: products) {
                PricebookEntry pricebookEntry = new PricebookEntry();
                if (!String.isBlank(p.priceBookEntryId)) {
                    productEntryIds.add(p.priceBookEntryId);
                    pricebookEntry.Id = p.priceBookEntryId;
                } else {
                    pricebookEntry.Pricebook2Id = pricebook.Id;
                    pricebookEntry.Pricebook2 = pricebook;
                    pricebookEntry.Product2Id = p.id;
                    pricebookEntry.Product2 = productMap.get(p.id);
                }
                pricebookEntry.UnitPrice = p.unitPrice;
                pricebookEntry.IsActive = true;
                if(p.newUnitPrice > 0) {
                    pricebookEntry.UnitPrice = p.newUnitPrice;
                }
                if (p.newGroupUnitPrice > 0 && (p.newGroupUnitPrice < p.newUnitPrice || p.newUnitPrice == 0)) {
                    pricebookEntry.UnitPrice = p.newGroupUnitPrice;
                }
                priceBookEntries.add(pricebookEntry);
            }
            List<PricebookEntry> pricebookToDelete = [SELECT Id FROM PricebookEntry WHERE Id NOT IN :productEntryIds AND Pricebook2Id = :pricebook.Id];
            Database.delete(pricebookToDelete);
            List<Database.UpsertResult> sr = Database.upsert(priceBookEntries);
        } catch (Exception e){
            Database.rollback(sp);
            throw new ExternalObjectException(e.getMessage());
        }
        return 'PriceBook ' + pricebook.Id + ' update successful';
    }


    @AuraEnabled
    public static List<Pricebook2> getAllPriceBooks(String recordId){
        List<Pricebook2> pricebooks = [SELECT Id, Name, StartDate__c, End_Date__c, IsStandard FROM Pricebook2 WHERE IsActive = true];
        return pricebooks;
    }

    @AuraEnabled
    public static String removeFromPriceBook(String recordId){
        Savepoint sp = Database.setSavepoint();
        try {
            List<Pricebook2> pricebooks = [SELECT Id, (SELECT Id FROM PricebookEntries) FROM Pricebook2 WHERE Id = :recordId];
            for(Pricebook2 p: pricebooks){
                List<PricebookEntry> pricebookEntries = p.PricebookEntries;
                System.debug(pricebookEntries.size());
                Database.delete(pricebookEntries);
            }
            System.debug(pricebooks.size());
            Database.delete(pricebooks);
        } catch(Exception e) {
            Database.rollback(sp);
            throw new ExternalObjectException(e.getMessage());
        }
        return 'Pricebook removed from Pricebook list';
    }
}