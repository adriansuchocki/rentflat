/**
 * Created by BRITENET on 25.10.2019.
 */

public with sharing class RF_Flat_Helper {
    public static String generateSearchQuery(Map<String, String> parameters, Integer page) {
        String query = 'SELECT Id, Name, Size__c, Rooms__c, Bedrooms__c, Baths__c, (SELECT Id, Rating__c FROM RF_Comments__r),' +
                ' (SELECT Id, UnitPrice, Pricebook2.IsStandard FROM PricebookEntries WHERE (Pricebook2.IsStandard = true) OR (Pricebook2.StartDate__c <= TODAY AND Pricebook2.End_Date__c >= TODAY)), (SELECT Id, ContentDocumentId FROM ContentDocumentLinks),' +
                ' (SELECT Id, CreatedById FROM RF_Favourites__r) FROM Product2 WHERE Id IN (SELECT Product2Id FROM PricebookEntry WHERE (Pricebook2.IsStandard = true) OR (Pricebook2.StartDate__c <= TODAY AND Pricebook2.End_Date__c >= TODAY)) AND IsActive = true';
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

    public static List<RF_Flat> getFlats(Map<String, String> parameters, Integer page) {
        List<RF_Flat> flats = new List<RF_Flat>();
        List<Product2> products = new List<Product2>();
        String query = RF_Flat_Search_Handler.generateSearchQuery(parameters, page);
        System.debug(query);
        products = Database.query(query);
        System.debug(products.size());
        for(Product2 p: products) {
            RF_Flat flat = new RF_Flat(p);
            flat.photos = RF_ContentDocument_Helper.getContentDocument(p.ContentDocumentLinks);
            flats.add(flat);
        }
        return flats;
    }

    public static RF_Flat getFlat(String productId) {
        Product2 p = [SELECT Balcony__c, Baths__c, Bedrooms__c, Cameras_security_fenced__c, City__c, Country__c, CreatedById, CreatedDate, Description,
                Description__c, DisplayUrl, ExternalDataSourceId, ExternalId, Family, Floor_no__c, Garage__c, Garden__c, Ground_floor__c, Gym_in_the_building__c,
                Id, Last_floor__c, Lift__c,  Mezzanine__c, Name, Near_metro__c, Near_park__c, Near_pubs_restaurants__c, Near_tram_bus__c, Number_of_view__c, Park_view__c,
                Parking_garage__c, ProductCode, QuantityUnitOfMeasure, River_view__c, Rooms__c, Size__c, Street_name__c, Terrace__c, WC_separated__c,
                Wheelchair_Access__c, Year_built__c, Year_built_formula__c, (SELECT Id, Rating__c FROM RF_Comments__r),
        (SELECT Id, UnitPrice, Pricebook2.IsStandard FROM PricebookEntries WHERE (Pricebook2.IsStandard = true) OR (Pricebook2.StartDate__c <= TODAY AND Pricebook2.End_Date__c >= TODAY)),
        (SELECT Id, ContentDocumentId FROM ContentDocumentLinks),
        (SELECT Id, CreatedById FROM RF_Favourites__r) FROM Product2 WHERE Id = :productId LIMIT 1];
        RF_Flat flat = new RF_Flat(p);
        flat.photos = RF_ContentDocument_Helper.getContentDocuments(p.ContentDocumentLinks);
        return flat;
    }

    public static RF_Rataing getFlatRating(String productId){
        List<AggregateResult> comments = [SELECT Product__c, SUM(Rating__c) sumRating, COUNT(Rating__c) numberOfRating FROM RF_Comments__c WHERE Product__c = :productId GROUP BY Product__c];
        RF_Rataing r = new RF_Rataing();
        r.rating = 0.00;
        r.numberOfRating = 0;
        for(AggregateResult a: comments){
            Integer numberOfRating = (Integer) comments[0].get('numberOfRating');
            r.rating = ((Decimal) comments[0].get('sumRating')) / numberOfRating ;
            r.numberOfRating = numberOfRating;
        }
        return r;
    }

    public static void increaseNumberOfViews(String recordId){
        List<Product2> product = [SELECT Id, Number_of_view__c FROM Product2 WHERE Id = :recordId];
        if(!product.isEmpty()){
            product.get(0).Number_of_view__c ++;
            Database.update(product);
        }
    }
}