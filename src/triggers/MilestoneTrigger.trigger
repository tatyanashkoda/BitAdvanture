trigger MilestoneTrigger on Milestone__c (before update, before insert, after insert) {
    new MilestoneTriggerHandler().run();
}