/**
 * Created by BRITENET on 17.10.2019.
 */
({
    getCasesHelper: function (component) {
        var spinnerShowEvent = $A.get("e.c:RF_Flat_Spinner_Show_Event");
        spinnerShowEvent.fire();
        let action = component.get("c.getCases");
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                console.log(response.getReturnValue());
                component.set("v.cases", response.getReturnValue());
            }
            var spinnerHideEvent = $A.get("e.c:RF_Flat_Spinner_Hide_Event");
            spinnerHideEvent.fire();
        });
        $A.enqueueAction(action);
    },
})