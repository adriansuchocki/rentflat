/**
 * Created by BRITENET on 15.10.2019.
 */
({
    getFollowHelper: function (component) {
        var spinnerShowEvent = $A.get("e.c:RF_Flat_Spinner_Show_Event");
        spinnerShowEvent.fire();
        let action = component.get("c.getFollowFlat");
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                console.log(response.getReturnValue());
                component.set("v.flats", response.getReturnValue());
            } else {
                let toastCmp = component.find("RFToast");
                toastCmp.showToast({"statusCode": $A.get("{! $Label.c.MESSAGE_ERROR_CODE }"), "title": $A.get("{! $Label.c.MESSAGE_ERROR }"), "message": errors[0].message});
            }
            var spinnerHideEvent = $A.get("e.c:RF_Flat_Spinner_Hide_Event");
            spinnerHideEvent.fire();
        });
        $A.enqueueAction(action);
    },

    removeFromFollowHelper: function (component, id) {
        var spinnerShowEvent = $A.get("e.c:RF_Flat_Spinner_Show_Event");
        spinnerShowEvent.fire();
        let action = component.get("c.removeFromFollow");
        action.setParams({'recordId': id});
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                component.set("v.follow", false);
            }
            let toastCmp = component.find("RFToast");
            toastCmp.showToast(response.getReturnValue());
            var spinnerHideEvent = $A.get("e.c:RF_Flat_Spinner_Hide_Event");
            spinnerHideEvent.fire();
        });
        $A.enqueueAction(action);
    }
})