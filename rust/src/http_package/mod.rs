pub mod dns;

use lazy_static::lazy_static;
use reqwest::header::{HeaderMap, HeaderName, HeaderValue};
use reqwest::{Method, RequestBuilder};
use scopeguard::defer;
use std::collections::HashMap;
use std::str::FromStr;
use std::sync::{Arc, RwLock};
use std::time::Duration;
use url::Url;

#[derive(Debug)]
#[allow(non_camel_case_types)]
pub enum MyHttpVersion {
    HTTP_09,
    HTTP_10,
    HTTP_11,
    HTTP_2,
    HTTP_3,
    HTTP_UNKNOWN,
}

#[derive(Debug)]
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
        reqwest::Version::HTTP_09 => MyHttpVersion::HTTP_09,
        reqwest::Version::HTTP_10 => MyHttpVersion::HTTP_10,
        reqwest::Version::HTTP_11 => MyHttpVersion::HTTP_11,
        reqwest::Version::HTTP_2 => MyHttpVersion::HTTP_2,
        reqwest::Version::HTTP_3 => MyHttpVersion::HTTP_3,
        _ => MyHttpVersion::HTTP_UNKNOWN,
    }
}

lazy_static! {
    static ref DEFAULT_HEADER: RwLock<HeaderMap> = RwLock::from(HeaderMap::new());
    static ref DNS_CLIENT: Arc<dns::MyHickoryDnsResolver> =
        Arc::from(dns::MyHickoryDnsResolver::default());
    static ref HTTP_CLIENT: reqwest::Client = new_http_client(true);
}

fn new_http_client(keep_alive: bool) -> reqwest::Client {
    let mut c = reqwest::Client::builder()
        .dns_resolver(DNS_CLIENT.clone())
        .use_rustls_tls()
        .connect_timeout(Duration::from_secs(10))
        .gzip(true)
        .no_proxy();
    if !keep_alive {
        c = c.tcp_keepalive(None);
    } else {
        c = c.tcp_keepalive(Duration::from_secs(120));
    }
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
    with_ip_address: Option<String>,
) -> anyhow::Result<RustHttpResponse> {
    let address_clone = with_ip_address.clone();
    let url_clone = url.clone();

    if address_clone.is_some() {
        let addr = std::net::IpAddr::from_str(with_ip_address.unwrap().as_str()).unwrap();
        let mut hosts = dns::MY_HOSTS_MAP.write().unwrap();
        let url_host = Url::from_str(url.as_str())
            .unwrap()
            .host()
            .unwrap()
            .to_string();
        hosts.insert(url_host, addr);
    }

    defer! {
        if address_clone.is_some() {
            let mut hosts = dns::MY_HOSTS_MAP.write().unwrap();
            hosts.remove(url.clone().as_str());
        }
    }

    let mut req = if address_clone.is_some() {
        _mix_header(new_http_client(false).request(method, url_clone), headers)
    } else {
        _mix_header(HTTP_CLIENT.request(method, url_clone), headers)
    };
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

pub async fn dns_lookup_ips(name: String) -> anyhow::Result<Vec<String>> {
    DNS_CLIENT.lookup_ips(name).await
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
