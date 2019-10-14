/**
 * Created by BRITENET on 09.10.2019.
 */

trigger RF_Flat_ContentDocumentLink_Trigger on ContentDocumentLink (after insert, before insert) {
    RF_TriggerFactory.createHandler(ContentDocumentLink.sobjectType);
}