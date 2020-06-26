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
        Milestone_Developer__c md = new Milestone_Developer__c(
                RecordTypeId = GetRecordType.getRecordType('Milestone_Developer__c', recordTypeName),
                Name = 'Name',
                Milestone__c = milestone.Id,
                Developer__c = developer.Id
        );
        if (md.RecordType.Name == Constants.EARLY_COST_RECORD_TYPE) {
            md.Developing_cost__c = 100;
        } else if (md.RecordType.Name == Constants.FIXED_COST_RECORD_TYPE) {
            md.Cost_Per_Hour__c = 10;
            md.Number_of_Hours__c = 10;
        }
        insert md;
        return md;
    }

    public static Milestone__c createMilestone(String recordTypeName) {
        Milestone__c milestone = new Milestone__c(
                RecordTypeId = GetRecordType.getRecordType('Milestone__c', recordTypeName),
                Name = 'MilestoneName',
                Cost__c = 1000,
                Developing_cost__c = 200,
                Start_date__c = Date.today(),
                Due_date__c = Date.today().addMonths(1),
                Status__c = 'Upcoming'
        );

        insert milestone;
        return milestone;
    }

    public static Project__c createProject(Customer__c customer) {
        Project__c project = new Project__c(
                Name = 'Project 1',
                Customer__c = customer.Id,
                Status__c = 'Upcoming'
        );
        insert project;
        return project;
    }

    public static Customer__c createCustomer() {
        Customer__c customer = new Customer__c(
                Name = 'Customer1'
        );
        return customer;
    }
}
