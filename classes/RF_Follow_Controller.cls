/**
 * Created by BRITENET on 23.10.2019.
 */

public with sharing class RF_Follow_Controller {

    @AuraEnabled
    public static List<RF_Flat> getFollowFlat(){
        return RF_Follow_Helper.getFollowFlat();
    }

    @AuraEnabled
    public static RF_Response_Message addToFollow(String recordId){
        return RF_Follow_Helper.addToFollow(recordId);
    }

    @AuraEnabled
    public static RF_Response_Message removeFromFollow(String recordId){
        return RF_Follow_Helper.removeFromFollow(recordId);
    }
}