/**
 * Created by BRITENET on 17.10.2019.
 */
({
    showSpinnerHandler: function(component,event,helper){
        component.set("v.Spinner", true);
    },

    hideSpinnerHandler: function(component,event,helper){
        component.set("v.Spinner", false);
    }
})