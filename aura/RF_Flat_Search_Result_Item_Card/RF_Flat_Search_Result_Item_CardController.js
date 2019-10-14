/**
 * Created by BRITENET on 14.10.2019.
 */
({
    showFlat: function (component, event, helper) {
        let id = component.get('v.flat.id');
        var navEvt = $A.get('e.force:navigateToURL');
        let link = '/product/' +  id;
        navEvt.setParams({url: link});
        navEvt.fire();
    }
})