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

#[cfg(test)]
mod tests {
    use super::*;

    const SHA: &str = "AbCdEf0123456789abcdef0123456789abcdef0123456789abcdef0123456789";

    fn entry() -> ManifestEntry {
        ManifestEntry {
            file_name: "Data/Localization/chinese (simplified)/global.ini".to_string(),
            sha256: SHA.to_string(),
            ..ManifestEntry::default()
        }
    }

    #[test]
    fn object_templates_expand_hash_and_name_placeholders() {
        let entry = entry();
        let lower = SHA.to_ascii_lowercase();
        let upper = SHA.to_ascii_uppercase();
        assert_eq!(
            format_object_template("{sha256}", "https://cdn.invalid/", &entry),
            format!("https://cdn.invalid/{lower}")
        );
        assert_eq!(
            format_object_template("{sha256_upper}", "https://cdn.invalid", &entry),
            format!("https://cdn.invalid/{upper}")
        );
        assert_eq!(
            format_object_template(
                "{sha2}/{sha4}/{sha256}.blob",
                "https://cdn.invalid//",
                &entry
            ),
            format!("https://cdn.invalid/ab/abcd/{lower}.blob")
        );
        assert_eq!(
            format_object_template("files/{file_name_url}", "https://cdn.invalid", &entry),
            "https://cdn.invalid/files/Data%2FLocalization%2Fchinese%20%28simplified%29%2Fglobal.ini"
        );
    }

    #[test]
    fn short_hashes_do_not_panic() {
        let entry = ManifestEntry {
            sha256: "a".to_string(),
            ..ManifestEntry::default()
        };
        assert_eq!(
            format_object_template("{sha2}/{sha4}/{sha256}", "https://cdn.invalid", &entry),
            "https://cdn.invalid///a"
        );
    }

    #[test]
    fn candidate_urls_try_entry_urls_then_mirrors_then_official() {
        let mut entry = entry();
        entry.source_urls = vec!["https://signed.invalid/obj?sig=1".to_string()];
        let config = Config {
            mirror_bases: vec!["https://m1.invalid".into(), "https://m2.invalid/".into()],
            official_bases: vec!["https://official.invalid".into()],
            object_path_templates: vec!["{sha256}".into(), "{sha2}/{sha256}".into()],
            ..Config::default()
        };
        let lower = SHA.to_ascii_lowercase();
        assert_eq!(
            candidate_object_urls(&config, &entry),
            vec![
                "https://signed.invalid/obj?sig=1".to_string(),
                format!("https://m1.invalid/{lower}"),
                format!("https://m1.invalid/ab/{lower}"),
                format!("https://m2.invalid/{lower}"),
                format!("https://m2.invalid/ab/{lower}"),
                format!("https://official.invalid/{lower}"),
                format!("https://official.invalid/ab/{lower}"),
            ]
        );

        let no_templates = Config {
            object_path_templates: Vec::new(),
            ..config
        };
        assert_eq!(
            candidate_object_urls(&no_templates, &entry),
            vec!["https://signed.invalid/obj?sig=1".to_string()]
        );
    }
}
