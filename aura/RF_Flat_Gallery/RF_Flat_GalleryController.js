/**
 * Created by BRITENET on 08.10.2019.
 */
({
    init: function (component, event, helper) {
        let recordId = component.get("v.recordId");
        helper.getContentDocuments(component, recordId);
    },
})