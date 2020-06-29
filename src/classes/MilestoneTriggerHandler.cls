public with sharing class MilestoneTriggerHandler extends TriggerHandler {
    public override void beforeUpdate() {
        updateStatus((List<Milestone__c>) Trigger.new);
        updateDueDate((List<Milestone__c>) Trigger.new);
    }

    public override void afterInsert() {
        checkStatusOnProject((List<Milestone__c>) Trigger.new);
    }

    private void updateStatus(List<Milestone__c> milestones) {
        for (Milestone__c ms : milestones) {
            Milestone__c oldMilestone = (Milestone__c) System.Trigger.oldMap.get(ms.Id);
            if (oldMilestone.Finished__c == false && ms.Finished__c == true) {
                ms.Status__c = Constants.STATUS_CLOSED;
                return;
            }

            if (oldMilestone.Finished__c == true && ms.Finished__c == false
                    && ms.Status__c == Constants.STATUS_CLOSED) {
                ms.Status__c = Constants.STATUS_INPROGRESS;
                ms.Finished_by__c = NULL;
                return;
            }

            if (ms.Status__c == Constants.STATUS_CLOSED) {
                ms.Finished__c = true;
                return;
            }

            if (ms.Finished_by__c != NULL || (oldMilestone.Finished_by__c != ms.Finished_by__c)) {
                ms.Finished__c = true;
                ms.Status__c = Constants.STATUS_CLOSED;
            }
        }
    }

    private void updateDueDate(List<Milestone__c> milestones) {
        for (Milestone__c ms : milestones) {
            Project__c project = [SELECT Due_date__c FROM Project__c WHERE Id = :ms.Project__c];
            if (ms.Due_date__c != NULL && ms.Start_date__c != NULL) {
                if (project.Due_date__c == NULL || project.Due_date__c < ms.Due_date__c) {
                    project.Due_date__c = ms.Due_date__c;
                }
                update project;
            }
        }
    }

    private void checkStatusOnProject(List<Milestone__c> milestones) {
        for (Milestone__c ms : milestones) {
            Project__c project = [
                    SELECT Status__c, Due_date__c, Finished_by__c, Project_is_finished__c
                    FROM Project__c
                    WHERE Id = :ms.Project__c
            ];
            if (project.Status__c == Constants.STATUS_CLOSED && project.Project_is_finished__c == true) {
                project.Status__c = Constants.STATUS_INPROGRESS;
                project.Project_is_finished__c = false;
                project.Finished_by__c = NULL;
            }
            update project;
        }
    }
}