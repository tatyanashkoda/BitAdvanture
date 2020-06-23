public with sharing class MilestoneDeveloperTriggerHandler extends TriggerHandler {
    public override void beforeInsert() {
        renameMilestoneDeveloper((List<Milestone_Developer__c>) Trigger.new);
        updateTotalAmount ((List<Milestone_Developer__c>) Trigger.new);
    }
    public override void afterInsert() {
        updateDevelopingCostAtCreation((List<Milestone_Developer__c>) Trigger.new);
        createBillObjForDev((List<Milestone_Developer__c>) Trigger.new);
    }
    public override void beforeUpdate() {
        updateTotalAmount ((List<Milestone_Developer__c>) Trigger.new);
    }
    public override void afterUpdate() {
        updateDevelopingCostAtCreation((List<Milestone_Developer__c>) Trigger.new);
    }

    public  override void afterDelete(){
        updateDevelopingCostAtCreation((List<Milestone_Developer__c>) Trigger.old);
    }


    private void renameMilestoneDeveloper(List<Milestone_Developer__c> milestoneDevelopers) {
        for (Milestone_Developer__c msDev : milestoneDevelopers) {
            Developer__c developer = [SELECT Id, Name FROM Developer__c WHERE Id = :msDev.Developer__c];
            msDev.Name = developer.Name;
        }
    }

    private void updateTotalAmount(List<Milestone_Developer__c> milestoneDevelopers) {
        Milestone_Developer__c msDev = new Milestone_Developer__c();
        for (Milestone_Developer__c milestoneDeveloper : milestoneDevelopers) {
            msDev = milestoneDeveloper;
            System.Debug('Hello!');
        }
        if (msDev.Developing_cost__c != null && (msDev.Number_of_Hours__c == null && msDev.Cost_Per_Hour__c == null)) {
            msDev.Total_Amount__c = msDev.Developing_cost__c;
        } else {
            msDev.Total_Amount__c = msDev.Cost_Per_Hour__c * msDev.Number_of_Hours__c;
        }
    }

    private void updateDevelopingCostAtCreation(List<Milestone_Developer__c> milestoneDevelopers) {
        Milestone_Developer__c msDev = new Milestone_Developer__c();
        for (Milestone_Developer__c milestoneDeveloper : milestoneDevelopers) {
            msDev = milestoneDeveloper;
        }

        Milestone__c milestone = [SELECT Id, Developing_cost__c, (Select Id, Name, Developing_cost__c,Total_Amount__c From Milestones_Developers__r) FROM Milestone__c WHERE Id = :msDev.Milestone__c];
        milestone.Developing_cost__c = 0;
        if(!milestone.Milestones_Developers__r.isEmpty()){
            for(Milestone_Developer__c msDeveloper : milestone.Milestones_Developers__r){
                milestone.Developing_cost__c = milestone.Developing_cost__c + msDeveloper.Total_Amount__c;
            }
        }
        update milestone;
    }

    private void createBillObjForDev(List<Milestone_Developer__c> milestoneDevelopers) {
        Id developerRecordTypeId = Schema.SObjectType.Bill__c.getRecordTypeInfosByName().get(Constants.TRANSACTION_RECORD_TYPE_SALARY).getRecordTypeId();
//        Id fixedCostRecordTypeId = Schema.SObjectType.Milestone_Developer__c.getRecordTypeInfosByName().get(Constants.FIXED_COST).getRecordTypeId();
//        Id earlyCostRecordTypeId = Schema.SObjectType.Milestone_Developer__c.getRecordTypeInfosByName().get(Constants.EARLY_COST).getRecordTypeId();
        Milestone_Developer__c msDeveloper = new Milestone_Developer__c();


        for (Milestone_Developer__c msDev : milestoneDevelopers) {
            msDeveloper = msDev;
        }
        Milestone__c milestone = [SELECT Id, Name FROM Milestone__c Where Id = :msDeveloper.Milestone__c];

        Bill__c newBill = new Bill__c(
                Paid__c = false,
                Description__c = milestone.Name,
                Developer__c = msDeveloper.Developer__c,
                RecordTypeId = developerRecordTypeId,
                Amount__c = msDeveloper.Total_Amount__c,
                Milestone_Developer__c = msDeveloper.Id
        );
        insert newBill;
    }

    private void updateBillObjForDev(Milestone_Developer__c milestoneDeveloper) {
        List<Bill__c> billObjects = [
                SELECT Amount__c,Paid__c, Id, Description__c,Developer__c,RecordTypeId, Milestone_Developer__c
                FROM Bill__c
                Where Milestone_Developer__c = :milestoneDeveloper.Id
        ];
        if (billObjects.isEmpty()) {
            milestoneDeveloper.addError('There are no any bills');
            return;
        }

        Decimal billsAmountSum = 0;
        for (Bill__c bill : billObjects) {
            billsAmountSum += bill.Amount__c;
        }

        Decimal newBillAmount = milestoneDeveloper.Total_Amount__c - billsAmountSum;
        if (newBillAmount < 0) {
            milestoneDeveloper.addError('The amount cannot be reduced. The bill was paid');
            return;
        }

        if (newBillAmount == 0) {
            return;
        }

        Bill__c existingBill = billObjects.get(0);
        Bill__c newBill = new Bill__c(
                Paid__c = false,
                Description__c = existingBill.Description__c,
                Developer__c = existingBill.Developer__c,
                RecordTypeId = existingBill.RecordTypeId,
                Milestone_Developer__c = existingBill.Milestone_Developer__c,
                Amount__c = newBillAmount
        );
        insert newBill;
        update billObjects;
    }
}