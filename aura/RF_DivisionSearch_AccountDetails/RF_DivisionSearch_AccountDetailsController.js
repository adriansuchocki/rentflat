({
    detailsSearch: function(component, event, helper) {
        let params = event.getParam('arguments');
        component.set('v.idAccount', params.idValue);
    },

    deleteAccount: function(component, event, helper) {
        if(confirm('Are you sure?')){
            let idValue =  component.get("v.idAccount");
            let action = component.get("c.deleteSelectedAccount");
            action.setParams({"id": idValue});
            action.setCallback(this, function(response){
                let state = response.getState();
                let errors = response.getError();
                if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                    let toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }"),
                        "message": $A.get("{! $Label.c.MESSAGE_SUCCESS_DELETE_ACCOUNT }"),
                        "type": "success"
                    });
                    toastEvent.fire();
                    let searchEvent = component.getEvent("searchAccountAction");
                    searchEvent.fire();
                } else {
                    let toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": $A.get("{!$ Label.c.LABEL_ERROR_TITLE }"),
                        "message": errors[0].message,
                        "type": "error"
                    });
                    toastEvent.fire();
                }
            });
            $A.enqueueAction(action);
        }
    },

    editAccount: function(component, event, helper) {
        event.preventDefault();
        let idValue =  component.get("v.idAccount");
        let modalEvent = $A.get("e.c:RF_DivisionSearch_RecordEditForm_Event");
        modalEvent.setParams({"idAccount": idValue})
        modalEvent.fire();
    },

    clearComponent: function(component, event, helper) {
        component.set("v.idAccount", '');
    }
})