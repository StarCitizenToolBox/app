use std::collections::HashMap;
use std::fs;
use std::path::{Path, PathBuf};

use crate::api::unp4k_api;
use anyhow::Result;

use super::{
    build_fs_index, categorize_parser_error, cgf_parser, collect_material_textures,
    collect_material_textures_from_fs, find_ivo_companion_name, find_ivo_companion_path,
    gltf_builder, is_ivo_signature, ivo_parser, load_best_material_from_fs,
    load_best_material_from_p4k, load_companion_bytes_from_fs, load_companion_bytes_from_p4k,
    material_parser, resolve_material_path, ConvertBytesOutput, ConvertOptions, ConvertOutput,
    MaterialData, ModelConvertError, SceneData,
};

pub async fn convert_from_p4k(
    p4k_path: &str,
    model_path: &str,
    output_dir: &str,
    options: ConvertOptions,
) -> std::result::Result<ConvertOutput, ModelConvertError> {
    let ext = Path::new(model_path)
        .extension()
        .and_then(|v| v.to_str())
        .unwrap_or_default()
        .to_lowercase();
    if ext != "cgf" && ext != "cga" {
        return Err(ModelConvertError::UnsupportedFormat);
    }

    unp4k_api::p4k_open(p4k_path.to_string())
        .await
        .map_err(|e| ModelConvertError::Io(e.to_string()))?;

    let model_bytes = unp4k_api::p4k_extract_to_memory(model_path.to_string())
        .await
        .map_err(|e| ModelConvertError::Io(e.to_string()))?;

    let all_files = unp4k_api::p4k_get_all_files()
        .await
        .map_err(|e| ModelConvertError::Io(e.to_string()))?;
    let mut index = HashMap::with_capacity(all_files.len());
    for item in all_files {
        index.insert(item.name.to_lowercase(), item.name);
    }

    if is_ivo_signature(&model_bytes) {
        return convert_ivo_from_p4k(model_path, output_dir, options, model_bytes, index).await;
    }

    let mut scene =
        cgf_parser::parse_static_scene(&model_bytes).map_err(categorize_parser_error)?;

    let desired_material_count = scene
        .meshes
        .iter()
        .flat_map(|mesh| mesh.primitives.iter())
        .map(|primitive| primitive.material_id.max(0) as usize + 1)
        .max()
        .unwrap_or(1);
    let companion_bytes = load_companion_bytes_from_p4k(model_path, &index).await?;
    let material = load_best_material_from_p4k(
        model_path,
        &model_bytes,
        companion_bytes.as_deref(),
        &index,
        desired_material_count,
    )
    .await?;

    let mut warnings = std::mem::take(&mut scene.warnings);
    let (textures, materials, materials_by_id, texture_warnings) = collect_material_textures(
        &scene,
        &material,
        model_path,
        &index,
        options.max_texture_size,
    )
    .await?;
    warnings.extend(texture_warnings);

    let output_name = Path::new(model_path)
        .file_stem()
        .and_then(|v| v.to_str())
        .unwrap_or("model");
    let output_path = PathBuf::from(output_dir).join(format!("{output_name}.glb"));
    if output_path.exists() && !options.overwrite {
        return Err(ModelConvertError::OutputExists);
    }

    if !options.embed_textures {
        warnings.push(
            "embed_textures=false is not supported yet; textures are still embedded".to_string(),
        );
    }

    gltf_builder::write_glb(
        &scene,
        &textures,
        &materials,
        &materials_by_id,
        &output_path,
    )
    .map_err(|e| ModelConvertError::Io(e.to_string()))?;

    Ok(ConvertOutput {
        output_path: output_path.to_string_lossy().to_string(),
        warnings,
        source_mode: "rust_crch".to_string(),
        fallback_reason: None,
    })
}

