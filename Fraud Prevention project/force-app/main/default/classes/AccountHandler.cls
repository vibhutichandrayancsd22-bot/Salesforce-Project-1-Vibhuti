// In AccountHandler.cls
public class AccountHandler {
    
    public static void accountCreation(Account accToInsert) { // <-- Change: Add parameter
        try{
            insertAccountRecords(accToInsert); // <-- Change: Pass parameter
        } catch(MyException me) {
            system.debug('Error: ' + me.getMessage());
        }
    }
    
    public static void insertAccountRecords(Account accToInsert) { // <-- Change: Add parameter
        try{
            insert accToInsert; // <-- Change: Use the parameter
        } catch(DMLException e) {
            throw new MyException('Account cannot be created: ' + e.getMessage());
        }
    }
    
    // updateAccountPhone method stays the same
    public static void updateAccountPhone(List<Account> accounts) {
        // ...
    }

    public static void updateAccountDescription(List<Account> accounts) {
        for(Account acc : accounts){
            acc.Description = 'Updated by Handler';
        }
        update accounts;
    }
}