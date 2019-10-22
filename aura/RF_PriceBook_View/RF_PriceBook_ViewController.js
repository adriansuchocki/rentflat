/**
 * Created by BRITENET on 19.10.2019.
 */
({
    handleRefreshLists : function(component, event, helper){
        let resultComponent = component.find("product-search-form");
        resultComponent.refreshLists();
    },
})