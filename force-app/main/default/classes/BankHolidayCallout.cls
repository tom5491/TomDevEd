public with sharing class BankHolidayCallout {
    public static void getBankHolidays(){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint('https://www.gov.uk/bank-holidays.json');
        
        HttpResponse res = http.send(req);

        String resp = res.getBody();

        resp = resp.replaceAll('date', 'date_z');
        resp = resp.replaceAll('england-and-wales', 'england_and_wales');

        BankHolidayWrapperClass bhwc = (BankHolidayWrapperClass) JSON.deserialize(resp, BankHolidayWrapperClass.class);
        List<Bank_Holiday__c> bhList = new List<Bank_Holiday__c>();

        List<Bank_Holiday__c> currentBhList = [SELECT Id, Date__c FROM Bank_Holiday__c];
        Set<Date> bankHolidayDateSet = new Set<Date>();

        for(Bank_Holiday__c currentBh : currentBhList){
            bankHolidayDateSet.add(currentBh.Date__c);
        }

        for(Events event : bhwc.england_and_wales.events){
            Date newDate = Date.valueOf(event.date_z);

            if(!bankHolidayDateSet.contains(newDate)){
                Bank_Holiday__c bh = new Bank_Holiday__c();
                bh.Name = event.title;
                bh.Date__c = Date.valueOf(event.date_z);
                bh.Substitute__c = event.notes.contains('Substitute day') ? true : false; 
                bhList.add(bh);
            }
        }

        if(!bhList.isEmpty()){
            insert bhList;
        }
    }

    public class BankHolidayWrapperClass {
        public England_and_wales england_and_wales;
    }

    public class England_and_wales {
        public String division;
        public List<Events> events;
    }
        
    public class Events {
            public String title {get;set;} 
            public String date_Z {get;set;} // in json: date
            public String notes {get;set;} 
            public Boolean bunting {get;set;} 
    }
}