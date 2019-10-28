/**
 * Created by BRITENET on 12.10.2019.
 */
({
    showFlat: function (component, event, helper) {
        let id = component.get('v.flat.recordId');
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