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
        
        BankHolidayWrapperClass bhwc = new BankHolidayWrapperClass();
            
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