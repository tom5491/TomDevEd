public class AnimalLocator{
    public static String getAnimalNameById(Integer x){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/' + x);
        req.setMethod('GET');
        
        HttpResponse res = http.send(req);
        
        String animalName;
        if (res.getStatusCode() == 200) {
            // Deserializes the JSON string into collections of primitive data types.
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            // Cast the values in the 'animal' key as a map            
            Map<String, Object> animal = (Map<String, Object>) results.get('animal');
            animalName = animal.get('name').toString();            
            System.debug('Received the following animal:' + animalName);                       
        }
        return animalName;
    }
}