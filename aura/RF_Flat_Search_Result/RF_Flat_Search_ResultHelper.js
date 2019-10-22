/**
 * Created by BRITENET on 10.10.2019.
 */
({
    getResultList: function (component, title, page) {
        var spinnerShowEvent = $A.get("e.c:RF_Flat_Spinner_Show_Event");
        spinnerShowEvent.fire();
        let action = component.get("c.getResultList");
        action.setParams({"title": title, "page": page});
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                var flats = response.getReturnValue();
                component.set("v.resultList", flats);
            }
            var spinnerHideEvent = $A.get("e.c:RF_Flat_Spinner_Hide_Event");
            spinnerHideEvent.fire();
        });
        $A.enqueueAction(action);
    },

    getNextPageResultList: function (component, title, page) {
        var spinnerShowEvent = $A.get("e.c:RF_Flat_Spinner_Show_Event");
        spinnerShowEvent.fire();
        let action = component.get("c.getResultList");
        action.setParams({"title": title, "page": page});
        action.setCallback(this, function(response){
            let state = response.getState();
            let errors = response.getError();
            if (component.isValid() && state === $A.get("{! $Label.c.LABEL_SUCCESS_TITLE }")) {
                let currentList = component.get("v.resultList");
                let resultList = response.getReturnValue();
                let result = currentList.concat(resultList);
                component.set("v.resultList", result);
            }
            var spinnerHideEvent = $A.get("e.c:RF_Flat_Spinner_Hide_Event");
            spinnerHideEvent.fire();
        });
        $A.enqueueAction(action);
    },
})