/// In-memory variant of `convert_from_p4k` — returns GLB bytes instead of writing to disk.
pub async fn convert_from_p4k_to_bytes(
    p4k_path: &str,
    model_path: &str,
    options: ConvertOptions,
) -> std::result::Result<ConvertBytesOutput, ModelConvertError> {
    let ext = Path::new(model_path)
        .extension()
        .and_then(|v| v.to_str())
        .unwrap_or_default()
        .to_lowercase();
    if ext != "cgf" && ext != "cga" {
        return Err(ModelConvertError::UnsupportedFormat);
    }

    unp4k_api::p4k_open(p4k_path.to_string())
        .await
        .map_err(|e| ModelConvertError::Io(e.to_string()))?;

    let model_bytes = unp4k_api::p4k_extract_to_memory(model_path.to_string())
        .await
        .map_err(|e| ModelConvertError::Io(e.to_string()))?;

    let all_files = unp4k_api::p4k_get_all_files()
        .await
        .map_err(|e| ModelConvertError::Io(e.to_string()))?;
    let mut index = HashMap::with_capacity(all_files.len());
    for item in all_files {
        index.insert(item.name.to_lowercase(), item.name);
    }

    if is_ivo_signature(&model_bytes) {
        return convert_ivo_from_p4k_to_bytes(model_path, options, model_bytes, index).await;
    }

    let mut scene =
        cgf_parser::parse_static_scene(&model_bytes).map_err(categorize_parser_error)?;

    let desired_material_count = scene
        .meshes
        .iter()
        .flat_map(|mesh| mesh.primitives.iter())
        .map(|primitive| primitive.material_id.max(0) as usize + 1)
        .max()
        .unwrap_or(1);
    let companion_bytes = load_companion_bytes_from_p4k(model_path, &index).await?;
    let material = load_best_material_from_p4k(
        model_path,
        &model_bytes,
        companion_bytes.as_deref(),
        &index,
        desired_material_count,
    )
    .await?;

    let mut warnings = std::mem::take(&mut scene.warnings);
    let (textures, materials, materials_by_id, texture_warnings) = collect_material_textures(
        &scene,
        &material,
        model_path,
        &index,
        options.max_texture_size,
    )
    .await?;
    warnings.extend(texture_warnings);

    if !options.embed_textures {
        warnings.push(
            "embed_textures=false is not supported yet; textures are still embedded".to_string(),
        );
    }

    let glb_bytes = gltf_builder::build_glb_bytes(&scene, &textures, &materials, &materials_by_id)
        .map_err(|e| ModelConvertError::Io(e.to_string()))?;

    Ok(ConvertBytesOutput {
        glb_bytes,
        warnings,
        source_mode: "rust_crch".to_string(),
        fallback_reason: None,
    })
}

pub async fn convert_from_fs(
    model_path: &str,
    asset_root: &str,
    output_dir: &str,
    options: ConvertOptions,
) -> std::result::Result<ConvertOutput, ModelConvertError> {
    convert_from_fs_internal(model_path, asset_root, output_dir, options, None).await
}

pub async fn convert_local_batch_and_merge(
    _asset_root: &str,
    _output_dir: &str,
    _options: ConvertOptions,
) -> std::result::Result<(), ModelConvertError> {
    Err(ModelConvertError::UnsupportedFormat)
}

pub fn is_supported_model(path: &str) -> bool {
    let ext = Path::new(path)
        .extension()
        .and_then(|v| v.to_str())
        .unwrap_or_default()
        .to_lowercase();
    ext == "cgf" || ext == "cga"
}

pub fn _debug_result(_: Result<()>) {}

