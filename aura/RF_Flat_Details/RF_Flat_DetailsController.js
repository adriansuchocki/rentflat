/**
 * Created by BRITENET on 08.10.2019.
 */
({
    init: function (component, event, helper) {
        let recordId = component.get("v.recordId");
        helper.getPriceValue(component, recordId);
        helper.getReservedDate(component, recordId);
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

    }
})