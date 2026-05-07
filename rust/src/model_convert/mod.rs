pub mod cgf_parser;
pub mod cryengine;
pub mod entity_assembly_parser;
pub mod glb_merge;
pub mod gltf_builder;
pub mod ivo_parser;
pub mod material_parser;
pub mod path_resolver;
pub mod pipeline;
pub mod texture_decode;
pub mod types;
use crate::api::unp4k_api;
pub use pipeline::{
    _debug_result, convert_from_fs, convert_from_p4k, convert_from_p4k_to_bytes,
    convert_local_batch_and_merge, is_supported_model,
};
use std::collections::HashMap;
use std::fs;
use std::path::{Path, PathBuf};
pub use types::*;
use walkdir::WalkDir;
fn categorize_parser_error<E: ToString>(error: E) -> ModelConvertError {
    categorize_parser_error_message(error.to_string())
}
fn categorize_parser_error_message(message: String) -> ModelConvertError {
    if is_binary_not_supported_message(&message) {
        ModelConvertError::ParserBinaryNotSupported(message)
    } else {
        ModelConvertError::ModelParseFailed(message)
    }
}
fn is_binary_not_supported_message(message: &str) -> bool {
    let normalized = message.to_lowercase();
    if !(normalized.contains("unsupported") || normalized.contains("not supported")) {
        return false;
    }
    const CONTEXT_KEYWORDS: &[&str] = &[
        "signature",
        "version",
        "file type",
        "chunk",
        "binary",
        "format",
    ];
    CONTEXT_KEYWORDS
        .iter()
        .any(|keyword| normalized.contains(keyword))
}
fn texture_not_found_warning(texture_name: &str, channel: &str) -> String {
    format!("Texture not found for {channel}: {texture_name}")
}
fn texture_decode_failed_warning(path: &str, channel: &str, reason: &str) -> String {
    format!("Texture decode failed for {channel} at {path}: {reason}")
}
fn material_fallback_warning(material_id: i32) -> String {
    format!("Material id {material_id} is missing; fallback to default material")
}
fn opacity_approximation_warning(material_id: i32) -> String {
    format!(        "Material id {material_id} uses opacity map; exported with glTF alphaMode=BLEND approximation"    )
}
fn material_uses_specular_texture(material: &MaterialData) -> bool {
    let mask = material
        .string_gen_mask
        .as_deref()
        .unwrap_or_default()
        .to_ascii_uppercase();
    mask.contains("SPECULARPOW_GLOSSALPHA")
}
fn material_uses_opacity_texture(material: &MaterialData) -> bool {
    material.opacity_texture.is_some() || !material.opacity_texture_candidates.is_empty()
}
fn resolve_texture_candidates<'a>(
    candidates: impl IntoIterator<Item = &'a str>,
    model_paths: &[String],
    index: &HashMap<String, String>,
) -> Option<String> {
    for candidate in candidates {
        for model_path in model_paths {
            if let Some(path) = path_resolver::resolve_texture_path(model_path, candidate, index) {
                return Some(path);
            }
        }
    }
    None
}
fn texture_search_roots_p4k(model_path: &str, index: &HashMap<String, String>) -> Vec<String> {
    let mut roots = vec![model_path.to_string()];
    if let Some(companion_name) = find_ivo_companion_name(model_path, index) {
        if roots
            .iter()
            .all(|root| !root.eq_ignore_ascii_case(&companion_name))
        {
            roots.push(companion_name);
        }
    }
    roots
}
fn texture_search_roots_fs(model_path: &str) -> Vec<String> {
    let mut roots = vec![model_path.to_string()];
    if let Some(companion_path) = find_ivo_companion_path(model_path) {
        if companion_path.exists() {
            let companion = companion_path.to_string_lossy().to_string();
            if roots
                .iter()
                .all(|root| !root.eq_ignore_ascii_case(&companion))
            {
                roots.push(companion);
            }
        }
    }
    roots
}
async fn collect_material_textures(
    scene: &SceneData,
    root_material: &MaterialData,
    model_path: &str,
    index: &HashMap<String, String>,
    max_texture_size: Option<u32>,
) -> std::result::Result<
    (
        Vec<DecodedTexture>,
        Vec<GltfMaterialData>,
        HashMap<i32, usize>,
        Vec<String>,
    ),
    ModelConvertError,
