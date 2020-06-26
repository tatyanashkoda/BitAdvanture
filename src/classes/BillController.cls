/**
 * Created by tshkoda on 5/25/2020.
 */

public with sharing class BillController {
    @AuraEnabled
    public static String getRecordTypeName(Id recordId) {
        Bill__c currentBill = [SELECT RecordType.Name From Bill__c WHERE Id = :recordId];
        return currentBill.RecordType.Name;
    }
}