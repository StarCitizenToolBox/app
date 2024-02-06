use std::sync::Arc;
use crate::downloader::{do_cancel_download, do_start_download, DownloadCallbackData};
use crate::frb_generated::StreamSink;

pub fn start_download(url: String, save_path: String, file_name: String, connection_count: u8, sink: StreamSink<DownloadCallbackData>) {
    let _ = do_start_download(url, save_path, file_name, connection_count, Arc::new(sink));
}

pub async fn cancel_download(id: String) {
    do_cancel_download(&id).await
}