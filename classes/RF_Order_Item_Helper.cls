/**
 * Created by BRITENET on 23.10.2019.
 */

public class RF_Order_Item_Helper {
    public static OrderItem createOrderItem(RF_Reservation r, Product2 p) {
        OrderItem oi = new OrderItem();
        oi.Product2 = p;
        oi.ServiceDate = r.reservationFrom;
        oi.EndDate = r.reservationTo;
        oi.Quantity = r.reservationFrom.daysBetween(r.reservationTo) + 1;
        for(PricebookEntry pe: p.PricebookEntries) {
            if(r.priceBookId == pe.Id) {
                oi.UnitPrice = pe.UnitPrice;
            }
            if(pe.Pricebook2.IsStandard){
                oi.PricebookEntry = pe;
                oi.PricebookEntryId = pe.Id;
            }
        }
        return oi;
    }
}