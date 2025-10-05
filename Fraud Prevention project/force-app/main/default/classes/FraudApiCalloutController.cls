public with sharing class FraudApiCalloutController {

    @AuraEnabled(cacheable=true)
    public static String getFraudAlertsFromAPI() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Fraud_API_Credential/alerts'); // Named Credential
        req.setMethod('GET');

        Http http = new Http();
        HttpResponse res = http.send(req);

        // Return the response body (JSON) to your LWC
        return res.getBody();
    }
}