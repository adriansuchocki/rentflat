/**
 * Created by BRITENET on 18.10.2019.
 */
({
    init: function (component, event, helper) {
        let recordId = component.get("v.recordId");
        helper.getPriceBookHelper(component, recordId);
    },

    handleAddToNewList: function (component, event, helper) {
        let index = event.getSource().get("v.value");
        let productStandardPriceBookList = component.get("v.productStandardPriceBookList");
        let productPriceBook = component.get("v.productPriceBook");
        let concatValue = productStandardPriceBookList.splice(index, 1);
        console.log(productPriceBook);
        productPriceBook.productNewPriceBookList.push(concatValue[0]);
        component.set("v.productStandardPriceBookList", productStandardPriceBookList);
        component.set("v.productPriceBook", productPriceBook);
    },

    handleFilterResult: function (component, event, helper) {
        let productPriceBook = component.get("v.productPriceBook");
        let filterText = component.get("v.filterText");
        helper.getAllProductsHelper(component, filterText, productPriceBook.productNewPriceBookList);
    }
})