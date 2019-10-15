/**
 * Created by BRITENET on 10.10.2019.
 */
({
    init: function(component, event, helper) {
        var flatsJson = sessionStorage.getItem("RF_Flat_Search--flatList");
        if (!$A.util.isUndefinedOrNull(flatsJson)) {
            var flats = JSON.parse(flatsJson);
            console.log(flats);
            component.set("v.resultList", flats);
//            sessionStorage.removeItem("RF_Flat_Search--flatList");
        }
    },

    showCard: function(component, event, helper) {
        component.set("v.layout", false);
    },

    showList: function(component, event, helper) {
        component.set("v.layout", true);
    },

    handleShowMoreResults: function(component, event, handler) {
        let resultList = component.get("v.resultList");
        component.set("v.previousNumberOfRecords", resultList.length);
        let searchEvent = $A.get("e.c:RF_Flat_Search_More_Result_Event");
        searchEvent.fire();
    }
})