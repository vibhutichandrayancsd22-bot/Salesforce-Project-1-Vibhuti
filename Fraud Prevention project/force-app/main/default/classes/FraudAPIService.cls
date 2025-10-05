public with sharing class FraudAPIService {

    // This method fetches fraud alerts from the external API
    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getFraudAlertsFromAPI() {
        try {
            // Create HTTP request
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:Fraud_API_Credential/alerts'); // Named Credential
            req.setMethod('GET');
            

            Http http = new Http();
            HttpResponse res = http.send(req);
            
            // Parse JSON response into a list of maps
            List<Map<String, Object>> alerts = (List<Map<String, Object>>) JSON.deserializeUntyped(res.getBody());
            
            return alerts;
        } catch(Exception e) {
            // Handle errors gracefully
            System.debug('Error fetching fraud alerts: ' + e.getMessage());
            return new List<Map<String, Object>>();
        }
    }
}