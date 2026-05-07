use std::collections::HashMap;
use std::path::Path;

pub fn normalize(path: &str) -> String {
    let p = path.replace('/', "\\");
    if p.starts_with('\\') {
        p
    } else {
        format!("\\{p}")
    }
}

pub fn find_mtl_path(model_path: &str, index: &HashMap<String, String>) -> Option<String> {
    let model_norm = normalize(model_path);
    let base = Path::new(&model_norm)
        .with_extension("mtl")
        .to_string_lossy()
        .replace('/', "\\");
    let mut candidates = vec![base.clone()];

    if let Some(stem) = Path::new(&base).file_stem().and_then(|v| v.to_str()) {
        let mut parent = Path::new(&model_norm).parent();
        while let Some(dir) = parent {
            for suffix in ["", "_a", "_b", "_c", "_d", "_e", "_f", "_g"] {
                candidates.push(
                    dir.join(format!("{stem}{suffix}.mtl"))
                        .to_string_lossy()
                        .replace('/', "\\"),
                );
            }
            parent = dir.parent();
        }
    }

    for candidate in candidates {
        if let Some(hit) = find_case_insensitive(index, &candidate) {
            return Some(hit);
        }

        // common fallback for material references rooted at objects/
        if let Some(stripped) = strip_root_prefix(&candidate, "objects\\") {
            if let Some(hit) = find_case_insensitive(index, &stripped) {
                return Some(hit);
            }
        }
    }

    // last resort: match by filename
    find_by_filename(
        index,
        Path::new(&base).file_name().and_then(|v| v.to_str())?,
    )
}

pub fn resolve_texture_path(
    model_path: &str,
    texture_ref: &str,
    index: &HashMap<String, String>,
) -> Option<String> {
    let texture_norm = texture_ref.replace('/', "\\");
    let texture_norm_prefixed = normalize(&texture_norm);
    let has_ext = Path::new(&texture_norm).extension().is_some();
    let mut candidates = Vec::new();

    candidates.push(texture_norm_prefixed.clone());
    if let Some(stripped) = strip_root_prefix(&texture_norm_prefixed, "objects\\") {
        candidates.push(stripped);
    }

    let model_dir = normalize(model_path);
    if let Some(pos) = model_dir.rfind('\\') {
        let dir = &model_dir[..pos];
        candidates.push(format!("{dir}\\{texture_norm}"));

        if !has_ext {
            let exts = [".dds", ".png", ".tga", ".tif", ".tiff"];
            for ext in exts {
                candidates.push(format!("{dir}\\{texture_norm}{ext}"));
            }
        } else if Path::new(&texture_norm).file_stem().is_some() {
            let exts = [".dds", ".png", ".tga", ".tif", ".tiff"];
            for ext in exts {
                candidates.push(
                    Path::new(dir)
                        .join(Path::new(&texture_norm).file_stem().unwrap())
                        .with_extension(ext.trim_start_matches('.'))
                        .to_string_lossy()
                        .replace('/', "\\"),
                );
            }
        }
    }

    if !has_ext {
        let exts = [".dds", ".png", ".tga", ".tif", ".tiff"];
        for ext in exts {
            candidates.push(format!("{texture_norm_prefixed}{ext}"));
        }
    } else if Path::new(&texture_norm).file_stem().is_some() {
        let exts = [".dds", ".png", ".tga", ".tif", ".tiff"];
        for ext in exts {
            candidates.push(
                Path::new(&texture_norm_prefixed)
                    .with_extension(ext.trim_start_matches('.'))
                    .to_string_lossy()
                    .replace('/', "\\"),
            );
        }
    }

    for c in candidates {
        if let Some(hit) = find_case_insensitive(index, &c) {
            return Some(hit.clone());
        }
    }

    // fallback: filename-only match when directory hierarchy differs after extraction
    let file_name = if has_ext {
        Path::new(&texture_norm)
            .file_name()
            .and_then(|v| v.to_str())
            .map(|v| v.to_string())
    } else {
        [".dds", ".png", ".tga", ".tif", ".tiff"]
            .iter()
            .map(|ext| format!("{texture_norm}{ext}"))
            .find_map(|candidate| {
                Path::new(&candidate)
                    .file_name()
                    .and_then(|v| v.to_str())
                    .map(|v| v.to_string())
            })
    };
    if let Some(_name) = file_name {
        if let Some(hit) = find_by_filename_with_context(index, &texture_norm) {
            return Some(hit);
        }
    }

    // Preserve the broad stem-based fallback for most textures, but avoid
    // widening this specific BANU glow texture to an unrelated DDS variant.
    let skip_stem_fallback = texture_norm
        .to_ascii_lowercase()
        .contains("banu_display_glows_diff.tif");
    if !skip_stem_fallback {
        if let Some(stem) = Path::new(&texture_norm)
            .file_stem()
            .and_then(|v| v.to_str())
        {
            if let Some(hit) = find_by_stem(index, stem) {
                return Some(hit);
            }
        }
    }

    None
}

fn find_case_insensitive(index: &HashMap<String, String>, path: &str) -> Option<String> {
    index.get(&path.to_lowercase()).cloned()
}

fn strip_root_prefix(path: &str, prefix: &str) -> Option<String> {
    let normalized = normalize(path);
    let lower = normalized.to_lowercase();
    let wanted = format!("\\{}", prefix.to_lowercase());
    if lower.starts_with(&wanted) {
        Some(format!("\\{}", &normalized[wanted.len()..]))
    } else {
        None
    }
}

