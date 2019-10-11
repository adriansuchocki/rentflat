/**
 * Created by BRITENET on 11.10.2019.
 */
({
    getFlatComments: function (component, recordId) {
        let spinnerAction = component.find("spinnerResult");
        let action = component.get("c.getFlatComments");
        spinnerAction.showHideSpinner(true);
        alert('Robie2');
        action.setParams({'recordId': recordId});
        alert('Robie');
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                console.log(response.getReturnValue());
                component.set("v.comments", response.getReturnValue());
            } else {
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": $A.get("{!$ Label.c.LABEL_ERROR_TITLE }"),
                    "message": errors[0].message,
                    "type": "error"
                });
                toastEvent.fire();
            }
            spinnerAction.showHideSpinner(false);
        });
        $A.enqueueAction(action);
    }
})