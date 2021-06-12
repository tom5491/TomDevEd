public class AnimalResponseClass {

    public class JSONResponse { 
        //create JSON structure class
        public Animal animal;
    }
    
        //Define values as is with data types
    public class animal{
        public String name, food, product;        
      	    //Ensure name of the variables matches the JSON keys
    }

  	public static String methodName() {

          //Make the Request and save it

          String requestURL = 'https://admin2dev.com/rest/response2.json';
          String requestType = 'GET'; //GET POST PATCH PUT DELETE

          Http http = new Http();
          HttpRequest request = new HttpRequest();
          request.setEndpoint(requestURL);
          request.setMethod(requestType);
          HttpResponse response = http.send(request);

          // Deserialize based on result type class
          JSONResponse result = (JSONResponse) JSON.deserialize(response.getBody(), JSONResponse.class);
          return result.animal.name; //Replace JSONObject with value from JSONResponse and Key_Name with the key you're accessing in the said JSON

    }
}