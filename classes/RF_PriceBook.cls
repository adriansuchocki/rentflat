/**
 * Created by BRITENET on 23.10.2019.
 */

public class RF_PriceBook {
    @AuraEnabled
    public Pricebook2 priceBook { get; set; }
    @AuraEnabled
    public List<RF_PriceBook_Item> priceBookItems { get; set; }
}