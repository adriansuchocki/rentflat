({
    searchAccount: function(component, event, helper) {
        let nameAccount = component.find("searchAccountName").get("v.value");
        let industryAccount = component.find("searchAccountIndustry").get("v.value");
        let phoneAccount = component.find("searchAccountPhone").get("v.value");
        let typeAccount = component.find("searchAccountType").get("v.value");
        helper.searchAccount(component, nameAccount, industryAccount, phoneAccount, typeAccount);
    },

    clearAllComponent: function(component, event, helper) {
        let searchEvent = component.getEvent("clearAllComponents");
        searchEvent.fire();
    },

    clearComponent: function(component, event, helper) {
        let nameAccount = component.find("searchAccountName").set("v.value", "");
        let industryAccount = component.find("searchAccountIndustry").set("v.value", "");
        let phoneAccount = component.find("searchAccountPhone").set("v.value", "");
        let typeAccount = component.find("searchAccountType").set("v.value", "");
    }
})