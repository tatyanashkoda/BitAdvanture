trigger BillTrigger on Bill__c (after update, after insert) {
    new BillTriggerHandler().run();
}