/**
 * Created by BRITENET on 10.10.2019.
 */
({
    init: function(component, event, helper) {
        var flatsJson = sessionStorage.getItem("RF_Flat_Search--flatList");
        if (!$A.util.isUndefinedOrNull(flatsJson)) {
            var flats = JSON.parse(flatsJson);
            component.set("v.resultList", flats);
//            sessionStorage.removeItem("RF_Flat_Search--flatList");
        }
    },

    showCard: function(component, event, helper) {
        component.set("v.layout", false);
    },

    showList: function(component, event, helper) {
        component.set("v.layout", true);
    }
})