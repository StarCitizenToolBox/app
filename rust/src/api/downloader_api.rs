use std::collections::HashMap;
use std::path::PathBuf;
use std::sync::Arc;

use anyhow::{bail, Context, Result};
use bytes::Bytes;
use flutter_rust_bridge::frb;
use librqbit::{
    AddTorrent, AddTorrentOptions, AddTorrentResponse, Session, SessionOptions,
    TorrentStats, ManagedTorrent, TorrentStatsState,
};
use once_cell::sync::OnceCell;
use parking_lot::RwLock;
use serde::{Deserialize, Serialize};
use tokio::sync::Mutex;

// Type alias for ManagedTorrentHandle
type ManagedTorrentHandle = Arc<ManagedTorrent>;

// Global session instance
static SESSION: OnceCell<Arc<Session>> = OnceCell::new();
static SESSION_INIT_LOCK: once_cell::sync::Lazy<Mutex<()>> =
    once_cell::sync::Lazy::new(|| Mutex::new(()));

// Store torrent handles
static TORRENT_HANDLES: once_cell::sync::Lazy<RwLock<HashMap<usize, ManagedTorrentHandle>>> =
    once_cell::sync::Lazy::new(|| RwLock::new(HashMap::new()));

// Store output folders for each task
static TASK_OUTPUT_FOLDERS: once_cell::sync::Lazy<RwLock<HashMap<usize, String>>> =
    once_cell::sync::Lazy::new(|| RwLock::new(HashMap::new()));

/// Download task status
#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum DownloadTaskStatus {
    Initializing,
    Live,
    Paused,
    Error,
    Finished,
}

/// Download task information
#[derive(Debug, Clone)]
pub struct DownloadTaskInfo {
    pub id: usize,
    pub name: String,
    pub status: DownloadTaskStatus,
    pub total_bytes: u64,
    pub downloaded_bytes: u64,
    pub uploaded_bytes: u64,
    pub download_speed: u64,
    pub upload_speed: u64,
    pub progress: f64,
    pub num_peers: usize,
    pub output_folder: String,
}

/// Global statistics
#[derive(Debug, Clone, Default)]
pub struct DownloadGlobalStat {
    pub download_speed: u64,
    pub upload_speed: u64,
    pub num_active: usize,
    pub num_waiting: usize,
}

/// Initialize the download manager session
#[frb(sync)]
pub fn downloader_init(download_dir: String) -> Result<()> {
    // Already initialized
    if SESSION.get().is_some() {
        return Ok(());
    }

    let rt = tokio::runtime::Handle::current();
    rt.block_on(async {
        let _lock = SESSION_INIT_LOCK.lock().await;
        
        // Double check after acquiring lock
        if SESSION.get().is_some() {
            return Ok(());
        }

        let output_folder = PathBuf::from(&download_dir);
        std::fs::create_dir_all(&output_folder)?;

        let session = Session::new_with_opts(
            output_folder,
            SessionOptions {
                disable_dht: false,
                disable_dht_persistence: true,
                persistence: None,
                ..Default::default()
            },
        )
        .await
        .context("Failed to create rqbit session")?;

        SESSION
            .set(session)
            .map_err(|_| anyhow::anyhow!("Session already initialized"))?;

        Ok(())
    })
}

/// Check if the downloader is initialized
#[frb(sync)]
pub fn downloader_is_initialized() -> bool {
    SESSION.get().is_some()
}

/// Add a torrent from bytes (e.g., .torrent file content)
pub async fn downloader_add_torrent(
    torrent_bytes: Vec<u8>,
    output_folder: Option<String>,
    trackers: Option<Vec<String>>,
) -> Result<usize> {
    let session = SESSION
        .get()
        .context("Downloader not initialized. Call downloader_init first.")?;

    let bytes = Bytes::from(torrent_bytes);
    let add_torrent = AddTorrent::from_bytes(bytes);

    let mut opts = AddTorrentOptions {
        overwrite: true,
        paused: false,
        ..Default::default()
    };

    if let Some(ref folder) = output_folder {
        opts.output_folder = Some(folder.clone());
    }

    if let Some(tracker_list) = trackers {
        opts.trackers = Some(tracker_list);
    }

    let response = session
        .add_torrent(add_torrent, Some(opts))
        .await
        .context("Failed to add torrent")?;

    match response {
        AddTorrentResponse::Added(id, handle) => {
            // Store output folder
            if let Some(folder) = output_folder.clone() {
                TASK_OUTPUT_FOLDERS.write().insert(id, folder);
            }
            TORRENT_HANDLES.write().insert(id, handle);
            Ok(id)
        }
        AddTorrentResponse::AlreadyManaged(id, handle) => {
            if let Some(folder) = output_folder.clone() {
                TASK_OUTPUT_FOLDERS.write().insert(id, folder);
            }
            TORRENT_HANDLES.write().insert(id, handle);
            Ok(id)
        }
        AddTorrentResponse::ListOnly(_) => {
            bail!("Torrent was only listed, not added")
        }
    }
}

