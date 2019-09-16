public with sharing class RF_DivisionSearch_ResultApexController {
    public class Location{
        @AuraEnabled
        public String icon{get;set;}
        @AuraEnabled
        public String title{get;set;}
        @AuraEnabled
        public String description{get;set;}
        @AuraEnabled
        public GeoLocation location{get;set;}
    }

    public class GeoLocation{
        @AuraEnabled
        public String Street{get;set;}
        @AuraEnabled
        public String PostalCode{get;set;}
        @AuraEnabled
        public String City{get;set;}
        @AuraEnabled
        public String State{get;set;}
        @AuraEnabled
        public String Country{get;set;}
    }

    @AuraEnabled
    public static List<Account> getResultSearch(String name, String industry, String phone, String type){
        Map<String, String> parameters = new Map<String, String>();
        System.debug(name);
        parameters.put('Name', name);
        parameters.put('Industry', industry);
        parameters.put('Phone', phone);
        parameters.put('Type', type);
        List<Account> accounts = new List<Account>();
        String query = RF_DivisionSearch_ResultApexHelper.generateSearchQuery(parameters);
        System.debug(query);
        accounts = Database.query(query);
        return accounts;
    }

    @AuraEnabled
    public static List<Location> getResultLocations(String id, String name, String industry, String phone, String type){
        List<Account> accounts = getResultSearch(name, industry, phone, type);
        System.debug(id);
        List<Location> loc = new List<Location>();
        for(Account acc :accounts){
            GeoLocation geoInfo = new GeoLocation();
            geoInfo.Street = acc.BillingStreet;
            geoInfo.PostalCode = acc.BillingPostalCode;
            geoInfo.City = acc.BillingCity;
            geoInfo.State = acc.BillingState;
            geoInfo.Country = acc.BillingCountry;
            Location locDetail = new Location();
            locDetail.icon = 'action:map';
            locDetail.title = acc.Name;
            locDetail.description = acc.Name;
            locDetail.location = geoInfo;
            if(String.isEmpty(id)){
                loc.add(locDetail);
            } else if(acc.Id == id) {
                loc.add(locDetail);
            }
        }
        return loc ;
    }

    @AuraEnabled
    public static String deleteSelectedAccount(String id) {
        List<Account> accounts = [SELECT Id FROM Account WHERE Id = : id];
        try {
            delete accounts[0];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return '';
    }
}