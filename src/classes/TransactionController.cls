/**
 * Created by tshkoda on 6/2/2020.
 */

public with sharing class TransactionController {
    @AuraEnabled
    public static void saveTransaction(Transactions__c trans, String recordType) {
        Id devRecordTypeId = GetRecordType.getRecordType('Transactions__c', 'recordType');
        trans.RecordTypeId = devRecordTypeId;
        insert trans;
    }
}
