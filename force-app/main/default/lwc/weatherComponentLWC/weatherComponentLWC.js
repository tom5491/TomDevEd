import { LightningElement, track, wire } from 'lwc';
import weatherCredentials from '@salesforce/apex/GetIntegrationCredentials.getCredentials';
import {FetchWrapper} from 'c/utilities';
import weatherIcons from '@salesforce/resourceUrl/WeatherIcons';

export default class WeatherComponentLWC extends LightningElement {
    integrationObject;
    fetchWrapper;
    endpoint = "weather";
    city = "London,uk";
    selectedWeatherIconMap = {};
    weatherData;
    weatherIconPath = weatherIcons + '/WeatherIcons/';
    dailyData;
    weatherIconMap = {
                "Thunderstorm": "038-storm-3.png",
                "Drizzle": "008-rainy",
                "Rain": "028-rainy-1",
                "Snow": "019-snowy.png",
                "Clear": "005-sun.png",
                "Clouds": "007-cloud.png",
                "Atmosphere": "036-foog.png"
            };

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

    getWeatherIcon(condition){
        if(!condition in this.weatherIconMap){
            return this.weatherIconMap.Atmosphere;
        } else {
            return this.weatherIconMap[condition];
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
            "exclude": "minutely",
            "units": "metric"
        });
        this.endpoint = "onecall";
        this.handleFetch();
    }

    handleFetch(){
        this.fetchWrapper.get(this.endpoint, {})
        .then(data => {
            if(this.endpoint === "weather"){
                data.weather = data.weather[0];
                data.weather.icon = this.weatherIconPath + this.getWeatherIcon(data.weather.main);
                data.dt = String(data.dt).padEnd(13,"0");
                this.weatherData = data;
                console.log("Weather Data: " + JSON.stringify(data));
                this.instantiateOneCallFetchWrapper(data.coord.lon, data.coord.lat);
            } else {
                data.daily.splice(0,1);
                data.daily.splice(5);
                data.daily.forEach(day => {
                    day.weather = day.weather[0];
                    day.weather.icon = this.weatherIconPath + this.getWeatherIcon(day.weather.main);
                    day.dt = String(day.dt).padEnd(13,"0");
                    day.sunrise = String(day.sunrise).padEnd(13,"0");
                    day.sunset = String(day.sunset).padEnd(13,"0");
                    day.moonrise = String(day.moonrise).padEnd(13,"0");
                    day.moonset = String(day.moonset).padEnd(13,"0");
                });
                data.hourly = data.hourly.filter(hr => new Date(Number.parseInt(String(hr.dt).padEnd(13,"0"), 10)).getHours() % 3 == 0);
                data.hourly.forEach(hr => {
                    hr.weather = hr.weather[0];
                    hr.weather.icon = this.weatherIconPath + this.getWeatherIcon(hr.weather.main);
                    hr.dt = String(hr.dt).padEnd(13,"0");
                    hr.sunrise = String(hr.sunrise).padEnd(13,"0");
                    hr.sunset = String(hr.sunset).padEnd(13,"0");
                    hr.moonrise = String(hr.moonrise).padEnd(13,"0");
                    hr.moonset = String(hr.moonset).padEnd(13,"0");
                });
                
                this.dailyData = data.daily;

                console.log("dailyData : " + JSON.stringify(data.daily));
            }
        })
        .catch(err => {
            console.error("Error: " + err);
        });
    }

}