trigger DeveloperWorkTrigger on Developer_Work__c (before insert, before update, before delete, after insert, after update, after delete) {
    new DeveloperWorkTriggerHandler().run();
}