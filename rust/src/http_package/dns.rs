use hickory_resolver::config::{NameServerConfigGroup, ResolverConfig, ResolverOpts};
use hickory_resolver::{lookup_ip::LookupIpIntoIter, TokioAsyncResolver};
use lazy_static::lazy_static;
use once_cell::sync::OnceCell;
use reqwest::dns::{Addrs, Name, Resolve, Resolving};
use std::collections::HashMap;
use std::io;
use std::net::{IpAddr, Ipv4Addr, SocketAddr};
use std::sync::{Arc, RwLock};

lazy_static! {
    pub static ref MY_HOSTS_MAP: RwLock<HashMap<String, IpAddr>> = RwLock::from(HashMap::new());
}

/// Wrapper around an `AsyncResolver`, which implements the `Resolve` trait.
#[derive(Debug, Default, Clone)]
pub(crate) struct MyHickoryDnsResolver {
    /// Since we might not have been called in the context of a
    /// Tokio Runtime in initialization, so we must delay the actual
    /// construction of the resolver.
    state: Arc<OnceCell<TokioAsyncResolver>>,
}

struct SocketAddrs {
    iter: LookupIpIntoIter,
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
                iter: lookup.into_iter(),
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
            .iter()
            .map(|rdata| rdata.to_string())
            .collect::<Vec<_>>();
        Ok(t)
    }
    pub(crate) async fn lookup_ips(&self, name: String) -> anyhow::Result<Vec<String>> {
        let resolver = self.state.get_or_try_init(new_resolver)?;
        let ips = resolver.ipv4_lookup(name).await?;
        let t = ips.iter().map(|ip| ip.to_string()).collect::<Vec<_>>();
        Ok(t)
    }
}

impl Iterator for SocketAddrs {
    type Item = SocketAddr;

    fn next(&mut self) -> Option<Self::Item> {
        self.iter.next().map(|ip_addr| SocketAddr::new(ip_addr, 0))
    }
}

fn new_resolver() -> io::Result<TokioAsyncResolver> {
    let group = NameServerConfigGroup::from_ips_clear(
        &[
            IpAddr::V4(Ipv4Addr::new(119, 29, 29, 29)),
            IpAddr::V4(Ipv4Addr::new(223, 6, 6, 6)),
            IpAddr::V4(Ipv4Addr::new(1, 1, 1, 1)),
            IpAddr::V4(Ipv4Addr::new(8, 8, 8, 8)),
            IpAddr::V4(Ipv4Addr::new(180, 76, 76, 76)),
            IpAddr::V4(Ipv4Addr::new(1, 2, 4, 8)),
            IpAddr::V4(Ipv4Addr::new(166, 111, 8, 28)),
            IpAddr::V4(Ipv4Addr::new(101, 226, 4, 6)),
            IpAddr::V4(Ipv4Addr::new(114, 114, 114, 114)),
        ],
        53,
        false,
    );
    let cfg = ResolverConfig::from_parts(None, vec![], group);
    let mut opts = ResolverOpts::default();
    opts.edns0 = true;
    opts.timeout = std::time::Duration::from_secs(5);
    opts.try_tcp_on_error = true;
    opts.ip_strategy = hickory_resolver::config::LookupIpStrategy::Ipv4thenIpv6;
    opts.num_concurrent_reqs = 3;
    Ok(TokioAsyncResolver::tokio(cfg, opts))
}
