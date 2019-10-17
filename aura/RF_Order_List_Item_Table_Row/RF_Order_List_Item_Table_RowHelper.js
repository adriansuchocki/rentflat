/**
 * Created by BRITENET on 17.10.2019.
 */
({
    createCaseHelper: function(component, recordId, subject, description) {
        var spinnerShowEvent = $A.get("e.c:RF_Flat_Spinner_Show_Event");
        spinnerShowEvent.fire();
        let action = component.get("c.createCase");
        action.setParams({"recordId": recordId, "subject": subject, "description": description});
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": response.getReturnValue(),
                    "type": "success"
                });
                toastEvent.fire();
                component.set("v.orderItem.Complained__c", true);
                component.set("v.cart", false);
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