/**
 * Created by BRITENET on 09.10.2019.
 */

public with sharing class RF_ContentDocumentLink_Trigger_Handler implements RF_ITrigger {
    List<ContentDocumentLink> contentDocumentLinks;
    List<ContentVersion> contentVersionList;
    List<String> cdlIds = new List<Id>();

    public void bulkBefore() {

    }

    public void bulkAfter() {

    }

    public void beforeInsert(List<SObject> newlstObj) {

//        contractsNew = (List<FB_Contract_Player_Club__c>) newlstObj;
//
//        for(FB_Contract_Player_Club__c newContract: contractsNew) {
//            players.add(newContract.Player__c);
//            clubs.add(newContract.Club__c);
//        }
//
//        contracts = [SELECT Player__c, Club__c, Player__r.Full_name__c, Club__r.Club_name__c, Start_date__c, End_date__c FROM FB_Contract_Player_Club__c WHERE Player__c IN :players AND Club__c IN :clubs];
//
//        for(FB_Contract_Player_Club__c contract: contracts) {
//            String key = String.valueOf(contract.Player__c) + String.valueOf(contract.Club__c);
//            if(contractsMap.containsKey(key)) {
//                contractsToMap = contractsMap.get(key);
//            } else {
//                contractsToMap = new List<FB_Contract_Player_Club__c>();
//            }
//            contractsToMap.add(contract);
//            contractsMap.put(key, contractsToMap);
//        }
//        String error = '';
//        for(FB_Contract_Player_Club__c newContract: contractsNew){
//            String key = String.valueOf(newContract.Player__c) + String.valueOf(newContract.Club__c);
//            error = '';
//            if(contractsMap.containsKey(key)){
//                contracts = contractsMap.get(key);
//                for(FB_Contract_Player_Club__c contract: contracts) {
//                    if((newContract.End_date__c == null && contract.End_date__c == null) ||
//                            (newContract.End_date__c == null && contract.End_date__c != null && newContract.Start_date__c < contract.End_date__c) ||
//                            (newContract.End_date__c != null && contract.End_date__c == null && contract.Start_date__c < newContract.End_date__c) ||
//                            (newContract.End_date__c != null && contract.End_date__c != null &&
//                                    ((contract.Start_date__c < newContract.End_date__c && contract.End_date__c > newContract.End_date__c) ||
//                                            (contract.Start_date__c < newContract.Start_date__c && contract.End_date__c > newContract.Start_date__c)))) {
//                        error += ' ' + System.Label.PLAYER_FULLNAME + ': ' + contract.Player__r.Full_name__c +
//                                ' ' + System.Label.CLUB_NAME + ': ' + contract.Club__r.Club_name__c +
//                                ' ' + System.Label.CONTRACT_START_DATE + ': ' + String.valueOf(contract.Start_date__c) +
//                                ' ' + System.Label.CONTRACT_END_DATE + ': ' + (contract.End_date__c != null? String.valueOf(contract.End_date__c) : System.Label.CONTRACT_END_DATE_UNKNOWN);
//                        newContract.addError(System.Label.ERROR_ADD_PLAYER_MESSAGE + error, false);
//                    }
//                }
//            }
//        }
    }
    public void beforeUpdate(List<SObject> newlstObj,List<SObject> oldlstObj,Map<Id,SObject> newMapObj, Map<Id,SObject> oldMapObj) {

    }

    public void beforeDelete(List<SObject> oldlstObj,Map<Id,SObject> oldMapObj) {

    }

    public void afterInsert(List<SObject> newlstObj,Map<Id,SObject> newMapObj) {
        contentDocumentLinks = (List<ContentDocumentLink>) newlstObj;
        System.debug(contentDocumentLinks.size());
        for(ContentDocumentLink cdl: contentDocumentLinks) {
            cdlIds.add(cdl.ContentDocumentId);
            System.debug(cdl.ContentDocumentId);
        }
        System.debug(cdlIds.size());
        contentVersionList = [SELECT Id, ContentDocument.Title FROM ContentVersion where ContentDocumentId IN :cdlIds];
        System.debug(contentVersionList.size());
        for(ContentVersion cv: contentVersionList) {
            ContentDistribution cd = new ContentDistribution();
            cd.Name = cv.ContentDocument.Title;
            cd.ContentVersionId = cv.Id;
            cd.PreferencesAllowViewInBrowser= true;
            cd.PreferencesLinkLatestVersion=true;
            cd.PreferencesNotifyOnVisit=false;
            cd.PreferencesPasswordRequired=false;
            cd.PreferencesAllowOriginalDownload= true;
            insert cd;
            System.debug('Dodalem ' + cd.Id);
        }

    }

    public void afterUpdate(List<SObject> newlstObj,List<SObject> oldlstObj,Map<Id,SObject> newMapObj, Map<Id,SObject> oldMapObj) {

    }

    public void afterDelete(List<SObject> oldlstObj,Map<Id,SObject> oldMapObj) {

    }

    public void andFinally() {

    }

}