global with sharing class CalendarController {

    public String todaysDate { get; set; }

    global CalendarController() {
        todaysDate = System.now().format('yyyy-MM-dd');
    }

    @RemoteAction
    global static List<GetEvent> getEvents() {
        List<GetEvent> getEvents = new List<GetEvent>();
        TimeZone timeZone = UserInfo.getTimeZone();
        List<Event> events = [SELECT Id, Subject,StartDateTime, EndDateTime, WhoId From Event];
        List<Contact> contacts = [SELECT Id, Name From Contact];

        for (Event objEvent : events) {
            GetEvent getEvent = new GetEvent();
            for (Contact contact : contacts) {
                if (contact.Id == objEvent.WhoId) {
                    getEvent.title = contact.Name;
                }
            }
            getEvent.Id = objEvent.Id;
            if (objEvent.Subject != null) {
                getEvent.Subject = objEvent.Subject;
            }
            if (objEvent.StartDateTime != null) {
                getEvent.StartDateTime = objEvent.StartDateTime.getTime() + timeZone.getOffset(objEvent.StartDateTime.addHours(3));
            }

            if (objEvent.EndDateTime != null) {
                getEvent.EndDateTime = objEvent.EndDateTime.getTime() + timeZone.getOffset(objEvent.EndDateTime.addHours(3));
            }
            getEvents.add(getEvent);
        }
        return getEvents;
    }

    public static Contact createOrGetContact(String contactFirstName, String contactLastName, String contactEmail) {
        List<User> guestUser = [SELECT Id FROM User Where Username =: Constants.GUEST_USER_NAME];
        List<Contact> contacts = [SELECT Id,FirstName,LastName FROM Contact WHERE Email = :contactEmail AND LastName = :contactLastName];
        if (contacts.isEmpty()) {
            Contact newContact = new Contact(
                    FirstName = contactFirstName,
                    LastName = contactLastName,
                    Email = contactEmail,
                    OwnerId = '0056F00000C7241QAB'
            );
            insert newContact;
            return newContact;
        } else {
            return contacts.get(0);
        }
    }

    @RemoteAction
    global static List<Free_Time__c> getFreeTimes(){
        List<Free_Time__c> freeTimes = [SELECT Id, Start_Time__c, End_Time__c From Free_Time__c];
        return freeTimes;
    }

    @RemoteAction
    global static List<GetEvent> createOrUpdateEvents(String calendarEvent) {
        Custom_Event__c eventObject = ((Custom_Event__c) JSON.deserialize(calendarEvent, Custom_Event__c.class));
        Boolean checkOnFreeTime = false;

        List<Free_Time__c>freeTimes = [
                SELECT Start_Time__c, End_Time__c
                From Free_Time__c
                WHERE Start_Time__c <= :eventObject.Start_Time__c
                AND End_Time__c >= :eventObject.Start_Time__c
                AND End_Time__c >= :eventObject.End_Time__c
        ];


        if (!freeTimes.isEmpty()) {
            checkOnFreeTime = true;
        }
        if (checkOnFreeTime == true) {
            Custom_Event__c objEvent = new Custom_Event__c(
                    Start_Time__c = eventObject.Start_Time__c,
                    End_Time__c = eventObject.End_Time__c,
                    Subject__c = eventObject.Subject__c,
                    Status__c = Constants.WAITING_FOR_APPROVAL_STATUS,
                    Contact_Email__c = eventObject.Contact_Email__c,
                    Attached_to__c = Constants.CONTACT_MANAGER_ID
            );
            objEvent.Contact__c = createOrGetContact(eventObject.Contact_First_Name__c, eventObject.Contact_Last_Name__c, eventObject.Contact_Email__c).Id;
            insert objEvent;
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Success! Event sent for review.');
            ApexPages.addMessage(msg);
            return getEvents();
        }
        else {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'No meetings are held at this time.');
            ApexPages.addMessage(msg);
            return null;
        }
    }

    global class GetEvent {
        public String Id;
        public String Title;
        public String FirstName;
        public String LastName;
        public Long StartDateTime;
        public Long EndDateTime;
        public String Subject;
    }
}