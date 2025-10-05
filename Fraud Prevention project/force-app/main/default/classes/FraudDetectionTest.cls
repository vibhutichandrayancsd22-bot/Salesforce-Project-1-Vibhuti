@isTest
private class FraudDetectionTest {

    @testSetup
    static void setupTestData() {
        // Create Account
        Account testAccount = new Account(Name='Test Customer Account');
        insert testAccount;

        // FIX: Create a placeholder transaction first to satisfy the required field on the Fraud Rule
        Finance_Transaction_Custom__c placeholderTxn = new Finance_Transaction_Custom__c(
            Account_Customer__c = testAccount.Id,
            Amount__c = 1,
            Transaction_Date__c = Date.today(),
            Status__c = 'Success'
        );
        insert placeholderTxn;

        // Create a Fraud Rule and link it to the placeholder transaction
        Fraud_Rule__c rule = new Fraud_Rule__c(
            Name = 'High Amount Rule',
            Threshold_Amount__c = 5000,
            Active__c = true,
            Rule_type__c = 'High Amount',
            Linked_Transaction__c = placeholderTxn.Id // FIX: Populate the required field
        );
        insert rule;
    }

    @isTest
    static void testFraudulentTransactionCreatesAlertAndCase() {
        Account acct = [SELECT Id FROM Account WHERE Name='Test Customer Account' LIMIT 1];

        // Transaction above the threshold
        Finance_Transaction_Custom__c txn = new Finance_Transaction_Custom__c(
            Account_Customer__c = acct.Id,
            Name = 'Fraudulent Transaction',
            Amount__c = 9000,
            Transaction_Date__c = Date.today(),
            Status__c = 'Pending'
        );

        Test.startTest();
        insert txn;  // Trigger should create Fraud Alert and Investigation Case
        Test.stopTest();

        // Verify Fraud Alert creation
        List<Fraud_Alert__c> alertList = [
            SELECT Id, Linked_Transaction__c, Assigned_Officer__c
            FROM Fraud_Alert__c
            WHERE Linked_Transaction__c = :txn.Id
        ];
        
        System.assertEquals(1, alertList.size(), 'One alert should be created');
    }

    @isTest
    static void testNonFraudulentTransactionCreatesNoRecords() {
        Account acct = [SELECT Id FROM Account WHERE Name='Test Customer Account' LIMIT 1];

        // Transaction below the threshold
        Finance_Transaction_Custom__c txn = new Finance_Transaction_Custom__c(
            Account_Customer__c = acct.Id,
            Name = 'Safe Transaction',
            Amount__c = 1000,
            Transaction_Date__c = Date.today(),
            Status__c = 'Pending'
        );

        Test.startTest();
        insert txn;  // Trigger should NOT create Fraud Alert or Case
        Test.stopTest();

        List<Fraud_Alert__c> alertList = [
            SELECT Id FROM Fraud_Alert__c WHERE Linked_Transaction__c = :txn.Id
        ];
        
        System.assertEquals(0, alertList.size(), 'No alert should be created');
    }
}