/**
 * Created by BRITENET on 15.10.2019.
 */
({
    init: function(component, event, helper) {
        helper.getOrdersHelper(component);
    },

    showFlat: function (component, event, helper) {
        let id = event.getSource().get("v.value");
        var navEvt = $A.get('e.force:navigateToURL');
        let link = '/product/' +  id;
        navEvt.setParams({url: link});
        navEvt.fire();
    },

    handleRemoveFollow: function (component, event, helper) {
        event.stopImmediatePropagation();
        let value = event.getSource().get("v.value");
        let array = value.split("/");
        helper.removeFromFollowHelper(component, array[1]);
        let flats = component.get("v.flats");
        if(flats.length > 1){
            flats.splice(array[0], 1);
        } else {
            flats = [];
        }
        console.log(flats);
        component.set("v.flats", flats);
    }
})