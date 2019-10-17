/**
 * Created by BRITENET on 16.10.2019.
 */
({
    handleShowCaseForm: function (component, event, helper) {
        let cartStatus = component.get("v.cart");
        component.set("v.cart", !cartStatus);
    },

    handleCreateCase: function (component, event, helper) {
        let recordId = event.getSource().get("v.value");
        let subject = component.get("v.subject");
        let description = component.get("v.description");
        var validExpense = component.find('expenseform').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if(validExpense){
            helper.createCaseHelper(component, recordId, subject, description);
        }
    }
})