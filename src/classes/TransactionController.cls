/**
 * Created by tshkoda on 6/2/2020.
 */

public with sharing class TransactionController {
    @AuraEnabled
    public static void saveTransaction(Transactions__c trans,String recordType){
        Id devRecordTypeId = Schema.SObjectType.Transactions__c.getRecordTypeInfosByName().get(recordType).getRecordTypeId();
        trans.RecordTypeId = devRecordTypeId;
        insert trans;
    }
}