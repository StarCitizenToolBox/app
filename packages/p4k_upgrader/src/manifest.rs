use crate::config::Config;
use crate::error::{unavailable, Result};
use serde::{Deserialize, Serialize};
use std::path::PathBuf;

#[derive(Debug, Clone, Default, Serialize, Deserialize, PartialEq, Eq)]
pub struct ManifestEntry {
    pub file_name: String,
    pub sha256: String,
    pub crc32: u32,
    pub compression_method: u16,
    pub compressed_size: u64,
    pub uncompressed_size: u64,
    #[serde(default)]
    pub last_mod_file_time: u16,
    #[serde(default)]
    pub last_mod_file_date: u16,
    #[serde(default)]
    pub encryption: u16,
    #[serde(default)]
    pub signature: String,
    #[serde(default)]
    pub loose_file: bool,
    #[serde(default)]
    pub target: String,
    #[serde(default)]
    pub source_urls: Vec<String>,
}

impl ManifestEntry {
    pub fn p4k_name(&self) -> String {
        normalize_zip_name(if self.target.is_empty() {
            &self.file_name
        } else {
            &self.target
        })
    }
}

#[derive(Debug, Clone, Default)]
pub struct Manifest {
    pub raw_path: PathBuf,
    pub index_path: PathBuf,
    pub meta_path: PathBuf,
    pub manifest_sha256: String,
    pub entries: Vec<ManifestEntry>,
}

pub fn cache_manifest(_config: &Config) -> Result<Manifest> {
    unavailable()
}

pub fn clear_manifest_memory_cache() {}

pub fn normalize_zip_name(name: &str) -> String {
    name.replace('\\', "/").trim_start_matches('/').to_string()
}

pub fn sha256_file(path: impl AsRef<std::path::Path>) -> Result<String> {
    let bytes = std::fs::read(path)?;
    Ok(sha256_bytes(&bytes))
}

pub fn sha256_bytes(data: &[u8]) -> String {
    use sha2::{Digest, Sha256};
    let digest = Sha256::digest(data);
    digest.iter().map(|byte| format!("{byte:02x}")).collect()
}
