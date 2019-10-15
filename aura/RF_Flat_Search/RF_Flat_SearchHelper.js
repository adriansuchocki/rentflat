/**
 * Created by BRITENET on 10.10.2019.
 */
({
    getCartListHelper: function (component) {
        let spinnerAction = component.find("spinnerResult");
        let action = component.get("c.getCart");
        spinnerAction.showHideSpinner(true);
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                console.log(response.getReturnValue())
                component.set("v.cartList", response.getReturnValue());
            }
            spinnerAction.showHideSpinner(false);
        });
        $A.enqueueAction(action);
    },

    getResultList: function (component, title, page) {
        let spinnerAction = component.find("spinnerResult");
        let action = component.get("c.getResultList");
        spinnerAction.showHideSpinner(true);
        action.setParams({"title": title, "page": page});
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                var flats = response.getReturnValue();
                sessionStorage.setItem("RF_Flat_Search--flatList", JSON.stringify(flats));
                var navEvt = $A.get("e.force:navigateToURL");
                navEvt.setParams({url: "/product-search"});
                navEvt.fire();
            }
            spinnerAction.showHideSpinner(false);
        });
        $A.enqueueAction(action);
    },

    getNextPageResultList: function (component, title, page) {
        let spinnerAction = component.find("spinnerResult");
        let action = component.get("c.getResultList");
        spinnerAction.showHideSpinner(true);
        action.setParams({"title": title, "page": page});
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                var flatsJson = JSON.parse(sessionStorage.getItem('RF_Flat_Search--flatList'));
                var resultList = response.getReturnValue();
                let result = flatsJson.concat(resultList);
                sessionStorage.setItem("RF_Flat_Search--flatList", JSON.stringify(result));
                let searchEvent = $A.get("e.c:RF_Flat_Search_Show_More_Results_Event");
                searchEvent.fire();
            }
            spinnerAction.showHideSpinner(false);
        });
        $A.enqueueAction(action);
    },

    reserveFlatHelper: function (component) {
        let spinnerAction = component.find("spinnerResult");
        let action = component.get("c.reserveFlatFromCart");
        spinnerAction.showHideSpinner(true);
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
                let searchEvent = $A.get("e.c:RF_Flat_Search_Cart");
                searchEvent.fire();
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
    },
})