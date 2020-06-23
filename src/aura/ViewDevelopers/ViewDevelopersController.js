({
	doInit : function(component, event, helper) {
        var action = cmp.get("c.getAllDevelopers");
        action.setCallback(this, function(response){
            if (reponse.getState === "SUCCESS") {
                component.set("v.developer", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
    
    
})