> {
    let mut warnings = Vec::new();
    let mut sorted_ids = root_material
        .sub_materials
        .iter()
        .enumerate()
        .filter_map(|(index, material)| (!material.no_draw).then_some(index as i32))
        .collect::<Vec<_>>();
    if sorted_ids.is_empty() {
        sorted_ids.push(-1);
    }
    let mut texture_map: HashMap<String, usize> = HashMap::new();
    let mut textures = Vec::new();
    let mut materials = Vec::new();
    let mut materials_by_id = HashMap::new();
    for material_id in sorted_ids {
        let material_ref = if material_id >= 0 {
            root_material
                .sub_materials
                .get(material_id as usize)
                .unwrap_or_else(|| {
                    warnings.push(material_fallback_warning(material_id));
                    root_material
                })
        } else {
            root_material
        };
        let mut gltf_material = GltfMaterialData::default();
        gltf_material.name = material_ref.name.clone();
        gltf_material.base_color_factor = Some(if material_ref.no_draw {
            [0.0, 0.0, 0.0, 0.0]
        } else {
            let diffuse = material_ref.diffuse.unwrap_or([1.0, 1.0, 1.0]);
            [
                diffuse[0],
                diffuse[1],
                diffuse[2],
                material_ref.opacity.unwrap_or(1.0).clamp(0.0, 1.0),
            ]
        });
        gltf_material.specular_factor = Some(material_ref.specular.unwrap_or([1.0, 1.0, 1.0]));
        gltf_material.emissive_factor = material_ref.emissive_color.or_else(|| {
            material_ref
                .glow_amount
                .filter(|value| *value > 0.0)
                .map(|_| [1.0, 1.0, 1.0])
        });
        let shininess = material_ref.shininess.unwrap_or(0.0);
        let glossiness = (shininess / 255.0).clamp(0.0, 1.0);
        gltf_material.glossiness_factor = Some(glossiness);
        gltf_material.pbr_roughness_factor = Some(((255.0 - shininess) / 255.0).clamp(0.0, 1.0));
        gltf_material.double_sided = Some(
            material_ref
                .material_flags
                .map(|flags| (flags & 0x2) != 0)
                .unwrap_or(false),
        );
        let opacity = material_ref.opacity.unwrap_or(1.0).clamp(0.0, 1.0);
        gltf_material.alpha_mode = Some(if material_ref.no_draw {
            "MASK".to_string()
        } else if material_ref.alpha_test.unwrap_or(0.0) > 0.0 {
            "MASK".to_string()
        } else if opacity < 1.0 || material_uses_opacity_texture(material_ref) {
            "BLEND".to_string()
        } else {
            "OPAQUE".to_string()
        });
        gltf_material.alpha_cutoff = material_ref.alpha_test;
        gltf_material.no_draw = material_ref.no_draw;
        gltf_material.emissive_strength = material_ref.glow_amount;
        let normal_candidates = material_ref.normal_candidates.clone();
        let base_candidates = material_ref.base_color_candidates.clone();
        let spec_candidates = material_ref.specular_texture_candidates.clone();
        gltf_material.normal_texture = maybe_collect_channel_texture_p4k(
            material_ref.name.as_deref(),
            "normal",
            &normal_candidates,
            model_path,
            index,
            max_texture_size,
            &mut textures,
            &mut texture_map,
            &mut warnings,
        )
        .await?;
        gltf_material.base_color_texture = maybe_collect_channel_texture_p4k(
            material_ref.name.as_deref(),
            "baseColor",
            &base_candidates,
            model_path,
            index,
            max_texture_size,
            &mut textures,
            &mut texture_map,
            &mut warnings,
        )
        .await?;
        gltf_material.diffuse_texture = gltf_material.base_color_texture;
        if material_uses_specular_texture(material_ref) {
            gltf_material.specular_glossiness_texture = maybe_collect_channel_texture_p4k(
                material_ref.name.as_deref(),
                "specular",
                &spec_candidates,
                model_path,
                index,
                max_texture_size,
                &mut textures,
                &mut texture_map,
                &mut warnings,
            )
            .await?;
        }
        if let Some(emissive) = maybe_collect_channel_texture_p4k(
            material_ref.name.as_deref(),
            "emissive",
            &material_ref.emissive_candidates,
            model_path,
            index,
            max_texture_size,
            &mut textures,
            &mut texture_map,
            &mut warnings,
        )
        .await?
        {
            gltf_material.emissive_texture = Some(emissive);
        }
        if let Some(occlusion) = maybe_collect_channel_texture_p4k(
            material_ref.name.as_deref(),
            "occlusion",
            &material_ref.occlusion_candidates,
            model_path,
            index,
            max_texture_size,
            &mut textures,
            &mut texture_map,
            &mut warnings,
        )
        .await?
        {
            gltf_material.occlusion_texture = Some(occlusion);
        }
        if let Some(opacity) = maybe_collect_channel_texture_p4k(
            material_ref.name.as_deref(),
            "opacity",
            &material_ref.opacity_texture_candidates,
            model_path,
            index,
            max_texture_size,
            &mut textures,
            &mut texture_map,
            &mut warnings,
        )
        .await?
        {
            gltf_material.opacity_texture = Some(opacity);
            warnings.push(opacity_approximation_warning(material_id));
        }
        materials_by_id.insert(material_id, materials.len());
        materials.push(gltf_material);
    }
    apply_opacity_textures(&mut textures, &mut materials, &mut warnings);
    Ok((textures, materials, materials_by_id, warnings))
}
fn collect_material_textures_from_fs(
    scene: &SceneData,
    root_material: &MaterialData,
    model_path: &str,
    index: &HashMap<String, String>,
    max_texture_size: Option<u32>,
) -> std::result::Result<
    (
        Vec<DecodedTexture>,
        Vec<GltfMaterialData>,
        HashMap<i32, usize>,
        Vec<String>,
    ),
    ModelConvertError,
