use crate::frb_generated::StreamSink;
use anyhow::Result;
use p4k_upgrader::{
    cancel_update, clear_manifest_memory_cache, estimate_update_size, is_repair_update_mode,
    pause_update, reset_update_control, resume_update, run_repair_update, run_update,
    set_download_thread_limit, verify_existing, Config, DownloadSource, Error,
    MirrorUnavailableReason, ProgressEvent, ProgressReporter,
};
use std::path::PathBuf;
use std::sync::{Arc, Mutex};
use std::time::{Duration, Instant};

const PROGRESS_THROTTLE_INTERVAL: Duration = Duration::from_millis(150);
const PROGRESS_MEANINGFUL_DELTA_INTERVAL: Duration = Duration::from_millis(100);
const PROGRESS_MEANINGFUL_BYTE_DELTA: u64 = 64 * 1024 * 1024;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum P4kDownloadSource {
    Official,
    CommunityMirror,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum P4kMirrorUnavailableReason {
    NotEligible,
    NotMirrored,
    IncompleteBase,
    ReleaseMismatch,
}

#[derive(Debug, Clone)]
pub struct P4kMirrorUnavailable {
    pub reason: P4kMirrorUnavailableReason,
    pub object_sha256: Option<String>,
    pub compressed_size: Option<u64>,
    pub message: String,
}

#[derive(Debug, Clone)]
pub struct P4kUpgraderEstimateOutcome {
    pub report: Option<P4kUpgraderEstimateReport>,
    pub mirror_unavailable: Option<P4kMirrorUnavailable>,
    pub error_message: Option<String>,
}

#[derive(Debug, Clone)]
pub struct P4kUpgraderConfig {
    pub source: P4kDownloadSource,
    pub manifest_source: String,
    pub mirror_bases: Vec<String>,
    pub official_bases: Vec<String>,
    pub p4k_base_url: String,
    pub p4k_base_verification_url: String,
    pub object_path_templates: Vec<String>,
    pub request_cookie: String,
    pub rsi_token: String,
    pub cache_dir: String,
    pub game_dir: String,
    pub update_p4k: bool,
    pub update_loose_files: bool,
    pub inplace_update_p4k: bool,
    pub fallback_rebuild_on_inplace_verify_failure: bool,
    pub replace_existing_p4k: bool,
    pub verify_after_assemble: bool,
    pub verify_cig_structure: bool,
    pub max_entries: Option<usize>,
}

#[derive(Debug, Clone)]
pub struct P4kUpgraderEstimateEntry {
    pub name: String,
    pub sha256: String,
    pub compressed_size: u64,
}

#[derive(Debug, Clone)]
pub struct P4kUpgraderEstimateReport {
    pub manifest_entries: usize,
    pub base_download_required: bool,
    pub base_download_bytes: u64,
    pub p4k_entries_requiring_download: usize,
    pub loose_entries_requiring_download: usize,
    pub total_entries_requiring_download: usize,
    pub payload_download_bytes: u64,
    pub payload_estimate_exact: bool,
    pub payload_download_gb_decimal: f64,
    pub payload_download_gib: f64,
    /// E: static "full-download" reference value — the manifest's
    /// cumulative non-loose compressed_size. Used by the UI for the
    /// "总下载大小" display row. NOT diffed against cached bytes; the
    /// differential lives in `payload_download_bytes` (unchanged).
    pub total_download_bytes: u64,
    pub entries: Vec<P4kUpgraderEstimateEntry>,
}

#[derive(Debug, Clone)]
pub struct P4kUpgraderProgressEvent {
    pub phase: String,
    pub name: String,
    pub current: usize,
    pub total: usize,
    pub downloaded_bytes: u64,
    pub total_bytes: u64,
    pub active_downloads: usize,
    pub thread_limit: usize,
    pub message: String,
    pub mirror_unavailable: Option<P4kMirrorUnavailable>,
}

#[flutter_rust_bridge::frb(sync)]
pub fn p4k_upgrader_default_object_path_templates() -> Vec<String> {
    Config::default().object_path_templates
}

#[flutter_rust_bridge::frb(serialize)]
pub fn p4k_upgrader_estimate(config: P4kUpgraderConfig) -> P4kUpgraderEstimateOutcome {
    let config = match to_upgrader_config(config) {
        Ok(config) => config,
        Err(error) => return P4kUpgraderEstimateOutcome::from_anyhow(error),
    };
    reset_update_control();
    let report = match estimate_update_size(&config) {
        Ok(report) => report,
        Err(error) => return P4kUpgraderEstimateOutcome::from_upgrader(error),
    };
    P4kUpgraderEstimateOutcome {
        report: Some(P4kUpgraderEstimateReport {
            manifest_entries: report.manifest_entries,
            base_download_required: report.base_download_required,
            base_download_bytes: report.base_download_bytes,
            p4k_entries_requiring_download: report.p4k_entries_requiring_download,
            loose_entries_requiring_download: report.loose_entries_requiring_download,
            total_entries_requiring_download: report.total_entries_requiring_download,
            payload_download_bytes: report.payload_download_bytes,
            payload_estimate_exact: report.payload_estimate_exact,
            payload_download_gb_decimal: report.payload_download_gb_decimal,
            payload_download_gib: report.payload_download_gib,
            total_download_bytes: report.total_download_bytes,
            entries: report
                .entries
                .into_iter()
                .map(|entry| P4kUpgraderEstimateEntry {
                    name: entry.name,
                    sha256: entry.sha256,
                    compressed_size: entry.compressed_size,
                })
                .collect(),
        }),
        mirror_unavailable: None,
        error_message: None,
    }
}

#[flutter_rust_bridge::frb(serialize)]
pub fn p4k_upgrader_verify(config: P4kUpgraderConfig) -> Result<()> {
    let config = to_upgrader_config(config)?;
    reset_update_control();
    verify_existing(&config)?;
    Ok(())
}

#[flutter_rust_bridge::frb(serialize)]
pub fn p4k_upgrader_update(config: P4kUpgraderConfig) -> Result<String> {
    let config = to_upgrader_config(config)?;
    reset_update_control();
    let repair_mode = is_repair_update_mode(&config);
    let output = if repair_mode {
        run_repair_update(&config)?
    } else {
        run_update(&config).map_err(|err| anyhow::anyhow!(normal_update_error_message(err)))?
    };
    Ok(output.to_string_lossy().to_string())
}

#[flutter_rust_bridge::frb(serialize)]
pub async fn p4k_upgrader_update_with_progress(
    config: P4kUpgraderConfig,
    stream_sink: StreamSink<P4kUpgraderProgressEvent>,
) {
    let stream_sink = Arc::new(stream_sink);
    let sink = stream_sink.clone();
    let handle = tokio::task::spawn_blocking(move || {
        let mut config = match to_upgrader_config(config) {
            Ok(config) => config,
            Err(err) => {
                let _ = sink.add(P4kUpgraderProgressEvent::error(err.to_string(), None));
                return;
            }
        };
        reset_update_control();
        let progress_coalescer = Arc::new(ProgressEventCoalescer::new(sink.clone()));
        let progress_sink = progress_coalescer.clone();
        config.progress = ProgressReporter::new(move |event| {
            progress_sink.report_progress(event);
        });
        let repair_mode = is_repair_update_mode(&config);
        let result = if repair_mode {
            run_repair_update(&config)
        } else {
            run_update(&config)
        };
        match result {
            Ok(output) => {
                progress_coalescer.emit(P4kUpgraderProgressEvent::done(
                    output.to_string_lossy().to_string(),
                ));
            }
            Err(err) => {
                let mirror_unavailable = map_mirror_unavailable(&err);
                let message = err.to_string();
                if message.contains("cancelled") || message.contains("取消") {
                    progress_coalescer.emit(P4kUpgraderProgressEvent::cancelled(message));
                } else {
                    let message = if repair_mode {
                        message
                    } else {
                        normal_update_error_message(message)
                    };
                    progress_coalescer
                        .emit(P4kUpgraderProgressEvent::error(message, mirror_unavailable));
                }
            }
        }
    });
    // The update is intentionally detached; progress and terminal state are
    // reported through the FRB stream sink.
    std::mem::drop(handle);
}

#[flutter_rust_bridge::frb(sync)]
pub fn p4k_upgrader_set_download_threads(threads: usize) {
    set_download_thread_limit(threads);
}

#[flutter_rust_bridge::frb(sync)]
pub fn p4k_upgrader_pause() {
    pause_update();
}

#[flutter_rust_bridge::frb(sync)]
pub fn p4k_upgrader_resume() {
    resume_update();
}

#[flutter_rust_bridge::frb(sync)]
pub fn p4k_upgrader_cancel() {
    cancel_update();
}

#[flutter_rust_bridge::frb(sync)]
pub fn p4k_upgrader_clear_manifest_cache() {
    clear_manifest_memory_cache();
}

fn to_upgrader_config(input: P4kUpgraderConfig) -> Result<Config> {
    let game_dir = PathBuf::from(input.game_dir);
    let object_path_templates = input.object_path_templates;
    // Assign public compatibility fields after construction. External provider
    // builds may add private internal fields to Config, which makes struct
    // update syntax unusable outside that crate.
    let mut config = match input.source {
        P4kDownloadSource::Official => Config::default(),
        P4kDownloadSource::CommunityMirror => {
            Config::chinese_wiki_r2(game_dir.join("Data.p4k"), PathBuf::from(&input.cache_dir))
        }
    };
    config.download_source = match input.source {
        P4kDownloadSource::Official => DownloadSource::Official,
        P4kDownloadSource::CommunityMirror => DownloadSource::ChineseWikiR2,
    };
    if input.source == P4kDownloadSource::Official {
        config.manifest_source = input.manifest_source;
        config.mirror_bases = input.mirror_bases;
        config.official_bases = input.official_bases;
        config.p4k_base_url = input.p4k_base_url;
        config.p4k_base_verification_url = input.p4k_base_verification_url;
        config.request_cookie = input.request_cookie;
        config.rsi_token = input.rsi_token;
    }
    config.cache_dir = PathBuf::from(input.cache_dir);
    config.existing_p4k = game_dir.join("Data.p4k");
    config.output_p4k = game_dir.join("Data.p4k.tmp");
    config.loose_root = game_dir;
    config.update_p4k = input.update_p4k;
    config.update_loose_files = input.update_loose_files;
    config.inplace_update_p4k = input.inplace_update_p4k;
    config.fallback_rebuild_on_inplace_verify_failure =
        input.fallback_rebuild_on_inplace_verify_failure;
    config.replace_existing_p4k = input.replace_existing_p4k;
    config.verify_after_assemble = input.verify_after_assemble;
    config.verify_cig_structure = input.verify_cig_structure;
    config.verify_before_inplace = input.verify_cig_structure;
    // Normal UI updates set verify_cig_structure=false for speed, but they
    // still need scan-based in-place resume when a previous stop left Data.p4k
    // without a readable central directory / EOCD.
    config.resume_incomplete_inplace_update = true;
    config.verify_crc32_for_loose = false;
    config.max_entries = input.max_entries;
    if !object_path_templates.is_empty() {
        config.object_path_templates = object_path_templates;
    }

    if config.download_source == DownloadSource::Official
        && config.manifest_source.trim().is_empty()
    {
        anyhow::bail!("manifest_source is empty");
    }
    Ok(config)
}

fn map_mirror_unavailable(error: &Error) -> Option<P4kMirrorUnavailable> {
    let Error::MirrorUnavailable(details) = error else {
        return None;
    };
    Some(P4kMirrorUnavailable {
        reason: match details.reason {
            MirrorUnavailableReason::NotEligible => P4kMirrorUnavailableReason::NotEligible,
            MirrorUnavailableReason::NotMirrored => P4kMirrorUnavailableReason::NotMirrored,
            MirrorUnavailableReason::IncompleteBase => P4kMirrorUnavailableReason::IncompleteBase,
            MirrorUnavailableReason::ReleaseMismatch => P4kMirrorUnavailableReason::ReleaseMismatch,
        },
        object_sha256: details.object_sha256.clone(),
        compressed_size: details.compressed_size,
        message: details.message.clone(),
    })
}

impl P4kUpgraderEstimateOutcome {
    fn from_upgrader(error: Error) -> Self {
        Self {
            mirror_unavailable: map_mirror_unavailable(&error),
            error_message: if matches!(error, Error::MirrorUnavailable(_)) {
                None
            } else {
                Some(error.to_string())
            },
            report: None,
        }
    }

    fn from_anyhow(error: anyhow::Error) -> Self {
        Self {
            report: None,
            mirror_unavailable: None,
            error_message: Some(error.to_string()),
        }
    }
}

fn normal_update_error_message(message: impl std::fmt::Display) -> String {
    format!(
        "普通更新失败：{message}\n普通更新不会自动重建 Data.p4k。请检查网络/磁盘空间后重试；如果 Data.p4k 已损坏或反复失败，请手动点击“深度修复”。"
    )
}

#[flutter_rust_bridge::frb(ignore)]
struct ProgressEventCoalescer {
    sink: Arc<StreamSink<P4kUpgraderProgressEvent>>,
    state: Mutex<ProgressEventCoalescerState>,
}

#[derive(Default)]
#[flutter_rust_bridge::frb(ignore)]
struct ProgressEventCoalescerState {
    last_emitted: Option<P4kUpgraderProgressEvent>,
    last_emit_at: Option<Instant>,
    last_observed_phase: Option<String>,
    pending: Option<P4kUpgraderProgressEvent>,
}

impl ProgressEventCoalescer {
    fn new(sink: Arc<StreamSink<P4kUpgraderProgressEvent>>) -> Self {
        Self {
            sink,
            state: Mutex::new(ProgressEventCoalescerState::default()),
        }
    }

    fn report_progress(&self, event: ProgressEvent) {
        self.emit(P4kUpgraderProgressEvent::from(event));
    }

    fn emit(&self, event: P4kUpgraderProgressEvent) {
        let events = {
            let Ok(mut state) = self.state.lock() else {
                return;
            };
            state.events_to_emit(event, Instant::now())
        };
        for event in events {
            let _ = self.sink.add(event);
        }
    }
}

impl ProgressEventCoalescerState {
    fn events_to_emit(
        &mut self,
        event: P4kUpgraderProgressEvent,
        now: Instant,
    ) -> Vec<P4kUpgraderProgressEvent> {
        let phase_changed = self
            .last_observed_phase
            .as_deref()
            .map(|phase| phase != event.phase)
            .unwrap_or(true);
        self.last_observed_phase = Some(event.phase.clone());

        let is_important = event.is_important()
            || phase_changed
            || event.is_completion()
            || self.elapsed_since_last_emit(now) >= PROGRESS_THROTTLE_INTERVAL
            || self.has_meaningful_delta(&event, now);

        if is_important {
            let mut events = Vec::with_capacity(2);
            if (phase_changed || event.is_terminal())
                && !event.should_discard_pending_before_terminal()
                && self.pending_differs_from(&event)
            {
                if let Some(pending) = self.pending.take() {
                    self.record_emitted(&pending, now);
                    events.push(pending);
                }
            } else {
                self.pending = None;
            }
            self.record_emitted(&event, now);
            events.push(event);
            events
        } else {
            self.pending = Some(event);
            Vec::new()
        }
    }

    fn elapsed_since_last_emit(&self, now: Instant) -> Duration {
        self.last_emit_at
            .map(|last| now.saturating_duration_since(last))
            .unwrap_or(PROGRESS_THROTTLE_INTERVAL)
    }

    fn has_meaningful_delta(&self, event: &P4kUpgraderProgressEvent, now: Instant) -> bool {
        if self.elapsed_since_last_emit(now) < PROGRESS_MEANINGFUL_DELTA_INTERVAL {
            return false;
        }
        let Some(last) = &self.last_emitted else {
            return true;
        };
        if last.phase != event.phase {
            return true;
        }
        if event.total_bytes > 0 && event.downloaded_bytes > last.downloaded_bytes {
            let delta = event.downloaded_bytes - last.downloaded_bytes;
            let percent_delta = (event.total_bytes / 100).max(1);
            return delta >= PROGRESS_MEANINGFUL_BYTE_DELTA || delta >= percent_delta;
        }
        false
    }

    fn pending_differs_from(&self, event: &P4kUpgraderProgressEvent) -> bool {
        self.pending
            .as_ref()
            .map(|pending| !pending.same_progress_position(event))
            .unwrap_or(false)
    }

    fn record_emitted(&mut self, event: &P4kUpgraderProgressEvent, now: Instant) {
        self.last_emitted = Some(event.clone());
        self.last_emit_at = Some(now);
    }
}

impl From<ProgressEvent> for P4kUpgraderProgressEvent {
    fn from(value: ProgressEvent) -> Self {
        Self {
            phase: value.phase,
            name: value.name,
            current: value.current,
            total: value.total,
            downloaded_bytes: value.downloaded_bytes,
            total_bytes: value.total_bytes,
            active_downloads: value.active_downloads,
            thread_limit: value.thread_limit,
            message: value.message,
            mirror_unavailable: None,
        }
    }
}

impl P4kUpgraderProgressEvent {
    fn is_important(&self) -> bool {
        matches!(
            self.phase.as_str(),
            "done" | "error" | "cancelled" | "download_error"
        )
    }

    fn is_terminal(&self) -> bool {
        matches!(self.phase.as_str(), "done" | "error" | "cancelled")
    }

    fn should_discard_pending_before_terminal(&self) -> bool {
        self.phase == "cancelled"
    }

    fn is_completion(&self) -> bool {
        if self.phase == "network_speed" {
            return false;
        }
        if self.total_bytes > 0 && self.total <= 1 {
            self.downloaded_bytes >= self.total_bytes
        } else {
            self.total > 0 && self.current >= self.total
        }
    }

    fn same_progress_position(&self, other: &Self) -> bool {
        self.phase == other.phase
            && self.name == other.name
            && self.current == other.current
            && self.total == other.total
            && self.downloaded_bytes == other.downloaded_bytes
            && self.total_bytes == other.total_bytes
            && self.message == other.message
    }

    fn done(message: String) -> Self {
        Self {
            phase: "done".into(),
            name: String::new(),
            current: 0,
            total: 0,
            downloaded_bytes: 0,
            total_bytes: 0,
            active_downloads: 0,
            thread_limit: 0,
            message,
            mirror_unavailable: None,
        }
    }

    fn error(message: String, mirror_unavailable: Option<P4kMirrorUnavailable>) -> Self {
        Self {
            phase: "error".into(),
            name: String::new(),
            current: 0,
            total: 0,
            downloaded_bytes: 0,
            total_bytes: 0,
            active_downloads: 0,
            thread_limit: 0,
            message,
            mirror_unavailable,
        }
    }

    fn cancelled(message: String) -> Self {
        Self {
            phase: "cancelled".into(),
            name: String::new(),
            current: 0,
            total: 0,
            downloaded_bytes: 0,
            total_bytes: 0,
            active_downloads: 0,
            thread_limit: 0,
            message,
            mirror_unavailable: None,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn bridge_config(verify_cig_structure: bool) -> P4kUpgraderConfig {
        P4kUpgraderConfig {
            source: P4kDownloadSource::Official,
            manifest_source: "https://example.invalid/manifest.json".to_string(),
            mirror_bases: Vec::new(),
            official_bases: Vec::new(),
            p4k_base_url: String::new(),
            p4k_base_verification_url: String::new(),
            object_path_templates: Vec::new(),
            request_cookie: String::new(),
            rsi_token: String::new(),
            cache_dir: "cache".to_string(),
            game_dir: "game".to_string(),
            update_p4k: true,
            update_loose_files: true,
            inplace_update_p4k: true,
            fallback_rebuild_on_inplace_verify_failure: verify_cig_structure,
            replace_existing_p4k: true,
            verify_after_assemble: verify_cig_structure,
            verify_cig_structure,
            max_entries: None,
        }
    }

    #[test]
    fn official_bridge_config_preserves_credentials() {
        let mut input = bridge_config(false);
        input.request_cookie = "cookie=value".to_string();
        input.rsi_token = "token".to_string();
        let config = to_upgrader_config(input).unwrap();
        assert_eq!(config.request_cookie, "cookie=value");
        assert_eq!(config.rsi_token, "token");
    }

    fn mirror_bridge_config() -> P4kUpgraderConfig {
        let mut input = bridge_config(false);
        input.source = P4kDownloadSource::CommunityMirror;
        input.manifest_source.clear();
        input
    }

    #[test]
    fn mirror_config_uses_upstream_source_without_credentials_or_official_urls() {
        let mut input = mirror_bridge_config();
        input.request_cookie = "must-not-survive".into();
        input.rsi_token = "must-not-survive".into();
        input.official_bases = vec!["https://official.invalid".into()];
        let config = to_upgrader_config(input).unwrap();
        assert_eq!(config.download_source, DownloadSource::ChineseWikiR2);
        assert!(config.manifest_source.is_empty());
        assert!(config.official_bases.is_empty());
        assert!(config.request_cookie.is_empty());
        assert!(config.rsi_token.is_empty());
    }

    #[test]
    fn mirror_unavailable_four_reasons_map_with_details() {
        for (upstream, expected) in [
            (
                MirrorUnavailableReason::NotEligible,
                P4kMirrorUnavailableReason::NotEligible,
            ),
            (
                MirrorUnavailableReason::NotMirrored,
                P4kMirrorUnavailableReason::NotMirrored,
            ),
            (
                MirrorUnavailableReason::IncompleteBase,
                P4kMirrorUnavailableReason::IncompleteBase,
            ),
            (
                MirrorUnavailableReason::ReleaseMismatch,
                P4kMirrorUnavailableReason::ReleaseMismatch,
            ),
        ] {
            let error = Error::MirrorUnavailable(p4k_upgrader::MirrorUnavailable {
                reason: upstream,
                object_sha256: Some("abc".into()),
                compressed_size: Some(42),
                message: "provider detail".into(),
            });
            let mapped = map_mirror_unavailable(&error).unwrap();
            assert_eq!(mapped.reason, expected);
            assert_eq!(mapped.object_sha256.as_deref(), Some("abc"));
            assert_eq!(mapped.compressed_size, Some(42));
            assert_eq!(mapped.message, "provider detail");
        }
    }

    #[test]
    fn hard_error_is_not_mirror_unavailable() {
        assert!(map_mirror_unavailable(&Error::Message("bad hash".into())).is_none());
    }

    #[test]
    fn normal_bridge_config_keeps_resume_enabled_without_deep_verify() {
        let config = to_upgrader_config(bridge_config(false)).unwrap();

        assert!(!config.verify_cig_structure);
        assert!(!config.verify_before_inplace);
        assert!(config.resume_incomplete_inplace_update);
        assert!(!config.fallback_rebuild_on_inplace_verify_failure);
    }

    #[test]
    fn deep_bridge_config_still_enables_strict_preverify_and_resume() {
        let config = to_upgrader_config(bridge_config(true)).unwrap();

        assert!(config.verify_cig_structure);
        assert!(config.verify_before_inplace);
        assert!(config.resume_incomplete_inplace_update);
        assert!(config.fallback_rebuild_on_inplace_verify_failure);
    }

    #[test]
    fn progress_coalescer_throttles_same_phase_updates() {
        let mut state = ProgressEventCoalescerState::default();
        let start = Instant::now();

        assert_eq!(
            state
                .events_to_emit(progress_event("downloading", 1, 100), start)
                .len(),
            1
        );
        assert!(state
            .events_to_emit(
                progress_event("downloading", 2, 100),
                start + Duration::from_millis(50)
            )
            .is_empty());
        assert_eq!(
            state
                .events_to_emit(
                    progress_event("downloading", 3, 100),
                    start + PROGRESS_THROTTLE_INTERVAL
                )
                .len(),
            1
        );
    }

    #[test]
    fn progress_coalescer_flushes_pending_on_phase_change() {
        let mut state = ProgressEventCoalescerState::default();
        let start = Instant::now();

        state.events_to_emit(progress_event("downloading", 1, 100), start);
        state.events_to_emit(
            progress_event("downloading", 2, 100),
            start + Duration::from_millis(50),
        );

        let emitted = state.events_to_emit(
            progress_event("writing", 0, 100),
            start + Duration::from_millis(60),
        );
        assert_eq!(emitted.len(), 2);
        assert_eq!(emitted[0].phase, "downloading");
        assert_eq!(emitted[0].downloaded_bytes, 2);
        assert_eq!(emitted[1].phase, "writing");
    }

    #[test]
    fn progress_coalescer_emits_errors_immediately() {
        let mut state = ProgressEventCoalescerState::default();
        let start = Instant::now();

        state.events_to_emit(progress_event("downloading", 1, 100), start);
        let emitted = state.events_to_emit(
            P4kUpgraderProgressEvent::error("boom".to_string(), None),
            start + Duration::from_millis(10),
        );

        assert_eq!(emitted.len(), 1);
        assert_eq!(emitted[0].phase, "error");
    }

    fn progress_event(
        phase: impl Into<String>,
        downloaded_bytes: u64,
        total_bytes: u64,
    ) -> P4kUpgraderProgressEvent {
        P4kUpgraderProgressEvent {
            phase: phase.into(),
            name: "Data.p4k".to_string(),
            current: 0,
            total: 0,
            downloaded_bytes,
            total_bytes,
            active_downloads: 1,
            thread_limit: 32,
            message: String::new(),
            mirror_unavailable: None,
        }
    }
}
