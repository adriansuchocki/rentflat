({
    init: function (component, event, helper) {
        component.set('v.zoomLevel', 2);
        component.set('v.showFooter', true);
    },
    methodSearch: function(component, event, helper) {
        let params = event.getParam('arguments');
        let action = component.get("c.getResultLocations");
        let spinnerAction = component.find("spinnerComponentMap");
        spinnerAction.showHideSpinner(true);
        action.setParams({"id": params.idValue, "name": params.nameValue, "industry": params.industryValue, "phone": params.phoneValue, "type": params.typeValue});
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                let locations = response.getReturnValue();
                if(locations.length == 1){
                    component.set('v.zoomLevel', 16);
                } else {
                    component.set('v.zoomLevel', 3);
                }
                component.set('v.mapMarkers', response.getReturnValue());
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
    },

    clearComponent: function(component, event, helper) {
        component.set('v.mapMarkers', null);
    }
});