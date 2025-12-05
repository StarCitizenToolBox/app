use std::collections::HashMap;
use std::num::NonZeroU32;
use std::path::PathBuf;
use std::sync::Arc;

use anyhow::{bail, Context, Result};
use bytes::Bytes;
use flutter_rust_bridge::frb;
use librqbit::{
    AddTorrent, AddTorrentOptions, AddTorrentResponse, ManagedTorrent, Session, SessionOptions, SessionPersistenceConfig, TorrentStats, TorrentStatsState, WebSeedConfig, api::TorrentIdOrHash, dht::PersistentDhtConfig, limits::LimitsConfig
};
use parking_lot::RwLock;
use serde::{Deserialize, Serialize};
use tokio::sync::Mutex;

// Type alias for ManagedTorrentHandle
type ManagedTorrentHandle = Arc<ManagedTorrent>;

// Global session instance - using RwLock to allow restart
static SESSION: once_cell::sync::Lazy<RwLock<Option<Arc<Session>>>> =
    once_cell::sync::Lazy::new(|| RwLock::new(None));
static SESSION_INIT_LOCK: once_cell::sync::Lazy<Mutex<()>> =
    once_cell::sync::Lazy::new(|| Mutex::new(()));

// Store torrent handles
static TORRENT_HANDLES: once_cell::sync::Lazy<RwLock<HashMap<usize, ManagedTorrentHandle>>> =
    once_cell::sync::Lazy::new(|| RwLock::new(HashMap::new()));

// Store completed tasks info (in-memory cache, cleared on restart)
static COMPLETED_TASKS_CACHE: once_cell::sync::Lazy<RwLock<Vec<DownloadTaskInfo>>> =
    once_cell::sync::Lazy::new(|| RwLock::new(Vec::new()));

