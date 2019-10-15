/**
 * Created by BRITENET on 10.10.2019.
 */

public with sharing class RF_Flat_Search_Handler {
    public static String generateSearchQuery(Map<String, String> parameters, Integer page) {
        String query = 'SELECT Id, Name, Size__c, Rooms__c, Bedrooms__c, Baths__c, (SELECT Id, Rating__c FROM RF_Comments__r),' +
                ' (SELECT Id, UnitPrice, Pricebook2.IsStandard FROM PricebookEntries), (SELECT Id, ContentDocumentId FROM ContentDocumentLinks) FROM Product2 WHERE Id IN (SELECT Product2Id FROM PricebookEntry)';
        String whereCondition = '';
        for(String fieldName: parameters.keySet()) {
            if(!String.isEmpty(parameters.get(fieldName))) {
                whereCondition += ' AND ' + fieldName + ' LIKE \'%' + parameters.get(fieldName) + '%\'';
            }
        }
        if(!String.isEmpty(whereCondition)) {
            query +=  whereCondition;
        }
        Integer offset = page * 20;
        query += ' LIMIT 20 OFFSET ' + offset;
        return query;
    }

    public static List<RF_Flat_Details.FlatSearchItem> getFlats(Map<String, String> parameters, Integer page) {
        List<RF_Flat_Details.FlatSearchItem> flatList = new List<RF_Flat_Details.FlatSearchItem>();
        List<Product2> products = new List<Product2>();
        String query = RF_Flat_Search_Handler.generateSearchQuery(parameters, page);
        System.debug(query);
        products = Database.query(query);
        System.debug(products.size());
        for(Product2 p: products) {
            List<RF_Comments__c> comments = p.RF_Comments__r;
            Decimal ratingSum = 0;
            for(RF_Comments__c c: comments){
                ratingSum += c.Rating__c;
            }
            RF_Flat_Details.FlatSearchItem flat = new RF_Flat_Details.FlatSearchItem();
            flat.id = p.Id;
            flat.title = p.Name;
            flat.size = p.Size__c;
            flat.rooms = p.Rooms__c;
            flat.bedrooms = p.Bedrooms__c;
            flat.bathrooms = p.Baths__c;
            List<RF_Flat_Details.ContentDoc> contents = new List<RF_Flat_Details.ContentDoc>();
            for(ContentDocumentLink cdl: p.ContentDocumentLinks){
                for(ContentDistribution cd: [SELECT Id, ContentDownloadUrl, ContentVersion.ContentDocumentId FROM ContentDistribution]){
                    if(cdl.ContentDocumentId == cd.ContentVersion.ContentDocumentId){
                        RF_Flat_Details.ContentDoc contentDoc = new RF_Flat_Details.ContentDoc();
                        contentDoc.link = cd.ContentDownloadUrl;
                        contents.add(contentDoc);
                        continue;
                    }
                }
            }
            flat.link = '';
            if(!contents.isEmpty()){
                flat.link = contents.get(0).link;
            }
            if(comments.isEmpty()){
                flat.rating = 0.00;
                flat.numberOfRating = 0;
            } else {
                flat.rating = ratingSum/comments.size();
                flat.rating = flat.rating.setScale(2);
                flat.numberOfRating = comments.size();
            }
            System.debug(p.PricebookEntries.size());
            RF_Flat_Details.PriceBook priceBookTemp = new RF_Flat_Details.PriceBook();
            for(PricebookEntry pe: p.PricebookEntries) {
                if(pe.Pricebook2.IsStandard) {
                    priceBookTemp.standardValue = pe.UnitPrice;
                }
                if(priceBookTemp.value == null) {
                    priceBookTemp.value = pe.UnitPrice;
                } else if(priceBookTemp.value > pe.UnitPrice) {
                    priceBookTemp.value = pe.UnitPrice;
                }
            }
            flat.price = priceBookTemp;
            flatList.add(flat);
        }
        return flatList;
    }

    public static RF_Flat_Details.FlatSearchItem getFlat(String productId) {
        Product2 p = [SELECT Balcony__c, Baths__c, Bedrooms__c, Cameras_security_fenced__c, City__c, Country__c, CreatedById, CreatedDate, Description,
                Description__c, DisplayUrl, ExternalDataSourceId, ExternalId, Family, Floor_no__c, Garage__c, Garden__c, Ground_floor__c, Gym_in_the_building__c,
                Id, Last_floor__c, Lift__c,  Mezzanine__c, Name, Near_metro__c, Near_park__c, Near_pubs_restaurants__c, Near_tram_bus__c, Park_view__c,
                Parking_garage__c, ProductCode, QuantityUnitOfMeasure, River_view__c, Rooms__c, Size__c, Street_name__c, Terrace__c, WC_separated__c,
                Wheelchair_Access__c, Year_built__c, Year_built_formula__c, (SELECT Id, Rating__c FROM RF_Comments__r),
        (SELECT Id, UnitPrice, Pricebook2.IsStandard FROM PricebookEntries), (SELECT Id, ContentDocumentId FROM ContentDocumentLinks) FROM Product2 WHERE Id = :productId];
        RF_Flat_Details.FlatSearchItem flat = new RF_Flat_Details.FlatSearchItem();
        flat.id = productId;
        flat.title = p.Name;
        flat.size = p.Size__c;
        flat.rooms = p.Rooms__c;
        flat.bedrooms = p.Bedrooms__c;
        flat.bathrooms = p.Baths__c;
        flat.cameraSecurityFenced = p.Cameras_security_fenced__c;
        flat.balcony = p.Balcony__c;
        flat.yearBuilding = p.Year_built_formula__c;
        flat.wheelchairAccess = p.Wheelchair_Access__c;
        flat.wcSeparated = p.WC_separated__c;
        flat.terrace = p.Terrace__c;
        flat.streetName = p.Street_name__c;
        flat.riverView = p.River_view__c;
        flat.parkingGarage = p.Parking_garage__c;
        flat.parkView = p.Park_view__c;
        flat.nearTramBus = p.Near_tram_bus__c;
        flat.nearPubsRestaurants = p.Near_pubs_restaurants__c;
        flat.nearPark = p.Near_park__c;
        flat.nearMetro = p.Near_metro__c;
        flat.mezzanine = p.Mezzanine__c;
        flat.lift = p.Lift__c;
        flat.lastFloor = p.Last_floor__c;
        flat.gymInBuilding = p.Gym_in_the_building__c;
        flat.groundFloor = p.Ground_floor__c;
        flat.garden = p.Garden__c;
        flat.country = p.Country__c;
        flat.city = p.City__c;
        flat.family = p.Family;
        flat.floorNo = p.Floor_no__c;
        flat.description = p.Description__c;
        flat.rating = 0.00;
        flat.numberOfRating = 0;
        Decimal sumRating = 0;
        Integer counterRating = 0;
        for(RF_Comments__c c: p.RF_Comments__r){
            sumRating += c.Rating__c;
            counterRating++;
        }
        if(sumRating > 0) {
            flat.rating = sumRating/counterRating;
            flat.numberOfRating = counterRating;
        }
        flat.comments = p.RF_Comments__r;
        List<RF_Flat_Details.ContentDoc> contents = new List<RF_Flat_Details.ContentDoc>();
        for(ContentDocumentLink cdl: p.ContentDocumentLinks){
            for(ContentDistribution cd: [SELECT Id, ContentDownloadUrl, ContentVersion.ContentDocumentId FROM ContentDistribution]){
                if(cdl.ContentDocumentId == cd.ContentVersion.ContentDocumentId){
                    RF_Flat_Details.ContentDoc contentDoc = new RF_Flat_Details.ContentDoc();
                    contentDoc.link = cd.ContentDownloadUrl;
                    contents.add(contentDoc);
                }
            }
        }
        flat.contents = contents;
        RF_Flat_Details.PriceBook priceBook = new RF_Flat_Details.PriceBook();
        for(PricebookEntry pe: p.PricebookEntries) {
            if(pe.Pricebook2.IsStandard) {
                priceBook.standardValue = pe.UnitPrice;
            }
            if(priceBook.value == null) {
                priceBook.id = pe.Id;
                priceBook.value = pe.UnitPrice;
            } else if(priceBook.value > pe.UnitPrice) {
                priceBook.id = pe.Id;
                priceBook.value = pe.UnitPrice;
            }
        }
        flat.priceBook = priceBook;
        return flat;
    }
}