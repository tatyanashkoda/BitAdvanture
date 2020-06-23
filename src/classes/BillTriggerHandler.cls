public with sharing class BillTriggerHandler extends TriggerHandler {

    public override void afterInsert() {
        createTransactionForBill ((List<Bill__c>) Trigger.new);
    }
    public override void afterUpdate() {
        createTransactionForBill ((List<Bill__c>) Trigger.new);
    }

    Id customerRTIdForTrans = Schema.SObjectType.Transactions__c.getRecordTypeInfosByName().get(Constants.TRANSACTION_RECORD_TYPE_CUSTOMER_PAYMENT).getRecordTypeId();
    Id devRTIdForTrans = Schema.SObjectType.Transactions__c.getRecordTypeInfosByName().get(Constants.TRANSACTION_RECORD_TYPE_SALARY).getRecordTypeId();
    Id otherExpenseRTIdForTrans = Schema.SObjectType.Transactions__c.getRecordTypeInfosByName().get(Constants.TRANSACTION_RECORD_TYPE_OTHER_EXPENSE).getRecordTypeId();
    Id moneyFlowRTIdForTrans = Schema.SObjectType.Transactions__c.getRecordTypeInfosByName().get(Constants.TRANSACTION_RECORD_TYPE_MONEY_FLOW).getRecordTypeId();

    Id customerRTIdForBill = Schema.SObjectType.Bill__c.getRecordTypeInfosByName().get(Constants.TRANSACTION_RECORD_TYPE_CUSTOMER_PAYMENT).getRecordTypeId();
    Id devRTIdForBill = Schema.SObjectType.Bill__c.getRecordTypeInfosByName().get(Constants.TRANSACTION_RECORD_TYPE_SALARY).getRecordTypeId();
    Id otherExpenseRTIdForBill = Schema.SObjectType.Bill__c.getRecordTypeInfosByName().get(Constants.TRANSACTION_RECORD_TYPE_OTHER_EXPENSE).getRecordTypeId();
    Id moneyFlowRTIdForBill = Schema.SObjectType.Bill__c.getRecordTypeInfosByName().get(Constants.TRANSACTION_RECORD_TYPE_MONEY_FLOW).getRecordTypeId();

    public PageReference redirect(Id billId) {
        //doing a DML as well
        PageReference pageRef = new PageReference('/apex/createTransactionPage');
        pageRef.setRedirect(true);
        pageRef.getParameters().put('IdBill', billId);
        return pageRef;
    }

    private void createTransactionForBill(List<Bill__c> bills) {
        System.debug(bills.size());
//        if(bills.size() == 1){
        redirect(bills.get(0).Id);
//        }
    }
}