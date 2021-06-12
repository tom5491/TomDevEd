/**
 * @description       : 
 * @author            : Tom Philippou
 * @last modified on  : 08-06-2021
 * @last modified by  : Tom Philippou
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   08-06-2021   Tom Philippou   Initial Version
**/
public class FitBitComponentController {
  @AuraEnabled
  public static string getUserDetails() {
    return getResponseBody('callout:Fitbit/1/user/-/profile.json');
  }

  @AuraEnabled
  public static string getTodaySummarry() {
    return getResponseBody(
      'callout:Fitbit/1/user/-/activities/date/today.json'
    );
  }

  @AuraEnabled
  public static string getFriendsList() {
    return getResponseBody('callout:Fitbit/1/user/-/friends/leaderboard.json');
  }

  @AuraEnabled
  public static string getMybadges() {
    return getResponseBody('callout:Fitbit/1/user/-/badges.json');
  }

  private static String getResponseBody(String endpoint) {
    HttpRequest req = new HttpRequest();
    Http http = new Http();
    req.setMethod('GET');
    req.setEndpoint(endpoint);
    HttpResponse res = http.send(req);
    return res.getBody();
  }
}