/**
 * Created by BRITENET on 14.10.2019.
 */
({
    removeElementFromCartListHelper: function (component, index) {
        let spinnerAction = component.find("spinnerResult");
        let action = component.get("c.removeElementFromCartList");
        spinnerAction.showHideSpinner(true);
        action.setParams({'index': index});
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                component.set('v.cartList', response.getReturnValue());
                let searchEvent = $A.get("e.c:RF_Flat_Search_Cart");
                searchEvent.fire();
            }
            spinnerAction.showHideSpinner(false);
        });
        $A.enqueueAction(action);
    },
})