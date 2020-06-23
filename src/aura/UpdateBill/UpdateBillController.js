/**
 * Created by tshkoda on 5/22/2020.
 */

({
    doInit: function (component, event, helper) {
        var action = component.get("c.getBillById");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseBill = response.getReturnValue();
                console.log(responseBill.Create_transaction__c);
                component.set("v.bill", responseBill);
                component.set("v.recordTypeName",responseBill.RecordType.DeveloperName);
            }
             else {
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
    updateBill: function (component, event, helper) {
        var action = component.get("c.saveBill");
        var newBill = component.get("v.bill");
        action.setParams({"bill": newBill});
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('state-->' + state);
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Student record has been updated successfully."
                });
                console.log(newBill.Paid__c + '!!!');
                console.log(component.get("v.bill") + '!!!');
                toastEvent.fire();
                window.location = "/" + component.get("v.recordId");
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "ERROR!",
                    "message": "Error"
                });
                toastEvent.fire();
            }
        });

        $A.enqueueAction(action);
    },
    doCancel: function (component, event, helper) {
        window.location = "/" + component.get("v.recordId");
    }

});