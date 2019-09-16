({
    handleSearchAccountMap : function(component, event, helper){
        let mapComponent = component.find("resultMap");
        let idValue = event.getParam('idAccount');
        let nameValue = event.getParam("nameAccount");
        let industryValue = event.getParam("industryAccount");
        let phoneValue = event.getParam("phoneAccount");
        let typeValue = event.getParam("typeAccount");
        mapComponent.getMapAccount(idValue, nameValue, industryValue, phoneValue, typeValue);
    },

    handleSearchAccount : function(component, event, helper){
        let resultComponent = component.find("searchResult");
        let nameValue = event.getParam("nameAccount");
        let industryValue = event.getParam("industryAccount");
        let phoneValue = event.getParam("phoneAccount");
        let typeValue = event.getParam("typeAccount");
        resultComponent.getSearchAccount(nameValue, industryValue, phoneValue, typeValue);
    },

     handleSearchAccountDetails: function(component, event, helper){
         let detailsComponent = component.find("accountDetails");
         let idValue = event.getParam('idAccount');
         detailsComponent.getAccountDetails(idValue);
     },

     handleSearchAccountAgain: function(component, event, helper){
          let searchComponent = component.find("searchForm");
          searchComponent.searchAccountAgain();
     },

     handleClearAllComponents: function(component, event, helper){
         let searchComponent = component.find("searchForm");
         searchComponent.clearSearchComponent();
         let detailsComponent = component.find("accountDetails");
         detailsComponent.clearDetailsComponent();
         let resultComponent = component.find("searchResult");
         resultComponent.clearResultComponent();
         let mapComponent = component.find("resultMap");
         mapComponent.clearMapComponent();
     },

     showSpinner: function(component, event, helper) {
         component.set("v.Spinner", true);
     },

     hideSpinner : function(component,event,helper){
         component.set("v.Spinner", false);
     }

})