({
    showAccountModal: function(component, event, helper) {
        let modalEvent = $A.get("e.c:RF_DivisionSearch_RecordEditForm_Event");
        modalEvent.setParams({"idAccount": ''})
        modalEvent.fire();
    }
})