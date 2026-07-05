use crate::config::Config;
use crate::error::{unavailable, Result};
use crate::manifest::ManifestEntry;
use std::path::{Path, PathBuf};

#[derive(Debug, Clone, Default)]
pub struct P4kRecord {
    pub name: String,
    pub flags: u16,
    pub method: u16,
    pub mod_time: u16,
    pub mod_date: u16,
    pub crc32: u32,
    pub compressed_size: u64,
    pub uncompressed_size: u64,
    pub local_offset: u64,
    pub version_made_by: u16,
    pub version_needed: u16,
    pub disk_start: u16,
    pub internal_attr: u16,
    pub external_attr: u32,
    pub central_extra: Vec<u8>,
    pub comment: Vec<u8>,
    pub raw_copy_size: u64,
    pub new_local_offset: u64,
    pub manifest_signature: Vec<u8>,
    pub manifest_sha256: String,
    pub local_signature: u32,
}

#[derive(Debug, Clone)]
pub enum P4kCacheSelection {
    Known(Vec<ManifestEntry>),
    DeferredRecovery {
        conservative_needed: Vec<ManifestEntry>,
        reason: String,
    },
}

pub fn parse_p4k(
    _path: impl AsRef<Path>,
    _progress: Option<&dyn Fn(u64, u64)>,
) -> Result<Vec<P4kRecord>> {
    unavailable()
}

pub fn read_central_directory_location<R: std::io::Read + std::io::Seek>(
    _reader: &mut R,
    _file_size: u64,
) -> Result<(u64, u64, u64)> {
    unavailable()
}

pub fn select_p4k_entries_requiring_cache(
    _config: &Config,
    _entries: &[ManifestEntry],
) -> Result<Vec<ManifestEntry>> {
    unavailable()
}

pub fn select_p4k_entries_requiring_cache_without_local_recovery_scan(
    _config: &Config,
    _entries: &[ManifestEntry],
) -> Result<Vec<ManifestEntry>> {
    unavailable()
}

pub fn plan_p4k_entries_requiring_cache_without_local_recovery_scan(
    _config: &Config,
    _entries: &[ManifestEntry],
) -> Result<P4kCacheSelection> {
    unavailable()
}

pub fn assemble_p4k(_config: &Config, _entries: &[ManifestEntry]) -> Result<PathBuf> {
    unavailable()
}

pub fn repair_p4k(_config: &Config, _entries: &[ManifestEntry]) -> Result<PathBuf> {
    unavailable()
}

pub fn update_p4k_in_place(_config: &Config, _entries: &[ManifestEntry]) -> Result<PathBuf> {
    unavailable()
}

pub fn verify_p4k_against_manifest(
    _p4k_path: impl AsRef<Path>,
    _entries: &[ManifestEntry],
    _progress: Option<&dyn Fn(u64, u64)>,
) -> Result<()> {
    unavailable()
}

pub fn verify_p4k_cig_structure(_p4k_path: impl AsRef<Path>) -> Result<()> {
    unavailable()
}

pub fn verify_p4k_cig_structure_allow_local_extra_padding(
    _p4k_path: impl AsRef<Path>,
    _allow_local_extra_padding: bool,
) -> Result<()> {
    unavailable()
}

pub fn verify_p4k_cig_structure_with_progress(
    _p4k_path: impl AsRef<Path>,
    _progress: Option<&dyn Fn(u64, u64)>,
) -> Result<()> {
    unavailable()
}

pub fn verify_p4k_cig_structure_with_progress_returning_records(
    _p4k_path: impl AsRef<Path>,
    _progress: Option<&dyn Fn(u64, u64)>,
) -> Result<Vec<P4kRecord>> {
    unavailable()
}

pub fn dedupe_entries_by_sha<I>(entries: I) -> Vec<ManifestEntry>
where
    I: IntoIterator<Item = ManifestEntry>,
{
    let mut seen = std::collections::HashSet::new();
    entries
        .into_iter()
        .filter(|entry| seen.insert(entry.sha256.clone()))
        .collect()
}

pub fn entry_storage_size(entry: &ManifestEntry) -> u64 {
    entry.compressed_size
}
