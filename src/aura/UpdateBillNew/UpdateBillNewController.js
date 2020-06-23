/**
 * Created by tshkoda on 5/28/2020.
 */

({

    doInit: function (component, event, helper) {
        var action = component.get("c.getRecordTypeName");
        action.setParams({
            "recordId": component.get("v.recordId")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var recordType = response.getReturnValue();
                component.set("v.recordTypeName", recordType);
            } else {
                var toastEvent = $A.get("event.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Unknown error."
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    handleUpdateRecord: function (component, event, helper) {

        component.find("recordEditor").saveRecord($A.getCallback(function (saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                component.set("v.newBill", component.get("v.billRecord"));
                component.set("v.newAmount", component.get("v.billRecord").Amount__c);
                if (component.get("v.billRecord").Paid__c === true) {
                    component.set("v.transaction", true);
                }
                console.log("Save completed successfully.");
            } else if (saveResult.state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                console.log('Problem saving record, error: ' +
                    JSON.stringify(saveResult.error));
                var errMsg = "";
                for (var i = 0; i < saveResult.error.length; i++) {
                    errMsg += saveResult.error[i].message + "\n";
                }
                component.set("v.recordSaveError", errMsg);
            } else {
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
        }));
    }
});