/**
 * Created by BRITENET on 23.10.2019.
 */

public with sharing class RF_Order_Helper {

    public static RF_Response_Message reserveFlat(List<String> productsId, List<RF_Reservation> reservations) {
        Savepoint sp = Database.setSavepoint();
        try {
            List<OrderItem> orderItems = new List<OrderItem>();
            Order order = getOrder();
            Date startDate;
            Date endDate;
            Map<Id, Product2> productMap = new Map<Id, Product2>([SELECT Id, (SELECT Id, UnitPrice, Pricebook2.IsStandard FROM PricebookEntries WHERE Pricebook2.IsActive = true ) FROM Product2 WHERE Id IN :productsId AND IsActive = true]);
            for (RF_Reservation r : reservations) {
                Product2 product = productMap.get(r.recordId);
                OrderItem oi = RF_Order_Item_Helper.createOrderItem(r, product);
                startDate = getStartReservationDate(startDate, r.reservationFrom);
                endDate = getEndReservationDate(endDate, r.reservationTo);
                if(oi.PricebookEntry.Pricebook2.IsStandard) {
                    order.Pricebook2Id = oi.PricebookEntry.Pricebook2Id;
                    order.Pricebook2 = oi.PricebookEntry.Pricebook2;
                }
                orderItems.add(oi);
            }
            order = setOrderDetails(startDate, endDate, order);
            Contract contract = createContract(startDate, endDate);
            order.ContractId = contract.Id;
            Database.insert(order);
            System.debug('Order size ' + orderItems.size());
            for(OrderItem oi: orderItems){
                oi.Order = order;
                oi.OrderId = order.Id;
            }
            Database.insert(orderItems);
        } catch (Exception e) {
            Database.rollback(sp);
            return new RF_Response_Message(Label.MESSAGE_ERROR_CODE, Label.MESSAGE_ERROR, e.getMessage());
        }
        return new RF_Response_Message(Label.MESSAGE_SUCCESS_CODE, Label.MESSAGE_SUCCESS, Label.MESSAGE_SUCCESS_RESERVED_FLAT);
    }

    public static Date getStartReservationDate(Date checkDate, Date reservationDate){
        if(checkDate == null){
            return reservationDate;
        }
        if(checkDate > reservationDate){
            return reservationDate;
        }
        return checkDate;
    }

    public static Date getEndReservationDate(Date checkDate, Date reservationDate){
        if(checkDate == null){
            return reservationDate;
        }
        if(checkDate < reservationDate){
            return reservationDate;
        }
        return checkDate;
    }

    public static Order getOrder(){
        String accountId = RF_Utils.getAccountIdForCurrentUser();
        Order order = new Order();
        order.AccountId = accountId;
        order.Status = RF_Utils.getOrderStatusForCurrentUser();
        return order;
    }

    public static Order setOrderDetails(Date startDate, Date endDate, Order order){
        order.EffectiveDate = startDate;
        order.EndDate = endDate;
        return order;
    }

    public static Contract createContract(Date startDate, Date endDate) {
        Savepoint spContract = Database.setSavepoint();
        String accountId = RF_Utils.getAccountIdForCurrentUser();
        Contract contract = new Contract();
        try{
            contract.AccountId = accountId;
            contract.StartDate = startDate;
            contract.Status = RF_Utils.getContractStatusForCurrentUser();
            contract.ContractTerm =  startDate.monthsBetween(endDate) + 1;
            Database.insert(contract);
        } catch(Exception e){
            Database.rollback(spContract);
            throw new RF_Flat_Reservation_Exception (e.getMessage());
        }
        return contract;
    }

}