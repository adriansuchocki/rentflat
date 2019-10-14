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

    handleAddToCart: function (component, event, helper) {
        var flatsJson = sessionStorage.getItem('RF_Flat_Search--cartList');
        var flats = JSON.parse(flatsJson);
        if(flats == null) {
            flats = [];
        }
        let recordId = component.get("v.recordId");
        let reservationFrom = component.get("v.reservationFrom");
        let reservationTo = component.get("v.reservationTo");
        flats.push({'id': recordId, 'reservationFrom': reservationFrom, 'reservationTo': reservationTo});
        sessionStorage.setItem('RF_Flat_Search--cartList', JSON.stringify(flats));
    },

    handleReserveFlat: function (component, event, helper) {
        let recordId = component.get('v.recordId');
        let reservationFrom = component.get('v.reservationFrom');
        let reservationTo = component.get('v.reservationTo');
        helper.reserveFlatHelper(component, recordId, reservationFrom, reservationTo);
    }
})