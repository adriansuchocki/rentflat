/**
 * Created by BRITENET on 11.10.2019.
 */
({
    clearFields: function(component, event, helper) {
        component.set('v.comment','');
        component.set('v.rating','0');
    },

    onSaveHelper: function(component, recordId, comment, rating) {
        let spinnerAction = component.find("spinnerResult");
        let action = component.get("c.addCommentAndRating");
        spinnerAction.showHideSpinner(true);
        action.setParams({'recordId': recordId, 'description': comment, 'rating': rating});
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                let refreshEvent = component.getEvent("refreshComments");
                refreshEvent.fire();
                let refreshFlatEvent = component.getEvent("refreshFlatDetails");
                refreshFlatEvent.fire();
            }
            let toastCmp = component.find("RFToast");
            toastCmp.showToast(response.getReturnValue());
            spinnerAction.showHideSpinner(false);
        });
        $A.enqueueAction(action);
    }
})