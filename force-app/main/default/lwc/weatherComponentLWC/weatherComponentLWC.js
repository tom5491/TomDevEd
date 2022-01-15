import { LightningElement, wire } from "lwc";
import weatherCredentials from "@salesforce/apex/GetIntegrationCredentials.getCredentials";
import { FetchWrapper } from "c/utilities";
import weatherIcons from "@salesforce/resourceUrl/WeatherIcons";
import { loadScript } from "lightning/platformResourceLoader";
import chartminjs from "@salesforce/resourceUrl/chartminjs";
import chartJsAdapterDate from "@salesforce/resourceUrl/chartJsAdapterDate";

export default class WeatherComponentLWC extends LightningElement {
  chartJsInitialised = false;
  dataInitialised = false;
  integrationObject;
  fetchWrapper;
  endpoint = "weather";
  city = "London,uk";
  selectedWeatherIconMap = {};
  weatherData;
  weatherIconPath = weatherIcons + "/WeatherIcons/";
  hourlyData = [];
  dailyData;
  chart;

  weatherIconMap = {
    Thunderstorm: "038-storm-3.png",
    Drizzle: "008-rainy.png",
    Rain: "028-rainy-1.png",
    Snow: "019-snowy.png",
    Clear: "005-sun.png",
    Clouds: "007-cloud.png",
    Atmosphere: "036-foog.png"
  };

  @wire(weatherCredentials, { integrationName: "Open Weather" })
  wiredIntegration({ error, data }) {
    if (data) {
      console.log("data:", data);
      this.integrationObject = data;
      this.instantiateWeatherFetchWrapper();
    } else if (error) {
      console.log("Something went wrong:", error);
    }
  }

  getWeatherIcon(condition) {
    if (!(condition in this.weatherIconMap)) {
      return this.weatherIconMap.Atmosphere;
    }
    return this.weatherIconMap[condition];
  }

  instantiateWeatherFetchWrapper() {
    this.fetchWrapper = new FetchWrapper({ baseURL: this.integrationObject.Base_Url__c }).setUrlParameters({
      q: this.city,
      appId: this.integrationObject.Authentication_Token__c,
      units: "metric"
    });
    this.handleFetch();
  }

  instantiateOneCallFetchWrapper(lon, lat) {
    this.fetchWrapper = new FetchWrapper({ baseURL: this.integrationObject.Base_Url__c }).setUrlParameters({
      lon: lon,
      lat: lat,
      appId: this.integrationObject.Authentication_Token__c,
      exclude: "minutely",
      units: "metric"
    });
    this.endpoint = "onecall";
    this.handleFetch();
  }

  handleFetch() {
    this.fetchWrapper
      .get(this.endpoint, {})
      .then((data) => {
        if (this.endpoint === "weather") {
          console.log("### weather fetch 1");
          data.weather = data.weather[0];
          data.weather.icon = this.weatherIconPath + this.getWeatherIcon(data.weather.main);
          data.dt = String(data.dt).padEnd(13, "0");
          this.weatherData = data;
          // console.log("Weather Data: " + JSON.stringify(data));
          this.instantiateOneCallFetchWrapper(data.coord.lon, data.coord.lat);
        } else {
          console.log("### weather fetch 2 start");
          data.daily.splice(0, 1);
          data.daily.splice(5);
          data.daily.forEach((day) => {
            day.weather = day.weather[0];
            day.weather.icon = this.weatherIconPath + this.getWeatherIcon(day.weather.main);
            day.dt = String(day.dt).padEnd(13, "0");
            day.sunrise = String(day.sunrise).padEnd(13, "0");
            day.sunset = String(day.sunset).padEnd(13, "0");
            day.moonrise = String(day.moonrise).padEnd(13, "0");
            day.moonset = String(day.moonset).padEnd(13, "0");
          });
          data.hourly = data.hourly.filter(
            (hr) => new Date(Number.parseInt(String(hr.dt).padEnd(13, "0"), 10)).getHours() % 3 === 0
          );
          data.hourly.forEach((hr) => {
            hr.weather = hr.weather[0];
            hr.weather.icon = this.weatherIconPath + this.getWeatherIcon(hr.weather.main);
            hr.dt = String(hr.dt).padEnd(13, "0");
            hr.sunrise = String(hr.sunrise).padEnd(13, "0");
            hr.sunset = String(hr.sunset).padEnd(13, "0");
            hr.moonrise = String(hr.moonrise).padEnd(13, "0");
            hr.moonset = String(hr.moonset).padEnd(13, "0");
            const hrObject = { y: Math.round(hr.temp), x: Number.parseInt(hr.dt, 10) };
            this.hourlyData.push(hrObject);
          });

          this.dailyData = data.daily;

          //   console.log("hourlyData : " + JSON.stringify(data.hourly));
          // console.log("hourlyData : " + JSON.stringify(this.hourlyData));

          console.log("### weather fetch 2 end");

          this.dataInitialised = true;
          this.renderChart();
        }
      })
      .catch((err) => {
        console.error("Error: " + err);
      });
  }

  renderedCallback() {
    if (this.chartJsInitialised) {
      return;
    }
    console.log("### renderedCallback");

    this.chartJsInitialised = true;

    Promise.all([loadScript(this, chartminjs), loadScript(this, chartJsAdapterDate)])
      .then(() => {
        this.finishedLoading = true;
        this.renderChart();
        console.log("### renderedCallback finished");
      })
      .catch((error) => {
        console.error({
          message: "Error occured on ChartJs",
          error
        });
      });
  }

  renderChart() {
    if (!this.dataInitialised || !this.finishedLoading) {
      return;
    }

    console.log("this.dataInitialised: " + this.dataInitialised);
    console.log("this.chartJsInitialised: " + this.chartJsInitialised);

    // const labels = ["January", "February", "March", "April", "May", "June"];
    //
    // const config = {
    //   type: "line",
    //   data: {
    //     labels: labels,
    //     datasets: [
    //       {
    //         label: "My First dataset",
    //         backgroundColor: "rgb(255, 99, 132)",
    //         borderColor: "rgb(255, 99, 132)",
    //         data: [0, 10, 5, 2, 20, 30, 45]
    //       }
    //     ]
    //   },
    //   options: {}
    // };

    const config = {
      type: "line",
      data: {
        datasets: [
          {
            fill: false,
            label: "Line Dataset 1",
            data: this.hourlyData,
            backgroundColor: ["#80aaff"],
            borderColor: ["blue"],
            pointBackgroundColor: "#80aaff",
            pointBorderColor: "blue"
          }
        ]
      },
      options: {
        tension: 0.4,
        // responsive: true,
        title: {
          display: true,
          text: "Sand Samples Against Comm Weight %."
        },
        scales: {
          xAxes: {
            type: "time"
            // time: {
            //   //   unit: "hour",
            //   //   displayFormats: {
            //   //     hour: "HH:mm"
            //   //   }
            // }
          },
          yAxes: {
            type: "linear",
            ticks: {
              //   beginAtZero: true,
              autoSkip: true,
              suggestedMin: 0,
              suggestedMax: 100,
              stepSize: 1
            }
          }
        }
      }
    };

    console.log("this.template: " + this.template);
    const ctx = this.template.querySelector("canvas.linechart").getContext("2d");
    this.chart = new window.Chart(ctx, config);
    this.chart.canvas.parentNode.style.height = "100%";
    this.chart.canvas.parentNode.style.width = "100%";
  }
}
