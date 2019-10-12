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
        contentDocumentLinks = (List<ContentDocumentLink>) newlstObj;
        for(ContentDocumentLink cdl: contentDocumentLinks) {
            cdl.Visibility = 'AllUsers';
        }
    }
    public void beforeUpdate(List<SObject> newlstObj,List<SObject> oldlstObj,Map<Id,SObject> newMapObj, Map<Id,SObject> oldMapObj) {

    }

    public void beforeDelete(List<SObject> oldlstObj,Map<Id,SObject> oldMapObj) {

    }

    public void afterInsert(List<SObject> newlstObj,Map<Id,SObject> newMapObj) {
        contentDocumentLinks = (List<ContentDocumentLink>) newlstObj;
        for(ContentDocumentLink cdl: contentDocumentLinks) {
            cdlIds.add(cdl.ContentDocumentId);
        }
        contentVersionList = [SELECT Id, ContentDocument.Title FROM ContentVersion where ContentDocumentId IN :cdlIds];
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
        }

    }

    public void afterUpdate(List<SObject> newlstObj,List<SObject> oldlstObj,Map<Id,SObject> newMapObj, Map<Id,SObject> oldMapObj) {

    }

    public void afterDelete(List<SObject> oldlstObj,Map<Id,SObject> oldMapObj) {

    }

    public void andFinally() {

    }

}