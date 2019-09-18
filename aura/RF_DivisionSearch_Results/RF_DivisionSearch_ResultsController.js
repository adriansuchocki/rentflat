({
    init: function (component, event, helper) {
        component.set('v.idAccount', '');
        component.set("v.Spinner", false);
    },

    searchAccount: function(component, event, helper) {
        let params = event.getParam('arguments');
        let action = component.get("c.getResultSearch");
        component.set("v.nameValue", params.nameValue);
        component.set("v.industryValue", params.industryValue);
        component.set("v.phoneValue", params.phoneValue);
        component.set("v.typeValue", params.typeValue);
        component.set("v.Spinner", true);
        action.setParams({"name": params.nameValue, "industry": params.industryValue, "phone": params.phoneValue, "type": params.typeValue});
        action.setCallback(this, function(response){
            let state = response.getState();
            console.log(response.getError());
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                component.set("v.accounts", response.getReturnValue());
                let mapEvent = component.getEvent("searchAccountListMap");
                mapEvent.setParams({"idAccount": "", "nameAccount": params.nameValue, "industryAccount": params.industryValue, "phoneAccount": params.phoneValue, "typeAccount": params.typeValue})
                mapEvent.fire();
                let detailsEvent = component.getEvent("searchAccountDetails");
                detailsEvent.setParams({"idAccount": ''})
                detailsEvent.fire();
            } else {
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": $A.get("{!$ Label.c.LABEL_ERROR_TITLE }"),
                    "message": errors[0].message,
                    "type": "error"
                });
                toastEvent.fire();
            }
            component.set("v.Spinner", false);
        });
        $A.enqueueAction(action);
    },

    showDetails: function(component, event, helper) {
        var Elements = component.find('row');
        for (var i = 0; i < Elements.length; i++) {
            if($A.util.hasClass(Elements[i], "highlight")){
                $A.util.toggleClass(Elements[i], "highlight");
            }
        }
        let idValue;
        if(component.get('v.idAccount') != event.currentTarget.dataset.record) {
            idValue = event.currentTarget.dataset.record;
            $A.util.addClass(Elements[event.currentTarget.dataset.id], "highlight");
        } else {
            idValue = ''
        }
        component.set('v.idAccount', idValue)
        let nameValue = component.get("v.nameValue");
        let industryValue = component.get("v.industryValue");
        let phoneValue = component.get("v.phoneValue");
        let typeValue = component.get("v.typeValue");
        let mapEvent = component.getEvent("searchAccountListMap");
        mapEvent.setParams({"idAccount": idValue, "nameAccount": nameValue, "industryAccount": industryValue, "phoneAccount": phoneValue, "typeAccount": typeValue})
        mapEvent.fire();
        let detailsEvent = component.getEvent("searchAccountDetails");
        detailsEvent.setParams({"idAccount": idValue})
        detailsEvent.fire();
    },

    clearComponent: function(component, event, helper) {
        component.set('v.idAccount', '');
        component.set("v.accounts", null);
    },

    showSpinner: function(component, event, helper) {
        component.set("v.Spinner", true);
    },

    hideSpinner : function(component,event,helper){
        component.set("v.Spinner", false);
    }
})