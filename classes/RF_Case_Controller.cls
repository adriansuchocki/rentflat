/**
 * Created by BRITENET on 24.10.2019.
 */

public with sharing class RF_Case_Controller {

    @AuraEnabled
    public static RF_Response_Message createCase(String recordId, String subject, String description){
        return RF_Case_Helper.createCase(recordId, subject, description);
    }

    @AuraEnabled
    public static List<Case> getCases(){
        return RF_Case_Helper.getCases();
    }
}