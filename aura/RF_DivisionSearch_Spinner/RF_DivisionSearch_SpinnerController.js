({
    showHideSpinnerHandler: function(component,event,helper){
        let spinnerValue = component.get("v.spinnerParam");
        component.set("v.Spinner", spinnerValue);
    }
})