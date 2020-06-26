public with sharing class GetRecordType {

    public static Id getRecordType(String NameOfObject, String recordTypeName) {
        Map<String, Schema.SObjectType> objectTypeMap = Schema.getGlobalDescribe() ;
        Schema.SObjectType sObjectType = objectTypeMap.get(NameOfObject) ;
        Schema.DescribeSObjectResult cfrSchema = sObjectType.getDescribe() ;
        Map<String, Schema.RecordTypeInfo> RecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id recordTypeId = RecordTypeInfo.get(recordTypeName).getRecordTypeId();
        return recordTypeId;
    }
}