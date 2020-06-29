global with sharing class ViewDevelopersController {
    @AuraEnabled
    public static List<Milestone_Developer__c> getAllDevelopers() {
        List<Milestone_Developer__c> dev = new LIST<Milestone_Developer__c>();
        dev = [SELECT Id, Name FROM Milestone_Developer__c];
        return dev;
    }
}