/**
 * Created by BRITENET on 10.10.2019.
 */
({

    handleSearchFlat: function (component, event, helper) {
        let fieldText = component.get("v.searchText");
        component.set("v.page", 0);
        let page = component.get("v.page");
        helper.getResultList(component, fieldText, page);
    },
})