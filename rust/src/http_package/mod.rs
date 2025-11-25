pub mod dns;

use once_cell::sync::Lazy;
use reqwest::header::{HeaderMap, HeaderName, HeaderValue};
use reqwest::{Method, RequestBuilder};
use scopeguard::defer;
use std::collections::HashMap;
use std::str::FromStr;
use std::sync::{Arc, RwLock};
use std::time::Duration;
use url::Url;
use tokio::sync::mpsc;
use tokio::task::JoinHandle;

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

static DEFAULT_HEADER: Lazy<RwLock<HeaderMap>> = Lazy::new(|| RwLock::from(HeaderMap::new()));

static DNS_CLIENT: Lazy<Arc<dns::MyHickoryDnsResolver>> =
    Lazy::new(|| Arc::from(dns::MyHickoryDnsResolver::default()));

static HTTP_CLIENT: Lazy<reqwest::Client> = Lazy::new(|| new_http_client(true,true));

static HTTP_CLIENT_NO_CUSTOM_DNS: Lazy<reqwest::Client> = Lazy::new(|| new_http_client(true,false));

fn new_http_client(keep_alive: bool,with_custom_dns: bool) -> reqwest::Client {
    let mut c = reqwest::Client::builder()
        .use_rustls_tls()
        .connect_timeout(Duration::from_secs(10))
        .gzip(true)
        .no_proxy();
    if with_custom_dns {
        c = c.dns_resolver(DNS_CLIENT.clone());
    }
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
    with_custom_dns: Option<bool>,
) -> anyhow::Result<RustHttpResponse> {
    let address_clone = with_ip_address.clone();
    let url_clone = url.clone();

    if address_clone.is_some() {
        let addr = std::net::IpAddr::from_str(with_ip_address.unwrap().as_str())?;
        let mut hosts = dns::MY_HOSTS_MAP.write().unwrap();
        let url_host = Url::from_str(url.as_str())?
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
        _mix_header(new_http_client(false,with_custom_dns.unwrap_or(false)).request(method, url_clone), headers)
    } else {
        if with_custom_dns.unwrap_or(false) {
            _mix_header(HTTP_CLIENT.request(method, url_clone), headers)
        }else {
            _mix_header(HTTP_CLIENT_NO_CUSTOM_DNS.request(method, url_clone), headers)
        }
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

/// Get the fastest URL from a list of URLs by testing them concurrently.
/// Returns the first URL that responds successfully (HTTP 200), and cancels all other pending requests.
/// 
/// # Arguments
/// * `urls` - List of base URLs to test
/// * `path_suffix` - Optional path suffix to append to each URL for testing
///   If None, tests the base URL directly
/// 
/// # Returns
/// * `Ok(Some(url))` - The first base URL that responded successfully
/// * `Ok(None)` - All URLs failed or the list was empty
pub async fn get_faster_url(
    urls: Vec<String>,
    path_suffix: Option<String>,
) -> anyhow::Result<Option<String>> {
    if urls.is_empty() {
        return Ok(None);
    }

    let (tx, mut rx) = mpsc::channel(urls.len());
    let mut handles: Vec<JoinHandle<()>> = Vec::new();

    // Spawn a task for each URL
    for url in urls.iter() {
        let url_clone = url.clone();
        let tx_clone = tx.clone();
        let path_suffix_clone = path_suffix.clone();
        
        let handle = tokio::spawn(async move {
            // Build request URL
            let req_url = if let Some(suffix) = path_suffix_clone {
                format!("{}{}", url_clone, suffix)
            } else {
                url_clone.clone()
            };

            // Perform HEAD request
            let result = fetch(
                Method::HEAD,
                req_url,
                None,
                None,
                None,
                Some(false),
            ).await;

            // Send result back through channel
            if let Ok(response) = result {
                if response.status_code == 200 {
                    let _ = tx_clone.send(Some(url_clone)).await;
                    return;
                }
            }
            
            // Send None if request failed
            let _ = tx_clone.send(None).await;
        });

        handles.push(handle);
    }

    // Drop the original sender so the channel closes when all tasks complete
    drop(tx);

    // Wait for the first successful response
    let mut completed = 0;
    let total = urls.len();
    
    while let Some(result) = rx.recv().await {
        if let Some(url) = result {
            // Found a successful URL - abort all other tasks
            for handle in handles {
                handle.abort();
            }
            return Ok(Some(url));
        }
        
        completed += 1;
        if completed >= total {
            // All requests completed without success
            break;
        }
    }

    Ok(None)
}
