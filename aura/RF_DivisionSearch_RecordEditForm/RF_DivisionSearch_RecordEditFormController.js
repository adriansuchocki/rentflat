({
    handleLoad: function(component, event, helper) {
        component.set('v.showSpinner', false);
    },

    handleSubmit: function(component, event, helper) {
        component.set('v.disabled', true);
        component.set('v.showSpinner', true);
    },

    handleError: function(component, event, helper) {
        component.set('v.showSpinner', false);
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": $A.get("{!$ Label.c.LABEL_ERROR_TITLE }"),
            "message": $A.get("{! $Label.c.MESSAGE_ERROR_CREATE_ACCOUNT }"),
            "type": "error"
        });
        toastEvent.fire();
    },

    handleSuccess: function(component, event, helper) {
        component.set('v.showSpinner', false);
        component.set('v.saved', true);
        let toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			"title": $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }"),
			"message": $A.get("{! $Label.c.MESSAGE_SUCCESS_CREATE_ACCOUNT }"),
			"type": "success"
		});
		toastEvent.fire();
        component.set('v.disabled', false);
    },

    handleClose: function(component, event, helper) {
        component.set('v.showSpinner', false);
        component.set('v.saved', true);
        var showModal = component.get('v.showModal');
        component.set('v.showModal', !showModal);
    },

    handleShowModal: function(component, event, helper) {
        let idValue = event.getParam('idAccount');
        component.set('v.idAccount', idValue);
        component.set('v.showSpinner', false);
        component.set('v.saved', false);
        var showModal = component.get('v.showModal');
        component.set('v.showModal', !showModal);
    }
})