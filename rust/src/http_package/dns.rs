use hickory_resolver::config::{ConnectionConfig, NameServerConfig, ResolverConfig, ResolverOpts};
use hickory_resolver::net::runtime::TokioRuntimeProvider;
use hickory_resolver::proto::rr::RData;
use hickory_resolver::TokioResolver;
use once_cell::sync::{Lazy, OnceCell};
use reqwest::dns::{Addrs, Name, Resolve, Resolving};
use std::collections::HashMap;
use std::io;
use std::net::{IpAddr, Ipv4Addr, SocketAddr};
use std::sync::{Arc, RwLock};
use std::vec::IntoIter;

pub static MY_HOSTS_MAP: Lazy<RwLock<HashMap<String, IpAddr>>> =
    Lazy::new(|| RwLock::from(HashMap::new()));

/// Wrapper around an `AsyncResolver`, which implements the `Resolve` trait.
#[derive(Debug, Default, Clone)]
pub(crate) struct MyHickoryDnsResolver {
    /// Since we might not have been called in the context of a
    /// Tokio Runtime in initialization, so we must delay the actual
    /// construction of the resolver.
    state: Arc<OnceCell<TokioResolver>>,
}

struct SocketAddrs {
    iter: IntoIter<IpAddr>,
}

impl Resolve for MyHickoryDnsResolver {
    fn resolve(&self, name: Name) -> Resolving {
        let my_hosts = MY_HOSTS_MAP.read().unwrap();
        let name_str = name.as_str();
        if let Some(ip) = my_hosts.get(name_str) {
            let addrs: Addrs = Box::new(std::iter::once(SocketAddr::new(*ip, 0)));
            println!("using host map === {:?}", name_str);
            return Box::pin(async move { Ok(addrs) });
        }

        let resolver = self.clone();
        Box::pin(async move {
            let resolver = resolver.state.get_or_try_init(new_resolver)?;
            let lookup = resolver.lookup_ip(name.as_str()).await?;
            let addrs: Addrs = Box::new(SocketAddrs {
                iter: lookup.iter().collect::<Vec<_>>().into_iter(),
            });
            Ok(addrs)
        })
    }
}

impl MyHickoryDnsResolver {
    pub(crate) async fn lookup_txt(&self, name: String) -> anyhow::Result<Vec<String>> {
        let resolver = self.state.get_or_try_init(new_resolver)?;
        let txt = resolver.txt_lookup(name).await?;
        let t = txt
            .answers()
            .iter()
            .filter_map(|record| match &record.data {
                RData::TXT(txt) => Some(txt.to_string()),
                _ => None,
            })
            .collect::<Vec<_>>();
        Ok(t)
    }
    pub(crate) async fn lookup_ips(&self, name: String) -> anyhow::Result<Vec<String>> {
        let resolver = self.state.get_or_try_init(new_resolver)?;
        let ips = resolver.ipv4_lookup(name).await?;
        let t = ips
            .answers()
            .iter()
            .filter_map(|record| match &record.data {
                RData::A(ip) => Some(Ipv4Addr::from(*ip).to_string()),
                _ => None,
            })
            .collect::<Vec<_>>();
        Ok(t)
    }
}

impl Iterator for SocketAddrs {
    type Item = SocketAddr;

    fn next(&mut self) -> Option<Self::Item> {
        self.iter.next().map(|ip_addr| SocketAddr::new(ip_addr, 0))
    }
}

fn new_resolver() -> io::Result<TokioResolver> {
    let group = [
        IpAddr::V4(Ipv4Addr::new(119, 29, 29, 29)),
        IpAddr::V4(Ipv4Addr::new(223, 6, 6, 6)),
        IpAddr::V4(Ipv4Addr::new(1, 1, 1, 1)),
        IpAddr::V4(Ipv4Addr::new(8, 8, 8, 8)),
        IpAddr::V4(Ipv4Addr::new(180, 76, 76, 76)),
        IpAddr::V4(Ipv4Addr::new(1, 2, 4, 8)),
        IpAddr::V4(Ipv4Addr::new(166, 111, 8, 28)),
        IpAddr::V4(Ipv4Addr::new(101, 226, 4, 6)),
        IpAddr::V4(Ipv4Addr::new(114, 114, 114, 114)),
    ];
    let name_servers = group
        .into_iter()
        .map(|ip| {
            NameServerConfig::new(
                ip,
                false,
                vec![ConnectionConfig::udp(), ConnectionConfig::tcp()],
            )
        })
        .collect();
    let cfg = ResolverConfig::from_parts(None, vec![], name_servers);
    let mut opts = ResolverOpts::default();
    opts.edns0 = true;
    opts.timeout = std::time::Duration::from_secs(5);
    opts.try_tcp_on_error = true;
    opts.ip_strategy = hickory_resolver::config::LookupIpStrategy::Ipv4thenIpv6;
    opts.num_concurrent_reqs = 3;
    let provider = TokioRuntimeProvider::default();
    let mut builder = TokioResolver::builder_with_config(cfg, provider);
    *builder.options_mut() = opts;
    builder.build().map_err(io::Error::other)
}
