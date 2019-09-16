public with sharing class RF_DivisionSearch_ResultApexHelper {
    public static String generateSearchQuery(Map<String, String> parameters) {
        String query = 'SELECT ID, Name, Type, NumberOfEmployees, TickerSymbol, Phone, BillingAddress, BillingStreet, BillingCity, BillingCountry, BillingPostalCode, BillingState FROM Account WHERE RecordTypeId IN (Select Id from RecordType WHERE Name = \'Division\') ';
        String whereCondition = '';
        for(String fieldName: parameters.keySet()) {
            if(!String.isEmpty(parameters.get(fieldName))) {
                whereCondition += ' AND ' + fieldName + ' LIKE \'%' + parameters.get(fieldName) + '%\'';
            }
        }
        if(!String.isEmpty(whereCondition)) {
            query += whereCondition;
        }
        return query;
    }
}