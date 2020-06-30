/**
 * Created by tshkoda on 6/29/2020.
 */

@IsTest
private class ProjectTriggerHandlerTest {
    @TestSetup
    static void setup(){
        DataForTests.createCompanyBudget();
    }

    @IsTest
    static void checkProjectStatus() {
        Customer__c customer = DataForTests.createCustomer();
        Project__c project = DataForTests.createProject(customer);

        project.Project_is_finished__c = true;
        assertErrorOnUpdate(project, 'Unable to close the project because there are unclosed milestones');

        update project;
        project = [SELECT Id, Project_is_finished__c, Status__c FROM Project__c LIMIT 1];
        System.assertEquals(Constants.STATUS_CLOSED, project.Status__c);
        System.assertEquals(true, project.Project_is_finished__c);

        project.Project_is_finished__c = false;
        update project;
        project = [SELECT Id, Finished_by__c, Project_is_finished__c, Status__c FROM Project__c LIMIT 1];
        System.assertEquals(Constants.STATUS_INPROGRESS, project.Status__c);
        System.assertEquals(NULL, project.Finished_by__c);

        project.Status__c = Constants.STATUS_CLOSED;
        update project;
        project = [SELECT Id, Finished_by__c, Project_is_finished__c, Status__c FROM Project__c LIMIT 1];
        System.assertEquals(true, project.Project_is_finished__c);

        project.Finished_by__c = Date.today();
        update project;
        System.assertEquals(Constants.STATUS_CLOSED, project.Status__c);
        System.assertEquals(true, project.Project_is_finished__c);

        project.Finished_by__c = Date.today().addDays(5);
        update project;
        System.assertEquals(Constants.STATUS_CLOSED, project.Status__c);
    }

    private static void assertErrorOnUpdate(Project__c project, String expected) {
        Milestone__c milestone = DataForTests.createMilestone('Upwork', project);
        try {
            update project;
            System.assert(false, 'exception expected for SObject ' + project);
        } catch (Exception e) {
            System.assert(e.getMessage().contains(expected), 'message=' + e.getMessage());
        }
        milestone.Status__c = Constants.STATUS_CLOSED;
        update milestone;
    }
}