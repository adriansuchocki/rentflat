/**
 * Created by BRITENET on 08.10.2019.
 */
({
    getReservedDate: function (component, recordId) {
        let spinnerAction = component.find("spinnerResult");
        let action = component.get("c.getReservedDate");
        spinnerAction.showHideSpinner(true);
        action.setParams({"productId": recordId});
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                component.set("v.flatReservations", response.getReturnValue());
            }
            spinnerAction.showHideSpinner(false);
        });
        $A.enqueueAction(action);
    },

    getFlatDetailsHelper: function (component, recordId) {
        let spinnerAction = component.find("spinnerResult");
        let action = component.get("c.getFlat");
        spinnerAction.showHideSpinner(true);
        action.setParams({"productId": recordId})
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            console.log(state);
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                console.log(response.getReturnValue());
                let flatRecord = response.getReturnValue();
                component.set("v.follow", flatRecord.follow);
                component.set("v.flat", response.getReturnValue());
            }
            spinnerAction.showHideSpinner(false);
        });
        $A.enqueueAction(action);
    },
    addToFollowHelper: function (component, id) {
        let spinnerAction = component.find("spinnerResult");
        let action = component.get("c.addToFollow");
        action.setParams({'recordId': id});
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                component.set("v.follow", true);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": response.getReturnValue(),
                    "type": "success"
                });
                toastEvent.fire();
            } else {
                var toastEvent = $A.get("e.force:showToast");
                console.log(errors[0]);
                toastEvent.setParams({
                    "title": "Error!",
                    "message": errors[0].message,
                    "type": "error"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },

    removeFromFollowHelper: function (component, id) {
        let spinnerAction = component.find("spinnerResult");
        let action = component.get("c.removeFromFollow");
        action.setParams({'recordId': id});
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                component.set("v.follow", false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": response.getReturnValue(),
                    "type": "success"
                });
                toastEvent.fire();
            } else {
                var toastEvent = $A.get("e.force:showToast");
                console.log(errors[0]);
                toastEvent.setParams({
                    "title": "Error!",
                    "message": errors[0].message,
                    "type": "error"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },

    addNumberOfViewHelper: function (component, id){
        let spinnerAction = component.find("spinnerResult");
        let action = component.get("c.increaseNumberOfViews");
        action.setParams({'recordId': id});
        $A.enqueueAction(action);
    }
})