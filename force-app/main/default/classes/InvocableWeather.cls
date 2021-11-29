/**
 * @description       : 
 * @author            : Tom Philippou
 * @last modified on  : 27-06-2021
 * @last modified by  : Tom Philippou
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   27-06-2021   Tom Philippou   Initial Version
**/
public class InvocableWeather {
    @InvocableMethod
    public static void updateToday() {
        WeatherTodayCallout.methodName();
    }
}