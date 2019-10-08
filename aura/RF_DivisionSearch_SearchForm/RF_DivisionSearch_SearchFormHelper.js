({
    searchAccount : function(component, nameAccount, industryAccount, phoneAccount, typeAccount) {
        let searchEvent = component.getEvent("searchAccountList");
        searchEvent.setParams({"nameAccount": nameAccount, "industryAccount": industryAccount, "phoneAccount": phoneAccount, "typeAccount": typeAccount});
        searchEvent.fire();
    }
})