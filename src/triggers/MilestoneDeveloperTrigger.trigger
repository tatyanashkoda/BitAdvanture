trigger MilestoneDeveloperTrigger on Milestone_Developer__c (before insert, after insert, after update, before update, after delete ) {
    new MilestoneDeveloperTriggerHandler().run();
}