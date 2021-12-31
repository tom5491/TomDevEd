import { LightningElement } from 'lwc';
import getNasaApiKey from '@salesforce/apex/NasaApiCall.';

export default class NASAPicOfDay extends LightningElement {
    nasaPicObj = {};

    fetch();
}