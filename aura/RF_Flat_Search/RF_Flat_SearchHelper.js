/**
 * Created by BRITENET on 10.10.2019.
 */
({
    getResultList: function (component, title) {
        let spinnerAction = component.find("spinnerResult");
        let action = component.get("c.getResultList");
        spinnerAction.showHideSpinner(true);
        action.setParams({'title': title});
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                var flats = response.getReturnValue();
                console.log(flats);
                sessionStorage.setItem('RF_Flat_Search--flatList', JSON.stringify(flats));
                var navEvt = $A.get('e.force:navigateToURL');
                navEvt.setParams({url: '/product-search'});
                navEvt.fire();
            }
            spinnerAction.showHideSpinner(false);
        });
        $A.enqueueAction(action);
    }
})