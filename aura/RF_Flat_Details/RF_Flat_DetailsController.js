/**
 * Created by BRITENET on 08.10.2019.
 */
({
    init: function (component, event, helper) {
        let recordId = component.get("v.recordId");
        let variable = 'RF_Flat_Search--visitedList-' + recordId
        let flatVisited = sessionStorage.getItem(variable);
        if ($A.util.isUndefinedOrNull(flatVisited)) {
            sessionStorage.setItem(variable, true);
            helper.addNumberOfViewHelper(component, recordId);
        }
        helper.getFlatDetailsHelper(component, recordId);
    },

    handleAddFollow: function (component, event, helper) {
        let id = component.get('v.flat.product.Id');
        helper.addToFollowHelper(component, id);
    },

    handleRemoveFollow: function (component, event, helper) {
        let id = component.get('v.flat.product.Id');
        helper.removeFromFollowHelper(component, id);
    },

    handleRefreshFlatDetails: function (component, event, helper) {
        let recordId = component.get("v.recordId");
        helper.getFlatDetailsHelper(component, recordId);
    }
})