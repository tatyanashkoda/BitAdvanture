public with sharing  class GetRecordType {

    public static Id getRecordType(String recordTypeName){
        Id recordTypeId = Schema.SObjectType.Transactions__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        return recordTypeId;
    }
}