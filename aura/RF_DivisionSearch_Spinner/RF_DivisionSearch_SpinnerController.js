({
    showHideSpinnerHandler: function(component,event,helper){
        let params = event.getParam('arguments');
        let spinnerValue = params.spinnerParam;
        component.set("v.Spinner", spinnerValue);
    }
})