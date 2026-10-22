pub mod dns;

use once_cell::sync::Lazy;
use reqwest::header::{HeaderMap, HeaderName, HeaderValue};
use reqwest::{Method, RequestBuilder};
use std::collections::HashMap;
use std::net::SocketAddr;
use std::str::FromStr;
use std::sync::{Arc, RwLock};
use std::time::Duration;
use tokio::sync::mpsc;
use tokio::task::JoinHandle;
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

static DEFAULT_HEADER: Lazy<RwLock<HeaderMap>> = Lazy::new(|| RwLock::from(HeaderMap::new()));

static DNS_CLIENT: Lazy<Arc<dns::MyHickoryDnsResolver>> =
    Lazy::new(|| Arc::from(dns::MyHickoryDnsResolver::default()));

static HTTP_CLIENT: Lazy<reqwest::Client> = Lazy::new(|| new_http_client(true, true));

static HTTP_CLIENT_NO_CUSTOM_DNS: Lazy<reqwest::Client> =
    Lazy::new(|| new_http_client(true, false));

fn new_http_client(keep_alive: bool, with_custom_dns: bool) -> reqwest::Client {
    new_http_client_builder(keep_alive, with_custom_dns)
        .build()
        .unwrap()
}

fn new_http_client_builder(keep_alive: bool, with_custom_dns: bool) -> reqwest::ClientBuilder {
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
    c
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
    let mut req = if let Some(ip_address) = with_ip_address {
        // Pin the host on a client of its own, so the pin cannot leak into
        // other requests or race with concurrent pins of the same host.
        let addr = std::net::IpAddr::from_str(ip_address.as_str())?;
        let url_host = Url::from_str(url.as_str())?
            .host_str()
            .ok_or_else(|| anyhow::anyhow!("url has no host: {url}"))?
            .to_string();
        // Port 0 keeps the port from the URL.
        let client = new_http_client_builder(false, with_custom_dns.unwrap_or(false))
            .resolve(&url_host, SocketAddr::new(addr, 0))
            .build()?;
        _mix_header(client.request(method, url), headers)
    } else if with_custom_dns.unwrap_or(false) {
        _mix_header(HTTP_CLIENT.request(method, url), headers)
    } else {
        _mix_header(HTTP_CLIENT_NO_CUSTOM_DNS.request(method, url), headers)
    };
    if let Some(input_data) = input_data {
        req = req.body(input_data);
    }
    let resp = req.send().await?;
    let url = resp.url().to_string();
    let status_code = resp.status().as_u16();
    let resp_headers = _reade_resp_header(resp.headers());
    let content_length = resp.content_length();
    let version = resp.version();
    let mut remote_addr = "".to_string();
    if let Some(addr) = resp.remote_addr() {
        remote_addr = addr.to_string();
    }
    let mut data: Option<Vec<u8>> = None;

    let bytes = resp.bytes().await;
    if let Ok(bytes) = bytes {
        data = Some(bytes.to_vec());
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
    // Defaults first, minus any header the request sets itself, so a
    // per-request value (e.g. User-Agent) wins over the default.
    let mut defaults = DEFAULT_HEADER.read().unwrap().clone();
    if let Some(headers) = &headers {
        for name in headers.keys() {
            if let Ok(name) = HeaderName::from_str(name) {
                defaults.remove(name);
            }
        }
    }
    req = req.headers(defaults);
    if let Some(headers) = headers {
        for x in headers {
            req = req.header(x.0, x.1);
        }
    }
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
            let result = fetch(Method::HEAD, req_url, None, None, None, Some(false)).await;

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

#[cfg(test)]
mod tests {
    use super::*;
    use std::io::{BufRead, BufReader, Write};
    use std::net::TcpListener;
    use std::sync::mpsc as std_mpsc;

    /// Serves every connection with `status` and forwards each request head
    /// (lower-cased) to the returned receiver.
    fn local_server(status: u16) -> (u16, std_mpsc::Receiver<String>) {
        local_server_at("127.0.0.1", 0, status)
    }

    /// Like `local_server`, on `ip` at `port` (0 picks a free one).
    fn local_server_at(ip: &str, port: u16, status: u16) -> (u16, std_mpsc::Receiver<String>) {
        let listener = TcpListener::bind((ip, port)).unwrap();
        let port = listener.local_addr().unwrap().port();
        let (tx, rx) = std_mpsc::channel();
        std::thread::spawn(move || {
            for stream in listener.incoming() {
                let Ok(mut stream) = stream else { continue };
                let mut reader = BufReader::new(stream.try_clone().unwrap());
                let mut head = String::new();
                loop {
                    let mut line = String::new();
                    if reader.read_line(&mut line).unwrap_or(0) == 0 || line == "\r\n" {
                        break;
                    }
                    head.push_str(&line.to_ascii_lowercase());
                }
                let _ = tx.send(head);
                let _ = write!(
                    stream,
                    "HTTP/1.1 {status} X\r\nContent-Length: 0\r\nConnection: close\r\n\r\n"
                );
            }
        });
        (port, rx)
    }

    #[tokio::test]
    async fn faster_url_returns_the_base_url_that_answered_200() {
        let (bad, _) = local_server(404);
        let (good, good_requests) = local_server(200);
        let bad_url = format!("http://127.0.0.1:{bad}");
        let good_url = format!("http://127.0.0.1:{good}");

        let fastest = get_faster_url(
            vec![bad_url, good_url.clone()],
            Some("/api/version".to_string()),
        )
        .await
        .unwrap();

        assert_eq!(fastest, Some(good_url));
        let head = good_requests.recv().unwrap();
        assert!(head.starts_with("head /api/version http/1.1"), "{head}");
    }

    #[tokio::test]
    async fn faster_url_is_none_when_nothing_answers_200() {
        let (a, _) = local_server(404);
        let (b, _) = local_server(503);
        let urls = vec![
            format!("http://127.0.0.1:{a}"),
            format!("http://127.0.0.1:{b}"),
        ];
        assert_eq!(get_faster_url(urls, None).await.unwrap(), None);
        assert_eq!(get_faster_url(Vec::new(), None).await.unwrap(), None);
    }

    #[tokio::test]
    async fn pinned_ip_is_used_with_custom_dns() {
        let (port, requests) = local_server(200);
        let resp = fetch(
            Method::GET,
            format!("http://pinned-custom-dns.invalid:{port}/ping"),
            None,
            None,
            Some("127.0.0.1".to_string()),
            Some(true),
        )
        .await
        .unwrap();
        assert_eq!(resp.status_code, 200);
        let head = requests.recv().unwrap();
        assert!(
            head.contains(&format!("host: pinned-custom-dns.invalid:{port}")),
            "{head}"
        );
    }

    /// The hosts booster passes only the IP.
    #[tokio::test]
    async fn pinned_ip_is_used_without_custom_dns_flag() {
        let (port, _) = local_server(200);
        let resp = fetch(
            Method::HEAD,
            format!("http://pinned-default.invalid:{port}/"),
            None,
            None,
            Some("127.0.0.1".to_string()),
            None,
        )
        .await
        .unwrap();
        assert_eq!(resp.status_code, 200);
    }

    /// The hosts booster tests several IPs of a host; each request must reach
    /// the IP it pinned, even when they run at the same time.
    #[tokio::test]
    async fn concurrent_pins_of_one_host_reach_their_own_ip() {
        let (port, first) = local_server_at("127.0.0.1", 0, 200);
        let (_, second) = local_server_at("127.0.0.2", port, 200);
        let url = format!("http://same-host.invalid:{port}/");

        let (a, b) = tokio::join!(
            fetch(
                Method::GET,
                url.clone(),
                None,
                None,
                Some("127.0.0.1".into()),
                None
            ),
            fetch(
                Method::GET,
                url.clone(),
                None,
                None,
                Some("127.0.0.2".into()),
                None
            ),
        );
        assert_eq!(a.unwrap().status_code, 200);
        assert_eq!(b.unwrap().status_code, 200);
        first.try_recv().expect("127.0.0.1 was not reached");
        second.try_recv().expect("127.0.0.2 was not reached");

        // Nothing is left pinned: without a pin the made-up host does not resolve.
        assert!(fetch(Method::GET, url, None, None, None, None)
            .await
            .is_err());
    }

    #[tokio::test]
    async fn invalid_pinned_ip_is_rejected_before_sending() {
        let err = fetch(
            Method::GET,
            "http://bad-ip.invalid/".to_string(),
            None,
            None,
            Some("999.1.1.1".to_string()),
            Some(true),
        )
        .await
        .unwrap_err();
        assert!(err.to_string().contains("invalid"), "{err}");
    }

    /// DEFAULT_HEADER is a process global.
    static HEADER_LOCK: tokio::sync::Mutex<()> = tokio::sync::Mutex::const_new(());

    #[tokio::test]
    async fn default_headers_are_sent_alongside_request_headers() {
        let _guard = HEADER_LOCK.lock().await;
        let (port, requests) = local_server(200);
        set_default_header(HashMap::from([(
            "x-sct-test-default".to_string(),
            "d".to_string(),
        )]));
        let resp = fetch(
            Method::GET,
            format!("http://127.0.0.1:{port}/"),
            Some(HashMap::from([(
                "x-sct-test-request".to_string(),
                "r".to_string(),
            )])),
            None,
            None,
            None,
        )
        .await;
        set_default_header(HashMap::new());
        assert_eq!(resp.unwrap().status_code, 200);
        let head = requests.recv().unwrap();
        assert!(head.contains("x-sct-test-default: d"), "{head}");
        assert!(head.contains("x-sct-test-request: r"), "{head}");
    }

    #[tokio::test]
    async fn per_request_headers_override_default_headers() {
        let _guard = HEADER_LOCK.lock().await;
        let (port, requests) = local_server(200);
        set_default_header(HashMap::from([(
            "x-sct-test-shared".to_string(),
            "default".to_string(),
        )]));
        let resp = fetch(
            Method::GET,
            format!("http://127.0.0.1:{port}/"),
            Some(HashMap::from([(
                "x-sct-test-shared".to_string(),
                "request".to_string(),
            )])),
            None,
            None,
            None,
        )
        .await;
        set_default_header(HashMap::new());
        assert_eq!(resp.unwrap().status_code, 200);
        let head = requests.recv().unwrap();
        assert!(head.contains("x-sct-test-shared: request"), "{head}");
        assert!(!head.contains("x-sct-test-shared: default"), "{head}");
    }
}