async fn convert_ivo_from_p4k(
    model_path: &str,
    output_dir: &str,
    options: ConvertOptions,
    model_bytes: Vec<u8>,
    index: HashMap<String, String>,
) -> std::result::Result<ConvertOutput, ModelConvertError> {
    let output_name = Path::new(model_path)
        .file_stem()
        .and_then(|v| v.to_str())
        .unwrap_or("model");
    let output_path = PathBuf::from(output_dir).join(format!("{output_name}.glb"));
    if output_path.exists() && !options.overwrite {
        return Err(ModelConvertError::OutputExists);
    }

    let companion_bytes = load_companion_bytes_from_p4k(model_path, &index).await?;
    let native_ivo = ivo_parser::parse_static_scene(&model_bytes);
    let (mut scene, source_mode, extra_warnings) = match native_ivo {
        Ok(scene) if !scene.meshes.is_empty() => (scene, "rust_ivo", Vec::new()),
        Ok(_) => {
            let primary_reason = "native_ivo_parser produced no meshes".to_string();
            if let Some(companion_name) = find_ivo_companion_name(model_path, &index) {
                let companion_bytes = unp4k_api::p4k_extract_to_memory(companion_name.clone())
                    .await
                    .map_err(|e| ModelConvertError::Io(e.to_string()))?;
                if is_ivo_signature(&companion_bytes) {
                    let companion_ivo = ivo_parser::parse_static_scene_with_layout(
                        &companion_bytes,
                        Some(&model_bytes),
                    )
                    .map_err(categorize_parser_error)?;
                    if !companion_ivo.meshes.is_empty() {
                        (
                            companion_ivo,
                            "rust_ivo_companion",
                            vec![format!(
                                "native IVO parser used companion file after primary parse fallback: {} ({})",
                                companion_name, primary_reason
                            )],
                        )
                    } else {
                        return Err(ModelConvertError::ModelParseFailed(format!(
                            "IVO conversion failed without external fallback: {primary_reason}; companion_native_ivo_parser produced no meshes: {companion_name}"
                        )));
                    }
                } else {
                    return Err(ModelConvertError::ModelParseFailed(format!(
                        "IVO conversion failed without external fallback: {primary_reason}"
                    )));
                }
            } else {
                return Err(ModelConvertError::ModelParseFailed(format!(
                    "IVO conversion failed without external fallback: {primary_reason}"
                )));
            }
        }
        Err(e) => {
            let primary_reason = format!("native_ivo_parser_failed: {e}");
            if let Some(companion_name) = find_ivo_companion_name(model_path, &index) {
                let companion_bytes = unp4k_api::p4k_extract_to_memory(companion_name.clone())
                    .await
                    .map_err(|e| ModelConvertError::Io(e.to_string()))?;
                if is_ivo_signature(&companion_bytes) {
                    let companion_ivo = ivo_parser::parse_static_scene_with_layout(
                        &companion_bytes,
                        Some(&model_bytes),
                    )
                    .map_err(categorize_parser_error)?;
                    if !companion_ivo.meshes.is_empty() {
                        (
                            companion_ivo,
                            "rust_ivo_companion",
                            vec![format!(
                                "native IVO parser used companion file after primary parse fallback: {} ({})",
                                companion_name, primary_reason
                            )],
                        )
                    } else {
                        return Err(ModelConvertError::ModelParseFailed(format!(
                            "IVO conversion failed without external fallback: {primary_reason}; companion_native_ivo_parser produced no meshes: {companion_name}"
                        )));
                    }
                } else {
                    return Err(ModelConvertError::ModelParseFailed(format!(
                        "IVO conversion failed without external fallback: {primary_reason}"
                    )));
                }
            } else {
                return Err(ModelConvertError::ModelParseFailed(format!(
                    "IVO conversion failed without external fallback: {primary_reason}"
                )));
            }
        }
    };

    let desired_material_count = scene
        .meshes
        .iter()
        .flat_map(|mesh| mesh.primitives.iter())
        .map(|primitive| primitive.material_id.max(0) as usize + 1)
        .max()
        .unwrap_or(1);
    let material = load_best_material_from_p4k(
        model_path,
        &model_bytes,
        companion_bytes.as_deref(),
        &index,
        desired_material_count,
    )
    .await?;

    let (textures, materials, materials_by_id, texture_warnings) = collect_material_textures(
        &scene,
        &material,
        model_path,
        &index,
        options.max_texture_size,
    )
    .await?;

    let mut warnings = std::mem::take(&mut scene.warnings);
    warnings.extend(extra_warnings);
    warnings.extend(texture_warnings);

    if !options.embed_textures {
        warnings.push(
            "embed_textures=false is not supported yet; textures are still embedded".to_string(),
        );
    }

    gltf_builder::write_glb(
        &scene,
        &textures,
        &materials,
        &materials_by_id,
        &output_path,
    )
    .map_err(|e| ModelConvertError::Io(e.to_string()))?;

    Ok(ConvertOutput {
        output_path: output_path.to_string_lossy().to_string(),
        warnings,
        source_mode: source_mode.to_string(),
        fallback_reason: None,
    })
}