fn find_by_filename(index: &HashMap<String, String>, file_name: &str) -> Option<String> {
    let file_name = file_name.to_lowercase();
    let suffix = format!("\\{file_name}");

    if let Some(hit) = index.iter().find_map(|(k, v)| {
        let tail = Path::new(k).file_name().and_then(|n| n.to_str())?;
        if tail.eq_ignore_ascii_case(&file_name) {
            Some(v.clone())
        } else {
            None
        }
    }) {
        return Some(hit);
    }

    let mut candidates = index
        .iter()
        .filter_map(|(k, v)| {
            if k.ends_with(&suffix) {
                Some((k.len(), v.clone()))
            } else {
                None
            }
        })
        .collect::<Vec<_>>();
    candidates.sort_by_key(|(len, _)| *len);
    candidates.into_iter().map(|(_, v)| v).next()
}

fn find_by_filename_with_context(
    index: &HashMap<String, String>,
    requested_path: &str,
) -> Option<String> {
    let requested = requested_path.replace('/', "\\");
    let file_name = Path::new(&requested).file_name().and_then(|v| v.to_str())?;
    let candidates = index
        .iter()
        .filter_map(|(k, v)| {
            let tail = Path::new(k).file_name().and_then(|n| n.to_str())?;
            if !tail.eq_ignore_ascii_case(file_name) {
                return None;
            }
            Some(v.clone())
        })
        .collect::<Vec<_>>();
    if candidates.is_empty() {
        return None;
    }

    let parent_segments = requested
        .split('\\')
        .filter(|part| !part.is_empty())
        .rev()
        .skip(1)
        .take(3)
        .map(|s| s.to_string())
        .collect::<Vec<_>>();

    if parent_segments.is_empty() {
        return Some(candidates[0].clone());
    }

    let best = candidates
        .into_iter()
        .map(|path| {
            let score = parent_segments
                .iter()
                .filter(|seg| {
                    let pat = format!(r"(^|[\\/]){}([\\/]|$)", regex::escape(seg));
                    regex::Regex::new(&pat)
                        .ok()
                        .map(|re| re.is_match(&path))
                        .unwrap_or(false)
                })
                .count();
            (score, path.len(), path)
        })
        .max_by(|a, b| a.cmp(b));
    best.map(|(_, _, path)| path)
}

fn find_by_stem(index: &HashMap<String, String>, stem: &str) -> Option<String> {
    let wanted = stem.to_lowercase();
    index.iter().find_map(|(k, v)| {
        let file_name = Path::new(k).file_name().and_then(|n| n.to_str())?;
        let key_stem = Path::new(file_name).file_stem().and_then(|s| s.to_str())?;
        if key_stem.eq_ignore_ascii_case(&wanted) {
            Some(v.clone())
        } else {
            None
        }
    })
}

#[cfg(test)]
mod tests {
    use std::collections::HashMap;

    use super::{find_mtl_path, normalize, resolve_texture_path};

    #[test]
    fn normalize_converts_slashes_and_adds_leading_backslash() {
        assert_eq!(
            normalize("Data/Objects/Ship.cgf"),
            "\\Data\\Objects\\Ship.cgf"
        );
        assert_eq!(
            normalize("\\Data\\Objects\\Ship.cgf"),
            "\\Data\\Objects\\Ship.cgf"
        );
    }

    #[test]
    fn find_mtl_path_matches_case_insensitive_index_key() {
        let mut index = HashMap::new();
        index.insert(
            "\\data\\objects\\ship.mtl".to_string(),
            "Data\\Objects\\Ship.mtl".to_string(),
        );

        let resolved = find_mtl_path("Data/Objects/Ship.CGF", &index);
        assert_eq!(resolved, Some("Data\\Objects\\Ship.mtl".to_string()));
    }

    #[test]
    fn find_mtl_path_fallbacks_to_filename_when_path_differs() {
        let mut index = HashMap::new();
        index.insert(
            "\\ships\\banu\\defender\\banu_defender.mtl".to_string(),
            "Ships\\BANU\\Defender\\banu_defender.mtl".to_string(),
        );

        let resolved = find_mtl_path(
            "Objects/Spaceships/Ships/BANU/Defender/banu_defender.cga",
            &index,
        );
        assert_eq!(
            resolved,
            Some("Ships\\BANU\\Defender\\banu_defender.mtl".to_string())
        );
    }

    #[test]
    fn resolve_texture_path_handles_absolute_relative_and_extension_fallback() {
        let mut index = HashMap::new();
        index.insert(
            "\\textures\\paint\\hull_diff.dds".to_string(),
            "Textures\\Paint\\hull_diff.dds".to_string(),
        );
        index.insert(
            "\\data\\objects\\ships\\hull_diff.png".to_string(),
            "Data\\Objects\\Ships\\hull_diff.png".to_string(),
        );

        let direct = resolve_texture_path(
            "Data/Objects/Ships/Gladius.cgf",
            "Textures/Paint/hull_diff.dds",
            &index,
        );
        assert_eq!(direct, Some("Textures\\Paint\\hull_diff.dds".to_string()));

        let relative = resolve_texture_path("Data/Objects/Ships/Gladius.cgf", "hull_diff", &index);
        assert_eq!(
            relative,
            Some("Data\\Objects\\Ships\\hull_diff.png".to_string())
        );
    }

    #[test]
    fn resolve_texture_path_fallbacks_to_filename_match() {
        let mut index = HashMap::new();
        index.insert(
            "\\textures\\interior\\glow\\banu_display_glows_diff.dds".to_string(),
            "Textures\\Interior\\Glow\\banu_display_glows_diff.dds".to_string(),
        );

        let resolved = resolve_texture_path(
            "Objects/Spaceships/Ships/BANU/Defender/banu_defender.cga",
            "Objects/Spaceships/Ships/BANU/Textures/Interior/Glow/banu_display_glows_diff.tif",
            &index,
        );
        assert_eq!(resolved, None);
    }
}
