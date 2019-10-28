/**
 * Created by BRITENET on 23.10.2019.
 */
({
    getCartListHelper: function (component) {
        let action = component.get("c.getCart");
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                console.log(response.getReturnValue())
                component.set("v.cartList", response.getReturnValue());
            } else {
                let toastCmp = component.find("RFToast");
                toastCmp.showToast({"statusCode": $A.get("{! $Label.c.MESSAGE_ERROR_CODE }"), "title": $A.get("{! $Label.c.MESSAGE_ERROR }"), "message": errors[0].message});
            }
        });
        $A.enqueueAction(action);
    },

    reserveFlatHelper: function (component) {
        let spinnerShowEvent = $A.get("e.c:RF_Flat_Spinner_Show_Event");
        spinnerShowEvent.fire();
        let action = component.get("c.reserveFlatFromCart");
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                let searchEvent = $A.get("e.c:RF_Flat_Search_Cart");
                searchEvent.fire();
            }
            let toastCmp = component.find("RFToast");
            toastCmp.showToast(response.getReturnValue());
            let spinnerHideEvent = $A.get("e.c:RF_Flat_Spinner_Hide_Event");
            spinnerHideEvent.fire();
        });
        $A.enqueueAction(action);
    },
})