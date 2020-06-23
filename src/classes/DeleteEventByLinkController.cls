public with sharing class DeleteEventByLinkController {
    public Id id { get; set; }
    public transient List<Messaging.SingleEmailMessage> mails;
    public Custom_Event__c getCustomEvents() {
        id = ApexPages.currentPage().getParameters().get('id');
        List<Custom_Event__c> customEvents = [SELECT Start_Time__c, End_Time__c, Id, Subject__c FROM Custom_Event__c WHERE Id = :id];
        return customEvents.get(0);
    }

    public void deleteEvent() {
        Custom_Event__c customEvent = [SELECT Start_Time__c, End_Time__c, Id, Subject__c, Contact__c, Attached_to__c FROM Custom_Event__c WHERE Id = :id];
        Event event = [SELECT Id FROM Event WHERE StartDateTime = :customEvent.Start_Time__c AND EndDateTime = :customEvent.End_Time__c AND WhoId = :customEvent.Contact__c];
        mails = sendEmail(Constants.EMAIL_TEMPLATE_REMOVAL, customEvent.Attached_to__c, customEvent.Id);
        Messaging.SendEmailResult[] resultMail = Messaging.sendEmail(mails);
        Delete customEvent;
        Delete event;
    }
    public static Messaging.SingleEmailMessage generateEmailMessage(Id templateId, Id targetId, Id whatId) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTemplateId(templateId);
        mail.setTargetObjectId(targetId);
        mail.setSaveAsActivity(false);
        mail.setWhatId(whatId);
        return mail;
    }

    public static List<Messaging.SingleEmailMessage> sendEmail(String emailTemplateName, Id idSendEmail, Id eventId) {
        EmailTemplate emailTemplate = Database.query('Select id from EmailTemplate where name=: emailTemplateName');
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();

        mails.add(generateEmailMessage(emailTemplate.Id, idSendEmail, eventId));

        return mails;
    }
}