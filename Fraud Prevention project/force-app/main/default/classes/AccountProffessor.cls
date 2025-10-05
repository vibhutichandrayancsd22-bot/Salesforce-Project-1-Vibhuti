public class AccountProffessor implements Database.Batchable<SObject> {

    // Start method: Returns the query locator for Accounts
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Query all Accounts where Industry is not already 'Technology'
        return Database.getQueryLocator('SELECT Id, Industry FROM Account WHERE Industry != \'Technology\'');
    }

    // Execute method: Processes each batch of records
    public void execute(Database.BatchableContext bc, List<Account> scope) {
        for (Account acc : scope) {
            acc.Industry = 'Technology';
        }
        update scope;
    }

    // Finish method: Runs after all batches are processed
    public void finish(Database.BatchableContext bc) {
        // Optional: Add any post-processing logic or notifications here
        System.debug('All accounts updated to Technology industry.');
    }
}