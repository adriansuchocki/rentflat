/**
 * Created by BRITENET on 18.10.2019.
 */
({
    getAllProductsHelper: function (component, text, inNewPriceBook) {
        let action = component.get("c.getAllResultList");
        action.setParams({'text': text, 'inNewPriceBook': inNewPriceBook})
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                console.log(response.getReturnValue());
                component.set("v.productStandardPriceBookList", response.getReturnValue());
                let spinnerHideEvent = $A.get("e.c:RF_Flat_Spinner_Hide_Event");
                spinnerHideEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },

    getPriceBookHelper: function (component, recordId) {
        let spinnerShowEvent = $A.get("e.c:RF_Flat_Spinner_Show_Event");
        spinnerShowEvent.fire();
        let action = component.get("c.getPriceBookDetails");
        action.setParams({'recordId': recordId})
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                console.log(response.getReturnValue());
                let result = response.getReturnValue();
                if(result.productNewPriceBookList == null) {
                    result.productNewPriceBookList = [];
                }
                console.log(result);
                component.set("v.productPriceBook", result);
                this.getAllProductsHelper(component, "", result.productNewPriceBookList);
            }
        });
        $A.enqueueAction(action);
    },
})