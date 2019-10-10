/**
 * Created by BRITENET on 10.10.2019.
 */
({
    handleSearchFlat: function (component, event, helper) {
        let resultComponent = component.find("resultComponent");
        let title = event.getParam('title');
        resultComponent.search(title);
    }
})