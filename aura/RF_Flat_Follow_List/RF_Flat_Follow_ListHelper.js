/**
 * Created by BRITENET on 15.10.2019.
 */
({
    getOrdersHelper: function (component) {
        var spinnerShowEvent = $A.get("e.c:RF_Flat_Spinner_Show_Event");
        spinnerShowEvent.fire();
        let action = component.get("c.getFollowFlat");
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                console.log(response.getReturnValue());
                component.set("v.flats", response.getReturnValue());
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
            var spinnerHideEvent = $A.get("e.c:RF_Flat_Spinner_Hide_Event");
            spinnerHideEvent.fire();
        });
        $A.enqueueAction(action);
    }
})