global class FitBitOauth extends Auth.AuthProviderPluginClass {
    
    // Name for this auth provider.
    private String authProvider = 'FitBitAuth2'; 
    
    // Api name for the custom metadata type created for this auth provider.
    private String customMetadataTypeApiName = 'FitBit_Integration_Setting__mdt'; 
    
    private String clientId;
    private String clientSecret;
    private String accessTokenUrl;
    private String authorizationUrl;
    private String scope;
    private String userInfoUrl;
    private String redirectUri;
    private String expiryTime;
    
    // This method is responsible for returning the custom metadata storing the api credentials and other details
    global String getCustomMetadataType() {
        return customMetadataTypeApiName;
    }
    
    // This method is responsible to initiate the authorization code flow
    global PageReference initiate(Map<String, String> authProviderConfiguration, String stateToPropagate) {
        clientId = authProviderConfiguration.get('Client_Id__c');
        authorizationUrl = authProviderConfiguration.get('Authorization_Url__c');
        clientSecret = authProviderConfiguration.get('Client_Secret__c');
        scope = authProviderConfiguration.get('Scope__c');
        scope = scope.replaceAll(' ', '%20');
        redirectUri = authProviderConfiguration.get('Redirect_URI__c');
        redirectUri = EncodingUtil.urlEncode(redirectUri, 'UTF-8');
        expiryTime = authProviderConfiguration.get('Expiry_Time__c');
        String url = authorizationUrl + '?response_type=token&client_id='+clientId+'&redirect_uri='+redirectUri+'&scope='+scope+'&expires_in='+expiryTime;
        System.debug('url: ' + url);
        return new PageReference(url);
    }
    
    /**
    * This method is responsible to handle the callback from authorization code flow
    * set the access token, refresh token and other parameters
    * 
    *    
    */
    global Auth.AuthProviderTokenResponse handleCallback(Map<String, String> authProviderConfiguration, Auth.AuthProviderCallbackState state) {
        
        clientId = authProviderConfiguration.get('Client_Id__c');
        clientSecret = authProviderConfiguration.get('Client_Secret__c');
        scope = authProviderConfiguration.get('Scope__c');
        redirectUri = authProviderConfiguration.get('Redirect_URI__c');
        accessTokenUrl = authProviderConfiguration.get('Access_Token_URL__c');
        
        Map<String,String> queryParams = state.queryParameters;
        String code = queryParams.get('code');
        String sfdcState = queryParams.get('state');
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(accessTokenURL);
        req.setHeader('Accept','application/json');
        req.setMethod('POST');
        req.setBody('client_id='+clientId+'&client_secret='+clientSecret+'&code='+code+'&redirect_uri='+redirectUri+'&state='+sfdcState);
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        String responseBody = res.getBody();
        System.debug('handleCallback responseBody: ' + responseBody);
        
        FitBitResponse response = (FitBitResponse) JSON.deserialize(responseBody, FitBitResponse.class);
        
        return new Auth.AuthProviderTokenResponse('GithubAuth', response.access_token, null, sfdcState);
    }
    
    // This method is responsible to get the user information used for authentication from the external api
    global Auth.UserData getUserInfo(Map<String, String> authProviderConfiguration, Auth.AuthProviderTokenResponse response) {
        
        userInfoUrl = authProviderConfiguration.get('User_Info_URL__c');
        String token = response.oauthToken;
        
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer ' + token);
        req.setEndpoint(userInfoUrl);
        req.setMethod('GET');
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        String responseBody = res.getBody();
        System.debug('response: ' + responseBody);
        
        FitBitUserInfoResponse infoApiResponse = (FitBitUserInfoResponse) JSON.deserialize(responseBody, FitBitUserInfoResponse.class);
        
        String[] names = infoApiResponse.name.split(' ');
        
        String userId, fullName, firstName, lastName, locale, loginURL;
        
        locale = 'en-au';
        loginURL = authProviderConfiguration.get('Login_URL__c');
        
        userId = infoApiResponse.login;
        fullName = infoApiResponse.name;
        if(names.size()>=2) {
            firstName = names[0];
            lastName = names[1];
        }
        
        return new Auth.UserData(
            userId,
            firstName,
            lastName,
            fullName,
            null,
            null, 
            userId,
            locale,
            'FitBit',
            loginURL,
            null
        );
    }
    
    
    public class FitBitResponse {
        public String access_token;
    }
    
    // Wrapper class to handle User Info API response
    public class FitBitUserInfoResponse {
        public String login;
        public String name;
    }
}