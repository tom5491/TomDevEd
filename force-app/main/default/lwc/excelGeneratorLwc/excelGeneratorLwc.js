import { LightningElement } from 'lwc';

export default class ExcelGeneratorLwc extends LightningElement {
    retrieveData = (url) => {
        fetch(url)
        .then((response) => {
            if(response.ok){
                response.json()
            } else {
                throw new Error(`${response.status} ${response.statusText}`);
            }
        })
        .then((data) => {
            console.log(data);
        })
        .catch(err => {
            console.error(err);
        })
        .finally(
            console.log("Callout Finished.")
        )
    };

    // checkData = 
}