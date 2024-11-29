pub mod binding {
    #![allow(warnings)]
    rust2go::r2g_include_binding!();
}

#[rust2go::r2g]
pub trait RsCallGo {
    fn ping(ping: String) -> String;
}