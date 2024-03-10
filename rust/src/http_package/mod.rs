pub mod dns;

use reqwest::header::{HeaderMap, HeaderName, HeaderValue};
use reqwest::{Method, RequestBuilder};
use std::collections::HashMap;
use std::str::FromStr;
use std::sync::{Arc, RwLock};
use std::time::Duration;
use flutter_rust_bridge::for_generated::lazy_static;

#[allow(non_camel_case_types)]
pub enum MyHttpVersion { HTTP_09, HTTP_10, HTTP_11, HTTP_2, HTTP_3 }

pub struct RustHttpResponse {
    pub status_code: u16,
    pub headers: HashMap<String, String>,
    pub url: String,
    pub content_length: Option<u64>,
    pub version: MyHttpVersion,
    pub remote_addr: String,
    pub data: Option<Vec<u8>>,
}

fn _hyper_version_to_my_version(v: reqwest::Version) -> MyHttpVersion {
    match v {
        reqwest::Version::HTTP_09 => { MyHttpVersion::HTTP_09 }
        reqwest::Version::HTTP_10 => { MyHttpVersion::HTTP_10 }
        reqwest::Version::HTTP_11 => { MyHttpVersion::HTTP_11 }
        reqwest::Version::HTTP_2 => { MyHttpVersion::HTTP_2 }
        reqwest::Version::HTTP_3 => { MyHttpVersion::HTTP_3 }
        _ => { panic!("Unsupported HTTP version") }
    }
}

lazy_static! {
    static ref DEFAULT_HEADER: RwLock<HeaderMap> = RwLock::from(HeaderMap::new());
    static ref DNS_CLIENT : Arc<dns::MyHickoryDnsResolver> = Arc::from(dns::MyHickoryDnsResolver::default());
    static ref HTTP_CLIENT: reqwest::Client = {
        reqwest::Client::builder()
            .dns_resolver(DNS_CLIENT.clone())
            .use_rustls_tls()
            .connect_timeout(Duration::from_secs(10))
            .gzip(true)
            .no_proxy()
            .build()
            .unwrap()
    };
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
    let mut req = _mix_header(HTTP_CLIENT.request(method, url), headers);
    if input_data.is_some() {
        req = req.body(input_data.unwrap());
    }
    let resp = req.send().await?;

    let url = resp.url().to_string();
    let status_code = resp.status().as_u16();
    let resp_headers = _reade_resp_header(resp.headers());
    let content_length = resp.content_length();
    let version = resp.version();
    let mut remote_addr = "".to_string();
    if resp.remote_addr().is_some() {
        remote_addr = resp.remote_addr().unwrap().to_string();
    }
    let mut data: Option<Vec<u8>> = None;

    let bytes = resp.bytes().await;
    if bytes.is_ok() {
        data = Some(bytes.unwrap().to_vec());
    }

    let version = _hyper_version_to_my_version(version);

    let resp = RustHttpResponse {
        status_code,
        headers: resp_headers,
        url,
        content_length,
        version,
        remote_addr,
        data,
    };
    Ok(resp)
}

pub async fn dns_lookup_txt(name: String) -> anyhow::Result<Vec<String>> {
    DNS_CLIENT.lookup_txt(name).await
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
