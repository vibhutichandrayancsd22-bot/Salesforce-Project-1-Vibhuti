public with sharing class FraudApiSiteCalloutController {
    @AuraEnabled(cacheable=true)
    public static String getFraudAlerts() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Fraud_API_Credential/alerts');
        req.setMethod('GET');
        Http http = new Http();
        HttpResponse res = http.send(req);
        return res.getBody();
    }
}