/**
 * Created by BRITENET on 12.10.2019.
 */
({
    removeFromList: function(component, event, helper) {
        event.stopImmediatePropagation();
        let index = event.getSource().get("v.value");
        var flatsJson = sessionStorage.getItem('RF_Flat_Search--cartList');
        var flats = JSON.parse(flatsJson);
        flats.splice(index,1);
        sessionStorage.setItem('RF_Flat_Search--cartList', JSON.stringify(flats));
        let searchEvent = $A.get("e.c:RF_Flat_Search_Cart");
        console.log('StartEvent = '+searchEvent);
        searchEvent.fire();
    },

    showFlat: function (component, event, helper) {
        let id = component.get('v.flat.id');
        var navEvt = $A.get('e.force:navigateToURL');
        let link = '/product/' +  id;
        navEvt.setParams({url: link});
        navEvt.fire();
    },

    reserveFlatHelper: function (component, event, helper) {
        let spinnerAction = component.find("spinnerResult");
        let action = component.get("c.reserveFlat");
        spinnerAction.showHideSpinner(true);
        var flatsJson = sessionStorage.getItem('RF_Flat_Search--cartList');
        var flats = JSON.parse(flatsJson);
//        let reservationList = [{"recordId": recordId, "title": "", "link": "", "reservationFrom": reservationFrom, "reservationTo": reservationTo}];
//        let JSONlist = JSON.stringify(flatsJson);
        action.setParams({"reservationList": flats});
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": response.getReturnValue(),
                    "type": "success"
                });
                toastEvent.fire();
            } else {
                var toastEvent = $A.get("e.force:showToast");
                console.log(errors[0]);
                toastEvent.setParams({
                    "title": "Error!",
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