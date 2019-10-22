/**
 * Created by BRITENET on 21.10.2019.
 */
({
    init: function(component, event, helper) {
        helper.getPriceBookHelper(component);
    },

    showPriceBook: function (component, event, helper) {
        let id = event.getSource().get("v.value");
        let evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:RF_PriceBook_View",
            componentAttributes: {
                recordId : id
            }
        });
        evt.fire();
    },

    handleAddNew: function (component, event, helper) {
        let evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:RF_PriceBook_View",
        });
        evt.fire();
    },

    handleRemovePriceBook: function (component, event, helper) {
        event.stopImmediatePropagation();
        let value = event.getSource().get("v.value");
        let array = value.split("/");
        helper.removeFromPriceBookHelper(component, array[1]);
        let priceBooks = component.get("v.pricebooks");
        if(priceBooks.length > 1){
            priceBooks.splice(array[0], 1);
        } else {
            priceBooks = [];
        }
        component.set("v.pricebooks", priceBooks);
    }
})