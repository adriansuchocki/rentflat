/**
 * Created by BRITENET on 23.10.2019.
 */

public class RF_ContentDocument_Helper {
    public static List<String> getContentDocument(List<ContentDocumentLink> contentDocumentLinks){
        List<String> contentDocumentsURL = new List<String>();
        Set<String> contentId = new Set<String>();
        for(ContentDocumentLink cdl: contentDocumentLinks) {
            contentId.add(cdl.ContentDocumentId);
        }
        Set<Id> versionContentList = new Set<Id>();
        List<ContentVersion> contentVersions = [SELECT Id FROM ContentVersion WHERE ContentDocumentId IN :contentId];
        for(ContentVersion cv: contentVersions){
            versionContentList.add(cv.Id);
        }
        List<ContentDistribution> contentDistributions = [SELECT Id, ContentDownloadUrl, ContentVersion.ContentDocumentId FROM ContentDistribution WHERE ContentVersionId IN :versionContentList LIMIT 1];
        System.debug(contentDistributions);
        for(ContentDistribution cd: contentDistributions){
            contentDocumentsURL.add(cd.ContentDownloadUrl);
        }
        return contentDocumentsURL;
    }

    public static List<String> getContentDocuments(List<ContentDocumentLink> contentDocumentLinks){
        List<String> contentDocumentsURL = new List<String>();
        Set<String> contentId = new Set<String>();
        for(ContentDocumentLink cdl: contentDocumentLinks) {
            contentId.add(cdl.ContentDocumentId);
        }
        Set<Id> versionContentList = new Set<Id>();
        List<ContentVersion> contentVersions = [SELECT Id FROM ContentVersion WHERE ContentDocumentId IN :contentId];
        for(ContentVersion cv: contentVersions){
            versionContentList.add(cv.Id);
        }
        List<ContentDistribution> contentDistributions = [SELECT Id, ContentDownloadUrl, ContentVersion.ContentDocumentId FROM ContentDistribution WHERE ContentVersionId IN :versionContentList];
        System.debug(contentDistributions);
        for(ContentDistribution cd: contentDistributions){
            contentDocumentsURL.add(cd.ContentDownloadUrl);
        }
        return contentDocumentsURL;
    }
}