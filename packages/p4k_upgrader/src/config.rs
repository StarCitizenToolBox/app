use crate::error::{fail, Result};
use serde::{Deserialize, Serialize};
use std::fmt;
use std::path::{Path, PathBuf};
use std::sync::atomic::{AtomicU64, AtomicUsize, Ordering};
use std::sync::Arc;
use std::time::{Duration, SystemTime, UNIX_EPOCH};

#[derive(Debug, Clone, Copy, Default, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum DownloadSource {
    #[default]
    Official,
    ChineseWikiR2,
}

static DOWNLOAD_THREAD_LIMIT: AtomicUsize = AtomicUsize::new(32);
static BASE_DOWNLOAD_THREAD_LIMIT: AtomicUsize = AtomicUsize::new(8);
static UPDATE_CONTROL_STATE: AtomicUsize = AtomicUsize::new(0);
const NETWORK_PROGRESS_REPORT_INTERVAL_MS: u64 = 250;

pub fn set_download_thread_limit(value: usize) {
    DOWNLOAD_THREAD_LIMIT.store(value.clamp(1, 96), Ordering::Relaxed);
}

pub fn download_thread_limit() -> usize {
    DOWNLOAD_THREAD_LIMIT.load(Ordering::Relaxed).clamp(1, 96)
}

pub fn set_base_download_thread_limit(value: usize) {
    BASE_DOWNLOAD_THREAD_LIMIT.store(value.clamp(1, 32), Ordering::Relaxed);
}

pub fn base_download_thread_limit() -> usize {
    BASE_DOWNLOAD_THREAD_LIMIT
        .load(Ordering::Relaxed)
        .clamp(1, 32)
}

pub fn redact_url_query(url: &str) -> String {
    match url.split_once('?') {
        Some((base, _)) => format!("{base}?<redacted>"),
        None => url.to_string(),
    }
}

pub fn reset_update_control() {
    UPDATE_CONTROL_STATE.store(0, Ordering::Relaxed);
}

pub fn pause_update() {
    UPDATE_CONTROL_STATE.store(1, Ordering::Relaxed);
}

pub fn resume_update() {
    UPDATE_CONTROL_STATE.store(0, Ordering::Relaxed);
}

pub fn cancel_update() {
    UPDATE_CONTROL_STATE.store(2, Ordering::Relaxed);
}

pub const SIGNED_URL_REFRESH_PHASE: &str = "signed_url_refresh_required";

/// The stub never downloads, so there are no in-flight signatures to replace.
pub fn update_signed_urls(_urls: &[String]) -> usize {
    0
}

pub fn is_signed_url_rejection(error: &str) -> bool {
    let lower = error.to_ascii_lowercase();
    lower.contains("invalid signed request")
        || (lower.contains("code=403") && lower.contains("mcdn.robertsspaceindustries.com"))
}

pub fn wait_if_paused_or_cancelled() -> Result<()> {
    loop {
        match UPDATE_CONTROL_STATE.load(Ordering::Relaxed) {
            0 => return Ok(()),
            1 => std::thread::sleep(Duration::from_millis(250)),
            _ => return fail("P4K update cancelled by user"),
        }
    }
}

pub fn wait_before_download_retry(config: &Config) -> Result<()> {
    let mut remaining = config.download_retry_delay_ms;
    while remaining > 0 {
        wait_if_paused_or_cancelled()?;
        let step = remaining.min(250);
        std::thread::sleep(Duration::from_millis(step));
        remaining -= step;
    }
    wait_if_paused_or_cancelled()
}

pub fn append_error_log(_config: &Config, message: &str) {
    eprintln!("{message}");
}

#[derive(Debug, Clone, Default, Serialize, Deserialize)]
pub struct ProgressEvent {
    pub phase: String,
    pub name: String,
    pub current: usize,
    pub total: usize,
    pub downloaded_bytes: u64,
    pub total_bytes: u64,
    pub active_downloads: usize,
    pub thread_limit: usize,
    pub message: String,
}

type ProgressCallback = dyn Fn(ProgressEvent) + Send + Sync + 'static;

#[derive(Clone, Default)]
pub struct ProgressReporter(Option<Arc<ProgressCallback>>);

impl ProgressReporter {
    pub fn new(callback: impl Fn(ProgressEvent) + Send + Sync + 'static) -> Self {
        Self(Some(Arc::new(callback)))
    }

    pub fn report(&self, event: ProgressEvent) {
        if let Some(callback) = &self.0 {
            callback(event);
        }
    }
}

