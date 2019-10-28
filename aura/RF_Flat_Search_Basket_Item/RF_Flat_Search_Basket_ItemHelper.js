/**
 * Created by BRITENET on 14.10.2019.
 */
({
    removeElementFromCartListHelper: function (component, index) {
        let spinnerShowEvent = $A.get("e.c:RF_Flat_Spinner_Show_Event");
        spinnerShowEvent.fire();
        let action = component.get("c.removeElementFromCartList");
        action.setParams({'index': index});
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                component.set('v.cartList', response.getReturnValue());
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