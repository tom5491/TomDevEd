public class AddPrimaryContact implements Queueable {
    
    private Contact c;
    private String state;
    
    public AddPrimaryContact(Contact con, String state){
        this.c = con;
        this.state = state;
    }
    
    public void execute(QueueableContext context) {
        List<Account> accounts = [SELECT Id, Name, BillingState FROM Account WHERE BillingState = :state LIMIT 200];
        List<Contact> contact_lst = new List<Contact>();
        for(Account Account : Accounts) {
            Contact cont = c.clone(false, false, false, false);
            cont.AccountId = Account.Id;
            contact_lst.add(cont);
            
        }
        if(contact_lst.size()>0) {
            insert contact_lst;
        }
    }
}