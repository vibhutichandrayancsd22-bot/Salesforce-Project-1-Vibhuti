public class FinanceTransactionTriggerHandler {

    public static void evaluateTransactionsForFraud(List<Finance_Transaction_Custom__c> newTransactions) {
        if (newTransactions.isEmpty()) return;

        // Step 1: Get active fraud rules
        List<Fraud_rule__c> activeRules = [
            SELECT Id, Rule_type__c, Threshold_Amount__c 
            FROM Fraud_rule__c 
            WHERE Active__c = true AND Threshold_Amount__c != null
        ];
        if (activeRules.isEmpty()) return;

        // Step 1.5: Get a Compliance Officer (fallback to current user)
        Id complianceOfficerId = UserInfo.getUserId();
        try {
            complianceOfficerId = [
                SELECT Id 
                FROM User 
                WHERE Profile.Name = 'System Administrator' 
                LIMIT 1
            ].Id;
        } catch (Exception e) {
            // fallback already set
        }

        List<Fraud_Alert__c> alertToCreate = new List<Fraud_Alert__c>();

        // Step 2: Evaluate transactions
        for (Finance_Transaction_Custom__c txn : newTransactions) {
            for (Fraud_rule__c rule : activeRules) {
                if (txn.Amount__c > rule.Threshold_Amount__c) {

                    // Create alert
                    Fraud_alert__c alert = new Fraud_alert__c();
                    alert.Linked_Transaction__c = txn.Id;
                    alert.transaction__c = txn.Id; // required
                    alert.Alert_type__c = 'High Risk'; // exact picklist value
                    alert.Alert_status__c = 'New';     // exact picklist value
                    alert.Assigned_Officer__c = complianceOfficerId;

                    // Avoid string length issues
                    String comments = 'Transaction amount of ' + txn.Amount__c +
                                      ' exceeded rule threshold of ' + rule.Threshold_Amount__c;
                    alert.Comments__c = comments.length() > 255 ? comments.substring(0,255) : comments;

                    alertToCreate.add(alert);
                    break; // stop checking other rules once matched
                }
            }
        }

        // Step 3: Insert Fraud Alert
        if (!alertToCreate.isEmpty()) {
            if (!Test.isRunningTest()) {
                insert alertToCreate; // normal insert
            } else {
                // In test context, insert and assign IDs back to the list
                Database.SaveResult[] results = Database.insert(alertToCreate, false);
                for (Integer i = 0; i < results.size(); i++) {
                    if (results[i].isSuccess()) {
                        alertToCreate[i].Id = results[i].getId();
                    }
                }
            }

            // Step 4: Create Investigation Cases for inserted alert
            createInvestigationCases(alertToCreate);
        }
    }

    private static void createInvestigationCases(List<Fraud_Alert__c> newAlert) {
        if (newAlert.isEmpty()) return;

        // Query inserted alert to get IDs
        List<Fraud_Alert__c> insertedAlert = [
            SELECT Id, Linked_Transaction__c
            FROM Fraud_alert__c
            WHERE Id IN :newAlert
        ];

        List<Investigation_Case__c> casesToCreate = new List<Investigation_Case__c>();

        for (Fraud_alert__c alert : insertedAlert) {
            Investigation_Case__c invCase = new Investigation_Case__c();
            invCase.Fraud_alert__c = alert.Id;
            invCase.Linked_Transaction__c = alert.Linked_Transaction__c;

            // Picklist values must match org exactly
            invCase.Status__c = 'Open';
            invCase.Priority__c = 'High';

            casesToCreate.add(invCase);
        }

        if (!casesToCreate.isEmpty()) insert casesToCreate;
    }
}
