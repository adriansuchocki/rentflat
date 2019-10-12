/**
 * Created by BRITENET on 11.10.2019.
 */
({
    init: function (component, event, helper) {
        let recordId = component.get('v.recordId');
        helper.getFlatComments(component, recordId);
    }
})