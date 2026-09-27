//! Backend of `api::input_capture_api` (kept outside `api/` so flutter_rust_bridge does not
//! scan the platform code).

#[cfg_attr(not(windows), allow(dead_code))]
pub(crate) mod logic;
#[cfg(windows)]
pub(crate) mod win_impl;
