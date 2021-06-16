public class WeatherTodayCallout {
	
    public class JSONResponse { 
        //create JSON structure class
        public Main	main; 
        public Clouds clouds;
        public List<Weather> weather;
        public Wind wind;	
    }
	
    //Define values as is with data types
    //Ensure name of the variables matches the JSON keys
    
    public class Weather {
        String main, description, icon;
    	Integer id;
    }
    
    public class Main {
        Double temp, feels_like, temp_min, temp_max, humidity;
    }
    
    public class Clouds {
        Integer all;
    }
    
    public class Wind {
        Double speed;
        Integer deg;
    }
    
    @future(callout=true)
    public static void methodName() {

        //Make the Request and save it

		String requestURL = 'https://api.openweathermap.org/data/2.5/weather?q=London,uk&units=metric&appid=643a4a64d4f7dd4d68cfd20b3b47f66a';
		String requestType = 'GET'; //GET POST PATCH PUT DELETE

		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndpoint(requestURL);
		request.setMethod(requestType);
		HttpResponse response = http.send(request);

		// Deserialize based on result type class
		JSONResponse res = (JSONResponse) JSON.deserialize(response.getBody(), JSONResponse.class);
        System.debug(res.main.humidity);
        System.debug(res.main.temp_max);
        
                
        Date today = System.Today();
        datetime dTime = datetime.now();
        List<Planner__c> pList = [SELECT Id, Study_Date__c FROM Planner__c WHERE Study_Date__c = today];
        List<Planner__c> finalList = new List<Planner__c>();
        
        for(Planner__c p: pList) {
            p.Temperature_Feels_Like__c = res.main.feels_like;
            p.Maximum_Temperature__c = res.main.temp_max;
            p.Minimum_Temperature__c = res.main.temp_min;
            p.Humidity__c = res.main.humidity;
            p.Outlook__c = res.weather[0].main + ' - ' + res.weather[0].description;
            p.Wind_Speed__c = res.wind.speed;
            p.Wind_Angle__c = res.wind.deg;
            p.Cloud_Coverage__c = res.clouds.all;
            p.Last_Updated__c = dTime;
            finalList.add(p);
        }
        update finalList;
        
        DateTime nowMinus1 = System.now().addhours(-1);
        List<Weather_Entry__c> weList = [SELECT Id, Entry_Date_Time__c FROM Weather_Entry__c WHERE Entry_Date_Time__c > :nowMinus1];
        if(weList.size()==0){
            Weather_Entry__c we = new Weather_Entry__c();
            we.Name = String.valueof(dTime);
            we.Temperature_Feels_Like__c = res.main.feels_like;
            we.Maximum_Temperature__c = res.main.temp_max;
            we.Minimum_Temperature__c = res.main.temp_min;
            we.Humidity__c = res.main.humidity;
            we.Outlook__c = res.weather[0].main + ' - ' + res.weather[0].description;
            we.Wind_Speed__c = res.wind.speed;
            we.Wind_Angle__c = res.wind.deg;
            we.Cloud_Coverage__c = res.clouds.all;
            we.Entry_Date_Time__c = dTime;
            we.Planner__c = pList[0].Id;
            
            insert we;
        }
	}
}