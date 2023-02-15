public with sharing class ContactActivityHistoryController {

    /**
     * Method: getData
     * Description: Uses the Contact__c field on the opportunity to query all the tasks and events related to that Contact.
     * Created BY: Kyle
     */  
    @AuraEnabled(cacheable=true)
    public static List<ActivityHistory> getData(String recordId) {
        System.debug('contactactibityHistoryCotnroller');
        System.debug(recordId);
        Opportunity opp = [SELECT Id, Contact__c, Contact__r.Name FROM Opportunity WHERE Id =: recordId]; 
        if (opp.Contact__c == null) {
            List<ActivityHistory> activities = new List<ActivityHistory>();
            return activities;
        } else {
            List<Event> events = [SELECT Id, WhoId, Subject, ActivityDateTime, Description FROM Event WHERE WhoId =: opp.Contact__c ];
            List<Task> tasks = [SELECT Id, Description, Subject, ActivityDate, Type, WhoId FROM Task WHERE WhoId =: opp.Contact__c];
            System.debug(events);
            System.debug(tasks);
            for (Task t: tasks) {
                System.debug(t.WhoId);
            }
            List<ActivityHistory> activities = new List<ActivityHistory>();
            for (Event e : events) {
                activities.add(new ActivityHistory(e, opp.Contact__r.Name));
            }
            
            for (Task t : tasks) {
                activities.add(new ActivityHistory(t, opp.Contact__r.Name));
            }
            System.debug(opp.Contact__r.Name);
            System.debug(opp.Contact__c);
            return activities;
         }
    }

    /**
     * Activity History to display tasks and events in component
     */
    public class ActivityHistory {
        @AuraEnabled
        public DateTime activityDate {get;set;}
        @AuraEnabled
        public String eventId {get;set;}
        @AuraEnabled
        public String subtype {get;set;}
        @AuraEnabled
        public String type {get;set;}
        @AuraEnabled
        public String subject {get;set;}
        @AuraEnabled
        public String contactId {get;set;}
        @AuraEnabled
        public String contactName {get;set;}

        public ActivityHistory(Task task, String contactName) {
            this.activityDate = task.ActivityDate;
            this.eventId = '/' + task.Id;
            this.subtype = task.Subject;
            this.type = 'Task';
            this.subject = task.subject;
            this.contactId = '/' + task.WhoId;
            this.contactName = contactName;
        }

        public ActivityHistory(Event event, String contactName) {
            this.activityDate = event.ActivityDateTime;
            this.eventId = '/' + event.Id;
            this.subtype = event.Subject;
            this.type = 'Event';
            this.subject = event.subject;
            this.contactId = '/' + event.whoId;
            this.contactName = contactName;
        }
    }
}