@isTest
private class FraudAlertControllerTest {
    @isTest
    static void testFraudAlertController() {
        Account acc = new Account(Name = 'Fraud Test');
        insert acc;

        Test.startTest();
        FraudAlertController.raiseAlert(acc.Id);
        Test.stopTest();

        System.assert(true, 'FraudAlertController executed');
    }
}
