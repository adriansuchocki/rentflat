/**
 * Created by BRITENET on 10.10.2019.
 */
({
    init: function(component, event, helper) {
        helper.getCartListHelper(component);
//        document.addEventListener('click', function(e){
//            let button = document.getElementById('dialogBtn');
//            let divDialog = document.getElementById('dialog');
//            let target = e?e.target:event.srcElement;
//            if(button !== div && divDialog !== div){
//            	alert('mam');
//            }
//            component.set("v.cart", false);
//        });
    },

    handleSearchFlat: function (component, event, helper) {
        let fieldText = component.get("v.searchText");
        component.set("v.page", 0);
        let page = component.get("v.page");
        helper.getResultList(component, fieldText, page);
    },

    handleNextSearchFlat: function (component, event, helper) {
        let fieldText = component.get("v.searchText");
        let page = component.get("v.page");
        component.set("v.page", page + 1);
        helper.getNextPageResultList(component, fieldText, page+1);
    },

    handleShowCart: function (component, event, helper) {
        let cartStatus = component.get("v.cart");
        component.set("v.cart", !cartStatus);
    },

    handleReserveFlat: function (component, event, helper) {
        helper.reserveFlatHelper(component);
    }
})