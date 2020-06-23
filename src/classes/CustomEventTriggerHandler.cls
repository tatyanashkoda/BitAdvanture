public with sharing class CustomEventTriggerHandler extends TriggerHandler {

    public override void afterUpdate() {
        checkStatus();
    }

    private void deleteEvant() {
        Id id = ApexPages.currentPage().getParameters().get('id');
        Custom_Event__c customEvent = [SELECT Start_Time__c, End_Time__c, Id, Subject__c, Attached_to__c FROM Custom_Event__c WHERE Id = :id];

    }

    private void checkStatus() {

        List<Custom_Event__c> customEvents = trigger.new;

        if (customEvents.get(0).Status__c == Constants.STATUS_APPROVED) {

            Event event = new Event(
                    Subject = Constants.SUBJECT_EVENT,
                    StartDateTime = customEvents.get(0).Start_Time__c,
                    EndDateTime = customEvents.get(0).End_Time__c,
                    WhatId = Constants.ACCOUNT_MANAGER_ID,
                    WhoId = customEvents.get(0).Contact__c,
                    Description = customEvents.get(0).Subject__c
            );
            insert event;
        }
    }
}