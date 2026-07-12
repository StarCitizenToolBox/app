use crate::config::Config;
use crate::error::{unavailable, Result};
use crate::manifest::ManifestEntry;
use std::path::PathBuf;

#[derive(Debug, Clone, Default)]
pub struct StagedLooseFile {
    pub entry: ManifestEntry,
    pub stage_path: PathBuf,
    pub target_path: PathBuf,
}

#[derive(Debug, Clone, Default)]
pub struct CommittedLooseFile {
    pub target_path: PathBuf,
    pub backup_path: Option<PathBuf>,
}

pub fn select_loose_entries_requiring_update(
    _config: &Config,
    _entries: &[ManifestEntry],
) -> Result<Vec<ManifestEntry>> {
    unavailable()
}

pub fn candidate_object_urls(config: &Config, entry: &ManifestEntry) -> Vec<String> {
    entry
        .source_urls
        .iter()
        .cloned()
        .chain(
            config
                .mirror_bases
                .iter()
                .flat_map(|base| {
                    config
                        .object_path_templates
                        .iter()
                        .map(move |template| (base, template))
                })
                .map(|(base, template)| format_object_template(template, base, entry)),
        )
        .chain(
            config
                .official_bases
                .iter()
                .flat_map(|base| {
                    config
                        .object_path_templates
                        .iter()
                        .map(move |template| (base, template))
                })
                .map(|(base, template)| format_object_template(template, base, entry)),
        )
        .collect()
}

pub fn format_object_template(template: &str, base: &str, entry: &ManifestEntry) -> String {
    let base = base.trim_end_matches('/');
    let sha256 = entry.sha256.to_ascii_lowercase();
    let sha256_upper = entry.sha256.to_ascii_uppercase();
    let file_name_url = urlencoding::encode(&entry.file_name);
    let path = template
        .replace("{sha256}", &sha256)
        .replace("{sha256_upper}", &sha256_upper)
        .replace("{sha2}", sha256.get(0..2).unwrap_or_default())
        .replace("{sha4}", sha256.get(0..4).unwrap_or_default())
        .replace("{file_name_url}", &file_name_url);
    format!("{base}/{path}")
}

pub fn prepare_staged_loose_files(
    _config: &Config,
    _entries: &[ManifestEntry],
) -> Result<Vec<StagedLooseFile>> {
    unavailable()
}

pub fn commit_staged_loose_files(_staged: &[StagedLooseFile]) -> Result<Vec<CommittedLooseFile>> {
    unavailable()
}

pub fn rollback_committed_loose_files(_committed: &[CommittedLooseFile]) {}

pub fn finalize_committed_loose_files(_committed: &[CommittedLooseFile]) {}

pub fn verify_loose_files(_config: &Config, _entries: &[ManifestEntry]) -> Result<()> {
    unavailable()
}