/// Download task status
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub enum DownloadTaskStatus {
    /// Checking/verifying existing files
    Checking,
    /// Actively downloading
    Live,
    /// Paused
    Paused,
    /// Error occurred
    Error,
    /// Download completed
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

/// Initialize the download manager session with persistence enabled
/// 
/// Parameters:
/// - working_dir: The directory to store session data (persistence, DHT, etc.)
/// - default_download_dir: The default directory to store downloads
/// - upload_limit_bps: Upload speed limit in bytes per second (0 = unlimited)
/// - download_limit_bps: Download speed limit in bytes per second (0 = unlimited)
pub async fn downloader_init(
    working_dir: String,
    default_download_dir: String,
    upload_limit_bps: Option<u32>,
    download_limit_bps: Option<u32>,
) -> Result<()> {
    // Already initialized
    if SESSION.read().is_some() {
        return Ok(());
    }

    let _lock = SESSION_INIT_LOCK.lock().await;
    
    // Double check after acquiring lock
    if SESSION.read().is_some() {
        return Ok(());
    }

    // Working directory for persistence and session data
    let working_folder = PathBuf::from(&working_dir);
    std::fs::create_dir_all(&working_folder)?;
    
    // Default download folder
    let output_folder = PathBuf::from(&default_download_dir);
    std::fs::create_dir_all(&output_folder)?;
    
    // Create persistence folder for session state in working directory
    let persistence_folder = working_folder.join("rqbit-session");
    std::fs::create_dir_all(&persistence_folder)?;
    
    // DHT persistence file in working directory
    let dht_persistence_file = working_folder.join("dht.json");

    let session = Session::new_with_opts(
        output_folder,
        SessionOptions {
            disable_dht: false,
            disable_dht_persistence: false,
            // Configure DHT persistence to use working directory
            dht_config: Some(PersistentDhtConfig {
                config_filename: Some(dht_persistence_file),
                ..Default::default()
            }),
            // Enable JSON-based session persistence for task recovery
            persistence: Some(SessionPersistenceConfig::Json {
                folder: Some(persistence_folder),
            }),
            fastresume: false,
            // Configure rate limits
            ratelimits: LimitsConfig {
                upload_bps: upload_limit_bps.and_then(NonZeroU32::new),
                download_bps: download_limit_bps.and_then(NonZeroU32::new),
            },
            webseed_config: Some(WebSeedConfig{
                max_concurrent_per_source: 32,
                max_total_concurrent: 64,
                request_timeout_secs: 30,
                prefer_for_large_gaps: true,
                min_gap_for_webseed: 10,
                max_errors_before_disable: 10,
                disable_cooldown_secs: 600,
                adaptive_increase_threshold: 5,
                adaptive_decrease_threshold: 10,
                ..Default::default()
            }),
            ..Default::default()
        },
    )
    .await
    .context("Failed to create rqbit session")?;

    *SESSION.write() = Some(session);

    Ok(())
}

/// Check if the downloader is initialized
#[frb(sync)]
pub fn downloader_is_initialized() -> bool {
    SESSION.read().is_some()
}

/// Check if there are pending tasks to restore from session file (without starting the downloader)
/// This reads the session.json file directly to check if there are any torrents saved.
/// 
/// Parameters:
/// - working_dir: The directory where session data is stored (same as passed to downloader_init)
/// 
/// Returns: true if there are tasks to restore, false otherwise
#[frb(sync)]
pub fn downloader_has_pending_session_tasks(working_dir: String) -> bool {
    let session_file = PathBuf::from(&working_dir)
        .join("rqbit-session")
        .join("session.json");
    
    if !session_file.exists() {
        return false;
    }
    
    // Try to read and parse the session file
    match std::fs::read_to_string(&session_file) {
        Ok(content) => {
            // Parse as JSON to check if there are any torrents
            // The structure is: { "torrents": { "0": {...}, "1": {...} } }
            match serde_json::from_str::<serde_json::Value>(&content) {
                Ok(json) => {
                    if let Some(torrents) = json.get("torrents") {
                        if let Some(obj) = torrents.as_object() {
                            return !obj.is_empty();
                        }
                    }
                    false
                }
                Err(_) => false,
            }
        }
        Err(_) => false,
    }
}

/// Helper function to get session
fn get_session() -> Result<Arc<Session>> {
    SESSION.read()
        .clone()
        .context("Downloader not initialized. Call downloader_init first.")
}

/// Add a torrent from bytes (e.g., .torrent file content)
pub async fn downloader_add_torrent(
    torrent_bytes: Vec<u8>,
    output_folder: Option<String>,
    trackers: Option<Vec<String>>,
) -> Result<usize> {
    let session = get_session()?;

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
            TORRENT_HANDLES.write().insert(id, handle);
            Ok(id)
        }
        AddTorrentResponse::AlreadyManaged(id, handle) => {
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
    let session = get_session()?;

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
            TORRENT_HANDLES.write().insert(id, handle);
            Ok(id)
        }
        AddTorrentResponse::AlreadyManaged(id, handle) => {
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
    let session = get_session()?;

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
    let session = get_session()?;

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
    let session = get_session()?;

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
        // Get output_folder from handle's shared options
        let output_folder = handle
            .shared()
            .options
            .output_folder
            .to_string_lossy()
            .into_owned();

        let status = get_task_status(&stats);
        let progress = if stats.total_bytes > 0 {
            stats.progress_bytes as f64 / stats.total_bytes as f64
        } else {
            0.0
        };

        // Get speed from live stats
        // Note: mbps in rqbit is actually MiB/s (bytes_per_second / 1024 / 1024)
        // So we convert back to bytes per second: mbps * 1024 * 1024
        let (download_speed, upload_speed, num_peers) = if let Some(live) = &stats.live {
            let down = (live.download_speed.mbps * 1024.0 * 1024.0) as u64;
            let up = (live.upload_speed.mbps * 1024.0 * 1024.0) as u64;
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
        TorrentStatsState::Initializing => DownloadTaskStatus::Checking,
        TorrentStatsState::Live => DownloadTaskStatus::Live,
        TorrentStatsState::Paused => DownloadTaskStatus::Paused,
        TorrentStatsState::Error => DownloadTaskStatus::Error,
    }
}

/// Get all tasks
pub async fn downloader_get_all_tasks() -> Result<Vec<DownloadTaskInfo>> {
    let session_guard = SESSION.read();
    let session = match session_guard.as_ref() {
        Some(s) => s.clone(),
        None => return Ok(vec![]),
    };
    drop(session_guard);

    // Use RwLock to collect tasks since with_torrents takes Fn (not FnMut)
    let tasks: RwLock<Vec<DownloadTaskInfo>> = RwLock::new(Vec::new());

    session.with_torrents(|torrents| {
        for (id, handle) in torrents {
            let stats = handle.stats();
            let name = handle.name().unwrap_or_else(|| format!("Task {}", id));
            // Get output_folder from handle's shared options
            let output_folder = handle
                .shared()
                .options
                .output_folder
                .to_string_lossy()
                .into_owned();

            let status = get_task_status(&stats);
            let progress = if stats.total_bytes > 0 {
                stats.progress_bytes as f64 / stats.total_bytes as f64
            } else {
                0.0
            };

            // Get speed from live stats
            // Note: mbps in rqbit is actually MiB/s (bytes_per_second / 1024 / 1024)
            // So we convert back to bytes per second: mbps * 1024 * 1024
            let (download_speed, upload_speed, num_peers) = if let Some(live) = &stats.live {
                let down = (live.download_speed.mbps * 1024.0 * 1024.0) as u64;
                let up = (live.upload_speed.mbps * 1024.0 * 1024.0) as u64;
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
            DownloadTaskStatus::Paused | DownloadTaskStatus::Checking => stat.num_waiting += 1,
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
    let session = get_session()?;

    let handles: Vec<_> = TORRENT_HANDLES.read().values().cloned().collect();
    
    for handle in handles {
        let _ = session.pause(&handle).await;
    }
    
    Ok(())
}

/// Resume all tasks
pub async fn downloader_resume_all() -> Result<()> {
    let session = get_session()?;

    let handles: Vec<_> = TORRENT_HANDLES.read().values().cloned().collect();
    
    for handle in handles {
        let _ = session.unpause(&handle).await;
    }
    
    Ok(())
}

/// Stop the downloader session (pauses all tasks but keeps session)
pub async fn downloader_stop() -> Result<()> {
    let session = SESSION.read().clone();
    if let Some(session) = session {
        session.stop().await;
    }
    TORRENT_HANDLES.write().clear();
    Ok(())
}

/// Shutdown the downloader session completely (allows restart with new settings)
pub async fn downloader_shutdown() -> Result<()> {
    let session_opt = {
        let mut guard = SESSION.write();
        guard.take()
    };
    
    if let Some(session) = session_opt {
        session.stop().await;
    }
    
    TORRENT_HANDLES.write().clear();
    // Clear completed tasks cache on shutdown
    COMPLETED_TASKS_CACHE.write().clear();
    Ok(())
}

/// Get all completed tasks from cache (tasks removed by downloader_remove_completed_tasks)
/// This cache is cleared when the downloader is shutdown/restarted
#[frb(sync)]
pub fn downloader_get_completed_tasks_cache() -> Vec<DownloadTaskInfo> {
    COMPLETED_TASKS_CACHE.read().clone()
}

/// Clear the completed tasks cache manually
#[frb(sync)]
pub fn downloader_clear_completed_tasks_cache() {
    COMPLETED_TASKS_CACHE.write().clear();
}

/// Update global speed limits
/// Note: rqbit Session doesn't support runtime limit changes, 
/// this function is a placeholder that returns an error.
/// Speed limits should be set during downloader_init.
pub async fn downloader_update_speed_limits(
    _upload_limit_bps: Option<u32>,
    _download_limit_bps: Option<u32>,
) -> Result<()> {
    // rqbit Session is created with limits but doesn't support runtime updates
    // To change limits, the session needs to be recreated
    anyhow::bail!("Runtime speed limit changes not supported. Please restart the downloader.")
}

/// Remove all completed tasks (equivalent to aria2's --seed-time=0 behavior)
/// Removed tasks are cached in memory and can be queried via downloader_get_completed_tasks_cache
pub async fn downloader_remove_completed_tasks() -> Result<u32> {
    let session = get_session()?;

    let tasks = downloader_get_all_tasks().await?;
    let mut removed_count = 0u32;
    
    for task in tasks {
        if task.status == DownloadTaskStatus::Finished {
            // Check if handle exists (drop lock before await)
            let has_handle = TORRENT_HANDLES.read().contains_key(&task.id);
            if has_handle {
                // Use TorrentIdOrHash::Id for deletion (TorrentId is just usize)
                if session.delete(TorrentIdOrHash::Id(task.id), false).await.is_ok() {
                    // Save task info to cache before removing
                    COMPLETED_TASKS_CACHE.write().push(task.clone());
                    
                    TORRENT_HANDLES.write().remove(&task.id);
                    removed_count += 1;
                }
            }
        }
    }
    
    Ok(removed_count)
}

/// Check if there are any active (non-completed) tasks
pub async fn downloader_has_active_tasks() -> bool {
    if let Ok(tasks) = downloader_get_all_tasks().await {
        for task in tasks {
            if task.status != DownloadTaskStatus::Finished 
                && task.status != DownloadTaskStatus::Error {
                return true;
            }
        }
    }
    false
}
