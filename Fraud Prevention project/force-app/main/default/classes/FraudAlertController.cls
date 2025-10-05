public with sharing class FraudAlertController {

    @AuraEnabled(cacheable=true)
    public static List<Fraud_alert__c> getFraudAlert() {
        return [
            SELECT Id, Name, Alert_status__c, transaction__c
            FROM Fraud_alert__c
            ORDER BY CreatedDate DESC
            LIMIT 10
        ];
    }
}