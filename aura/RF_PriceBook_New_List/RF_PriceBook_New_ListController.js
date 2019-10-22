/**
 * Created by BRITENET on 18.10.2019.
 */
({
    handleRemoveFromNewList: function (component, event, helper) {
        let index = event.getSource().get("v.value");
        let productStandardPriceBookList = component.get("v.productStandardPriceBookList");
        let productPriceBook = component.get("v.productPriceBook");
        let concatValue = productPriceBook.productNewPriceBookList.splice(index, 1);
        productStandardPriceBookList.push(concatValue[0]);
        component.set("v.productStandardPriceBookList", productStandardPriceBookList);
        component.set("v.productPriceBook", productPriceBook);
    },

    handleCalculateValue: function (component, event, helper) {
        let productPriceBook = component.get("v.productPriceBook");
        let percentageReduction = component.get("v.percentageReduction");
        productPriceBook.productNewPriceBookList.forEach(function(e){
            e.newGroupUnitPrice = e.unitPrice - (e.unitPrice * percentageReduction);
        });
        component.set("v.productPriceBook", productPriceBook);
    },

    handleUpsertPriceBook: function(component, event, helper) {
        var validExpense = component.find('expenseform').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if(validExpense){
            let newPriceBookEntryList = component.get("v.productPriceBook");
            helper.upsertPriceBookHelper(component, newPriceBookEntryList);
        }
    }

})