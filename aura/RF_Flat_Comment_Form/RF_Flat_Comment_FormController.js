/**
 * Created by BRITENET on 11.10.2019.
 */
({
    onSave: function(component,event, helper) {
        let spinnerAction = component.find("spinnerResult");
        let action = component.get("c.addCommentAndRating");
        spinnerAction.showHideSpinner(true);
        let recordId = component.get('v.recordId');
        let comment = component.get('v.comment');
        let rating = component.get('v.rating');
        action.setParams({'recordId': recordId, 'description': comment, 'rating': rating});
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                helper.clearFields(component,event, helper);
                let refreshEvent = component.getEvent("refreshComments");
                refreshEvent.fire();
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": $A.get("{!$ Label.c.LABEL_SUCCESS_TITLE }"),
                    "message": response.getReturnValue(),
                    "type": "success"
                });
                toastEvent.fire();
            } else {
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": $A.get("{!$ Label.c.LABEL_ERROR_TITLE }"),
                    "message": errors[0].message,
                    "type": "error"
                });
                toastEvent.fire();
            }
            spinnerAction.showHideSpinner(false);
        });
        $A.enqueueAction(action);
    }
})