global with sharing class ViewDevelopersController {

    @AuraEnabled
    public static List<Milestone_Developer__c> getAllDevelopers() {
        List<Milestone_Developer__c> dev = new LIST<Milestone_Developer__c>();
        dev = [select id,name from Milestone_Developer__c];
        System.Debug(dev);
        return dev;
    }
}