@isTest
private class QueueApexTest {

    @isTest
    static void testContactTitleUpdate() {
        // 1. Arrange: Create the data the job is looking for.
        // First, an Account to be the parent.
        Account acc = new Account(Name='Test Parent Account');
        insert acc;

        // Second, a Contact with a blank Title, linked to the Account.
        Contact con = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id
            // Title is left blank on purpose
        );
        insert con;

        Test.startTest();
            // 2. Act: Schedule the queueable job.
            System.enqueueJob(new QueueApex());
        Test.stopTest(); // This forces the job to finish.

        // 3. Assert: Verify the job updated the Contact's Title.
        Contact updatedContact = [SELECT Title FROM Contact WHERE Id = :con.Id];
        System.assertEquals('Customer', updatedContact.Title, 'The Contact title should be updated to Customer.');
    }
}
