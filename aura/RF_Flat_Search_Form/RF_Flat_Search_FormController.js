/**
 * Created by BRITENET on 10.10.2019.
 */
({
    handleSearchFlat: function (component, event, helper) {
        let fieldText = component.get('v.fieldText');
        let searchEvent = component.getEvent("searchFlat");
        searchEvent.setParams({'title': fieldText});
        searchEvent.fire();
    }
})