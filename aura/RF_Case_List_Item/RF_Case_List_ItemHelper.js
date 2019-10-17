/**
 * Created by BRITENET on 17.10.2019.
 */
({
    showCaseHelper: function (component, recordId) {
        var navEvt = $A.get('e.force:navigateToURL');
        let link = '/case/' + recordId;
        navEvt.setParams({url: link});
        navEvt.fire();
    }
})