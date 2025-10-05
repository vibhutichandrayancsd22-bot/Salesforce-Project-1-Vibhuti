@RestResource(urlMapping='/fraudalerts/*')
global with sharing class FraudalertRestService {

    @HttpGet
    global static List<Fraud_alert__c> getFraudalert() {
        return [SELECT Id, Name, Alert_status__c, transaction__c FROM Fraud_alert__c LIMIT 10];
    }
}