/// Add a torrent from a magnet link
pub async fn downloader_add_magnet(
    magnet_link: String,
    output_folder: Option<String>,
    trackers: Option<Vec<String>>,
) -> Result<usize> {
    let session = SESSION
        .get()
        .context("Downloader not initialized. Call downloader_init first.")?;

    // Check if it's a magnet link
    if !magnet_link.starts_with("magnet:") {
        bail!("Invalid magnet link. Must start with 'magnet:'");
    }

    let add_torrent = AddTorrent::from_url(magnet_link);

    let mut opts = AddTorrentOptions {
        overwrite: true,
        paused: false,
        ..Default::default()
    };

    if let Some(ref folder) = output_folder {
        opts.output_folder = Some(folder.clone());
    }

    if let Some(tracker_list) = trackers {
        opts.trackers = Some(tracker_list);
    }

    let response = session
        .add_torrent(add_torrent, Some(opts))
        .await
        .context("Failed to add magnet")?;

    match response {
        AddTorrentResponse::Added(id, handle) => {
            if let Some(folder) = output_folder.clone() {
                TASK_OUTPUT_FOLDERS.write().insert(id, folder);
            }
            TORRENT_HANDLES.write().insert(id, handle);
            Ok(id)
        }
        AddTorrentResponse::AlreadyManaged(id, handle) => {
            if let Some(folder) = output_folder.clone() {
                TASK_OUTPUT_FOLDERS.write().insert(id, folder);
            }
            TORRENT_HANDLES.write().insert(id, handle);
            Ok(id)
        }
        AddTorrentResponse::ListOnly(_) => {
            bail!("Magnet was only listed, not added")
        }
    }
}

/// Add a torrent from URL (HTTP download not supported, only torrent file URLs)
pub async fn downloader_add_url(
    url: String,
    output_folder: Option<String>,
    trackers: Option<Vec<String>>,
) -> Result<usize> {
    // Check if it's a magnet link
    if url.starts_with("magnet:") {
        return downloader_add_magnet(url, output_folder, trackers).await;
    }

    // Check if it's a torrent file URL
    if url.starts_with("http://") || url.starts_with("https://") {
        // Download the torrent file first
        let client = reqwest::Client::new();
        let response = client
            .get(&url)
            .send()
            .await
            .context("Failed to download torrent file")?;

        if !response.status().is_success() {
            bail!("Failed to download torrent file: HTTP {}", response.status());
        }

        let bytes = response
            .bytes()
            .await
            .context("Failed to read torrent file content")?;

        return downloader_add_torrent(bytes.to_vec(), output_folder, trackers).await;
    }

    bail!("HTTP downloads are not supported. Only BitTorrent (magnet links and .torrent files) are supported.")
}

/// Pause a download task
pub async fn downloader_pause(task_id: usize) -> Result<()> {
    let session = SESSION
        .get()
        .context("Downloader not initialized")?;

    let handle = {
        let handles = TORRENT_HANDLES.read();
        handles.get(&task_id).cloned()
    };

    if let Some(handle) = handle {
        session.pause(&handle).await.context("Failed to pause torrent")?;
        Ok(())
    } else {
        bail!("Task not found: {}", task_id)
    }
}

/// Resume a download task
pub async fn downloader_resume(task_id: usize) -> Result<()> {
    let session = SESSION
        .get()
        .context("Downloader not initialized")?;

    let handle = {
        let handles = TORRENT_HANDLES.read();
        handles.get(&task_id).cloned()
    };

    if let Some(handle) = handle {
        session.unpause(&handle).await.context("Failed to resume torrent")?;
        Ok(())
    } else {
        bail!("Task not found: {}", task_id)
    }
}

/// Remove a download task
pub async fn downloader_remove(task_id: usize, delete_files: bool) -> Result<()> {
    let session = SESSION
        .get()
        .context("Downloader not initialized")?;

    session
        .delete(librqbit::api::TorrentIdOrHash::Id(task_id), delete_files)
        .await
        .context("Failed to remove torrent")?;

    TORRENT_HANDLES.write().remove(&task_id);

    Ok(())
}

/// Get information about a specific task
pub async fn downloader_get_task_info(task_id: usize) -> Result<DownloadTaskInfo> {
    let handle = {
        let handles = TORRENT_HANDLES.read();
        handles.get(&task_id).cloned()
    };

    if let Some(handle) = handle {
        let stats = handle.stats();
        let name = handle.name().unwrap_or_else(|| format!("Task {}", task_id));
        let output_folder = TASK_OUTPUT_FOLDERS
            .read()
            .get(&task_id)
            .cloned()
            .unwrap_or_default();

        let status = get_task_status(&stats);
        let progress = if stats.total_bytes > 0 {
            stats.progress_bytes as f64 / stats.total_bytes as f64
        } else {
            0.0
        };

        // Get speed from live stats
        let (download_speed, upload_speed, num_peers) = if let Some(live) = &stats.live {
            let down = (live.download_speed.mbps * 1024.0 * 1024.0 / 8.0) as u64;
            let up = (live.upload_speed.mbps * 1024.0 * 1024.0 / 8.0) as u64;
            let peers = (live.snapshot.peer_stats.queued + live.snapshot.peer_stats.connecting + live.snapshot.peer_stats.live) as usize;
            (down, up, peers)
        } else {
            (0, 0, 0)
        };

        Ok(DownloadTaskInfo {
            id: task_id,
            name,
            status,
            total_bytes: stats.total_bytes,
            downloaded_bytes: stats.progress_bytes,
            uploaded_bytes: stats.uploaded_bytes,
            download_speed,
            upload_speed,
            progress,
            num_peers,
            output_folder,
        })
    } else {
        bail!("Task not found: {}", task_id)
    }
}

