/**
 * Created by BRITENET on 08.10.2019.
 */
({
    getFlatDetailsHelper: function (component, recordId) {
        let spinnerShowEvent = $A.get("e.c:RF_Flat_Spinner_Show_Event");
        spinnerShowEvent.fire();
        let action = component.get("c.getFlat");
        action.setParams({"productId": recordId})
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            console.log(state);
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                console.log(response.getReturnValue());
                let flatRecord = response.getReturnValue();
                component.set("v.flat", response.getReturnValue());
            } else {
                let toastCmp = component.find("RFToast");
                toastCmp.showToast({"statusCode": $A.get("{! $Label.c.MESSAGE_ERROR_CODE }"), "title": $A.get("{! $Label.c.MESSAGE_ERROR }"), "message": errors[0].message});
            }
            let spinnerHideEvent = $A.get("e.c:RF_Flat_Spinner_Hide_Event");
            spinnerHideEvent.fire();
        });
        $A.enqueueAction(action);
    },

    addToFollowHelper: function (component, id) {
        let spinnerShowEvent = $A.get("e.c:RF_Flat_Spinner_Show_Event");
        spinnerShowEvent.fire();
        let action = component.get("c.addToFollow");
        action.setParams({'recordId': id});
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                console.log(response.getReturnValue());
                component.set("v.flat.follow", true);
            }
            let toastCmp = component.find("RFToast");
            toastCmp.showToast(response.getReturnValue());
            console.log(response.getReturnValue());
            let spinnerHideEvent = $A.get("e.c:RF_Flat_Spinner_Hide_Event");
            spinnerHideEvent.fire();
        });
        $A.enqueueAction(action);
    },

    removeFromFollowHelper: function (component, id) {
        let spinnerShowEvent = $A.get("e.c:RF_Flat_Spinner_Show_Event");
        spinnerShowEvent.fire();
        let action = component.get("c.removeFromFollow");
        action.setParams({'recordId': id});
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                component.set("v.flat.follow", false);
            }
            let toastCmp = component.find("RFToast");
            toastCmp.showToast(response.getReturnValue());
            let spinnerHideEvent = $A.get("e.c:RF_Flat_Spinner_Hide_Event");
            spinnerHideEvent.fire();
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