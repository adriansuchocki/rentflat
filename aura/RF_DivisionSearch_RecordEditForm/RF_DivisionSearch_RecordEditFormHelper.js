({
    showHide : function(component) {
        let editForm = component.find("editForm");
        $A.util.toggleClass(editForm, "slds-hide");
    }
})