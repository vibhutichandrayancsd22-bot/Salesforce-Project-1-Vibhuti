public class QueueApex implements Queueable {
    public void execute(QueueableContext q) {
        // Update contacts whose title is blank
        List<Contact> contactList = [SELECT Id, FirstName, LastName, Title FROM Contact WHERE Title = NULL];
        for(Contact con : contactList) {
            con.Title = 'Customer';
        }

        if(!contactList.isEmpty()){
            update contactList;
        }
    }
}