/// In-memory variant of `convert_ivo_from_p4k` — returns GLB bytes instead of writing to disk.
async fn convert_ivo_from_p4k_to_bytes(
    model_path: &str,
    options: ConvertOptions,
    model_bytes: Vec<u8>,
    index: HashMap<String, String>,
) -> std::result::Result<ConvertBytesOutput, ModelConvertError> {
    let companion_bytes = load_companion_bytes_from_p4k(model_path, &index).await?;
    let native_ivo = ivo_parser::parse_static_scene(&model_bytes);
    let (mut scene, source_mode, extra_warnings) = match native_ivo {
        Ok(scene) if !scene.meshes.is_empty() => (scene, "rust_ivo", Vec::new()),
        Ok(_) => {
            let primary_reason = "native_ivo_parser produced no meshes".to_string();
            if let Some(companion_name) = find_ivo_companion_name(model_path, &index) {
                let companion_bytes = unp4k_api::p4k_extract_to_memory(companion_name.clone())
                    .await
                    .map_err(|e| ModelConvertError::Io(e.to_string()))?;
                if is_ivo_signature(&companion_bytes) {
                    let companion_ivo = ivo_parser::parse_static_scene_with_layout(
                        &companion_bytes,
                        Some(&model_bytes),
                    )
                    .map_err(categorize_parser_error)?;
                    if !companion_ivo.meshes.is_empty() {
                        (
                            companion_ivo,
                            "rust_ivo_companion",
                            vec![format!(
                                "native IVO parser used companion file after primary parse fallback: {} ({})",
                                companion_name, primary_reason
                            )],
                        )
                    } else {
                        return Err(ModelConvertError::ModelParseFailed(format!(
                            "IVO conversion failed without external fallback: {primary_reason}; companion_native_ivo_parser produced no meshes: {companion_name}"
                        )));
                    }
                } else {
                    return Err(ModelConvertError::ModelParseFailed(format!(
                        "IVO conversion failed without external fallback: {primary_reason}"
                    )));
                }
            } else {
                return Err(ModelConvertError::ModelParseFailed(format!(
                    "IVO conversion failed without external fallback: {primary_reason}"
                )));
            }
        }
        Err(e) => {
            let primary_reason = format!("native_ivo_parser_failed: {e}");
            if let Some(companion_name) = find_ivo_companion_name(model_path, &index) {
                let companion_bytes = unp4k_api::p4k_extract_to_memory(companion_name.clone())
                    .await
                    .map_err(|e| ModelConvertError::Io(e.to_string()))?;
                if is_ivo_signature(&companion_bytes) {
                    let companion_ivo = ivo_parser::parse_static_scene_with_layout(
                        &companion_bytes,
                        Some(&model_bytes),
                    )
                    .map_err(categorize_parser_error)?;
                    if !companion_ivo.meshes.is_empty() {
                        (
                            companion_ivo,
                            "rust_ivo_companion",
                            vec![format!(
                                "native IVO parser used companion file after primary parse fallback: {} ({})",
                                companion_name, primary_reason
                            )],
                        )
                    } else {
                        return Err(ModelConvertError::ModelParseFailed(format!(
                            "IVO conversion failed without external fallback: {primary_reason}; companion_native_ivo_parser produced no meshes: {companion_name}"
                        )));
                    }
                } else {
                    return Err(ModelConvertError::ModelParseFailed(format!(
                        "IVO conversion failed without external fallback: {primary_reason}"
                    )));
                }
            } else {
                return Err(ModelConvertError::ModelParseFailed(format!(
                    "IVO conversion failed without external fallback: {primary_reason}"
                )));
            }
        }
    };

    let desired_material_count = scene
        .meshes
        .iter()
        .flat_map(|mesh| mesh.primitives.iter())
        .map(|primitive| primitive.material_id.max(0) as usize + 1)
        .max()
        .unwrap_or(1);
    let material = load_best_material_from_p4k(
        model_path,
        &model_bytes,
        companion_bytes.as_deref(),
        &index,
        desired_material_count,
    )
    .await?;

    let (textures, materials, materials_by_id, texture_warnings) = collect_material_textures(
        &scene,
        &material,
        model_path,
        &index,
        options.max_texture_size,
    )
    .await?;

    let mut warnings = std::mem::take(&mut scene.warnings);
    warnings.extend(extra_warnings);
    warnings.extend(texture_warnings);

    if !options.embed_textures {
        warnings.push(
            "embed_textures=false is not supported yet; textures are still embedded".to_string(),
        );
    }

    let glb_bytes = gltf_builder::build_glb_bytes(&scene, &textures, &materials, &materials_by_id)
        .map_err(|e| ModelConvertError::Io(e.to_string()))?;

    Ok(ConvertBytesOutput {
        glb_bytes,
        warnings,
        source_mode: source_mode.to_string(),
        fallback_reason: None,
    })
}

