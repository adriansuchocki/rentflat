/**
 * Created by BRITENET on 10.10.2019.
 */
({
    init: function(component, event, helper) {
        helper.getCartListHelper(component);
        sessionStorage.removeItem("RF_Flat_Search--flatList");
    },

    handleSearchFlat: function (component, event, helper) {
        let fieldText = component.get("v.searchText");
        component.set("v.page", 0);
        let page = component.get("v.page");
        helper.getResultList(component, fieldText, page);
    },

    handleShowCart: function (component, event, helper) {
        let cartStatus = component.get("v.cart");
        component.set("v.cart", !cartStatus);
    },

    handleReserveFlat: function (component, event, helper) {
        helper.reserveFlatHelper(component);
    }
})