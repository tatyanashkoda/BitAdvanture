global with sharing class ViewDevelopersController {

    @auraEnabled
    public static List<Milestone_Developer__c> getAllDevelopers() {
        List<Milestone_Developer__c> dev = new LIST<Milestone_Developer__c>();
        dev = [select id,name from Milestone_Developer__c];
        System.Debug(dev);
        return dev;
    }
    /* public Project_Developer__c getSelectedregistrations(Id id)
     {
       Registration__c  reg=[select id,name,Email__c from Registration__c where id=:id];
         return reg;
     } */
}