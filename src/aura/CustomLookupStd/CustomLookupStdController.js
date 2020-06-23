({
    setSelectedRecordId: function(component, event, helper) {
        var selectedRecordId = component.get("v.selectedRecordId");
        component.find("lookupField").set("v.value", selectedRecordId);
    },

    fireOnSelectEvt : function(component, event, helper) {
        var cmpEvent = component.getEvent("onSelectEvt");
        cmpEvent.setParams({
            "childObjectName": component.get("v.childObjectName"),
            "fieldName": component.get("v.fieldName"),
            "selectedRecordId": component.find("lookupField").get("v.value")
        });
        cmpEvent.fire();
    }
})