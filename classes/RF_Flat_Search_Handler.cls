/**
 * Created by BRITENET on 10.10.2019.
 */

public with sharing class RF_Flat_Search_Handler {
    public static String generateSearchQuery(Map<String, String> parameters) {
        String query = 'SELECT Id, Name, Size__c, Rooms__c, Bedrooms__c, Baths__c FROM Product2';
        String whereCondition = '';
        for(String fieldName: parameters.keySet()) {
            if(!String.isEmpty(parameters.get(fieldName))) {
                whereCondition += ' WHERE ' + fieldName + ' LIKE \'%' + parameters.get(fieldName) + '%\'';
            }
        }
        if(!String.isEmpty(whereCondition)) {
            query += whereCondition;
        }
        return query;
    }
}