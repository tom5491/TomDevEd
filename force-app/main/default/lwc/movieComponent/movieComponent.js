import { LightningElement } from "lwc";

const QUERY_URL = "https://www.omdbapi.com/?t=";
const QUERY_URL_2 = "&apikey=4451f8f5"; //The client key for the API.
export default class App extends LightningElement {
    showval;
    backupimg;
    datafound;
    nodata;
    urltocall;

    //Making Callout using fetch. Learn more about fetch using the link provided in post
    getvalues() {
        fetch(this.urltocall)
            .then((response) => {
                if (!response.ok) {
                    this.error = response;
                }
                return response.json();
            })
            .then((jsonResponse) => {
                this.datafound = true;
                this.nodata = false;
                this.showval = jsonResponse;
                this.backupimg = false;

                if (JSON.stringify(this.showval).includes("Error")) {
                    this.datafound = false;
                    this.nodata = true;
                }
                if (this.showval.Poster.includes("N/A")) {
                    this.backupimg = true;
                }
                /*In order to show Progress Rings which accept number values (1-100),
                I am converting the JSON response for Ratings into usable format for rings.
                Check the JSON response Sample for more clarity*/
                for (var i = 0; i < this.showval.Ratings.length; i++) {
                    if (this.showval.Ratings[i].Source.includes("Internet")) {
                        let imdb = this.showval.Ratings[i].Value.split("/");
                        this.showval.Ratings[i].newValue = imdb[0] * 10;
                    }
                    if (this.showval.Ratings[i].Source.includes("Metacritic")) {
                        let imdb = this.showval.Ratings[i].Value.split("/");
                        this.showval.Ratings[i].newValue = imdb[0];
                    }
                    if (this.showval.Ratings[i].Source.includes("Rotten")) {
                        let imdb = this.showval.Ratings[i].Value.split("%");
                        this.showval.Ratings[i].newValue = imdb[0];
                    }
                }
            })
            .catch((error) => {
                this.error = error;
            });
    }
    //Fetching the user input and creating the HTTP callout URL as required by the API endpoint
    moviename(event) {
        let movieStr = event.target.value;
        let finalurl = QUERY_URL + movieStr + QUERY_URL_2;
        this.urltocall = finalurl;
    }
}
