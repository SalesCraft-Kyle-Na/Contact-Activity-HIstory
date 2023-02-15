@IsTest
private class ContactActivityHistoryControllerTest {

    @TestSetup
    static void setup() {
        Contact con = new Contact(FirstName = 'Test', LastName = 'Contact');
        insert con;
        date myDate = date.newInstance(2023, 11, 21);
        Opportunity opp = new Opportunity(Name = 'Test Opportunity', CloseDate = System.today(), StageName = 'Prospecting', Contact__c = con.Id);
        insert opp;
        opp.Contact__c = con.Id;
        update opp;
        Event e = new Event(Subject = 'Test Event', ActivityDateTime = System.now(), Description = 'Test Description', WhoId = con.Id, DurationInMinutes = 10);
        insert e;
        Task t = new Task(Subject = 'Test Task', ActivityDate = myDate, Description = 'Test Description', WhoId = con.Id);
        insert t;
    }

    @IsTest
    static void testGetData() {
        Opportunity opp = [SELECT Id, Name FROM Opportunity LIMIT 1];
        List<ContactActivityHistoryController.ActivityHistory> result = ContactActivityHistoryController.getData(opp.Id);
        System.assertEquals(2, result.size(), 'Expected 2 activities');
        for (ContactActivityHistoryController.ActivityHistory ah : result) {
            System.assertNotEquals(null, ah.activityDate, 'Expected activity date');
        }
    }
}