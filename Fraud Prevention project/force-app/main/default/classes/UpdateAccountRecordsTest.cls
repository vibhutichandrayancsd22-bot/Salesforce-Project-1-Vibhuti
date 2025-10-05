@isTest
private class UpdateAccountRecordsTest {

    @isTest
    static void testRecordUpdate() {
        // 1. Arrange: Create a test account WITH a phone number.
        // This is crucial so the query inside your method can find it.
        Account acc = new Account(Name='Test Update', Phone='1234567890');
        insert acc;

        Test.startTest();
            // 2. Act: Call the correct method with no parameters.
            UpdateAccountRecords.updatingAcc();
        Test.stopTest();

        // 3. Assert: Verify the phone number was changed to the new value.
        Account updatedAcc = [SELECT Id, Phone FROM Account WHERE Id = :acc.Id];
        System.assertEquals('3693693693', updatedAcc.Phone, 'The account phone should have been updated.');
    }
}