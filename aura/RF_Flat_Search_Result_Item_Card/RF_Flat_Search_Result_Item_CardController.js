/**
 * Created by BRITENET on 14.10.2019.
 */
({
    showFlat: function (component, event, helper) {
        let id = component.get('v.flat.product.Id');
        var navEvt = $A.get('e.force:navigateToURL');
        let link = '/product/' +  id;
        navEvt.setParams({url: link});
        navEvt.fire();
    },

    handleAddFollow: function (component, event, helper) {
        event.stopImmediatePropagation();
        let id = component.get('v.flat.product.Id');
        helper.addToFollowHelper(component, id);
    },

    handleRemoveFollow: function (component, event, helper) {
        event.stopImmediatePropagation();
        let id = component.get('v.flat.product.Id');
        helper.removeFromFollowHelper(component, id);
    }
})