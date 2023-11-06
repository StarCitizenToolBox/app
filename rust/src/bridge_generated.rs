#![allow(
    non_camel_case_types,
    unused,
    clippy::redundant_closure,
    clippy::useless_conversion,
    clippy::unit_arg,
    clippy::double_parens,
    non_snake_case,
    clippy::too_many_arguments
)]
// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`@ 1.82.3.

use crate::api::*;
use core::panic::UnwindSafe;
use flutter_rust_bridge::rust2dart::IntoIntoDart;
use flutter_rust_bridge::*;
use std::ffi::c_void;
use std::sync::Arc;

// Section: imports

use crate::downloader::DownloadCallbackData;
use crate::downloader::MyDownloaderStatus;
use crate::downloader::MyNetworkItemPendingType;

// Section: wire functions

fn wire_ping_impl(port_: MessagePort) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap::<_, _, _, String, _>(
        WrapInfo {
            debug_name: "ping",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || move |task_callback| Result::<_, ()>::Ok(ping()),
    )
}
fn wire_start_download_impl(
    port_: MessagePort,
    url: impl Wire2Api<String> + UnwindSafe,
    save_path: impl Wire2Api<String> + UnwindSafe,
    file_name: impl Wire2Api<String> + UnwindSafe,
    connection_count: impl Wire2Api<u8> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap::<_, _, _, (), _>(
        WrapInfo {
            debug_name: "start_download",
            port: Some(port_),
            mode: FfiCallMode::Stream,
        },
        move || {
            let api_url = url.wire2api();
            let api_save_path = save_path.wire2api();
            let api_file_name = file_name.wire2api();
            let api_connection_count = connection_count.wire2api();
            move |task_callback| {
                Result::<_, ()>::Ok(start_download(
                    api_url,
                    api_save_path,
                    api_file_name,
                    api_connection_count,
                    task_callback.stream_sink::<_, DownloadCallbackData>(),
                ))
            }
        },
    )
}
fn wire_cancel_download_impl(port_: MessagePort, id: impl Wire2Api<String> + UnwindSafe) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap::<_, _, _, (), _>(
        WrapInfo {
            debug_name: "cancel_download",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_id = id.wire2api();
            move |task_callback| Result::<_, ()>::Ok(cancel_download(api_id))
        },
    )
}
// Section: wrapper structs

// Section: static checks

// Section: allocate functions

// Section: related functions

// Section: impl Wire2Api

pub trait Wire2Api<T> {
    fn wire2api(self) -> T;
}

impl<T, S> Wire2Api<Option<T>> for *mut S
where
    *mut S: Wire2Api<T>,
{
    fn wire2api(self) -> Option<T> {
        (!self.is_null()).then(|| self.wire2api())
    }
}

impl Wire2Api<u8> for u8 {
    fn wire2api(self) -> u8 {
        self
    }
}

// Section: impl IntoDart

impl support::IntoDart for DownloadCallbackData {
    fn into_dart(self) -> support::DartAbi {
        vec![
            self.id.into_into_dart().into_dart(),
            self.total.into_into_dart().into_dart(),
            self.progress.into_into_dart().into_dart(),
            self.speed.into_into_dart().into_dart(),
            self.status.into_into_dart().into_dart(),
        ]
        .into_dart()
    }
}
impl support::IntoDartExceptPrimitive for DownloadCallbackData {}
impl rust2dart::IntoIntoDart<DownloadCallbackData> for DownloadCallbackData {
    fn into_into_dart(self) -> Self {
        self
    }
}

impl support::IntoDart for MyDownloaderStatus {
    fn into_dart(self) -> support::DartAbi {
        match self {
            Self::NoStart => vec![0.into_dart()],
            Self::Running => vec![1.into_dart()],
            Self::Pending(field0) => vec![2.into_dart(), field0.into_into_dart().into_dart()],
            Self::Error(field0) => vec![3.into_dart(), field0.into_into_dart().into_dart()],
            Self::Finished => vec![4.into_dart()],
        }
        .into_dart()
    }
}
impl support::IntoDartExceptPrimitive for MyDownloaderStatus {}
impl rust2dart::IntoIntoDart<MyDownloaderStatus> for MyDownloaderStatus {
    fn into_into_dart(self) -> Self {
        self
    }
}

impl support::IntoDart for MyNetworkItemPendingType {
    fn into_dart(self) -> support::DartAbi {
        match self {
            Self::QueueUp => 0,
            Self::Starting => 1,
            Self::Stopping => 2,
            Self::Initializing => 3,
        }
        .into_dart()
    }
}
impl support::IntoDartExceptPrimitive for MyNetworkItemPendingType {}
impl rust2dart::IntoIntoDart<MyNetworkItemPendingType> for MyNetworkItemPendingType {
    fn into_into_dart(self) -> Self {
        self
    }
}

// Section: executor

support::lazy_static! {
    pub static ref FLUTTER_RUST_BRIDGE_HANDLER: support::DefaultHandler = Default::default();
}

#[cfg(not(target_family = "wasm"))]
#[path = "bridge_generated.io.rs"]
mod io;
#[cfg(not(target_family = "wasm"))]
pub use io::*;