impl fmt::Debug for ProgressReporter {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("ProgressReporter")
            .field("enabled", &self.0.is_some())
            .finish()
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(default)]
pub struct Config {
    pub download_source: DownloadSource,
    pub manifest_source: String,
    pub mirror_bases: Vec<String>,
    pub official_bases: Vec<String>,
    pub p4k_base_url: String,
    pub p4k_base_verification_url: String,
    pub object_path_templates: Vec<String>,
    pub cache_dir: PathBuf,
    pub existing_p4k: PathBuf,
    pub output_p4k: PathBuf,
    pub loose_root: PathBuf,
    pub update_p4k: bool,
    pub update_loose_files: bool,
    pub replace_existing_p4k: bool,
    pub inplace_update_p4k: bool,
    pub verify_after_assemble: bool,
    pub verify_crc32_for_loose: bool,
    pub verify_cig_structure: bool,
    pub verify_before_inplace: bool,
    pub resume_incomplete_inplace_update: bool,
    pub refuse_inplace_when_existing_table16: bool,
    pub remove_extra_p4k_entries: bool,
    pub fallback_rebuild_on_inplace_verify_failure: bool,
    pub p4k_sector_size: u64,
    pub max_entries: Option<usize>,
    pub include_regex: String,
    pub exclude_regex: String,
    pub user_agent: String,
    pub request_cookie: String,
    pub rsi_token: String,
    pub download_timeout_sec: u64,
    pub chunk_size: usize,
    pub download_retry_count: usize,
    pub download_retry_delay_ms: u64,
    pub signed_url_refresh_timeout_sec: u64,
    #[serde(skip)]
    pub progress: ProgressReporter,
    #[serde(skip)]
    pub http_client: Option<reqwest::blocking::Client>,
    #[serde(skip)]
    pub network_downloaded_bytes: Arc<AtomicU64>,
    #[serde(skip)]
    pub network_progress_last_report_ms: Arc<AtomicU64>,
}

impl Default for Config {
    fn default() -> Self {
        Self {
            download_source: DownloadSource::Official,
            manifest_source: String::new(),
            mirror_bases: Vec::new(),
            official_bases: Vec::new(),
            p4k_base_url: String::new(),
            p4k_base_verification_url: String::new(),
            object_path_templates: vec![
                "{sha256_upper}".to_string(),
                "{sha256}".to_string(),
                "{sha2}/{sha4}/{sha256}".to_string(),
                "{sha2}/{sha4}/{sha256}.blob".to_string(),
                "{file_name_url}".to_string(),
            ],
            cache_dir: PathBuf::from("cache"),
            existing_p4k: PathBuf::from(r"E:\StarCitizen\LIVE\Data.p4k"),
            output_p4k: PathBuf::from(r"E:\StarCitizen\LIVE\Data.p4k.tmp"),
            loose_root: PathBuf::from(r"E:\StarCitizen\LIVE"),
            update_p4k: true,
            update_loose_files: false,
            replace_existing_p4k: true,
            inplace_update_p4k: true,
            verify_after_assemble: true,
            verify_crc32_for_loose: false,
            verify_cig_structure: true,
            verify_before_inplace: true,
            resume_incomplete_inplace_update: true,
            refuse_inplace_when_existing_table16: false,
            remove_extra_p4k_entries: true,
            fallback_rebuild_on_inplace_verify_failure: true,
            p4k_sector_size: 4096,
            max_entries: None,
            include_regex: String::new(),
            exclude_regex: String::new(),
            user_agent: "P4KUpdateVerifyToolkit/1.0".to_string(),
            request_cookie: String::new(),
            rsi_token: String::new(),
            download_timeout_sec: 60,
            chunk_size: 1024 * 1024,
            download_retry_count: 10,
            download_retry_delay_ms: 1000,
            signed_url_refresh_timeout_sec: 0,
            progress: ProgressReporter::default(),
            http_client: None,
            network_downloaded_bytes: Arc::new(AtomicU64::new(0)),
            network_progress_last_report_ms: Arc::new(AtomicU64::new(0)),
        }
    }
}

impl Config {
    pub fn with_download_source(mut self, source: DownloadSource) -> Self {
        self.download_source = source;
        self
    }

