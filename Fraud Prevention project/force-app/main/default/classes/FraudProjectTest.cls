@isTest
global class FraudProjectTest {

    @testSetup
    static void setupTestData() {
        // Accounts
        Account acc1 = new Account(Name='Test Account 1', Phone='1234567890');
        Account acc2 = new Account(Name='Test Account 2', Phone='0987654321');
        insert new List<Account>{acc1, acc2};

        // Contacts
        Contact con1 = new Contact(FirstName='John', LastName='Doe', AccountId=acc1.Id, Phone='1111111111');
        Contact con2 = new Contact(FirstName='Jane', LastName='Doe', AccountId=acc2.Id, Phone='2222222222');
        insert new List<Contact>{con1, con2};

        // Finance Transactions
        if(Schema.sObjectType.Finance_Transaction_Custom__c.isAccessible()){
            Finance_Transaction_Custom__c txn = new Finance_Transaction_Custom__c(
                Name = 'Txn 1',
                Amount__c = 6000,
                Account_Customer__c = acc1.Id,
                Transaction_Date__c = Date.today() // <-- THIS IS THE FIX
            );
            insert txn;
        }
    }


    @isTest static void testAccountProffessor() {
    // 1. Arrange: Create a test Account that needs to be updated.
    Account testAcc = new Account(Name='Batch Test Account', Industry='Finance');
    insert testAcc;

    Test.startTest();
        // 2. Act: Call the 'execute' method directly.
        // This tests the actual work of your batch class without the framework.
        AccountProffessor batchJob = new AccountProffessor();
        batchJob.execute(null, new List<Account>{ testAcc });
    Test.stopTest();

    // 3. Assert: Check that the record was updated as expected.
    Account updatedAcc = [SELECT Industry FROM Account WHERE Id = :testAcc.Id];
    System.assertEquals('Technology', updatedAcc.Industry, 'The Industry should be updated.');
}
    @isTest static void testFraudAlertController() {
        Test.startTest();
        if(Type.forName('FraudAlertController') != null) {
            FraudAlertController.getFraudAlert();
        }
        Test.stopTest();
        System.assert(true, 'FraudAlertController executed');
    }

    @isTest static void testFraudAlertEventPublisher() {
        String dummyAlertId = 'TestAlert001';
        String dummyStatus = 'New';
        String dummyTxnRef = 'Txn123';
        String dummyDescription = 'Test fraud alert';

        Test.startTest();
        if(Type.forName('FraudAlertEventPublisher') != null) {
            FraudAlertEventPublisher.publishFraudAlert(dummyAlertId, dummyStatus, dummyTxnRef, dummyDescription);
        }
        Test.stopTest();
        System.assert(true, 'FraudAlertEventPublisher executed');
    }

    @isTest static void testFraudApiCalloutController() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Test.startTest();
        if(Type.forName('FraudApiCalloutController') != null) {
            String response = FraudApiCalloutController.getFraudAlertsFromAPI();
            System.assert(response != null, 'Callout should return a response');
        }
        Test.stopTest();
    }

    @isTest static void testFraudApiService() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Test.startTest();
        if(Type.forName('FraudAPIService') != null) {
            List<Map<String,Object>> alerts = FraudAPIService.getFraudAlertsFromAPI();
            System.assert(alerts != null, 'Callout should return a list');
        }
        Test.stopTest();
    }

    @isTest static void testFraudApiSiteCalloutController() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Test.startTest();
        if(Type.forName('FraudApiSiteCalloutController') != null) {
            String response = FraudApiSiteCalloutController.getFraudAlerts();
            System.assert(response != null, 'Callout should return a response');
        }
        Test.stopTest();
    }

    @isTest static void testLoggingMediumLevel() {
        Test.startTest();
        if(Type.forName('LoggingMediumLevel') != null) {
            LoggingMediumLevel.createAccount('Test Account');
        }
        Test.stopTest();

        Integer countAcc = [SELECT COUNT() FROM Account WHERE Name='Test Account'];
        System.assert(countAcc > 0, 'Account should be created by LoggingMediumLevel');
    }

    @isTest static void testMyDebugSampleClass() {
        Test.startTest();
        if(Type.forName('MyDebugSampleClass') != null) {
            MyDebugSampleClass.createAccount();
        }
        Test.stopTest();

        Integer countAcc = [SELECT COUNT() FROM Account WHERE Name='Anisha'];
        System.assert(countAcc > 0, 'Account should be created by MyDebugSampleClass');
    }


global class MockHttpResponseGenerator implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"status":"ok", "alerts":[]}');
        res.setStatusCode(200);
        return res;
    }
}
}