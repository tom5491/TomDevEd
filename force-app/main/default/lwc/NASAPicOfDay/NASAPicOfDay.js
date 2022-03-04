import { LightningElement, wire } from "lwc";
import getNasaApiKey from "@salesforce/apex/NASAPicOfDayController.getNasaApiKey";
import { FetchWrapper } from "c/utilities";

export default class nasaPicOfDay extends LightningElement {
  endpoint = "planetary/apod";
  urlParameters = {};

  nasaApiKey;
  fetchUrl;
  nasaPicObj;
  isImage;
  isToday;
  showCopyright;
  currentDate;
  nasaFetchWrapper;

  @wire(getNasaApiKey)
  wiredIntegration({ error, data }) {
    if (data) {
      this.nasaApiKey = data;
      this.onTodayDate();
      this.endpoint = "planetary/apod";
    } else if (error) {
      console.log("Something went wrong:", error);
    }
  }

  onTodayDate() {
    this.urlParameters = {
      api_key: this.nasaApiKey.Authentication_Token__c
    };

    this.handleFetch();
  }

  onDateChange(event) {
    const buttonName = event.target.name;
    const nasaApiKey = this.nasaApiKey;
    // console.log("buttonName: " + buttonName);
    if (buttonName === "backDate") {
      this.currentDate = this.currentDate.setDate(this.currentDate.getDate() - 1);
    } else {
      this.currentDate = this.currentDate.setDate(this.currentDate.getDate() + 1);
    }
    this.urlParameters = {
      api_key: nasaApiKey.Authentication_Token__c,
      date: new Date(this.currentDate).toISOString().substring(0, 10)
    };
    this.handleFetch();
  }

  onRandomPic() {
    const nasaApiKey = this.nasaApiKey;
    this.urlParameters = {
      api_key: nasaApiKey.Authentication_Token__c,
      count: 1
    };

    this.handleFetch();
  }

  isTodayCheck() {
    // console.log("todays date: " + new Date());
    // console.log("current date: " + new Date(this.currentDate));
    if (new Date().toISOString().substring(0, 10) == new Date(this.currentDate).toISOString().substring(0, 10)) {
      this.isToday = true;
    } else {
      this.isToday = false;
    }
  }

  handleFetch() {
    const nasaFetchWrapper = new FetchWrapper({ baseURL: this.nasaApiKey.Base_Url__c }).setUrlParameters(
      this.urlParameters
    );
    // console.log("handleFetch endpoint: " + this.endpoint);
    nasaFetchWrapper.get(this.endpoint, {}).then((data) => {
      // console.log(data);
      if (Array.isArray(data)) {
        data = data[0];
      }
      this.currentDate = new Date(data.date);
      this.isTodayCheck();
      this.showCopyright = data.copyright !== undefined && data.copyright !== null;
      if (data.media_type === "image") {
        this.isImage = true;
      } else {
        this.isImage = false;
      }
      this.nasaPicObj = data;
    });
  }
}