    pub fn chinese_wiki_r2(
        existing_p4k: impl Into<PathBuf>,
        cache_dir: impl Into<PathBuf>,
    ) -> Self {
        let existing_p4k = existing_p4k.into();
        let output_p4k = existing_p4k.with_extension("p4k.tmp");
        let loose_root = existing_p4k
            .parent()
            .unwrap_or_else(|| Path::new("."))
            .to_path_buf();
        Self {
            download_source: DownloadSource::ChineseWikiR2,
            manifest_source: String::new(),
            mirror_bases: Vec::new(),
            official_bases: Vec::new(),
            p4k_base_url: String::new(),
            p4k_base_verification_url: String::new(),
            object_path_templates: Vec::new(),
            cache_dir: cache_dir.into(),
            existing_p4k,
            output_p4k,
            loose_root,
            request_cookie: String::new(),
            rsi_token: String::new(),
            ..Self::default()
        }
    }

    pub fn from_file(path: impl AsRef<Path>, _require_object_source: bool) -> Result<Self> {
        let path = path.as_ref();
        if !path.exists() {
            let template = serde_json::to_string_pretty(&Self::default())?;
            std::fs::write(path, template)?;
            return fail(format!(
                "created config template: {}. Edit it and run again.",
                path.display()
            ));
        }

        let content = std::fs::read_to_string(path)?;
        let content = content.strip_prefix('\u{feff}').unwrap_or(&content);
        let mut config: Self = serde_json::from_str(content)?;
        if config.manifest_source.trim().is_empty() {
            return fail("config manifest_source is empty");
        }
        let base = path.parent().unwrap_or_else(|| Path::new("."));
        if !config.cache_dir.is_absolute() {
            config.cache_dir = base.join(&config.cache_dir);
        }
        if !is_url(&config.manifest_source) {
            let manifest_path = Path::new(&config.manifest_source);
            if !manifest_path.is_absolute() {
                config.manifest_source = base.join(manifest_path).to_string_lossy().to_string();
            }
        }
        if config.chunk_size == 0 {
            return fail("config chunk_size must be greater than zero");
        }
        if config.p4k_sector_size <= 1 || !config.p4k_sector_size.is_power_of_two() {
            return fail("config p4k_sector_size must be a power of two");
        }
        Ok(config)
    }

    pub fn download_timeout(&self) -> Duration {
        Duration::from_secs(self.download_timeout_sec)
    }

    pub fn with_http_client(&self) -> Result<Self> {
        let mut config = self.clone();
        if config.http_client.is_none() {
            config.http_client = Some(config.build_http_client()?);
        }
        Ok(config)
    }

    pub fn download_client(&self) -> Result<reqwest::blocking::Client> {
        match &self.http_client {
            Some(client) => Ok(client.clone()),
            None => self.build_http_client(),
        }
    }

    pub fn reset_network_download_progress(&self) {
        self.network_downloaded_bytes.store(0, Ordering::Relaxed);
        self.network_progress_last_report_ms
            .store(0, Ordering::Relaxed);
    }

    pub fn record_network_download_bytes(
        &self,
        bytes: u64,
        active_downloads: usize,
        thread_limit: usize,
    ) {
        if bytes == 0 {
            return;
        }
        let downloaded = self
            .network_downloaded_bytes
            .fetch_add(bytes, Ordering::Relaxed)
            .saturating_add(bytes);
        let now = current_time_millis();
        let last = self.network_progress_last_report_ms.load(Ordering::Relaxed);
        if now.saturating_sub(last) < NETWORK_PROGRESS_REPORT_INTERVAL_MS {
            return;
        }
        if self
            .network_progress_last_report_ms
            .compare_exchange(last, now, Ordering::Relaxed, Ordering::Relaxed)
            .is_ok()
        {
            self.progress.report(ProgressEvent {
                phase: "network_speed".to_string(),
                name: String::new(),
                current: 0,
                total: 0,
                downloaded_bytes: downloaded,
                total_bytes: 1,
                active_downloads,
                thread_limit,
                message: String::new(),
            });
        }
    }

    fn build_http_client(&self) -> Result<reqwest::blocking::Client> {
        Ok(reqwest::blocking::Client::builder()
            .timeout(self.download_timeout())
            .connect_timeout(self.download_timeout().min(Duration::from_secs(30)))
            .user_agent(self.user_agent.clone())
            .http2_adaptive_window(true)
            .pool_max_idle_per_host(128)
            .tcp_nodelay(true)
            .no_gzip()
            .no_deflate()
            .build()?)
    }
}

fn current_time_millis() -> u64 {
    SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .map(|duration| duration.as_millis() as u64)
        .unwrap_or_default()
}

