/**
 * Created by BRITENET on 08.10.2019.
 */
({
    getContentDocuments: function (component, recordId) {
        let spinnerAction = component.find("spinnerResult");
        let action = component.get("c.getContentDocuments");
        spinnerAction.showHideSpinner(true);
        action.setParams({"parentId": recordId})
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            console.log(state);
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                console.log(response.getReturnValue());
                component.set("v.photos", response.getReturnValue());
            }
            spinnerAction.showHideSpinner(false);
        });
        $A.enqueueAction(action);
    }
})