public class GoogleTask {
    public static void getTasks(){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Google_Task/tasks/v1/lists/MTQ3MjAzMTE1NDE2MjU4ODg5NjQ6MDow/tasks');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Content-Length', '0');
        req.setMethod('GET');
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        String body = res.getBody();
        System.debug('Body: ' + res.getBody());
        
        GoogleWrapperClass gwc = GoogleWrapperClass.parse(body);
        Map<String, Items> itemsMap = new Map<String, Items>();
        for(Items item : gwc.items){
            itemsMap.put(item.id, item);
        }
        
        List<Task> taskList = new List<Task>();
        for(Task task :[SELECT Id, Google_Task_Id__c FROM Task WHERE Google_Task_Id__c IN :itemsMap.keyset()]){
            Items item = itemsMap.get(task.Google_Task_Id__c);
            task.ActivityDate = Date.valueOf(item.due.replace('T', ' '));
            task.Subject = item.title;
        }
        
    }
    
    public class GoogleWrapperClass {
        public String kind;
        public String etag;
        public List<Items> items;
    }

	public class Items {
		public String kind;
		public String id;
		public String etag;
		public String title;
		public String updated;
		public String selfLink;
		public String position;
		public String notes;
		public String status;
		public String due;
        public String parent;
	}
	
	public static GoogleWrapperClass parse(String json) {
		return (GoogleWrapperClass) System.JSON.deserialize(json, GoogleWrapperClass.class);
	}
    
}