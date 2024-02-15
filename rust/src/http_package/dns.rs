use std::io;
use hickory_resolver::{lookup_ip::LookupIpIntoIter, system_conf, TokioAsyncResolver};
use hyper::client::connect::dns::Name;
use once_cell::sync::OnceCell;
use reqwest::dns::{Addrs, Resolve, Resolving};
use std::net::SocketAddr;
use std::sync::Arc;

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
        let t = txt.iter()
            .map(|rdata| rdata.to_string())
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

fn new_resolver() -> io::Result<TokioAsyncResolver> {
    let (config, opts) = system_conf::read_system_conf().map_err(|e| {
        io::Error::new(
            io::ErrorKind::Other,
            format!("error reading DNS system conf: {}", e),
        )
    })?;
    Ok(TokioAsyncResolver::tokio(config, opts))
}
