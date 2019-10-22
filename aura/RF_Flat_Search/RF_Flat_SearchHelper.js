/**
 * Created by BRITENET on 10.10.2019.
 */
({
    getCartListHelper: function (component) {
        let action = component.get("c.getCart");
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                console.log(response.getReturnValue())
                component.set("v.cartList", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    getResultList: function (component, title, page) {
        let params = {'title': title, 'page': page};
        sessionStorage.setItem("RF_Flat_Search--flatList", JSON.stringify(params));
        var navEvt = $A.get("e.force:navigateToURL");
        navEvt.setParams({url: "/product-search"});
        navEvt.fire();
    },

    reserveFlatHelper: function (component) {
        let spinnerShowEvent = $A.get("e.c:RF_Flat_Spinner_Show_Event");
        spinnerShowEvent.fire();
        let action = component.get("c.reserveFlatFromCart");
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
            let spinnerHideEvent = $A.get("e.c:RF_Flat_Spinner_Hide_Event");
            spinnerHideEvent.fire();
        });
        $A.enqueueAction(action);
    },
})