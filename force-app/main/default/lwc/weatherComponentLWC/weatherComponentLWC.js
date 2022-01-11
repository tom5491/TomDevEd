import { LightningElement, wire } from 'lwc';
import weatherCredentials from '@salesforce/apex/GetIntegrationCredentials.getCredentials';
import FetchWrapper from 'c/utilities';

export default class WeatherComponentLWC extends LightningElement {
    integrationObject;
    fetchWrapper;
    endpoint = "weather";
    city = "London";

    @wire(weatherCredentials, {"integrationName": "Open Weather"})
    wiredIntegration({ error, data }) {
        if (data) {
            console.log('data:', data);
            this.integrationObject = data;
            this.instantiateFetchWrapper();
        } else if (error) {
            console.log('Something went wrong:', error);
        }
    }

    instantiateFetchWrapper(){
        this.fetchWrapper = new FetchWrapper({ baseURL:this.integrationObject.Base_Url__c})
        .setUrlParameters({
            "q": "London,uk", 
            "appId": this.integrationObject.Authentication_Token__c,
            "units": "metric"
        });
        this.handleFetch();
    }

    handleFetch(){
        this.fetchWrapper.get(this.endpoint, {})
        .then(data => {
            console.log("Weather Data: " + JSON.stringify(data));
        })
        .catch(err => {
            console.log("Error: " + err);
        });
    }

}