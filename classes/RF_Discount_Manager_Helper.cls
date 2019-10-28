/**
 * Created by BRITENET on 23.10.2019.
 */

public class RF_Discount_Manager_Helper {

    public static List<RF_PriceBook_Item> getAllResultList(String text, List<String> ids) {
        List<Product2> products = [SELECT Id, Name, Family, Country__c, City__c, (SELECT Id, UnitPrice FROM PricebookEntries WHERE IsActive = true AND Pricebook2.IsStandard = true) FROM Product2 WHERE IsActive = true AND Id NOT IN :ids AND Name like :text];
        List<RF_PriceBook_Item> ppb = new List<RF_PriceBook_Item>();
        for (Product2 p : products) {
            RF_Flat flat = new RF_Flat(p);
            RF_PriceBook_Item priceBookItem = new RF_PriceBook_Item(flat, p.PricebookEntries.get(0).UnitPrice, 0.0, 0.0, '');
            ppb.add(priceBookItem);
        }
        return ppb;
    }

    public static List<Pricebook2> getAllPriceBooks(String recordId){
        List<Pricebook2> pricebooks = [SELECT Id, Name, StartDate__c, End_Date__c, IsStandard FROM Pricebook2 WHERE IsActive = true];
        return pricebooks;
    }

    @AuraEnabled
    public static RF_PriceBook getPriceBookDetails(String recordId){
        RF_PriceBook ppb = new RF_PriceBook();
        List<RF_PriceBook_Item> productList = new List<RF_PriceBook_Item>();
        if(!String.isBlank(recordId)){
            List<Product2> products = [SELECT Id, Name, Family, Country__c, City__c, (SELECT Id, UnitPrice, Pricebook2.Name, Pricebook2.IsStandard, Pricebook2.StartDate__c, Pricebook2.End_Date__c FROM PricebookEntries WHERE IsActive = true AND  Pricebook2Id = :recordId) FROM Product2 WHERE IsActive = true AND Id IN (SELECT Product2Id FROM PricebookEntry WHERE Pricebook2Id = :recordId)];
            for(Product2 p: products){
                RF_Flat flat = new RF_Flat(p);
                RF_PriceBook_Item priceBookItem = new RF_PriceBook_Item(flat, p.PricebookEntries.get(0).UnitPrice, 0.0, 0.0, p.PricebookEntries.get(0).Id);
                productList.add(priceBookItem);
            }
            ppb.priceBook = products.get(0).PricebookEntries.get(0).Pricebook2;
            ppb.priceBookItems = productList;
        }
        return ppb;
    }



    @AuraEnabled
    public static RF_Response_Message upsertPriceBook(RF_PriceBook priceBookRF){
        Savepoint sp = Database.setSavepoint();
        List<RF_PriceBook_Item> priceBookItems = priceBookRF.priceBookItems;
        List<String> productEntryIds = new List<String>();
        List<PricebookEntry> priceBookEntries = new List<PricebookEntry>();
        Pricebook2 pricebook = priceBookRF.priceBook;
        try {
            pricebook.IsActive = true;
            Database.upsert(pricebook);
            for (RF_PriceBook_Item item: priceBookItems) {
                PricebookEntry pricebookEntry = new PricebookEntry();
                if (!String.isBlank(item.priceBookEntryId)) {
                    productEntryIds.add(item.priceBookEntryId);
                    pricebookEntry.Id = item.priceBookEntryId;
                } else {
                    pricebookEntry.Pricebook2Id = pricebook.Id;
                    pricebookEntry.Pricebook2 = pricebook;
                    pricebookEntry.Product2Id = item.flat.product.Id;
                    pricebookEntry.Product2 = item.flat.product;
                }
                pricebookEntry.UnitPrice = item.unitPrice;
                pricebookEntry.IsActive = true;
                if(item.newUnitPrice > 0) {
                    pricebookEntry.UnitPrice = item.newUnitPrice;
                }
                if (item.newGroupUnitPrice > 0 && (item.newGroupUnitPrice < item.newUnitPrice || item.newUnitPrice == 0)) {
                    pricebookEntry.UnitPrice = item.newGroupUnitPrice;
                }
                priceBookEntries.add(pricebookEntry);
            }
            List<PricebookEntry> pricebookToDelete = [SELECT Id FROM PricebookEntry WHERE Id NOT IN :productEntryIds AND Pricebook2Id = :pricebook.Id];
            Database.delete(pricebookToDelete);
            List<Database.UpsertResult> sr = Database.upsert(priceBookEntries);
        } catch (Exception e){
            Database.rollback(sp);
            return new RF_Response_Message(Label.MESSAGE_ERROR_CODE, Label.MESSAGE_ERROR, e.getMessage());
        }
        String result = Label.MESSAGE_SUCCESS_CREATE_PRICEBOOK_FIRST + ' ' + pricebook.Id + ' ' + Label.MESSAGE_SUCCESS_CREATE_SECOND;
        return new RF_Response_Message(Label.MESSAGE_SUCCESS_CODE, Label.MESSAGE_SUCCESS, result);
    }

    public static RF_Response_Message removeFromPriceBook(String recordId){
        Savepoint sp = Database.setSavepoint();
        try {
            List<Pricebook2> pricebooks = [SELECT Id, (SELECT Id FROM PricebookEntries) FROM Pricebook2 WHERE Id = :recordId];
            List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
            for(Pricebook2 p: pricebooks){
                pricebookEntries.addAll(p.PricebookEntries);

            }
            Database.delete(pricebookEntries);
            Database.delete(pricebooks);
        } catch(Exception e) {
            Database.rollback(sp);
            return new RF_Response_Message(Label.MESSAGE_ERROR_CODE, Label.MESSAGE_ERROR, e.getMessage());
        }
        return new RF_Response_Message(Label.MESSAGE_SUCCESS_CODE, Label.MESSAGE_SUCCESS, Label.MESSAGE_SUCCESS_DELETE_PRICEBOOK);
    }
}