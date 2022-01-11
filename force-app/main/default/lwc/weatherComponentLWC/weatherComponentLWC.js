import { LightningElement, wire } from 'lwc';
import weatherCredentials from '@salesforce/apex/GetIntegrationCredentials.getCredentials';

export default class WeatherComponentLWC extends LightningElement {
    integrationObject;

    @wire(weatherCredentials, {"integrationName": "Open Weather"})
    wiredIntegration({ error, data }) {
        if (data) {
            console.log('data:', data);
            this.integrationObject = data;
            this.onTodayDate();
            this.endpoint = "planetary/apod";
        } else if (error) {
            console.log('Something went wrong:', error);
        }
    }
}