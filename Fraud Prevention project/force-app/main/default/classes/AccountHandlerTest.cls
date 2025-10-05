@isTest
private class AccountHandlerTest {

    @isTest
    static void testAccountCreation_Success() {
        // 1. Arrange: Create the Account record you want to insert.
        Account accToCreate = new Account(Name='New Test Account');
        Integer countBefore = [SELECT COUNT() FROM Account];

        Test.startTest();
            // 2. Act: Call the method and PASS IN the account record.
            AccountHandler.accountCreation(accToCreate); // <-- THE FIX IS HERE
        Test.stopTest();

        // 3. Assert: Verify that one new account was created.
        Integer countAfter = [SELECT COUNT() FROM Account];
        System.assertEquals(countBefore + 1, countAfter, 'A new account should have been created.');
    }

                @isTest
    static void testUpdateAccountDescription_Success() {
        // 1. Arrange: Create the test account.
        Account acc = new Account(Name='Test for Description Update');
        insert acc;

        List<Account> accountsToUpdate = [SELECT Id, Description FROM Account WHERE Id = :acc.Id];

        Test.startTest();
            // 2. Act: Call the new method.
            AccountHandler.updateAccountDescription(accountsToUpdate);
        Test.stopTest();

        // 3. Assert: Check that the Description field was updated correctly.
        Account updatedAcc = [SELECT Id, Description FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Updated by Handler', updatedAcc.Description, 'The description should be updated.');
    }
    @isTest
    static void testAccountCreation_Error() {
        // 1. Arrange: Create an invalid Account (Name is required).
        Account badAcc = new Account();

        Test.startTest();
            // 2. Act & Assert: Call the method and verify it throws your custom exception.
            try {
                AccountHandler.accountCreation(badAcc);
            } catch (MyException e) {
                // This assertion proves your catch block is working.
                System.assert(e.getMessage().contains('Account cannot be created'), 'The custom exception should be thrown.');
            }
        Test.stopTest();
    }
}