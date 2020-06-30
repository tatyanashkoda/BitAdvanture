/**
 * Created by tshkoda on 6/30/2020.
 */

@IsTest
private class MilestoneDeveloperTriggerHandlerTest {
    @TestSetup
    static void setup() {
        Customer__c customer = DataForTests.createCustomer();
        Project__c project = DataForTests.createProject(customer);
        Developer__c developer = DataForTests.createDeveloper();
        Milestone__c milestone = DataForTests.createMilestone('Upwork', project);
        Milestone_Developer__c mdFix = DataForTests.createMilestoneDeveloper(Constants.FIXED_COST_RECORD_TYPE, milestone, developer);
        Milestone_Developer__c mdEarly = DataForTests.createMilestoneDeveloper(Constants.EARLY_COST_RECORD_TYPE, milestone, developer);
    }

    @IsTest
    static void testOnInsert() {
        Milestone_Developer__c mdFix = [
                SELECT Id, Name, Developer__r.Name, Total_Amount__c,Developing_cost__c
                FROM Milestone_Developer__c
                WHERE RecordType.Name = :Constants.FIXED_COST_RECORD_TYPE
                LIMIT 1
        ];
        System.assertEquals(mdFix.Developer__r.Name, mdFix.Name);
        System.assertEquals(mdFix.Developing_cost__c, mdFix.Total_Amount__c);

        Milestone_Developer__c mdEarly = [
                SELECT Id, Name, Developer__r.Name, Cost_Per_Hour__c, Number_of_Hours__c, Total_Amount__c
                FROM Milestone_Developer__c
                WHERE RecordType.Name = :Constants.EARLY_COST_RECORD_TYPE
                LIMIT 1
        ];
        System.assertEquals(mdEarly.Developer__r.Name, mdEarly.Name);
        System.assertEquals(mdEarly.Cost_Per_Hour__c * mdEarly.Number_of_Hours__c, mdEarly.Total_Amount__c);

        List<Bill__c> bill = [SELECT Id FROM Bill__c];
        System.assertNotEquals(0, bill.size());
    }

    @IsTest
    static void testOnUpdate() {
        Milestone_Developer__c mdFix = [
                SELECT Id, Name, Developer__r.Name, Total_Amount__c,Developing_cost__c
                FROM Milestone_Developer__c
                WHERE RecordType.Name = :Constants.FIXED_COST_RECORD_TYPE
                LIMIT 1
        ];
        mdFix.Developing_cost__c = +10;
        update mdFix;
        mdFix = [
                SELECT Id, Name, Developer__r.Name, Total_Amount__c,Developing_cost__c
                FROM Milestone_Developer__c
                WHERE RecordType.Name = :Constants.FIXED_COST_RECORD_TYPE
                LIMIT 1
        ];
        System.assertEquals(mdFix.Developing_cost__c, mdFix.Total_Amount__c);

        Milestone_Developer__c mdEarly = [
                SELECT Id, Name, Developer__r.Name, Cost_Per_Hour__c, Number_of_Hours__c, Total_Amount__c
                FROM Milestone_Developer__c
                WHERE RecordType.Name = :Constants.EARLY_COST_RECORD_TYPE
                LIMIT 1
        ];
        mdEarly.Cost_Per_Hour__c = +2;
        update mdEarly;
        mdEarly = [
                SELECT Id, Name, Developer__r.Name, Cost_Per_Hour__c, Number_of_Hours__c, Total_Amount__c
                FROM Milestone_Developer__c
                WHERE RecordType.Name = :Constants.EARLY_COST_RECORD_TYPE
                LIMIT 1
        ];
        System.assertEquals(mdEarly.Cost_Per_Hour__c * mdEarly.Number_of_Hours__c, mdEarly.Total_Amount__c);
    }

    @IsTest
    static void testOnDelete() {
        List<Milestone_Developer__c> milestoneDevelopers = [
                SELECT Id, Name, Developer__r.Name, Total_Amount__c,Developing_cost__c
                FROM Milestone_Developer__c
                WHERE RecordType.Name = :Constants.FIXED_COST_RECORD_TYPE
        ];
        delete milestoneDevelopers;
    }
}