> {
    let mut warnings = Vec::new();
    let mut sorted_ids = root_material
        .sub_materials
        .iter()
        .enumerate()
        .filter_map(|(index, material)| (!material.no_draw).then_some(index as i32))
        .collect::<Vec<_>>();
    if sorted_ids.is_empty() {
        sorted_ids.push(-1);
    }
    let mut texture_map: HashMap<String, usize> = HashMap::new();
    let mut textures = Vec::new();
    let mut materials = Vec::new();
    let mut materials_by_id = HashMap::new();
    for material_id in sorted_ids {
        let material_ref = if material_id >= 0 {
            root_material
                .sub_materials
                .get(material_id as usize)
                .unwrap_or_else(|| {
                    warnings.push(material_fallback_warning(material_id));
                    root_material
                })
        } else {
            root_material
        };
        let mut gltf_material = GltfMaterialData::default();
        gltf_material.name = material_ref.name.clone();
        gltf_material.base_color_factor = Some(if material_ref.no_draw {
            [0.0, 0.0, 0.0, 0.0]
        } else {
            let diffuse = material_ref.diffuse.unwrap_or([1.0, 1.0, 1.0]);
            [
                diffuse[0],
                diffuse[1],
                diffuse[2],
                material_ref.opacity.unwrap_or(1.0).clamp(0.0, 1.0),
            ]
        });
        gltf_material.specular_factor = Some(material_ref.specular.unwrap_or([1.0, 1.0, 1.0]));
        let shininess = material_ref.shininess.unwrap_or(0.0);
        let glossiness = (shininess / 255.0).clamp(0.0, 1.0);
        gltf_material.glossiness_factor = Some(glossiness);
        gltf_material.pbr_roughness_factor = Some(((255.0 - shininess) / 255.0).clamp(0.0, 1.0));
        gltf_material.double_sided = Some(
            material_ref
                .material_flags
                .map(|flags| (flags & 0x2) != 0)
                .unwrap_or(false),
        );
        let opacity = material_ref.opacity.unwrap_or(1.0).clamp(0.0, 1.0);
        gltf_material.alpha_mode = Some(if material_ref.no_draw {
            "MASK".to_string()
        } else if material_ref.alpha_test.unwrap_or(0.0) > 0.0 {
            "MASK".to_string()
        } else if opacity < 1.0 || material_uses_opacity_texture(material_ref) {
            "BLEND".to_string()
        } else {
            "OPAQUE".to_string()
        });
        gltf_material.alpha_cutoff = material_ref.alpha_test;
        gltf_material.no_draw = material_ref.no_draw;
        let normal_candidates = material_ref.normal_candidates.clone();
        let base_candidates = material_ref.base_color_candidates.clone();
        let spec_candidates = material_ref.specular_texture_candidates.clone();
        gltf_material.normal_texture = maybe_collect_channel_texture_fs(
            material_ref.name.as_deref(),
            "normal",
            &normal_candidates,
            model_path,
            index,
            max_texture_size,
            &mut textures,
            &mut texture_map,
            &mut warnings,
        )?;
        gltf_material.base_color_texture = maybe_collect_channel_texture_fs(
            material_ref.name.as_deref(),
            "baseColor",
            &base_candidates,
            model_path,
            index,
            max_texture_size,
            &mut textures,
            &mut texture_map,
            &mut warnings,
        )?;
        gltf_material.diffuse_texture = gltf_material.base_color_texture;
        if material_uses_specular_texture(material_ref) {
            gltf_material.specular_glossiness_texture = maybe_collect_channel_texture_fs(
                material_ref.name.as_deref(),
                "specular",
                &spec_candidates,
                model_path,
                index,
                max_texture_size,
                &mut textures,
                &mut texture_map,
                &mut warnings,
            )?;
        }
        gltf_material.emissive_texture = maybe_collect_channel_texture_fs(
            material_ref.name.as_deref(),
            "emissive",
            &material_ref.emissive_candidates,
            model_path,
            index,
            max_texture_size,
            &mut textures,
            &mut texture_map,
            &mut warnings,
        )?;
        gltf_material.occlusion_texture = maybe_collect_channel_texture_fs(
            material_ref.name.as_deref(),
            "occlusion",
            &material_ref.occlusion_candidates,
            model_path,
            index,
            max_texture_size,
            &mut textures,
            &mut texture_map,
            &mut warnings,
        )?;
        gltf_material.opacity_texture = maybe_collect_channel_texture_fs(
            material_ref.name.as_deref(),
            "opacity",
            &material_ref.opacity_texture_candidates,
            model_path,
            index,
            max_texture_size,
            &mut textures,
            &mut texture_map,
            &mut warnings,
        )?;
        if gltf_material.opacity_texture.is_some() {
            warnings.push(opacity_approximation_warning(material_id));
        }
        materials_by_id.insert(material_id, materials.len());
        materials.push(gltf_material);
    }
    apply_opacity_textures(&mut textures, &mut materials, &mut warnings);
    Ok((textures, materials, materials_by_id, warnings))
}
async fn maybe_collect_channel_texture_p4k(
    material_name: Option<&str>,
    channel_name: &str,
    texture_refs: &[String],
    model_path: &str,
    index: &HashMap<String, String>,
    max_texture_size: Option<u32>,
    textures: &mut Vec<DecodedTexture>,
    texture_map: &mut HashMap<String, usize>,
    warnings: &mut Vec<String>,
) -> std::result::Result<Option<usize>, ModelConvertError> {
    let texture_roots = texture_search_roots_p4k(model_path, index);
    let texture_path = resolve_texture_candidates(
        texture_refs.iter().map(String::as_str),
        &texture_roots,
        index,
    );
    let texture = if let Some(texture_path) = texture_path {
        let texture_bytes = unp4k_api::p4k_extract_to_memory(texture_path.clone())
            .await
            .map_err(|e| ModelConvertError::Io(e.to_string()))?;
        match texture_decode::decode_texture(&texture_path, &texture_bytes, max_texture_size) {
            Ok(mut texture) => {
                texture.label = Some(texture_label(material_name, channel_name));
                texture
            }
            Err(err) => {
                warnings.push(texture_decode_failed_warning(
                    &texture_path,
                    channel_name,
                    &err.to_string(),
                ));
                DecodedTexture {
                    name: texture_uri_from_path(&texture_path),
                    uri: texture_uri_from_path(&texture_path),
                    label: Some(texture_label(material_name, channel_name)),
                    width: 0,
                    height: 0,
                    rgba8: Vec::new(),
                }
            }
        }
    } else {
        warnings.push(texture_not_found_warning(
            texture_refs.first().map(|s| s.as_str()).unwrap_or_default(),
            channel_name,
        ));
        return Ok(None);
    };
    let idx = textures.len();
    textures.push(texture);
    Ok(Some(idx))
}
fn maybe_collect_channel_texture_fs(
    material_name: Option<&str>,
    channel_name: &str,
    texture_refs: &[String],
    model_path: &str,
    index: &HashMap<String, String>,
    max_texture_size: Option<u32>,
    textures: &mut Vec<DecodedTexture>,
    texture_map: &mut HashMap<String, usize>,
    warnings: &mut Vec<String>,
) -> std::result::Result<Option<usize>, ModelConvertError> {
    let texture_roots = texture_search_roots_fs(model_path);
    let texture_path = resolve_texture_candidates(
        texture_refs.iter().map(String::as_str),
        &texture_roots,
        index,
    );
    let texture = if let Some(texture_path) = texture_path {
        let texture_bytes = std::fs::read(&texture_path)
            .map_err(|e| ModelConvertError::Io(format!("read texture {texture_path}: {e}")))?;
        match texture_decode::decode_texture(&texture_path, &texture_bytes, max_texture_size) {
            Ok(mut texture) => {
                texture.label = Some(texture_label(material_name, channel_name));
                texture
            }
            Err(err) => {
                warnings.push(texture_decode_failed_warning(
                    &texture_path,
                    channel_name,
                    &err.to_string(),
                ));
                DecodedTexture {
                    name: texture_uri_from_path(&texture_path),
                    uri: texture_uri_from_path(&texture_path),
                    label: Some(texture_label(material_name, channel_name)),
                    width: 0,
                    height: 0,
                    rgba8: Vec::new(),
                }
            }
        }
    } else {
        warnings.push(texture_not_found_warning(
            texture_refs.first().map(|s| s.as_str()).unwrap_or_default(),
            channel_name,
        ));
        return Ok(None);
    };
    let idx = textures.len();
    textures.push(texture);
    Ok(Some(idx))
}
fn normalize_path_key(path: &Path) -> String {
    let mut s = path.to_string_lossy().replace('/', "\\");
    if !s.starts_with('\\') {
        s = format!("\\{s}");
    }
    s.to_lowercase()
}
fn texture_uri_from_path(path: &str) -> String {
    let normalized = path.replace('/', "\\");
    let lower = normalized.to_ascii_lowercase();
    if let Some(pos) = lower.rfind("\\textures\\") {
        let name = Path::new(&normalized[pos + "\\textures\\".len()..])
            .file_name()
            .and_then(|v| v.to_str())
            .unwrap_or(&normalized)
            .to_ascii_lowercase();
        return format!("textures\\{name}");
    }
    if let Some(pos) = lower.rfind("\\texture\\") {
        let name = Path::new(&normalized[pos + "\\texture\\".len()..])
            .file_name()
            .and_then(|v| v.to_str())
            .unwrap_or(&normalized)
            .to_ascii_lowercase();
        return format!("textures\\{name}");
    }
    Path::new(&normalized)
        .file_name()
        .and_then(|v| v.to_str())
        .unwrap_or(&normalized)
        .to_ascii_lowercase()
}
fn texture_label(material_name: Option<&str>, channel_name: &str) -> String {
    let channel = match channel_name {
        "baseColor" => "diffuse",
        other => other,
    };
    match material_name {
        Some(name) if !name.is_empty() => format!("{name}-{channel}"),
        _ => format!("texture-{channel}"),
    }
}
fn apply_opacity_textures(
    textures: &mut Vec<DecodedTexture>,
    materials: &mut [GltfMaterialData],
    warnings: &mut Vec<String>,
) {
    for material in materials {
        let Some(opacity_index) = material.opacity_texture else {
            continue;
        };
        let Some(base_index) = material.base_color_texture.or(material.diffuse_texture) else {
            continue;
        };
        if base_index == opacity_index {
            continue;
        }
        if base_index < textures.len() && opacity_index < textures.len() {
            let (base, opacity) = texture_pair_mut(textures, base_index, opacity_index);
            if let Some((base, opacity)) = base.zip(opacity) {
                if composite_opacity_texture(base, opacity) {
                    warnings.push(format!(
                        "Applied opacity texture to base color texture for {}",
                        material.name.as_deref().unwrap_or("material")
                    ));
                }
            }
        }
    }
}
fn texture_pair_mut(
    textures: &mut [DecodedTexture],
    a: usize,
    b: usize,
) -> (Option<&mut DecodedTexture>, Option<&mut DecodedTexture>) {
    if a == b {
        return (textures.get_mut(a), None);
    }
    let (low, high, low_is_a) = if a < b { (a, b, true) } else { (b, a, false) };
    let (left, right) = textures.split_at_mut(high);
    let first = left.get_mut(low);
    let second = right.get_mut(0);
    if low_is_a {
        (first, second)
    } else {
        (second, first)
    }
}
fn composite_opacity_texture(base: &mut DecodedTexture, opacity: &DecodedTexture) -> bool {
    if base.width == 0 || base.height == 0 || opacity.width == 0 || opacity.height == 0 {
        return false;
    }
    let expected = (base.width as usize)
        .saturating_mul(base.height as usize)
        .saturating_mul(4);
    if base.rgba8.len() != expected || opacity.rgba8.len() < 4 {
        return false;
    }
    let mut changed = false;
    let base_width = base.width;
    let base_height = base.height;
    let opacity_width = opacity.width;
    let opacity_height = opacity.height;
    for y in 0..base_height {
        let sample_y = if base_height <= 1 {
            0
        } else {
            ((y as u64 * opacity_height as u64) / base_height as u64) as u32
        };
        for x in 0..base_width {
            let sample_x = if base_width <= 1 {
                0
            } else {
                ((x as u64 * opacity_width as u64) / base_width as u64) as u32
            };
            let base_idx = ((y * base_width + x) * 4) as usize;
            let opacity_idx = ((sample_y * opacity_width + sample_x) * 4) as usize;
            let sr = opacity.rgba8.get(opacity_idx).copied().unwrap_or(255) as u32;
            let sg = opacity.rgba8.get(opacity_idx + 1).copied().unwrap_or(255) as u32;
            let sb = opacity.rgba8.get(opacity_idx + 2).copied().unwrap_or(255) as u32;
            let sa = opacity.rgba8.get(opacity_idx + 3).copied().unwrap_or(255) as u32;
            let opacity_alpha = if sa < 255 {
                sa
            } else {
                ((sr * 299 + sg * 587 + sb * 114) / 1000).min(255)
            } as u8;
            let base_alpha = base.rgba8.get(base_idx + 3).copied().unwrap_or(255);
            let merged = ((base_alpha as u32 * opacity_alpha as u32) / 255) as u8;
            if let Some(pixel_alpha) = base.rgba8.get_mut(base_idx + 3) {
                *pixel_alpha = merged;
                changed = true;
            }
        }
    }
    changed
}
fn is_ivo_signature(data: &[u8]) -> bool {
    data.len() >= 4 && data[0..4] == *b"#ivo"
}
fn find_ivo_companion_path(model_path: &str) -> Option<PathBuf> {
    let path = Path::new(model_path);
    let ext = path.extension()?.to_str()?;
    let companion_ext = if ext.eq_ignore_ascii_case("cga") {
        "cgam"
    } else if ext.eq_ignore_ascii_case("cgf") {
        "cgfm"
    } else {
        return None;
    };
    Some(path.with_extension(companion_ext))
}
fn find_ivo_companion_name(model_path: &str, index: &HashMap<String, String>) -> Option<String> {
    let companion_path = find_ivo_companion_path(model_path)?;
    index.get(&normalize_path_key(&companion_path)).cloned()
}
async fn load_companion_bytes_from_p4k(
    model_path: &str,
    index: &HashMap<String, String>,
) -> std::result::Result<Option<Vec<u8>>, ModelConvertError> {
    let Some(companion_name) = find_ivo_companion_name(model_path, index) else {
        return Ok(None);
    };
    let bytes = unp4k_api::p4k_extract_to_memory(companion_name)
        .await
        .map_err(|e| ModelConvertError::Io(e.to_string()))?;
    Ok(Some(bytes))
}
fn load_companion_bytes_from_fs(
    model_path: &str,
) -> std::result::Result<Option<Vec<u8>>, ModelConvertError> {
    let Some(companion_path) = find_ivo_companion_path(model_path) else {
        return Ok(None);
    };
    if !companion_path.exists() {
        return Ok(None);
    }
    let bytes = fs::read(&companion_path).map_err(|e| ModelConvertError::Io(e.to_string()))?;
    Ok(Some(bytes))
}
fn write_native_ivo_glb_from_fs(
    mut scene: SceneData,
    model_path: &str,
    asset_root: &str,
    output_path: &Path,
    material_override: Option<&str>,
    options: &ConvertOptions,
    source_mode: &str,
    mut extra_warnings: Vec<String>,
) -> std::result::Result<ConvertOutput, ModelConvertError> {
    let index = build_fs_index(asset_root).map_err(|e| ModelConvertError::Io(e.to_string()))?;
    let mut material = MaterialData::default();
    if let Some(mtl) = resolve_material_path(model_path, material_override, &index) {
        let mtl_bytes = fs::read(&mtl).map_err(|e| ModelConvertError::Io(e.to_string()))?;
        material = material_parser::parse_mtl_bytes(&mtl_bytes);
    }
    let mut warnings = std::mem::take(&mut scene.warnings);
    warnings.append(&mut extra_warnings);
    let (textures, materials, materials_by_id, texture_warnings) =
        collect_material_textures_from_fs(
            &scene,
            &material,
            model_path,
            &index,
            options.max_texture_size,
        )?;
    warnings.extend(texture_warnings);
    if !options.embed_textures {
        warnings.push(
            "embed_textures=false is not supported yet; textures are still embedded".to_string(),
        );
    }
    gltf_builder::write_glb(&scene, &textures, &materials, &materials_by_id, output_path)
        .map_err(|e| ModelConvertError::Io(e.to_string()))?;
    Ok(ConvertOutput {
        output_path: output_path.to_string_lossy().to_string(),
        warnings,
        source_mode: source_mode.to_string(),
        fallback_reason: None,
    })
}
fn resolve_material_path(
    model_path: &str,
    material_override: Option<&str>,
    index: &HashMap<String, String>,
) -> Option<String> {
    if let Some(override_path) = material_override {
        if let Some(hit) = path_resolver::resolve_texture_path(model_path, override_path, index) {
            return Some(hit);
        }
        let normalized = override_path.replace('/', "\\");
        let prefixed = if normalized.starts_with('\\') {
            normalized.clone()
        } else {
            format!("\\{normalized}")
        };
        if let Some(hit) = index.get(&prefixed.to_lowercase()) {
            return Some(hit.clone());
        }
    }
    path_resolver::find_mtl_path(model_path, index)
}
fn find_material_file_candidates(
    model_path: &str,
    model_bytes: &[u8],
    companion_bytes: Option<&[u8]>,
    material_override: Option<&str>,
    index: &HashMap<String, String>,
) -> Vec<String> {
    let mut candidates = Vec::new();
    let mut seen = std::collections::HashSet::new();
    let mut push_unique = |candidate: Option<String>, candidates: &mut Vec<String>| {
        let Some(candidate) = candidate else {
            return;
        };
        let key = candidate.to_lowercase();
        if seen.insert(key) {
            candidates.push(candidate);
        }
    };
    if let Some(override_path) = material_override {
        push_unique(
            path_resolver::resolve_texture_path(model_path, override_path, index)
                .or_else(|| path_resolver::find_mtl_path(override_path, index)),
            &mut candidates,
        );
    }
    push_unique(
        path_resolver::find_mtl_path(model_path, index),
        &mut candidates,
    );
    for bytes in [Some(model_bytes), companion_bytes].into_iter().flatten() {
        if let Ok(headers) = cryengine::cgf::parse_cgf_headers(bytes) {
            if let Ok(chunks) =
                cryengine::chunks::mtl_name::parse_cgf_mtl_name_chunks(bytes, &headers)
            {
                for chunk in chunks {
                    if chunk.name.is_empty() {
                        continue;
                    }
                    let candidate = if chunk.name.to_lowercase().ends_with(".mtl") {
                        chunk.name.clone()
                    } else {
                        format!("{}.mtl", chunk.name)
                    };
                    push_unique(
                        path_resolver::find_mtl_path(&candidate, index),
                        &mut candidates,
                    );
                }
            }
        }
    }
    candidates
}
fn load_best_material_from_fs(
    model_path: &str,
    model_bytes: &[u8],
    companion_bytes: Option<&[u8]>,
    material_override: Option<&str>,
    index: &HashMap<String, String>,
    desired_material_count: usize,
) -> std::result::Result<MaterialData, ModelConvertError> {
    let candidates = find_material_file_candidates(
        model_path,
        model_bytes,
        companion_bytes,
        material_override,
        index,
    );
    load_best_material_from_candidates_sync(&candidates, desired_material_count, |path| {
        fs::read(path).map_err(|e| ModelConvertError::Io(e.to_string()))
    })
}
async fn load_best_material_from_p4k(
    model_path: &str,
    model_bytes: &[u8],
    companion_bytes: Option<&[u8]>,
    index: &HashMap<String, String>,
    _desired_material_count: usize,
) -> std::result::Result<MaterialData, ModelConvertError> {
    let candidates =
        find_material_file_candidates(model_path, model_bytes, companion_bytes, None, index);
    for candidate in candidates {
        let bytes = unp4k_api::p4k_extract_to_memory(candidate.clone())
            .await
            .map_err(|e| ModelConvertError::Io(e.to_string()))?;
        let material = material_parser::parse_mtl_bytes(&bytes);
        if let Some(material) = finalize_loaded_material(material, &candidate) {
            return Ok(material);
        }
    }
    Ok(MaterialData::default())
}
fn load_best_material_from_candidates_sync<F>(
    candidates: &[String],
    _desired_material_count: usize,
    mut load_bytes: F,
) -> std::result::Result<MaterialData, ModelConvertError>
where
    F: FnMut(&str) -> std::result::Result<Vec<u8>, ModelConvertError>,
{
    for candidate in candidates {
        let bytes = load_bytes(candidate)?;
        let material = material_parser::parse_mtl_bytes(&bytes);
        if let Some(material) = finalize_loaded_material(material, candidate) {
            return Ok(material);
        }
    }
    Ok(MaterialData::default())
}
fn finalize_loaded_material(mut material: MaterialData, candidate: &str) -> Option<MaterialData> {
    if !material_has_payload(&material) {
        return None;
    }
    if material.name.is_none() {
        material.name = Path::new(candidate)
            .file_stem()
            .and_then(|stem| stem.to_str())
            .map(|stem| stem.to_string());
    }
    if material.sub_materials.is_empty() {
        let mut self_material = material.clone();
        self_material.sub_materials.clear();
        material.sub_materials = vec![self_material];
    }
    Some(material)
}
fn material_has_payload(material: &MaterialData) -> bool {
    material.name.is_some()
        || material.diffuse.is_some()
        || material.specular.is_some()
        || material.emissive_color.is_some()
        || material.glow_amount.is_some()
        || material.opacity.is_some()
        || material.shininess.is_some()
        || material.alpha_test.is_some()
        || material.material_flags.is_some()
        || material.shader.is_some()
        || material.string_gen_mask.is_some()
        || material.base_color.is_some()
        || !material.base_color_candidates.is_empty()
        || material.normal.is_some()
        || !material.normal_candidates.is_empty()
        || material.specular_texture.is_some()
        || !material.specular_texture_candidates.is_empty()
        || material.occlusion.is_some()
        || !material.occlusion_candidates.is_empty()
        || material.emissive.is_some()
        || !material.emissive_candidates.is_empty()
        || material.opacity_texture.is_some()
        || !material.opacity_texture_candidates.is_empty()
        || !material.sub_materials.is_empty()
}
fn build_fs_index(asset_root: &str) -> std::io::Result<HashMap<String, String>> {
    let root = Path::new(asset_root);
    let mut index = HashMap::new();
    for entry in WalkDir::new(root).into_iter().filter_map(|e| e.ok()) {
        if !entry.file_type().is_file() {
            continue;
        }
        let path = entry.path();
        let real = path.to_string_lossy().to_string();
        index.insert(normalize_path_key(path), real.clone());
        if let Ok(rel) = path.strip_prefix(root) {
            let rel_path = Path::new("\\").join(rel);
            index.insert(normalize_path_key(&rel_path), real.clone());
        }
    }
    Ok(index)
}
fn is_banu_candidate(path: &Path) -> bool {
    let name = path
        .file_name()
        .and_then(|v| v.to_str())
        .unwrap_or_default()
        .to_lowercase();
    let ext = path
        .extension()
        .and_then(|v| v.to_str())
        .unwrap_or_default()
        .to_lowercase();
    if ext != "cga" && ext != "cgf" {
        return false;
    }
    if !name.starts_with("banu_defender") {
        return false;
    }
    if name.contains("local_grid")
        || name.contains("customvisarea")
        || name.contains("_damaged")
        || name.contains("_destroyed")
        || name.contains("_lod")
    {
        return false;
    }
    true
}
#[cfg(test)]
mod tests {
    use super::convert_from_fs;
    use super::{
        build_fs_index, categorize_parser_error_message, is_banu_candidate,
        is_binary_not_supported_message, is_ivo_signature, is_supported_model,
        load_best_material_from_candidates_sync, DecodedTexture, GltfMaterialData, MaterialData,
        ModelConvertError,
    };
    use sha2::{Digest, Sha256};
    use std::fs;
    use std::path::Path;
    #[test]
    fn categorize_parser_error_marks_binary_not_supported_messages() {
        let err = categorize_parser_error_message(
            "Unsupported file version in binary chunk table".to_string(),
        );
        assert!(matches!(
            err,
            ModelConvertError::ParserBinaryNotSupported(_)
        ));
    }
    #[test]
    fn categorize_parser_error_marks_other_messages_as_parse_failed() {
        let err = categorize_parser_error_message("failed to parse mesh body".to_string());
        assert!(matches!(err, ModelConvertError::ModelParseFailed(_)));
    }
    #[test]
    fn is_binary_not_supported_requires_support_keyword_and_context() {
        assert!(is_binary_not_supported_message(
            "Unsupported binary format: unknown chunk signature"
        ));
        assert!(!is_binary_not_supported_message(
            "unsupported material syntax in xml"
        ));
        assert!(!is_binary_not_supported_message("chunk signature mismatch"));
    }
    #[test]
    fn is_supported_model_accepts_cgf_and_cga_case_insensitively() {
        assert!(is_supported_model("Data/Ship/Gladius.CGF"));
        assert!(is_supported_model("Data/Ship/Gladius.cga"));
        assert!(!is_supported_model("Data/Ship/Gladius.obj"));
    }
    #[test]
    fn material_default_has_no_channels_or_sub_materials() {
        let material = MaterialData::default();
        assert!(material.base_color.is_none());
        assert!(material.normal.is_none());
        assert!(material.occlusion.is_none());
        assert!(material.emissive.is_none());
        assert!(material.opacity_texture.is_none());
        assert!(material.sub_materials.is_empty());
    }
    #[test]
    fn load_best_material_accepts_basic_material_without_submaterials() {
        let fixture = Path::new(env!("CARGO_MANIFEST_DIR"))
            .join("..")
            .join("Cryengine-Converter-master")
            .join("Cryengine-Converter-master")
            .join("CgfConverterIntegrationTests")
            .join("TestData")
            .join("SimpleMat.xml");
        if !fixture.exists() {
            eprintln!(
                "skip load_best_material_accepts_basic_material_without_submaterials: missing fixture {fixture:?}"
            );
            return;
        }
        let candidates = vec![fixture.to_string_lossy().to_string()];
        let material = load_best_material_from_candidates_sync(&candidates, 1, |path| {
            fs::read(path).map_err(|e| ModelConvertError::Io(e.to_string()))
        })
        .expect("load material");
        assert_eq!(material.name.as_deref(), Some("SimpleMat"));
        assert_eq!(material.sub_materials.len(), 1);
        assert_eq!(material.sub_materials[0].name.as_deref(), Some("SimpleMat"));
    }
    #[test]
    fn build_fs_index_contains_absolute_and_relative_keys() {
        let temp = std::env::temp_dir().join("scbox_model_convert_index_test");
        let _ = fs::remove_dir_all(&temp);
        fs::create_dir_all(temp.join("Defender")).expect("mkdir");
        fs::write(temp.join("Defender").join("BANU_Defender.mtl"), b"test").expect("write");
        let index = build_fs_index(temp.to_string_lossy().as_ref()).expect("index");
        assert!(index
            .keys()
            .any(|k| k.contains("\\defender\\banu_defender.mtl")));
        let _ = fs::remove_dir_all(&temp);
    }
    #[test]
    fn opacity_texture_is_applied_to_base_color_alpha() {
        let mut textures = vec![
            DecodedTexture {
                name: "base.png".to_string(),
                uri: "base.png".to_string(),
                label: Some("base".to_string()),
                width: 2,
                height: 2,
                rgba8: vec![
                    255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255,
                ],
            },
            DecodedTexture {
                name: "opacity.png".to_string(),
                uri: "opacity.png".to_string(),
                label: Some("opacity".to_string()),
                width: 2,
                height: 2,
                rgba8: vec![
                    128, 128, 128, 255, 128, 128, 128, 255, 128, 128, 128, 255, 128, 128, 128, 255,
                ],
            },
        ];
        let mut materials = vec![GltfMaterialData {
            base_color_texture: Some(0),
            diffuse_texture: Some(0),
            opacity_texture: Some(1),
            ..Default::default()
        }];
        let mut warnings = Vec::new();

        super::apply_opacity_textures(&mut textures, &mut materials, &mut warnings);

        assert_eq!(textures[0].rgba8[3], 128);
        assert_eq!(textures[0].rgba8[7], 128);
        assert_eq!(textures[0].rgba8[11], 128);
        assert_eq!(textures[0].rgba8[15], 128);
    }
    #[test]
    fn is_banu_candidate_filters_lod_and_non_defender() {
        assert!(is_banu_candidate(Path::new("BANU_Defender_Door.cga")));
        assert!(!is_banu_candidate(Path::new("BANU_Defender_Door_lod1.cga")));
        assert!(!is_banu_candidate(Path::new("OtherShip.cga")));
    }
    #[test]
    fn ivo_signature_detection_works() {
        assert!(is_ivo_signature(b"#ivo\x01\x02\x03"));
        assert!(!is_ivo_signature(b"CrCh"));
        assert!(!is_ivo_signature(b"#iv"));
    }
    #[tokio::test(flavor = "multi_thread")]
    async fn export_banu_defender_single_glb() {
        let model_path =
            r"C:\CODE\ScCode\starcitizen_box\converter-target\BANU\Defender\BANU_Defender.cga";
        let asset_root = r"C:\CODE\ScCode\starcitizen_box\converter-target\BANU";
        let output_dir = r"C:\CODE\ScCode\starcitizen_box\converter-target\BANU\_single_export";
        fs::create_dir_all(output_dir).expect("create output dir");
        let result = convert_from_fs(
            model_path,
            asset_root,
            output_dir,
            super::ConvertOptions {
                embed_textures: true,
                overwrite: true,
                max_texture_size: None,
            },
        )
        .await
        .expect("export failed");
        assert!(Path::new(&result.output_path).exists());
        if std::env::var_os("SCTOOLBOX_COMPARE_CSHARP_GLB").is_some() {
            let reference = Path::new(
                r"C:\CODE\ScCode\starcitizen_box\converter-target\BANU\_cmp_csharp\BANU_Defender.glb",
            );
            let rust_hash = file_sha256(Path::new(&result.output_path));
            let csharp_hash = file_sha256(reference);
            assert_eq!(
                rust_hash, csharp_hash,
                "BANU_Defender glb hash mismatch; compare against the C# reference output"
            );
        }
    }
    fn file_sha256(path: &Path) -> String {
        let bytes = fs::read(path).expect("read glb");
        let digest = Sha256::digest(&bytes);
        digest.iter().map(|byte| format!("{byte:02x}")).collect()
    }
}
