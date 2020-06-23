public with sharing class DeveloperWorkTriggerHandler extends TriggerHandler {
    public override void beforeInsert() {
        renameDeveloperWork((List<Developer_Work__c>) Trigger.new);
    }

    private void renameDeveloperWork(List<Developer_Work__c> developerWorks) {
        for (Developer_Work__c dw : developerWorks) {
            dw.Name = dw.Number_of_Hours__c.format() + ' Hours and ' + dw.Cost_Per_Hour__c.format() + ' Cost';
        }
    }
}