/**
 * Created by BRITENET on 10.10.2019.
 */
({
    init: function(component, event, helper) {
        var paramsJson = sessionStorage.getItem("RF_Flat_Search--flatList");
        let title = "";
        let page = 0;
        if (!$A.util.isUndefinedOrNull(paramsJson)) {
            var params = JSON.parse(paramsJson);
            title = params.title;
        }
        component.set("v.title", title);
        component.set("v.page", page);
        helper.getResultList(component, title, page);
        sessionStorage.removeItem("RF_Flat_Search--flatList");
    },

    handleShowMoreResults: function (component, event, helper) {
        let fieldText = component.get("v.title");
        let page = component.get("v.page");
        component.set("v.page", page + 1);
        let resultList = component.get("v.resultList");
        component.set("v.previousNumberOfRecords", resultList.length);
        helper.getNextPageResultList(component, fieldText, page+1);
    },

    showCard: function(component, event, helper) {
        component.set("v.layout", false);
    },

    showList: function(component, event, helper) {
        component.set("v.layout", true);
    },
})