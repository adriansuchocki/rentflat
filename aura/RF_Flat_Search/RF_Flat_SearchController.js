/**
 * Created by BRITENET on 10.10.2019.
 */
({
    init: function(component, event, helper) {
        var flatsJson = sessionStorage.getItem('RF_Flat_Search--flatList');
        if (!$A.util.isUndefinedOrNull(flatsJson)) {
            var flats = JSON.parse(flatsJson);
            component.set('v.cartList', flats);
            sessionStorage.removeItem('RF_Flat_Search--flatList');
        }
    },

    handleSearchFlat: function (component, event, helper) {
        let fieldText = component.get("v.searchText");
        helper.getResultList(component, fieldText);
    },

    handleShowCart: function (component, event, helper) {
        let cartStatus = component.get("v.cart");
        component.set("v.cart", !cartStatus);
    }
})