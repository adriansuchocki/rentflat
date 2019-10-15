/**
 * Created by BRITENET on 08.10.2019.
 */
({
    getReservedDate: function (component, recordId) {
        let spinnerAction = component.find("spinnerResult");
        let action = component.get("c.getReservedDate");
        spinnerAction.showHideSpinner(true);
        action.setParams({"productId": recordId});
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                console.log(response.getReturnValue());
                component.set("v.flatReservations", response.getReturnValue());
            }
            spinnerAction.showHideSpinner(false);
        });
        $A.enqueueAction(action);
    },

    getFlatDetailsHelper: function (component, recordId) {
        let spinnerAction = component.find("spinnerResult");
        let action = component.get("c.getFlat");
        spinnerAction.showHideSpinner(true);
        action.setParams({"productId": recordId})
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            console.log(state);
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                console.log(response.getReturnValue());
                component.set("v.flat", response.getReturnValue());
            }
            spinnerAction.showHideSpinner(false);
        });
        $A.enqueueAction(action);
    }
})