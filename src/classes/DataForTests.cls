/**
 * Created by tshkoda on 6/26/2020.
 */

public with sharing class DataForTests {
    public static Bill__c createBill(String recordTypeName, Milestone_Developer__c md, Developer__c developer) {
        Bill__c bill = new Bill__c(
                Due_date__c = Date.today().addDays(7),
                Amount__c = 10,
                Description__c = '1234',
                RecordTypeId = GetRecordType.getRecordType('Bill__c', recordTypeName)
        );
        if (bill.RecordType.Name == Constants.DEVELOPER_PAYMENT_RECORD_TYPE) {
            bill.Developer__c = developer.Id;
            bill.Milestone_Developer__c = md.Id;
        } else if (bill.RecordType.Name == Constants.INCOMING_PAYMENT_RECORD_TYPE || bill.RecordType.Name == Constants.MONEY_FLOW_RECORD_TYPE) {
            bill.Developer__c = developer.Id;
        }
        insert bill;
        return bill;
    }

    public static Bill__c createBill(String recordTypeName, Developer__c developer) {
        Bill__c bill = new Bill__c(
                Due_date__c = Date.today().addDays(7),
                Amount__c = 10,
                Description__c = '1234',
                RecordTypeId = GetRecordType.getRecordType('Bill__c', recordTypeName)
        );
        if (bill.RecordType.Name == Constants.INCOMING_PAYMENT_RECORD_TYPE || bill.RecordType.Name == Constants.MONEY_FLOW_RECORD_TYPE) {
            bill.Developer__c = developer.Id;
        }
        insert bill;
        return bill;
    }

    public static Developer__c createDeveloper() {
        Developer__c developer = new Developer__c(
                Name = 'TestDev'
        );
        insert developer;
        return developer;
    }

    public static Milestone_Developer__c createMilestoneDeveloper(String recordTypeName, Milestone__c milestone, Developer__c developer) {
        Map<String, Id> recordTypeMap = new Map<String, Id>();
        for(RecordType rt: [SELECT Id, Name FROM RecordType WHERE SobjectType =: 'Milestone_Developer__c']){
            recordTypeMap.put(rt.Name, rt.Id);
        }

        Milestone_Developer__c md = new Milestone_Developer__c(
                RecordTypeId = GetRecordType.getRecordType('Milestone_Developer__c', recordTypeName),
                Name = 'Name',
                Milestone__c = milestone.Id,
                Developer__c = developer.Id
        );
        if (md.RecordTypeId == recordTypeMap.get(Constants.FIXED_COST_RECORD_TYPE)) {
            md.Developing_cost__c = 100;
        } else if (md.RecordTypeId == recordTypeMap.get(Constants.EARLY_COST_RECORD_TYPE)) {
            md.Cost_Per_Hour__c = 5;
            md.Number_of_Hours__c = 5;
        }
        insert md;
        return md;
    }

    public static Milestone__c createMilestone(String recordTypeName, Project__c project) {
        Milestone__c milestone = new Milestone__c(
                RecordTypeId = GetRecordType.getRecordType('Milestone__c', recordTypeName),
                Name = 'MilestoneName',
                Cost__c = 100000,
                Developing_cost__c = 200,
                Start_date__c = Date.today(),
                Due_date__c = Date.today().addMonths(1),
                Status__c = 'Upcoming',
                Project__c = project.Id
        );

        insert milestone;
        return milestone;
    }

    public static Project__c createProject(Customer__c customer) {
        Project__c project = new Project__c(
                Name = 'Project 1',
                Customer__c = customer.Id,
                Status__c = 'Upcoming',
                Project_is_finished__c = false
        );
        insert project;
        return project;
    }

    public static Customer__c createCustomer() {
        Customer__c customer = new Customer__c(
                Name = 'Customer1'
        );
        insert customer;
        return customer;
    }

    public static Bank_Account__c createBankAccount(Integer amount){
        Bank_Account__c ba = new Bank_Account__c(
                Name = 'Bank Account Name',
                Current_Amount__c = amount
        );
        insert ba;
        return ba;
    }
    public static Company_Budget__c createCompanyBudget(){
        Company_Budget__c cb = new Company_Budget__c(
                Name = Constants.COMPANY_NAME,
                Total_Income__c = 10000,
                Total_Developers_Payment__c = 1000,
                Total_Other_Expense__c = 10
        );
        insert cb;
        return cb;
    }
}
