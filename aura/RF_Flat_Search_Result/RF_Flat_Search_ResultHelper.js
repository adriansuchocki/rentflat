/**
 * Created by BRITENET on 10.10.2019.
 */
({
    getResultList: function (component, title) {
        let spinnerAction = component.find("spinnerResult");
        let action = component.get("c.getResultList");
        spinnerAction.showHideSpinner(true);
        action.setParams({'title': title})
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                component.set("v.resultList", response.getReturnValue());
            }
            spinnerAction.showHideSpinner(false);
        });
        $A.enqueueAction(action);
    }
})