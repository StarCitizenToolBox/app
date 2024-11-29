use crate::go::go_api::{RsCallGo, RsCallGoImpl};

pub fn ping_go(ping: String) -> String {
    RsCallGoImpl::ping(ping)
}
