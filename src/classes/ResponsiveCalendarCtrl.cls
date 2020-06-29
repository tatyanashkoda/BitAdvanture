global with sharing class ResponsiveCalendarCtrl {

    public string todaysdate { get; set; }

    global ResponsiveCalendarCtrl() {
        todaysdate = system.now().format('yyyy-MM-dd');
    }

    @RemoteAction
    global static list<calendarWrapper> getCalendarItems() {
        list<calendarWrapper> lstcalendar = new list<calendarWrapper>();
        TimeZone timeZone = UserInfo.getTimeZone();


        List<Event> events = [SELECT Id, Subject,StartDateTime, EndDateTime, WhoId FROM Event];
        List<Contact> contacts = [SELECT Id, LastName, FirstName FROM Contact];
        List<Free_Time__c> freeTimes = [SELECT Id, End_Time__c, Start_Time__c FROM Free_Time__c];

        for (Event objEvent : events) {
            calendarWrapper calendarWrapper = new calendarWrapper();
            for (Contact con : contacts) {
                if (con.Id == objEvent.WhoId) {
                    calendarWrapper.title = con.FirstName + ' ' + con.LastName ;
                }
            }
            calendarWrapper.Id = objEvent.Id;
            if (objEvent.StartDateTime != NULL) {
                calendarWrapper.startTime = objEvent.StartDateTime.getTime() + timeZone.getOffset(objEvent.StartDateTime);
            }

            if (objEvent.EndDateTime != NULL) {
                calendarWrapper.endTime = objEvent.EndDateTime.getTime() + timeZone.getOffset(objEvent.EndDateTime);

            }
            lstcalendar.add(calendarWrapper);
        }

        return lstcalendar;

    }

    @RemoteAction
    global static list<freeTime> getFreeTimesItems() {
        list<freeTime> lstcalendar = new list<freeTime>();
        TimeZone timeZone = UserInfo.getTimeZone();

        List<Free_Time__c> freeTimes = [SELECT Id, End_Time__c, Start_Time__c FROM Free_Time__c];

        for (Free_Time__c objEvent : freeTimes) {
            freeTime freeTime = new freeTime();

            freeTime.title = 'Test' ;
            freeTime.Id = objEvent.Id;
            if (objEvent.Start_Time__c != NULL) {
                freeTime.startTime = objEvent.Start_Time__c.getTime() + timeZone.getOffset(objEvent.Start_Time__c);
            }

            if (objEvent.End_Time__c != NULL) {
                freeTime.endTime = objEvent.End_Time__c.getTime() + timeZone.getOffset(objEvent.End_Time__c);

            }
            lstcalendar.add(freeTime);
        }
        return lstcalendar;

    }

    global class calendarWrapper {
        public String Id;
        public String title;
        public String url;
        public Long startTime;
        public Long endTime;
    }

    global class freeTime {
        public String Id;
        public String title;
        public Long startTime;
        public Long endTime;
    }
}