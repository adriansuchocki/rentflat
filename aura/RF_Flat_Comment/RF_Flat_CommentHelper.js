/**
 * Created by BRITENET on 11.10.2019.
 */
({
    getFlatComments: function (component, recordId) {
        let spinnerShowEvent = $A.get("e.c:RF_Flat_Spinner_Show_Event");
        spinnerShowEvent.fire();
        let action = component.get("c.getFlatComments");
        action.setParams({'recordId': recordId});
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                console.log(response.getReturnValue());
                component.set("v.comments", response.getReturnValue());
            } else {
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": $A.get("{!$ Label.c.LABEL_ERROR_TITLE }"),
                    "message": errors[0].message,
                    "type": "error"
                });
                toastEvent.fire();
            }
            let spinnerHideEvent = $A.get("e.c:RF_Flat_Spinner_Hide_Event");
            spinnerHideEvent.fire();
        });
        $A.enqueueAction(action);
    }
})