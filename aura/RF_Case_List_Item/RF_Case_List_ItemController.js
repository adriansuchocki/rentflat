/**
 * Created by BRITENET on 17.10.2019.
 */
({
    handleShowCase: function (component, event, helper) {
        let recordId = component.get("v.recordId");
        helper.showCaseHelper(component, recordId);
    }
})