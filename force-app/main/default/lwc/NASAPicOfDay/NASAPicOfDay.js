import { LightningElement, wire } from 'lwc';
import getNasaApiKey from '@salesforce/apex/NASAPicOfDayController.getNasaApiKey';

export default class NASAPicOfDay extends LightningElement {
    nasaApiKey;
    fetchUrl;
    nasaPicObj;
    isImage;
    isToday;
    currentDate;
    
    @wire(getNasaApiKey)
    wiredIntegration({ error, data }) {
        if (data) {
            this.nasaApiKey = data;
            this.onTodayDate();
        } else if (error) {
            console.log('Something went wrong:', error);
        }
    }

    onTodayDate(){
        const nasaApiKey = this.nasaApiKey;
        this.fetchUrl = nasaApiKey.Base_Url__c + 'planetary/apod?api_key=' + nasaApiKey.Authentication_Token__c;
        console.log("fetchUrl: " + this.fetchUrl);
        this.handleFetch();
    }

    onDateChange(event){
        const buttonName = event.target.name;
        const nasaApiKey = this.nasaApiKey;
        console.log("buttonName: " + buttonName);
        if(buttonName === 'backDate'){
            this.currentDate = this.currentDate.setDate(this.currentDate.getDate() - 1);
        } else {
            this.currentDate = this.currentDate.setDate(this.currentDate.getDate() + 1);
        }
        this.fetchUrl = nasaApiKey.Base_Url__c + 'planetary/apod?api_key=' + nasaApiKey.Authentication_Token__c + '&date=' + new Date(this.currentDate).toISOString().substring(0, 10);
        this.handleFetch();
    }

    onRandomPic(){
        const nasaApiKey = this.nasaApiKey;
        this.fetchUrl = nasaApiKey.Base_Url__c + 'planetary/apod?api_key=' + nasaApiKey.Authentication_Token__c + '&count=1';

        this.handleFetch();
    }

    isTodayCheck(){
        console.log("todays date: " + new Date());
        console.log("current date: " + new Date(this.currentDate));
        if(new Date().toISOString().substring(0,10) == new Date(this.currentDate).toISOString().substring(0,10)){
            this.isToday = true; 
        } else {
            this.isToday = false;
        }
    }

    handleFetch(){
        fetch(this.fetchUrl)
        .then(response => response.json())
        .then(data => {
            console.log(data);
            if(Array.isArray(data)){
                data = data[0];
            }
            let newDate = data.date;
            this.currentDate = new Date(newDate);
            this.isTodayCheck();
            if(data.media_type === 'image'){
                this.isImage = true;
            } else {
                this.isImage = false;
            }
            this.nasaPicObj = data;
        });
    }

    
}