async fn convert_from_fs_internal(
    model_path: &str,
    asset_root: &str,
    output_dir: &str,
    options: ConvertOptions,
    material_override: Option<&str>,
) -> std::result::Result<ConvertOutput, ModelConvertError> {
    let ext = Path::new(model_path)
        .extension()
        .and_then(|v| v.to_str())
        .unwrap_or_default()
        .to_lowercase();
    if ext != "cgf" && ext != "cga" {
        return Err(ModelConvertError::UnsupportedFormat);
    }

    let output_name = Path::new(model_path)
        .file_stem()
        .and_then(|v| v.to_str())
        .unwrap_or("model");
    let output_path = PathBuf::from(output_dir).join(format!("{output_name}.glb"));
    if output_path.exists() && !options.overwrite {
        return Err(ModelConvertError::OutputExists);
    }

    let model_bytes = fs::read(model_path).map_err(|e| ModelConvertError::Io(e.to_string()))?;
    if is_ivo_signature(&model_bytes) {
        let native_ivo = ivo_parser::parse_static_scene(&model_bytes);
        match native_ivo {
            Ok(scene) if !scene.meshes.is_empty() => {
                return write_native_ivo_glb_from_fs(
                    scene,
                    model_path,
                    asset_root,
                    &output_path,
                    material_override,
                    &options,
                    "rust_ivo",
                    Vec::new(),
                );
            }
            Ok(_) => {
                let primary_reason = "native_ivo_parser produced no meshes".to_string();

                if let Some(companion_path) = find_ivo_companion_path(model_path) {
                    if companion_path.exists() {
                        let companion_bytes = fs::read(&companion_path)
                            .map_err(|e| ModelConvertError::Io(e.to_string()))?;
                        if is_ivo_signature(&companion_bytes) {
                            let companion_ivo = ivo_parser::parse_static_scene_with_layout(
                                &companion_bytes,
                                Some(&model_bytes),
                            );
                            match companion_ivo {
                                Ok(scene) if !scene.meshes.is_empty() => {
                                    return write_native_ivo_glb_from_fs(
                                        scene,
                                        model_path,
                                        asset_root,
                                        &output_path,
                                        material_override,
                                        &options,
                                        "rust_ivo_companion",
                                        vec![format!(
                                            "native IVO parser used companion file after primary parse fallback: {} ({})",
                                            companion_path.display(),
                                            primary_reason
                                        )],
                                    );
                                }
                                Ok(_) => {
                                    let reason = format!(
                                        "{primary_reason}; companion_native_ivo_parser produced no meshes: {}",
                                        companion_path.display()
                                    );
                                    return Err(ModelConvertError::ModelParseFailed(format!(
                                        "IVO conversion failed without external fallback: {reason}"
                                    )));
                                }
                                Err(e) => {
                                    let reason = format!(
                                        "{primary_reason}; companion_native_ivo_parser_failed: {} ({e})",
                                        companion_path.display()
                                    );
                                    return Err(ModelConvertError::ModelParseFailed(format!(
                                        "IVO conversion failed without external fallback: {reason}"
                                    )));
                                }
                            }
                        }
                    }
                }

                return Err(ModelConvertError::ModelParseFailed(format!(
                    "IVO conversion failed without external fallback: {primary_reason}"
                )));
            }
            Err(e) => {
                let primary_reason = format!("native_ivo_parser_failed: {e}");

                if let Some(companion_path) = find_ivo_companion_path(model_path) {
                    if companion_path.exists() {
                        let companion_bytes = fs::read(&companion_path)
                            .map_err(|e| ModelConvertError::Io(e.to_string()))?;
                        if is_ivo_signature(&companion_bytes) {
                            let companion_ivo = ivo_parser::parse_static_scene_with_layout(
                                &companion_bytes,
                                Some(&model_bytes),
                            );
                            match companion_ivo {
                                Ok(scene) if !scene.meshes.is_empty() => {
                                    return write_native_ivo_glb_from_fs(
                                        scene,
                                        model_path,
                                        asset_root,
                                        &output_path,
                                        material_override,
                                        &options,
                                        "rust_ivo_companion",
                                        vec![format!(
                                            "native IVO parser used companion file after primary parse fallback: {} ({})",
                                            companion_path.display(),
                                            primary_reason
                                        )],
                                    );
                                }
                                Ok(_) => {
                                    let companion_reason = format!(
                                        "companion_native_ivo_parser produced no meshes: {}",
                                        companion_path.display()
                                    );
                                    let reason = format!("{primary_reason}; {companion_reason}");
                                    return Err(ModelConvertError::ModelParseFailed(format!(
                                        "IVO conversion failed without external fallback: {reason}"
                                    )));
                                }
                                Err(e) => {
                                    let companion_reason = format!(
                                        "companion_native_ivo_parser_failed: {} ({e})",
                                        companion_path.display()
                                    );
                                    let reason = format!("{primary_reason}; {companion_reason}");
                                    return Err(ModelConvertError::ModelParseFailed(format!(
                                        "IVO conversion failed without external fallback: {reason}"
                                    )));
                                }
                            }
                        }
                    }
                }

                return Err(ModelConvertError::ModelParseFailed(format!(
                    "IVO conversion failed without external fallback: {primary_reason}"
                )));
            }
        }
    }

    let index = build_fs_index(asset_root).map_err(|e| ModelConvertError::Io(e.to_string()))?;

    let mut scene =
        cgf_parser::parse_static_scene(&model_bytes).map_err(categorize_parser_error)?;

    let desired_material_count = scene
        .meshes
        .iter()
        .flat_map(|mesh| mesh.primitives.iter())
        .map(|primitive| primitive.material_id.max(0) as usize + 1)
        .max()
        .unwrap_or(1);
    let companion_bytes = load_companion_bytes_from_fs(model_path)?;
    let material = load_best_material_from_fs(
        model_path,
        &model_bytes,
        companion_bytes.as_deref(),
        material_override,
        &index,
        desired_material_count,
    )?;

    let mut warnings = std::mem::take(&mut scene.warnings);
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

    gltf_builder::write_glb(
        &scene,
        &textures,
        &materials,
        &materials_by_id,
        &output_path,
    )
    .map_err(|e| ModelConvertError::Io(e.to_string()))?;

    Ok(ConvertOutput {
        output_path: output_path.to_string_lossy().to_string(),
        warnings,
        source_mode: "rust_crch".to_string(),
        fallback_reason: None,
    })
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
