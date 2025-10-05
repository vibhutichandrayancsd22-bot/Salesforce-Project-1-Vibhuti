public with sharing class FraudAlertEventPublisher {

    // Method to publish a new Fraud Alert Event
    @AuraEnabled
    public static void publishFraudAlert(String alertId, String status, String transactionRef, String description) {
        try {
            // Create new event instance
            Fraud_Alert_Event__e event = new Fraud_Alert_Event__e(
                Alert_ID__c = alertId,
                Status__c = status,
                Transaction_Ref__c = transactionRef,
                Description__c = description
            );
            
            // Publish the event
            Database.SaveResult result = EventBus.publish(event);
            
            // Optional: check for errors
            if (!result.isSuccess()) {
                System.debug('Error publishing event: ' + result.getErrors()[0].getMessage());
            }
        } catch(Exception e) {
            System.debug('Exception while publishing event: ' + e.getMessage());
        }
    }
}