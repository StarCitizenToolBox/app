use once_cell::sync::Lazy;
use reqwest::header::{HeaderMap, HeaderName, HeaderValue};
use reqwest::{Method, RequestBuilder};
use std::collections::HashMap;
use std::str::FromStr;
use std::sync::RwLock;


#[derive(Debug)]
pub struct RustHttpResponse {
    pub status_code: u16,
    pub headers: HashMap<String, String>,
    pub url: String,
    pub content_length: Option<u64>,
    pub data: Option<Vec<u8>>,
}

static DEFAULT_HEADER: Lazy<RwLock<HeaderMap>> = Lazy::new(|| RwLock::from(HeaderMap::new()));

static HTTP_CLIENT: Lazy<reqwest::Client> = Lazy::new(|| new_http_client());

fn new_http_client() -> reqwest::Client {
    let c = reqwest::Client::builder();
    c.build().unwrap()
}

pub fn set_default_header(headers: HashMap<String, String>) {
    let mut dh = DEFAULT_HEADER.write().unwrap();
    dh.clear();
    for ele in headers {
        dh.append(
            HeaderName::from_str(ele.0.as_str()).unwrap(),
            HeaderValue::from_str(ele.1.as_str()).unwrap(),
        );
    }
}

pub async fn fetch(
    method: Method,
    url: String,
    headers: Option<HashMap<String, String>>,
    input_data: Option<Vec<u8>>,
) -> anyhow::Result<RustHttpResponse> {
    let url_clone = url.clone();

    let mut req = _mix_header(HTTP_CLIENT.request(method, url_clone), headers);
    if input_data.is_some() {
        req = req.body(input_data.unwrap());
    }
    let resp = req.send().await?;
    let url = resp.url().to_string();
    let status_code = resp.status().as_u16();
    let resp_headers = _reade_resp_header(resp.headers());
    let content_length = resp.content_length();
    
    let mut data: Option<Vec<u8>> = None;

    let bytes = resp.bytes().await;
    if bytes.is_ok() {
        data = Some(bytes?.to_vec());
    }
    let resp = RustHttpResponse {
        status_code,
        headers: resp_headers,
        url,
        content_length,
        data,
    };
    Ok(resp)
}

fn _reade_resp_header(r_header: &HeaderMap) -> HashMap<String, String> {
    let mut resp_headers = HashMap::new();
    for ele in r_header {
        resp_headers.insert(
            ele.0.as_str().to_string(),
            ele.1.to_str().unwrap_or("").to_string(),
        );
    }
    resp_headers
}

fn _mix_header(
    mut req: RequestBuilder,
    headers: Option<HashMap<String, String>>,
) -> RequestBuilder {
    if headers.is_some() {
        for x in headers.unwrap() {
            req = req.header(x.0, x.1);
        }
    }
    let dh = DEFAULT_HEADER.read().unwrap();
    req = req.headers(dh.clone());
    req
}
