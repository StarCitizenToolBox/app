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

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn p4k_name_prefers_target_and_uses_zip_separators() {
        let mut entry = ManifestEntry {
            file_name: r"\Data\Objects\a.cgf".to_string(),
            ..ManifestEntry::default()
        };
        assert_eq!(entry.p4k_name(), "Data/Objects/a.cgf");
        entry.target = "/Data/Objects/b.cgf".to_string();
        assert_eq!(entry.p4k_name(), "Data/Objects/b.cgf");
        assert_eq!(normalize_zip_name("//Data\\x"), "Data/x");
    }

    #[test]
    fn manifest_entries_default_optional_fields() {
        let entry: ManifestEntry = serde_json::from_str(
            r#"{"file_name":"Data/a.xml","sha256":"00","crc32":1,
                "compression_method":8,"compressed_size":2,"uncompressed_size":3}"#,
        )
        .unwrap();
        assert!(!entry.loose_file);
        assert!(entry.target.is_empty());
        assert!(entry.source_urls.is_empty());
        assert_eq!(entry.compression_method, 8);
        // Required fields stay required.
        assert!(serde_json::from_str::<ManifestEntry>(r#"{"file_name":"Data/a.xml"}"#).is_err());
    }

    #[test]
    fn sha256_is_lowercase_hex() {
        assert_eq!(
            sha256_bytes(b"abc"),
            "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad"
        );
        let dir = tempfile::tempdir().unwrap();
        let path = dir.path().join("blob");
        std::fs::write(&path, b"abc").unwrap();
        assert_eq!(sha256_file(&path).unwrap(), sha256_bytes(b"abc"));
        assert!(sha256_file(dir.path().join("missing")).is_err());
    }
}
