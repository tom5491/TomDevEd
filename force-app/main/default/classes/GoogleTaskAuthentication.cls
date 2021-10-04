public class GoogleTaskAuthentication {
	private String client_id;
    private String client_secret;
    private String refresh_token;
    
    public void getAccessToken(){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://www.googleapis.com/oauth2/v4/token?client_id='+client_id+'&client_secret='+client_secret+'&grant_type=refresh_token&refresh_token='+refresh_token);
    }
    
    public void getAuthDetails(){
        if(client_id == null || client_secret == null || refresh_token == null){
            
        }    
    }
}