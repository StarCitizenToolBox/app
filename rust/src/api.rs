use std::sync::Arc;
use async_std::task;
use flutter_rust_bridge::StreamSink;
use crate::downloader::{do_cancel_download, do_start_download, DownloadCallbackData};

pub fn ping() -> String {
    return String::from("PONG");
}

pub fn start_download(url: String, save_path: String, file_name: String, connection_count: u8, sink: StreamSink<DownloadCallbackData>) {
    let _ = do_start_download(url, save_path, file_name, connection_count, Arc::new(sink));
}

pub fn cancel_download(id: String) {
    task::block_on(do_cancel_download(&id))
}