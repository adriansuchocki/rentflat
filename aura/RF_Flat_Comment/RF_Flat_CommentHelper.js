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
                let toastCmp = component.find("RFToast");
                toastCmp.showToast({"statusCode": $A.get("{! $Label.c.MESSAGE_ERROR_CODE }"), "title": $A.get("{! $Label.c.MESSAGE_ERROR }"), "message": errors[0].message});
            }
            let spinnerHideEvent = $A.get("e.c:RF_Flat_Spinner_Hide_Event");
            spinnerHideEvent.fire();
        });
        $A.enqueueAction(action);
    }
})