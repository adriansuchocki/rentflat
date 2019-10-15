/**
 * Created by BRITENET on 10.10.2019.
 */
({
    init: function (component, event, helper) {
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.today', today);
        component.set('v.reservationFrom', today);
        component.set('v.reservationTo', today);
    },

    handleMinReservationTo: function (component, event, helper) {
        let fromDate = component.get('v.reservationFrom');
        component.set('v.reservationTo', fromDate);
    },

    handleAddToCart: function (component, event, helper) {
        let recordId = component.get("v.recordId");
        let title = component.get("v.title");
        let photos = component.get("v.photo");
        let photo = "";
        if(photos.length != 0) {
            photo = photos[0].link;
        }
        let reservationFrom = component.get("v.reservationFrom");
        let reservationTo = component.get("v.reservationTo");
        let priceBookId = component.get("v.priceBookId");
        let priceBookValue = component.get("v.priceBookValue");
        if(photos.length != 0) {
            photo = photos[0].link;
        }
        helper.addToCartHelper(component, recordId, title, photo, reservationFrom, reservationTo, priceBookId, priceBookValue);
        let searchEvent = $A.get("e.c:RF_Flat_Search_Cart");
        searchEvent.fire();
    },

    handleReserveFlat: function (component, event, helper) {
        let recordId = component.get("v.recordId");
        let title = component.get("v.title");
        let photos = component.get("v.photo");
        let photo = "";
        if(photos.length != 0) {
            photo = photos[0].link;
        }
        let reservationFrom = component.get("v.reservationFrom");
        let reservationTo = component.get("v.reservationTo");
        let priceBookId = component.get("v.priceBookId");
        let priceBookValue = component.get("v.priceBookValue");
        if(photos.length != 0) {
            photo = photos[0].link;
        }
        helper.reserveFlatHelper(component, recordId, title, photo, reservationFrom, reservationTo, priceBookId, priceBookValue);
    }
})