export default class FetchWrapper {
    // ### OLD VERSION ###
    // constructor(baseURL) {
    //     this.baseURL = baseURL;
    // }

    // get(endpoint) {
    //     return fetch(this.baseURL + endpoint)
    //         .then(response => response.json());
    // }

    // put(endpoint, body) {
    //     return this._send("put", endpoint, body);
    // }

    // post(endpoint, body) {
    //     return this._send("post", endpoint, body);
    // }

    // delete(endpoint, body) {
    //     return this._send("delete", endpoint, body);
    // }

    // _send(method, endpoint, body) {
    //     return fetch(this.baseURL + endpoint, {
    //         method,
    //         headers: {
    //             "Content-Type": "application/json"
    //         },
    //         body: JSON.stringify(body)
    //     }).then(response => response.json());
    // }

  constructor(options = {}) {
    this._baseURL = options.baseURL || "";
    this._headers = options.headers || {};
    this._urlParameters = "";
  }

  async _fetchJSON(endpoint, options = {}) {
    console.log("fullUrl: " + this._baseURL + endpoint + this._urlParameters)
    const res = await fetch(this._baseURL + endpoint + this._urlParameters, {
      ...options,
      headers: this._headers
    });

    if (!res.ok) throw new Error(res.statusText);

    if (options.parseResponse !== false && res.status !== 204)
      return res.json();

    return undefined;
  }

  setHeader(key, value) {
    this._headers[key] = value;
    return this;
  }

  getHeader(key) {
    return this._headers[key];
  }

  setUrlParameters(urlParameters) {
    if (urlParameters !== undefined) {
      this._urlParameters = "?";
      let count = 0;
      Object.keys(urlParameters).forEach((key) => {
        this._urlParameters += count !== 0 ? "&" : "";
        this._urlParameters += `${key}=${urlParameters[key]}`;
        count++;
      });
      return this;
    }
    return this;
  }

  setBasicAuth(username, password) {
    this._headers.Authorization = `Basic ${btoa(`${username}:${password}`)}`;
    console.log("Authentication info: " + this._headers.Authorization);
    return this;
  }

  setBearerAuth(token) {
    this._headers.Authorization = `Bearer ${token}`;
    return this;
  }

  get(endpoint, options = {}) {
    return this._fetchJSON(endpoint, {
      ...options,
      method: "GET"
    });
  }

  post(endpoint, body, options = {}) {
    return this._fetchJSON(endpoint, {
      ...options,
      body: body ? JSON.stringify(body) : undefined,
      method: "POST"
    });
  }

  put(endpoint, body, options = {}) {
    return this._fetchJSON(endpoint, {
      ...options,
      body: body ? JSON.stringify(body) : undefined,
      method: "PUT"
    });
  }

  patch(endpoint, operations, options = {}) {
    return this._fetchJSON(endpoint, {
      parseResponse: false,
      ...options,
      body: JSON.stringify(operations),
      method: "PATCH"
    });
  }

  delete(endpoint, options = {}) {
    return this._fetchJSON(endpoint, {
      parseResponse: false,
      ...options,
      method: "DELETE"
    });
  }
}
