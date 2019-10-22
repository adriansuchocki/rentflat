/**
 * Created by BRITENET on 11.10.2019.
 */
({
    addToCartHelper: function (component, recordId, title, photo, reservationFrom, reservationTo, priceBookId, priceBookValue){
        let spinnerShowEvent = $A.get("e.c:RF_Flat_Spinner_Show_Event");
        spinnerShowEvent.fire();
        let action = component.get("c.addToCart");
        let reservationList = [{"recordId": recordId, "title": title, "link": photo, "reservationFrom": reservationFrom, "reservationTo": reservationTo, "priceBookId": priceBookId, "priceBookValue": priceBookValue}];
        let JSONlist = JSON.stringify(reservationList);
        action.setParams({"reservationList": JSONlist});
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
            let spinnerHideEvent = $A.get("e.c:RF_Flat_Spinner_Hide_Event");
            spinnerHideEvent.fire();
        });
        $A.enqueueAction(action);
    },

    reserveFlatHelper: function (component, recordId, title, photo, reservationFrom, reservationTo, priceBookId, priceBookValue) {
        let spinnerAction = component.find("spinnerResult");
        let action = component.get("c.reserveFlat");
        spinnerAction.showHideSpinner(true);
        let reservationList = [{"recordId": recordId, "title": title, "link": photo, "reservationFrom": reservationFrom, "reservationTo": reservationTo, "priceBookId": priceBookId, "priceBookValue": priceBookValue}];
        let JSONlist = JSON.stringify(reservationList);
        action.setParams({"reservationList": JSONlist});
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