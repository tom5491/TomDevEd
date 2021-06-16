@isTest
global class TestDataFactory {
    global static List<Account> createAccountsWithOpps(Integer numAccts, Integer numOppsPerAcct) {
        List<Account> accts = new List<Account>();
        
        for(Integer i=0;i<numAccts;i++) {
            Account a = new Account(Name='TestAccount' + i);
            accts.add(a);
        }
        insert accts;
        
        List<Opportunity> opps = new List<Opportunity>();
        for (Integer j=0;j<numAccts;j++) {
            Account acct = accts[j];
            // For each account just inserted, add opportunities
            for (Integer k=0;k<numOppsPerAcct;k++) {
                opps.add(new Opportunity(Name=acct.Name + ' Opportunity ' + k,
                                       StageName='Prospecting',
                                       CloseDate=System.today().addMonths(1),
                                       AccountId=acct.Id));
            }
        }
        // Insert all opportunities for all accounts.
        insert opps;
        
        return accts;
    }
    global class HttpTestData implements HttpCalloutMock {
        global HttpResponse respond(HttpRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status":"success"}');
            res.setStatusCode(200);
            return res; 
        }
    }
    global static List<Account> createAccountsWithCons(Integer numAccts, Integer numConsPerAcct) {
        List<Account> accts = new List<Account>();
        
        for(Integer i=0;i<numAccts;i++) {
            Account a = new Account(Name='TestAccount' + i);
            accts.add(a);
        }
        insert accts;
        
        List<Contact> cons = new List<Contact>();
        for (Integer j=0;j<numAccts;j++) {
            Account acct = accts[j];
            // For each account just inserted, add opportunities
            for (Integer k=0;k<numConsPerAcct;k++) {
                cons.add(new Contact(LastName=acct.Name + ' Contact ' + k,
                                       AccountId=acct.Id));
            }
        }
    	// Insert all contacts for all accounts.
        insert cons;
        
        return accts;
    }
    global static List<Lead> createLeads(Integer numLeads){
        List<Lead> leads = new List<Lead>();
        
        for(Integer i = 0; i<numLeads; i++){
            Lead l = new Lead(LastName = 'Lead ' + i, 
                              Company = 'Test Company', 
                              Status = 'Open - Not Contacted');
            leads.add(l);
            
        }
        insert leads;
        
        return leads;
    }
    
    global static List<Contact> createContacts(Integer numCons) {
        List<Contact> conList = new List<Contact>();
        for(Integer i = 0; i < numCons; i++) {
            Contact con = new Contact(LastName = 'Test ' + i+1);
            conList.add(con);
        }
        insert conList;
        
        return conList;
    }
    
}