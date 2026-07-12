use crate::config::Config;
use crate::error::{unavailable, Result};
use crate::manifest::ManifestEntry;
use serde::Serialize;
use std::path::{Path, PathBuf};

#[derive(Debug, Clone, Default, Serialize)]
pub struct EstimateReport {
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
    pub total_download_bytes: u64,
    pub entries: Vec<EstimateEntry>,
}

#[derive(Debug, Clone, Default, Serialize)]
pub struct EstimateEntry {
    pub name: String,
    pub sha256: String,
    pub compressed_size: u64,
}

pub fn run_update(_config: &Config) -> Result<PathBuf> {
    unavailable()
}

pub fn is_repair_update_mode(config: &Config) -> bool {
    config.update_p4k
        && config.verify_cig_structure
        && config.verify_after_assemble
        && config.fallback_rebuild_on_inplace_verify_failure
}

pub fn run_repair_update(_config: &Config) -> Result<PathBuf> {
    unavailable()
}

pub fn verify_existing(_config: &Config) -> Result<()> {
    unavailable()
}

pub fn repair_existing(_config: &Config) -> Result<PathBuf> {
    unavailable()
}

pub fn estimate_update_size(_config: &Config) -> Result<EstimateReport> {
    unavailable()
}

pub fn clear_selection_memory_cache() {}

pub fn replace_existing_p4k(_assembled_path: &Path, _config: &Config) -> Result<()> {
    unavailable()
}

pub fn entries_requiring_download(
    _config: &Config,
    _entries: &[ManifestEntry],
) -> Result<Vec<ManifestEntry>> {
    unavailable()
}
