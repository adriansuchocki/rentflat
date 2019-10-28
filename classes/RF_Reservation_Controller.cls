/**
 * Created by BRITENET on 23.10.2019.
 */

public class RF_Reservation_Controller {
    @AuraEnabled
    public static RF_Response_Message addToCart(List<RF_Reservation> reservationList){
        if (Cache.Session.contains('local.RentFlat.CartList')) {
            List<RF_Reservation> resList = (List<RF_Reservation>) Cache.Session.get('local.RentFlat.CartList');
            resList.addAll(reservationList);
            Cache.Session.put('local.RentFlat.CartList', resList);
        } else {
            Cache.Session.put('local.RentFlat.CartList', reservationList);
        }
        return new RF_Response_Message(Label.MESSAGE_SUCCESS_CODE, Label.MESSAGE_SUCCESS, Label.MESSAGE_SUCCESS_ADD_TO_CART);
    }

    @AuraEnabled
    public static List<RF_Reservation> getCart(){
        List<RF_Reservation> resList = new List<RF_Reservation>();
        if (Cache.Session.contains('local.RentFlat.CartList')) {
            resList = (List<RF_Reservation>) Cache.Session.get('local.RentFlat.CartList');
        }
        for(RF_Reservation r: resList){
            if(r.reservationDays == null){
                r.reservationDays = r.reservationFrom.daysBetween(r.reservationTo) + 1;
            }
        }
        return resList;
    }

    @AuraEnabled
    public static RF_Response_Message removeElementFromCartList(Integer index){
        if (Cache.Session.contains('local.RentFlat.CartList')) {
            List<RF_Reservation> resList = (List<RF_Reservation>) Cache.Session.get('local.RentFlat.CartList');
            resList.remove(index);
            Cache.Session.put('local.RentFlat.CartList', resList);
        }
        return new RF_Response_Message(Label.MESSAGE_SUCCESS_CODE, Label.MESSAGE_SUCCESS, Label.MESSAGE_SUCCESS_REMOVE_FROM_CART);
    }

    @AuraEnabled
    public static RF_Response_Message reserveFlat(List<RF_Reservation> reservations) {
        return RF_Reservation_Helper.reserveFlat(reservations);
    }

    @AuraEnabled
    public static RF_Response_Message reserveFlatFromCart() {
        List<RF_Reservation> reservations = getCart();
        RF_Response_Message response = RF_Reservation_Helper.reserveFlat(reservations);
        RF_Reservation_Helper.clearCart();
        return response;
    }
}