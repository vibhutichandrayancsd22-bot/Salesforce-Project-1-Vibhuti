public class UpdateContactPhone {
public static void updateContactRecord()//developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_exception_trycatch_example.htmhttps://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_exception_trycatch_example.htm()// static: mem alloc once 
{
    list<contact> updateContactList=new list<contact>();
    //fetch all the records from the database where the phone is not null
    list<contact> contactList=[select id,name,phone from contact where phone!=null];
    //iterate over the collections
    for(contact con:contactList)
    {
        con.Phone= '88888888888';
        updateContactList.add(con);
    }
    try
    {
        //trying update the records using the collections
        update updateContactlist;
    }
    catch(DMLexception e)
    {
        system.debug('there is an error'+e.getmessage());
        system.debug('Line number'+e.getLineNumber());
        system.debug('The cause is'+ e.getCause());
    }
    finally{
        system.debug('the failure and the success is handled ');
    }
        
}
}