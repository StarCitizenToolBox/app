use std::collections::HashMap;
use std::error::Error;
use std::num::{NonZeroU8, NonZeroUsize};
use std::path::PathBuf;
use std::sync::Arc;
use std::time::Duration;
use async_std::sync::Mutex;
use flutter_rust_bridge::for_generated::lazy_static;
use http_downloader::{breakpoint_resume::DownloadBreakpointResumeExtension, ExtendedHttpFileDownloader, HttpDownloaderBuilder, speed_tracker::DownloadSpeedTrackerExtension, status_tracker::DownloadStatusTrackerExtension};
use http_downloader::bson_file_archiver::{ArchiveFilePath, BsonFileArchiverBuilder};
use url::Url;
use crate::frb_generated::StreamSink;
use http_downloader::status_tracker::{DownloaderStatus, NetworkItemPendingType};
use uuid::Uuid;

pub enum MyNetworkItemPendingType {
    QueueUp,
    Starting,
    Stopping,
    Initializing,
}

pub enum MyDownloaderStatus {
    NoStart,
    Running,
    Pending(MyNetworkItemPendingType),
    Error(String),
    Finished,
}

pub struct DownloadCallbackData {
    pub id: String,
    pub total: u64,
    pub progress: u64,
    pub speed: u64,
    pub status: MyDownloaderStatus,
}

impl DownloadCallbackData {
    pub fn new(id: String, total: u64) -> Self {
        DownloadCallbackData {
            id,
            total,
            progress: 0,
            speed: 0,
            status: MyDownloaderStatus::NoStart,
        }
    }
}

lazy_static! {
        static ref DOWNLOADERS_MAP: Mutex<HashMap<String, Arc<ExtendedHttpFileDownloader>>> = {
            let map = HashMap::new();
            Mutex::new(map)
        };
}

pub async fn do_cancel_download(id: &str) {
    let d = get_downloader(id).await;
    if d.is_none() {
        return;
    }
    d.unwrap().cancel().await
}

#[tokio::main]
pub async fn do_start_download(url: String, save_path: String, file_name: String, connection_count: u8, sink: Arc<StreamSink<DownloadCallbackData>>) -> Result<(), Box<dyn Error>> {
    let save_dir = PathBuf::from(save_path);
    let test_url = Url::parse(&*url)?;

    let (mut downloader, (status_state, speed_state, ..)) =

        HttpDownloaderBuilder::new(test_url, save_dir)
            .chunk_size(NonZeroUsize::new(1024 * 1024 * 10).unwrap()) // 块大小
            .download_connection_count(NonZeroU8::new(connection_count).unwrap())
            .file_name(Option::from(file_name))
            .build((
                // 下载状态追踪扩展
                // by cargo feature "status-tracker" enable
                DownloadStatusTrackerExtension { log: true },
                // 下载速度追踪扩展
                // by cargo feature "speed-tracker" enable
                DownloadSpeedTrackerExtension { log: true },
                // 断点续传扩展，
                // by cargo feature "breakpoint-resume" enable
                DownloadBreakpointResumeExtension {
                    // BsonFileArchiver by cargo feature "bson-file-archiver" enable
                    download_archiver_builder: BsonFileArchiverBuilder::new(ArchiveFilePath::Suffix("bson".to_string()))
                }
            ));

    let status_state_arc = Arc::new(status_state);
    let status_state_clone = Arc::clone(&status_state_arc);

    let id = Uuid::new_v4();
    // info!("Prepare download，准备下载");
    let download_future = downloader.prepare_download()?;
    let sink_clone = sink.clone();
    add_downloader(&id.to_string(), Arc::new(downloader)).await;

    // 打印下载进度
    // Print download Progress
    tokio::spawn({
        let mut downloaded_len_receiver = get_downloader(&id.to_string()).await.unwrap().downloaded_len_receiver().clone();
        let total_size_future = get_downloader(&id.to_string()).await.unwrap().total_size_future();
        async move {
            let total_len = total_size_future.await;
            if let Some(total_len) = total_len {
                // info!("Total size: {:.2} Mb",total_len.get() as f64 / 1024_f64/ 1024_f64);
                sink_clone.add(DownloadCallbackData::new(id.to_string(), total_len.get())).unwrap();
            }

            while downloaded_len_receiver.changed().await.is_ok() {
                let p = *downloaded_len_receiver.borrow();
                let _status = status_state_clone.status(); // get download status， 获取状态
                let _byte_per_second = speed_state.download_speed(); // get download speed，Byte per second，获取速度，字节每秒

                if let Some(total_len) = total_len {
                    sink_clone.add(DownloadCallbackData {
                        id: id.to_string(),
                        total: total_len.get(),
                        progress: p,
                        speed: _byte_per_second,
                        status: get_my_status(_status),
                    }).unwrap();
                }
                tokio::time::sleep(Duration::from_millis(100)).await;
            }
        }
    });

    download_future.await?;
    let _status = status_state_arc.status();
    sink.add(DownloadCallbackData {
        id: id.to_string(),
        total: 0,
        progress: 0,
        speed: 0,
        status: get_my_status(_status),
    }).unwrap();
    remove_downloader(&id.to_string()).await;
    println!("rust downloader download complete");
    Ok(())
}

async fn remove_downloader(id: &str) {
    let mut downloader_map = DOWNLOADERS_MAP.lock().await;
    downloader_map.remove(id);
}

async fn get_downloader(id: &str) -> Option<Arc<ExtendedHttpFileDownloader>> {
    let downloader_map = DOWNLOADERS_MAP.lock().await;
    return if let Some(downloader) = downloader_map.get(id) {
        Some(downloader.clone())
    } else {
        None
    };
}

async fn add_downloader(id: &str, d: Arc<ExtendedHttpFileDownloader>) {
    let mut downloader_map = DOWNLOADERS_MAP.lock().await;
    downloader_map.insert(id.to_string(), d);
}

fn get_my_status(_status: DownloaderStatus) -> MyDownloaderStatus {
    match _status {
        DownloaderStatus::NoStart => { MyDownloaderStatus::NoStart }
        DownloaderStatus::Running => { MyDownloaderStatus::Running }
        DownloaderStatus::Pending(n) => { MyDownloaderStatus::Pending(get_my_network_type(n)) }
        DownloaderStatus::Error(e) => { MyDownloaderStatus::Error(e) }
        DownloaderStatus::Finished => { MyDownloaderStatus::Finished }
    }
}

fn get_my_network_type(n: NetworkItemPendingType) -> MyNetworkItemPendingType {
    match n {
        NetworkItemPendingType::QueueUp => { MyNetworkItemPendingType::QueueUp }
        NetworkItemPendingType::Starting => { MyNetworkItemPendingType::Starting }
        NetworkItemPendingType::Stopping => { MyNetworkItemPendingType::Stopping }
        NetworkItemPendingType::Initializing => { MyNetworkItemPendingType::Initializing }
    }
}