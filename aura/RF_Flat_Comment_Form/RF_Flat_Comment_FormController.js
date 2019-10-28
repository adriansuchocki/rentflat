/**
 * Created by BRITENET on 11.10.2019.
 */
({
    onSave: function(component,event, helper) {
        let recordId = component.get('v.recordId');
        let comment = component.get('v.comment');
        let rating = component.get('v.rating');
        helper.onSaveHelper(component, recordId, comment, rating);
        helper.clearFields(component,event, helper);
    }
})