/**
 * Created by BRITENET on 08.10.2019.
 */
({
    getPriceValue: function (component, recordId) {
        let spinnerAction = component.find("spinnerResult");
        let action = component.get("c.getPriceBookValue");
        spinnerAction.showHideSpinner(true);
        action.setParams({"parentId": recordId});
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                component.set("v.pricebookValue", response.getReturnValue());
            }
            spinnerAction.showHideSpinner(false);
        });
        $A.enqueueAction(action);
    }
})