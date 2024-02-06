use std::collections::HashMap;
use std::time::Duration;
use once_cell::sync::Lazy;
use reqwest;
use reqwest::header::{HeaderMap, HeaderValue};
use reqwest::RequestBuilder;

static HTTP_CLIENT: Lazy<reqwest::Client> = Lazy::new(|| {
    let mut header_map = HeaderMap::new();
    header_map.insert("User-Agent", HeaderValue::from_static("SCToolBox/2.10.x lib_rust_http"));
    reqwest::Client::builder()
        .use_rustls_tls()
        .connect_timeout(Duration::from_secs(10))
        .timeout(Duration::from_secs(10))
        .default_headers(header_map).build().unwrap()
});


#[tokio::main]
pub async fn get_string(url: String, headers: Option<HashMap<String, String>>) -> String {
    let mut req = _append_header(HTTP_CLIENT.get(url), headers);
    req.send().await.unwrap().text().await.unwrap()
}

pub async fn post_json_string(url: String, headers: Option<HashMap<String, String>>, json_data: Option<String>) -> String {
    let mut req = _append_header(HTTP_CLIENT.post(url), headers);
    if json_data.is_some() {
        req = req.body(json_data.unwrap()).header(reqwest::header::CONTENT_TYPE, "application/json");
    }
    req.send().await.unwrap().text().await.unwrap()
}

fn _append_header(mut req: RequestBuilder, headers: Option<HashMap<String, String>>) -> RequestBuilder {
    if headers.is_some() {
        for x in headers.unwrap() {
            req = req.header(x.0, x.1);
        }
    }
    req
}