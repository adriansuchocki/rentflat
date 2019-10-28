/**
 * Created by BRITENET on 23.10.2019.
 */
({
    init: function(component, event, helper) {
        helper.getCartListHelper(component);
        sessionStorage.removeItem("RF_Flat_Search--flatList");
    },

    handleShowCart: function (component, event, helper) {
        let cartStatus = component.get("v.cart");
        component.set("v.cart", !cartStatus);
    },

    handleReserveFlat: function (component, event, helper) {
        helper.reserveFlatHelper(component);
    }
})