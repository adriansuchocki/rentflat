/**
 * Created by BRITENET on 10.10.2019.
 */
({
    init: function (component, event, helper) {
        helper.getResultList(component, '');
    },

    handleSearch: function (component, event, helper) {
        let params = event.getParam('arguments');
        let title = params.title;
        helper.getResultList(component, title);
    }
})