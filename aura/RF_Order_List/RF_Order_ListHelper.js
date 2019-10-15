/**
 * Created by BRITENET on 15.10.2019.
 */
({
    getOrdersHelper: function (component) {
//        let spinnerAction = component.find("spinnerResult");
        let action = component.get("c.getUserOrders");
//        spinnerAction.showHideSpinner(true);
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                console.log(response.getReturnValue());
                component.set("v.orders", response.getReturnValue());
            }
//            spinnerAction.showHideSpinner(false);
        });
        $A.enqueueAction(action);
    }
})