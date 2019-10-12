/**
 * Created by BRITENET on 10.10.2019.
 */
({
    handleSearchFlat: function (component, event, helper) {
        let fieldText = component.get('v.searchText');
        helper.getResultList(component, fieldText);
    }
})