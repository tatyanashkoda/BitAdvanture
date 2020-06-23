trigger CustomEventTrigger on Custom_Event__c (after insert, after update, before  delete) {
    new CustomEventTriggerHandler().run();
}