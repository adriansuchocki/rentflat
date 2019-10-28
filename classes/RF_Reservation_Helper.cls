/**
 * Created by BRITENET on 23.10.2019.
 */

public class RF_Reservation_Helper {

    public static RF_Response_Message reserveFlat(List<RF_Reservation> reservations) {
        List<String> productsId = new List<String>();
        for(RF_Reservation r: reservations){
            productsId.add(r.recordId);
        }
        return RF_Order_Helper.reserveFlat(productsId, reservations);
    }

    public static void clearCart(){
        List<RF_Reservation> resList = new List<RF_Reservation>();
        Cache.Session.put('local.RentFlat.CartList', resList);
    }

}