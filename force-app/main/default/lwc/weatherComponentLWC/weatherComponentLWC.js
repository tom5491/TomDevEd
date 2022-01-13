import { LightningElement, track, wire } from 'lwc';
import weatherCredentials from '@salesforce/apex/GetIntegrationCredentials.getCredentials';
import {FetchWrapper} from 'c/utilities';
import weatherIcons from '@salesforce/resourceUrl/WeatherIcons';

export default class WeatherComponentLWC extends LightningElement {
    integrationObject;
    fetchWrapper;
    endpoint = "weather";
    city = "Birmingham,uk";
    weatherIconMap = {};
    weatherData;
    weatherIconsVar = weatherIcons;
    weatherIcon = weatherIcons + '/WeatherIcons/005-sun.png';

    // constructor(){
    //     this.weatherIconMap = {
    //         "Thunderstorm":
    //         "Drizzle":
    //         "Rain": 
    //         "Snow":
    //         "Atmosphere":
    //         "Clear":
    //         "Clouds":
    //     };
    // }

    @wire(weatherCredentials, {"integrationName": "Open Weather"})
    wiredIntegration({ error, data }) {
        if (data) {
            console.log('data:', data);
            this.integrationObject = data;
            this.instantiateWeatherFetchWrapper();
        } else if (error) {
            console.log('Something went wrong:', error);
        }
    }

    instantiateWeatherFetchWrapper(){
        this.fetchWrapper = new FetchWrapper({ baseURL:this.integrationObject.Base_Url__c})
        .setUrlParameters({
            "q": this.city, 
            "appId": this.integrationObject.Authentication_Token__c,
            "units": "metric"
        });
        this.handleFetch();
    }

    instantiateOneCallFetchWrapper(lon, lat){
        this.fetchWrapper = new FetchWrapper({ baseURL:this.integrationObject.Base_Url__c})
        .setUrlParameters({
            "lon": lon, 
            "lat": lat, 
            "appId": this.integrationObject.Authentication_Token__c,
            "exclude": "minutely"
        });
        this.endpoint = "onecall";
        this.handleFetch();
    }

    handleFetch(){
        this.fetchWrapper.get(this.endpoint, {})
        .then(data => {
            console.log("Weather Data: " + JSON.stringify(data));
            if(this.endpoint === "weather"){
                data.weather = data.weather[0];
                data.dt = String(data.dt).padEnd(13,"0");
                this.weatherData = data;
                this.instantiateOneCallFetchWrapper(data.coord.lon, data.coord.lat);
            }
        })
        .catch(err => {
            console.log("Error: " + err);
        });
    }

}