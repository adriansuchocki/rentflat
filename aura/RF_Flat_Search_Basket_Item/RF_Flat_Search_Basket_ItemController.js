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

    handleRemoveElementFromCartList: function (component, event, helper) {
        event.stopImmediatePropagation();
        let index = event.getSource().get("v.value");
        helper.removeElementFromCartListHelper(component, index);
    }

})