/**
 * Created by BRITENET on 24.10.2019.
 */

public with sharing class RF_Response_Message {
    @AuraEnabled
    String statusCode { get; set; }
    @AuraEnabled
    String title { get; set; }
    @AuraEnabled
    String message { get; set; }

    public RF_Response_Message(String statusCode, String title, String message){
        this.statusCode = statusCode;
        this.title = title;
        this.message = message;
    }
}