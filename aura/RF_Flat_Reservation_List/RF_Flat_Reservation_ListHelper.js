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
            let toastCmp = component.find("RFToast");
            toastCmp.showToast(response.getReturnValue());
            let spinnerHideEvent = $A.get("e.c:RF_Flat_Spinner_Hide_Event");
            spinnerHideEvent.fire();
        });
        $A.enqueueAction(action);
    },

    reserveFlatHelper: function (component, recordId, title, photo, reservationFrom, reservationTo, priceBookId, priceBookValue) {
        let action = component.get("c.reserveFlat");
        let reservationList = [{"recordId": recordId, "title": title, "link": photo, "reservationFrom": reservationFrom, "reservationTo": reservationTo, "priceBookId": priceBookId, "priceBookValue": priceBookValue}];
        let JSONlist = JSON.stringify(reservationList);
        action.setParams({"reservations": JSONlist});
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            let toastCmp = component.find("RFToast");
            toastCmp.showToast(response.getReturnValue());
        });
        $A.enqueueAction(action);
    }
})