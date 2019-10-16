/**
 * Created by BRITENET on 08.10.2019.
 */
({
    init: function (component, event, helper) {
        let recordId = component.get("v.recordId");
        let flat = component.get("v.flatRecord");
        let sum = 0;
        helper.getFlatDetailsHelper(component, recordId);
    },

    handleUploadFinished : function(component, event, helper) {
        var uploadedFiles = event.getParam("files");
        var documentId = uploadedFiles[0].documentId;
        var fileName = uploadedFiles[0].name;
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "File "+fileName+" Uploaded successfully."
        });
        toastEvent.fire();

        $A.get('e.lightning:openFiles').fire({
            recordIds: [documentId]
        });

    },

    handleAddFollow: function (component, event, helper) {
        let id = component.get('v.flat.id');
        helper.addToFollowHelper(component, id);
    },

    handleRemoveFollow: function (component, event, helper) {
        let id = component.get('v.flat.id');
        helper.removeFromFollowHelper(component, id);
    }
})