use std::collections::HashMap;
use std::fs;
use std::path::{Path, PathBuf};
use walkdir::WalkDir;

use crate::api::unp4k_api;
use anyhow::Result;

use super::{
    build_fs_index, categorize_parser_error, cgf_parser, collect_material_textures,
    collect_material_textures_from_fs, entity_assembly_parser, find_ivo_companion_name,
    find_ivo_companion_path, glb_merge, gltf_builder, is_ivo_signature, ivo_parser,
    load_best_material_from_fs, load_best_material_from_p4k, load_companion_bytes_from_fs,
    load_companion_bytes_from_p4k, material_parser, path_resolver, resolve_material_path,
    BatchAssemblyStats, BatchConvertOutput, BatchFileOutput, ConvertBytesOutput, ConvertOptions,
    ConvertOutput, MaterialData, ModelConvertError, SceneData,
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
    asset_root: &str,
    output_dir: &str,
    options: ConvertOptions,
) -> std::result::Result<BatchConvertOutput, ModelConvertError> {
    let asset_root_path = Path::new(asset_root);
    if !asset_root_path.is_dir() {
        return Err(ModelConvertError::Io(format!(
            "asset root is not a directory: {asset_root}"
        )));
    }
    fs::create_dir_all(output_dir).map_err(|e| ModelConvertError::Io(e.to_string()))?;

    let index = build_fs_index(asset_root).map_err(|e| ModelConvertError::Io(e.to_string()))?;
    let (assembly_models, stats, mut warnings) = discover_assembly_models(asset_root, &index);
    let jobs = if assembly_models.is_empty() {
        warnings.push(
            "no assembly XML geometry found; falling back to all local model files".to_string(),
        );
        discover_model_files(asset_root)
            .into_iter()
            .map(|model_path| BatchModelJob {
                model_path,
                material_override: None,
                anchor: Some("root".to_string()),
            })
            .collect::<Vec<_>>()
    } else {
        assembly_models
    };

    if jobs.is_empty() {
        return Err(ModelConvertError::UnsupportedFormat);
    }

    let parts_dir = Path::new(output_dir).join("_parts");
    fs::create_dir_all(&parts_dir).map_err(|e| ModelConvertError::Io(e.to_string()))?;

    let mut files = Vec::new();
    let mut merge_inputs = Vec::new();
    let mut fallback_reason_by_file = Vec::new();
    for (idx, job) in jobs.iter().enumerate() {
        let part_dir = parts_dir.join(format!("{idx:04}"));
        fs::create_dir_all(&part_dir).map_err(|e| ModelConvertError::Io(e.to_string()))?;
        match convert_from_fs_internal(
            &job.model_path,
            asset_root,
            part_dir.to_string_lossy().as_ref(),
            options.clone(),
            job.material_override.as_deref(),
        )
        .await
        {
            Ok(output) => {
                if let Some(reason) = output.fallback_reason.as_ref() {
                    fallback_reason_by_file.push(format!("{}: {reason}", job.model_path));
                }
                merge_inputs.push(glb_merge::MergeInput {
                    path: PathBuf::from(&output.output_path),
                    anchor: job.anchor.clone(),
                    anchor_path: None,
                    anchor_translation: None,
                });
                files.push(BatchFileOutput {
                    model_path: job.model_path.clone(),
                    output_path: Some(output.output_path),
                    has_geometry: true,
                    error_code: None,
                    error_message: None,
                    warnings: output.warnings,
                    source_mode: output.source_mode,
                    fallback_reason: output.fallback_reason,
                });
            }
            Err(error) => {
                files.push(BatchFileOutput {
                    model_path: job.model_path.clone(),
                    output_path: None,
                    has_geometry: false,
                    error_code: Some(error.code().to_string()),
                    error_message: Some(error.to_string()),
                    warnings: Vec::new(),
                    source_mode: "failed".to_string(),
                    fallback_reason: None,
                });
            }
        }
    }

    if merge_inputs.is_empty() {
        return Err(ModelConvertError::ModelParseFailed(
            "no local model parts converted successfully".to_string(),
        ));
    }

    let merged_output_path = Path::new(output_dir).join("assembly.glb");
    let anchors = jobs
        .iter()
        .filter_map(|job| job.anchor.clone())
        .collect::<Vec<_>>();
    let _stats =
        glb_merge::merge_glbs_with_attachments(&merge_inputs, &anchors, &merged_output_path)
            .map_err(|e| ModelConvertError::Io(e.to_string()))?;

    let assembly_manifest_path = Path::new(output_dir).join("assembly_manifest.json");
    let assembly_report_path = Path::new(output_dir).join("assembly_report.json");
    write_batch_manifest(&assembly_manifest_path, asset_root, &jobs)
        .map_err(|e| ModelConvertError::Io(e.to_string()))?;
    write_batch_report(&assembly_report_path, &files)
        .map_err(|e| ModelConvertError::Io(e.to_string()))?;

    let success_count = files
        .iter()
        .filter(|file| file.output_path.is_some())
        .count() as i32;
    let failed_count = files
        .iter()
        .filter(|file| file.error_code.is_some())
        .count() as i32;
    Ok(BatchConvertOutput {
        merged_output_path: merged_output_path.to_string_lossy().to_string(),
        assembly_manifest_path: assembly_manifest_path.to_string_lossy().to_string(),
        assembly_report_path: assembly_report_path.to_string_lossy().to_string(),
        success_count,
        empty_count: 0,
        failed_count,
        warnings,
        files,
        source_mode: "rust_local_assembly".to_string(),
        assembly_graph_stats: stats,
        fallback_reason_by_file,
    })
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

#[derive(Debug, Clone)]
struct BatchModelJob {
    model_path: String,
    material_override: Option<String>,
    anchor: Option<String>,
}

fn discover_assembly_models(
    asset_root: &str,
    index: &HashMap<String, String>,
) -> (Vec<BatchModelJob>, BatchAssemblyStats, Vec<String>) {
    let mut jobs = Vec::new();
    let mut warnings = Vec::new();
    let mut stats = BatchAssemblyStats::default();
    for entry in WalkDir::new(asset_root)
        .into_iter()
        .filter_map(|entry| entry.ok())
    {
        if !entry.file_type().is_file() {
            continue;
        }
        let path = entry.path();
        let ext = path
            .extension()
            .and_then(|ext| ext.to_str())
            .unwrap_or_default()
            .to_ascii_lowercase();
        if !matches!(ext.as_str(), "xml" | "soc" | "entxml") {
            continue;
        }
        let Ok(xml_text) = fs::read_to_string(path) else {
            continue;
        };
        let Ok(graph) = entity_assembly_parser::parse_banu_assembly_graph(&xml_text) else {
            continue;
        };
        if graph.models.is_empty() && graph.object_containers.is_empty() {
            continue;
        }
        stats.nodes += graph.anchors.len() as i32;
        stats.geometry_nodes += graph.models.len() as i32;
        stats.object_containers += graph.object_containers.len() as i32;
        stats.roots += 1;
        for model in graph.models {
            if let Some(model_path) = path_resolver::resolve_texture_path(
                path.to_string_lossy().as_ref(),
                &model.model_ref,
                index,
            )
            .or_else(|| resolve_indexed_path(&model.model_ref, index))
            {
                jobs.push(BatchModelJob {
                    model_path,
                    material_override: model.material_override,
                    anchor: Some(model.anchor),
                });
            } else {
                warnings.push(format!(
                    "assembly model not found: {} referenced by {}",
                    model.model_ref,
                    path.display()
                ));
            }
        }
    }
    dedupe_jobs(&mut jobs);
    (jobs, stats, warnings)
}

fn discover_model_files(asset_root: &str) -> Vec<String> {
    let mut paths = Vec::new();
    for entry in WalkDir::new(asset_root)
        .into_iter()
        .filter_map(|entry| entry.ok())
    {
        if !entry.file_type().is_file() {
            continue;
        }
        let path = entry.path();
        let ext = path
            .extension()
            .and_then(|ext| ext.to_str())
            .unwrap_or_default()
            .to_ascii_lowercase();
        if ext != "cga" && ext != "cgf" {
            continue;
        }
        let name = path
            .file_name()
            .and_then(|name| name.to_str())
            .unwrap_or_default()
            .to_ascii_lowercase();
        if name.contains("_lod")
            || name.contains("_damaged")
            || name.contains("_destroyed")
            || name.contains("customvisarea")
            || name.contains("local_grid")
        {
            continue;
        }
        paths.push(path.to_string_lossy().to_string());
    }
    paths.sort();
    paths
}

fn resolve_indexed_path(path: &str, index: &HashMap<String, String>) -> Option<String> {
    let normalized = path.replace('/', "\\");
    let with_data =
        if normalized.to_ascii_lowercase().starts_with("data\\") || normalized.starts_with('\\') {
            normalized.clone()
        } else {
            format!("Data\\{normalized}")
        };
    let keys = [
        normalized.to_ascii_lowercase(),
        format!("\\{}", normalized.trim_start_matches('\\')).to_ascii_lowercase(),
        with_data.to_ascii_lowercase(),
        format!("\\{}", with_data.trim_start_matches('\\')).to_ascii_lowercase(),
    ];
    keys.into_iter().find_map(|key| index.get(&key).cloned())
}

fn dedupe_jobs(jobs: &mut Vec<BatchModelJob>) {
    let mut seen = std::collections::HashSet::new();
    jobs.retain(|job| {
        let key = format!(
            "{}|{}|{}",
            job.model_path.to_ascii_lowercase(),
            job.material_override
                .as_deref()
                .unwrap_or_default()
                .to_ascii_lowercase(),
            job.anchor
                .as_deref()
                .unwrap_or_default()
                .to_ascii_lowercase()
        );
        seen.insert(key)
    });
}

fn write_batch_manifest(path: &Path, asset_root: &str, jobs: &[BatchModelJob]) -> Result<()> {
    let models = jobs
        .iter()
        .map(|job| {
            serde_json::json!({
                "model_path": job.model_path,
                "material_override": job.material_override,
                "anchor": job.anchor,
            })
        })
        .collect::<Vec<_>>();
    let json = serde_json::json!({
        "asset_root": asset_root,
        "models": models,
    });
    fs::write(path, serde_json::to_vec_pretty(&json)?)?;
    Ok(())
}

fn write_batch_report(path: &Path, files: &[BatchFileOutput]) -> Result<()> {
    let files = files
        .iter()
        .map(|file| {
            serde_json::json!({
                "model_path": file.model_path,
                "output_path": file.output_path,
                "has_geometry": file.has_geometry,
                "error_code": file.error_code,
                "error_message": file.error_message,
                "warnings": file.warnings,
                "source_mode": file.source_mode,
                "fallback_reason": file.fallback_reason,
            })
        })
        .collect::<Vec<_>>();
    fs::write(path, serde_json::to_vec_pretty(&files)?)?;
    Ok(())
}

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
