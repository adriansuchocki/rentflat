/**
 * Created by BRITENET on 10.10.2019.
 */
({

    getResultList: function (component, title, page) {
        let params = {'title': title, 'page': page};
        sessionStorage.setItem("RF_Flat_Search--flatList", JSON.stringify(params));
        var navEvt = $A.get("e.force:navigateToURL");
        navEvt.setParams({url: "/product-search"});
        navEvt.fire();
    },
})