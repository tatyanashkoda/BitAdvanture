public with sharing class ProjectTriggerHandler extends TriggerHandler {

    public override void beforeUpdate() {
        checkAndUpdateDateFnished((List<Project__c>) Trigger.new);
        //checkClosedMilestones((List<Project__c>) Trigger.new);
    }

    private void checkAndUpdateDateFnished(List<Project__c> projects) {
        for (Project__c project : projects) {
            Project__c oldProject = (Project__c) System.Trigger.oldMap.get(project.Id);
            if (oldProject.Project_is_finished__c == false && project.Project_is_finished__c == true) {
                project.Status__c = Constants.STATUS_CLOSED;
                checkClosedMilestones(project);
                return;
            }

            if (oldProject.Project_is_finished__c == true && project.Project_is_finished__c == false
                    && project.Status__c == Constants.STATUS_CLOSED) {
                project.Status__c = Constants.STATUS_INPROGRESS;
                project.Finished_by__c = null;
                return;
            }

            if (oldProject.Status__c != Constants.STATUS_CLOSED && project.Status__c == Constants.STATUS_CLOSED) {
                project.Project_is_finished__c = true;
                checkClosedMilestones(project);
                return;
            }

            if (project.Finished_by__c != NULL || (oldProject.Finished_by__c != project.Finished_by__c)) {
                project.Project_is_finished__c = true;
                project.Status__c = Constants.STATUS_CLOSED;
            }
        }

    }
    private void checkClosedMilestones(Project__c project) {
        if (project.Status__c == Constants.STATUS_CLOSED) {
            List<Milestone__c> milestones = [SELECT Id, Status__c FROM Milestone__c WHERE Project__c = :project.Id];
            for (Milestone__c milestone : milestones) {
                if (milestone.Status__c != Constants.STATUS_CLOSED) {
                    project.addError('Unable to close the project because there are unclosed milestones');
                }
            }
        }

    }
}