fn get_task_status(stats: &TorrentStats) -> DownloadTaskStatus {
    if stats.error.is_some() {
        return DownloadTaskStatus::Error;
    }
    
    if stats.finished {
        return DownloadTaskStatus::Finished;
    }

    match stats.state {
        TorrentStatsState::Initializing => DownloadTaskStatus::Initializing,
        TorrentStatsState::Live => DownloadTaskStatus::Live,
        TorrentStatsState::Paused => DownloadTaskStatus::Paused,
        TorrentStatsState::Error => DownloadTaskStatus::Error,
    }
}

/// Get all tasks
pub async fn downloader_get_all_tasks() -> Result<Vec<DownloadTaskInfo>> {
    let session = SESSION.get();
    if session.is_none() {
        return Ok(vec![]);
    }
    let session = session.unwrap();

    // Use RwLock to collect tasks since with_torrents takes Fn (not FnMut)
    let tasks: RwLock<Vec<DownloadTaskInfo>> = RwLock::new(Vec::new());

    session.with_torrents(|torrents| {
        for (id, handle) in torrents {
            let stats = handle.stats();
            let name = handle.name().unwrap_or_else(|| format!("Task {}", id));
            let output_folder = TASK_OUTPUT_FOLDERS
                .read()
                .get(&id)
                .cloned()
                .unwrap_or_default();

            let status = get_task_status(&stats);
            let progress = if stats.total_bytes > 0 {
                stats.progress_bytes as f64 / stats.total_bytes as f64
            } else {
                0.0
            };

            // Get speed from live stats
            let (download_speed, upload_speed, num_peers) = if let Some(live) = &stats.live {
                let down = (live.download_speed.mbps * 1024.0 * 1024.0 / 8.0) as u64;
                let up = (live.upload_speed.mbps * 1024.0 * 1024.0 / 8.0) as u64;
                let peers = (live.snapshot.peer_stats.queued + live.snapshot.peer_stats.connecting + live.snapshot.peer_stats.live) as usize;
                (down, up, peers)
            } else {
                (0, 0, 0)
            };

            tasks.write().push(DownloadTaskInfo {
                id,
                name,
                status,
                total_bytes: stats.total_bytes,
                downloaded_bytes: stats.progress_bytes,
                uploaded_bytes: stats.uploaded_bytes,
                download_speed,
                upload_speed,
                progress,
                num_peers,
                output_folder,
            });

            // Update handles cache
            TORRENT_HANDLES.write().insert(id, handle.clone());
        }
    });

    Ok(tasks.into_inner())
}

/// Get global statistics
pub async fn downloader_get_global_stats() -> Result<DownloadGlobalStat> {
    let tasks = downloader_get_all_tasks().await?;

    let mut stat = DownloadGlobalStat::default();
    
    for task in &tasks {
        stat.download_speed += task.download_speed;
        stat.upload_speed += task.upload_speed;
        
        match task.status {
            DownloadTaskStatus::Live => stat.num_active += 1,
            DownloadTaskStatus::Paused | DownloadTaskStatus::Initializing => stat.num_waiting += 1,
            _ => {}
        }
    }

    Ok(stat)
}

/// Check if a task with given name exists
pub async fn downloader_is_name_in_task(name: String) -> bool {
    if let Ok(tasks) = downloader_get_all_tasks().await {
        for task in tasks {
            if task.name.contains(&name) {
                return true;
            }
        }
    }
    false
}

/// Pause all tasks
pub async fn downloader_pause_all() -> Result<()> {
    let session = SESSION
        .get()
        .context("Downloader not initialized")?;

    let handles: Vec<_> = TORRENT_HANDLES.read().values().cloned().collect();
    
    for handle in handles {
        let _ = session.pause(&handle).await;
    }
    
    Ok(())
}

/// Resume all tasks
pub async fn downloader_resume_all() -> Result<()> {
    let session = SESSION
        .get()
        .context("Downloader not initialized")?;

    let handles: Vec<_> = TORRENT_HANDLES.read().values().cloned().collect();
    
    for handle in handles {
        let _ = session.unpause(&handle).await;
    }
    
    Ok(())
}

/// Stop the downloader session
pub async fn downloader_stop() -> Result<()> {
    if let Some(session) = SESSION.get() {
        session.stop().await;
    }
    TORRENT_HANDLES.write().clear();
    TASK_OUTPUT_FOLDERS.write().clear();
    Ok(())
}
