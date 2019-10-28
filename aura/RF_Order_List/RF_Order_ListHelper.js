/**
 * Created by BRITENET on 15.10.2019.
 */
({
    getOrdersHelper: function (component) {
        var spinnerShowEvent = $A.get("e.c:RF_Flat_Spinner_Show_Event");
        spinnerShowEvent.fire();
        let action = component.get("c.getUserOrders");
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                console.log(response.getReturnValue());
                component.set("v.orders", response.getReturnValue());
            } else {
                let toastCmp = component.find("RFToast");
                toastCmp.showToast({"statusCode": $A.get("{! $Label.c.MESSAGE_ERROR_CODE }"), "title": $A.get("{! $Label.c.MESSAGE_ERROR }"), "message": errors[0].message});
            }
            var spinnerHideEvent = $A.get("e.c:RF_Flat_Spinner_Hide_Event");
            spinnerHideEvent.fire();
        });
        $A.enqueueAction(action);
    }
})