/**
 * Created by tshkoda on 5/25/2020.
 */

public with sharing class BillController {
    @AuraEnabled
    public static Bill__c getBillById(Id recordId) {
        List<Bill__c> bills = [
                SELECT Id, Amount__c, Name, Description__c,RecordType.Developername, Developer__r.Name, Due_date__c,
                        Paid__c, Transaction__c, Milestone_Developer__r.Name, Create_transaction__c
                FROM Bill__c
                WHERE Id = :recordId
        ];
        if (!bills.isEmpty()) {
            return bills.get(0);
        }
        return null;
    }

    @AuraEnabled
    public static Bill__c saveBill(Bill__c bill) {
        // Perform isUpdateable() checking first, then
        System.debug(bill);
            update bill;
        return bill;
    }

    @AuraEnabled
    public static String getRecordTypeName(Id recordId){
        Bill__c currentBill = [SELECT RecordType.Name From Bill__c WHERE Id =: recordId];
        return currentBill.RecordType.Name;
    }
}