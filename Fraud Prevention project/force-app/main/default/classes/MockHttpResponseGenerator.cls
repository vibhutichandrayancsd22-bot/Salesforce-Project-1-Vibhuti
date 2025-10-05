@IsTest
private class MockHttpResponseGeneratorTest {

    // Inner class to mock HTTP callout
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status":"success"}');
            res.setStatusCode(200);
            return res;
        }
    }

    @IsTest
    static void testMockHttpCallout() {
        // Set mock callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Create a dummy HTTP request
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://dummyendpoint.com');
        req.setMethod('GET');

        // Perform HTTP callout inside test context
        Http http = new Http();
        HttpResponse res = http.send(req);

        // Assertions
        System.assertEquals(200, res.getStatusCode(), 'Status code should be 200');
        System.assertEquals('{"status":"success"}', res.getBody(), 'Response body should match');
        System.assertEquals('application/json', res.getHeader('Content-Type'), 'Header should match');
    }
}
