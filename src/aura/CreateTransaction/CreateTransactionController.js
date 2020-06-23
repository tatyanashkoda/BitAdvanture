/**
 * Created by tshkoda on 6/1/2020.
 */

({
    doInit: function (component, event, helper) {
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set("v.newTransaction.Date_of_Payment__c", today);
        component.set("v.newTransaction.Budget__c", component.get("v.billRecord.Amount__c"));
        component.set("v.newTransaction.Description__c", component.get("v.billRecord.Description__c"));
    },

    saveTransactionRecord: function (component, event, helper) {
        var transObj = component.get("v.newTransaction");
        if (component.get("v.billRecord").Developer__c != undefined) {
            transObj.Developer__c = component.get("v.billRecord").Developer__c;
        }
        if (component.get("v.billRecord").Milestone__c != undefined) {
            transObj.Milestone__c = component.get("v.billRecord").Milestone__c;
        }
        if (component.get("v.lookUpRecordToAccount").Id != undefined) {
            transObj.To_Account__c = component.get("v.lookUpRecordToAccount").Id;
        }
        if (component.get("v.lookUpRecordFromAccount").Id != undefined) {
            transObj.From_Account__c = component.get("v.lookUpRecordFromAccount").Id;
        }

        var action = component.get('c.saveTransaction');
        action.setParams({
            'trans': transObj,
            "recordType": component.get("v.recordTypeName")
        })
        action.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("event.force:showToast");
                toastEvent.setParams({
                    "title": "SUCCESS!",
                    "message": "Record Created."
                });
            } else {
                alert('Error');
            }
        });
        $A.enqueueAction(action);
    }

});