/**
 * Created by BRITENET on 19.10.2019.
 */
({
    upsertPriceBookHelper: function (component, newPriceBookEntryList) {
        var spinnerShowEvent = $A.get("e.c:RF_Flat_Spinner_Show_Event");
        spinnerShowEvent.fire();
        let action = component.get("c.upsertPriceBook");
        console.log(newPriceBookEntryList);
        action.setParams({'priceBook': newPriceBookEntryList})
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                let evt = $A.get("e.force:navigateToComponent");
                evt.setParams({
                    componentDef : "c:RF_PriceBook_List",
                });
                evt.fire();
            }
            let toastCmp = component.find("RFToast");
            toastCmp.showToast(response.getReturnValue());
            var spinnerHideEvent = $A.get("e.c:RF_Flat_Spinner_Hide_Event");
            spinnerHideEvent.fire();
        });
        $A.enqueueAction(action);
    }
})