pub(crate) fn is_url(value: &str) -> bool {
    value.starts_with("http://") || value.starts_with("https://")
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::sync::Mutex;

    /// Thread limits and the pause/cancel flag are process globals.
    static GLOBALS: Mutex<()> = Mutex::new(());

    fn write_config(dir: &Path, json: &str) -> PathBuf {
        let path = dir.join("config.json");
        std::fs::write(&path, json).unwrap();
        path
    }

    fn error_text<T: fmt::Debug>(result: Result<T>) -> String {
        result.unwrap_err().to_string()
    }

    #[test]
    fn missing_config_writes_an_editable_template() {
        let dir = tempfile::tempdir().unwrap();
        let path = dir.path().join("config.json");

        let err = error_text(Config::from_file(&path, true));
        assert!(err.contains("created config template"), "{err}");

        let template: Config =
            serde_json::from_str(&std::fs::read_to_string(&path).unwrap()).unwrap();
        assert_eq!(
            template.object_path_templates,
            Config::default().object_path_templates
        );
        assert_eq!(template.p4k_sector_size, 4096);
        // The template is not runnable until a manifest is filled in.
        let err = error_text(Config::from_file(&path, true));
        assert!(err.contains("manifest_source is empty"), "{err}");
    }

    #[test]
    fn relative_paths_resolve_against_the_config_directory() {
        let dir = tempfile::tempdir().unwrap();
        let path = write_config(
            dir.path(),
            "\u{feff}{\"manifest_source\": \"manifests/live.json\", \"cache_dir\": \"objects\"}",
        );
        let config = Config::from_file(&path, true).unwrap();
        assert_eq!(config.cache_dir, dir.path().join("objects"));
        assert_eq!(
            PathBuf::from(&config.manifest_source),
            dir.path().join("manifests/live.json")
        );
        // Unspecified fields keep their defaults.
        assert_eq!(config.download_retry_count, 10);
        assert_eq!(config.download_source, DownloadSource::Official);
    }

    #[test]
    fn urls_and_absolute_paths_are_left_alone() {
        let dir = tempfile::tempdir().unwrap();
        let absolute_cache = dir.path().join("abs-cache");
        let json = serde_json::json!({
            "manifest_source": "https://example.invalid/manifest.json?sig=1",
            "cache_dir": absolute_cache,
            "download_source": "chinese_wiki_r2",
        });
        let path = write_config(dir.path(), &json.to_string());
        let config = Config::from_file(&path, true).unwrap();
        assert_eq!(
            config.manifest_source,
            "https://example.invalid/manifest.json?sig=1"
        );
        assert_eq!(config.cache_dir, absolute_cache);
        assert_eq!(config.download_source, DownloadSource::ChineseWikiR2);
    }

    #[test]
    fn invalid_sizes_are_rejected() {
        let dir = tempfile::tempdir().unwrap();
        let cases = [
            (r#"{"manifest_source": " "}"#, "manifest_source is empty"),
            (
                r#"{"manifest_source": "m.json", "chunk_size": 0}"#,
                "chunk_size",
            ),
            (
                r#"{"manifest_source": "m.json", "p4k_sector_size": 0}"#,
                "power of two",
            ),
            (
                r#"{"manifest_source": "m.json", "p4k_sector_size": 1}"#,
                "power of two",
            ),
            (
                r#"{"manifest_source": "m.json", "p4k_sector_size": 3000}"#,
                "power of two",
            ),
        ];
        for (json, expected) in cases {
            let path = write_config(dir.path(), json);
            let err = error_text(Config::from_file(&path, true));
            assert!(err.contains(expected), "{json}: {err}");
        }
        let path = write_config(
            dir.path(),
            r#"{"manifest_source": "m.json", "p4k_sector_size": 512}"#,
        );
        assert!(Config::from_file(&path, true).is_ok());

        let path = write_config(dir.path(), "{ not json");
        assert!(matches!(
            Config::from_file(&path, true),
            Err(crate::error::Error::Json(_))
        ));
    }

    #[test]
    fn mirror_config_places_temp_p4k_next_to_the_game() {
        let game = Path::new("D:/RSI/StarCitizen/LIVE");
        let config = Config::chinese_wiki_r2(game.join("Data.p4k"), "D:/cache");
        assert_eq!(config.download_source, DownloadSource::ChineseWikiR2);
        assert_eq!(config.output_p4k, game.join("Data.p4k.tmp"));
        assert_eq!(config.loose_root, game);
        assert_eq!(config.cache_dir, PathBuf::from("D:/cache"));
        assert!(config.object_path_templates.is_empty());
        // Everything else matches the official defaults.
        assert!(config.update_p4k && config.verify_cig_structure);
    }

    #[test]
    fn thread_limits_are_clamped() {
        let _guard = GLOBALS.lock().unwrap_or_else(|e| e.into_inner());
        set_download_thread_limit(0);
        assert_eq!(download_thread_limit(), 1);
        set_download_thread_limit(500);
        assert_eq!(download_thread_limit(), 96);
        set_download_thread_limit(32);
        assert_eq!(download_thread_limit(), 32);

        set_base_download_thread_limit(0);
        assert_eq!(base_download_thread_limit(), 1);
        set_base_download_thread_limit(100);
        assert_eq!(base_download_thread_limit(), 32);
        set_base_download_thread_limit(8);
    }

    #[test]
    fn cancel_stops_waiting_workers_and_resume_releases_paused_ones() {
        let _guard = GLOBALS.lock().unwrap_or_else(|e| e.into_inner());
        reset_update_control();
        assert!(wait_if_paused_or_cancelled().is_ok());

        cancel_update();
        let err = error_text(wait_if_paused_or_cancelled());
        assert!(err.contains("cancelled"), "{err}");
        let config = Config {
            download_retry_delay_ms: 10_000,
            ..Config::default()
        };
        // A retry back-off is cut short by a cancel instead of sleeping it out.
        let start = std::time::Instant::now();
        assert!(wait_before_download_retry(&config).is_err());
        assert!(start.elapsed() < Duration::from_secs(2));

        pause_update();
        let waiter = std::thread::spawn(wait_if_paused_or_cancelled);
        std::thread::sleep(Duration::from_millis(100));
        assert!(!waiter.is_finished());
        resume_update();
        assert!(waiter.join().unwrap().is_ok());
        reset_update_control();
    }

    #[test]
    fn signed_url_rejections_are_recognised() {
        assert!(is_signed_url_rejection(
            "HTTP status error: code=403 raw=Google-Edge-Cache: Invalid Signed Request"
        ));
        assert!(is_signed_url_rejection(
            "code=403 url=https://sc-prod.MCDN.robertsspaceindustries.com/a?<redacted>"
        ));
        assert!(!is_signed_url_rejection(
            "code=404 url=https://sc-prod.mcdn.robertsspaceindustries.com/a"
        ));
        assert!(!is_signed_url_rejection(
            "code=403 url=https://example.invalid/a"
        ));
        assert_eq!(update_signed_urls(&["https://a".into()]), 0);
    }

    #[test]
    fn url_queries_are_redacted_from_logs() {
        assert_eq!(
            redact_url_query("https://cdn.invalid/obj?Expires=1&Signature=abc"),
            "https://cdn.invalid/obj?<redacted>"
        );
        assert_eq!(
            redact_url_query("https://cdn.invalid/obj"),
            "https://cdn.invalid/obj"
        );
    }

    #[test]
    fn network_progress_accumulates_and_throttles_reports() {
        let events = Arc::new(Mutex::new(Vec::new()));
        let sink = events.clone();
        let config = Config {
            progress: ProgressReporter::new(move |event| sink.lock().unwrap().push(event)),
            ..Config::default()
        };

        config.record_network_download_bytes(0, 1, 8);
        assert!(events.lock().unwrap().is_empty());

        config.record_network_download_bytes(1000, 2, 8);
        assert_ne!(
            config
                .network_progress_last_report_ms
                .load(Ordering::Relaxed),
            0
        );
        // Move the last report ahead of the clock so the second sample is
        // inside the window however long the test is paused between calls.
        config
            .network_progress_last_report_ms
            .store(current_time_millis() + 60_000, Ordering::Relaxed);
        config.record_network_download_bytes(500, 2, 8);
        {
            let events = events.lock().unwrap();
            assert_eq!(
                events.len(),
                1,
                "second sample falls inside the 250 ms window"
            );
            assert_eq!(events[0].phase, "network_speed");
            assert_eq!(events[0].downloaded_bytes, 1000);
            assert_eq!(events[0].active_downloads, 2);
            assert_eq!(events[0].thread_limit, 8);
        }
        assert_eq!(
            config.network_downloaded_bytes.load(Ordering::Relaxed),
            1500
        );

        config.reset_network_download_progress();
        config.record_network_download_bytes(7, 1, 8);
        let events = events.lock().unwrap();
        assert_eq!(events.len(), 2);
        assert_eq!(events[1].downloaded_bytes, 7);
    }
}
