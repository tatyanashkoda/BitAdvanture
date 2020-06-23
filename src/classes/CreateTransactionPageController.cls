public with sharing class CreateTransactionPageController{
    public String recordTypeId { get; set; }
    public String recordTypeName { get; set; }
    public CreateTransactionPageController() {
        recordTypeId = ApexPages.currentPage().getParameters().get('RecordType');
        List<RecordType> rtIds = [SELECT Name from RecordType where Id = :recordTypeId LIMIT 1];
        if (rtIds.size() > 0) {
            recordTypeName = rtIds[0].Name;
        }
    }
}