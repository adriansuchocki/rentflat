/**
 * Created by BRITENET on 24.10.2019.
 */
({
    handleShowToast : function(component, event, helper) {
        let params = event.getParam('arguments');
        if (params) {
            console.log(params.response);
            let type = 'error';
            if(params.response.statusCode == 200){
                type = 'success'
            }
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": params.response.title,
                "message": params.response.message,
                "type": type
            });
            toastEvent.fire();
        }
    }
})