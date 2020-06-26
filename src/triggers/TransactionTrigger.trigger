trigger TransactionTrigger on Transactions__c (before insert, after insert, before update ,after delete) {
    new TransactionTriggerHandler().run();
}