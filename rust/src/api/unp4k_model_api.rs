use anyhow::Result;
use flutter_rust_bridge::frb;
use parking_lot::Mutex;
use std::collections::HashMap;
use std::fs;
use std::path::{Path, PathBuf};
use uuid::Uuid;

use crate::model_convert::{self, ConvertCancelToken, ConvertOptions};
use crate::model_render;

#[frb(dart_metadata=("freezed"))]
pub struct ModelConvertResult {
    pub success: bool,
    pub output_path: Option<String>,
    pub error_code: Option<String>,
    pub error_message: Option<String>,
    pub warnings: Vec<String>,
}

#[frb(dart_metadata=("freezed"))]
pub struct ModelConvertBytesResult {
    pub success: bool,
    pub glb_bytes: Option<Vec<u8>>,
    pub error_code: Option<String>,
    pub error_message: Option<String>,
    pub warnings: Vec<String>,
}

#[frb(dart_metadata=("freezed"))]
pub struct ModelRenderResult {
    pub success: bool,
    pub width: u32,
    pub height: u32,
    pub rgba_data: Option<Vec<u8>>,
    pub error_message: Option<String>,
}

#[frb(dart_metadata=("freezed"))]
pub struct SessionCreateResult {
    pub success: bool,
    pub session_id: Option<String>,
    pub model_radius: f32,
    pub error_message: Option<String>,
}

#[frb(dart_metadata=("freezed"))]
pub struct SessionStartResult {
    pub success: bool,
    pub session_id: Option<String>,
    pub error_message: Option<String>,
}

#[frb(dart_metadata=("freezed"))]
pub struct SessionStatusResult {
    pub exists: bool,
    pub ready: bool,
    pub failed: bool,
    pub stage: String,
    pub model_radius: f32,
    pub error_message: Option<String>,
}

#[frb(dart_metadata=("freezed"))]
pub struct LocalBatchFileResult {
    pub model_path: String,
    pub output_path: Option<String>,
    pub has_geometry: bool,
    pub error_code: Option<String>,
    pub error_message: Option<String>,
    pub warnings: Vec<String>,
    pub source_mode: String,
    pub fallback_reason: Option<String>,
}

#[frb(dart_metadata=("freezed"))]
pub struct AssemblyGraphStats {
    pub nodes: i32,
    pub geometry_nodes: i32,
    pub object_containers: i32,
    pub roots: i32,
}

#[frb(dart_metadata=("freezed"))]
pub struct LocalBatchConvertResult {
    pub success: bool,
    pub merged_output_path: Option<String>,
    pub assembly_manifest_path: Option<String>,
    pub assembly_report_path: Option<String>,
    pub success_count: i32,
    pub empty_count: i32,
    pub failed_count: i32,
    pub warnings: Vec<String>,
    pub files: Vec<LocalBatchFileResult>,
    pub source_mode: String,
    pub assembly_graph_stats: AssemblyGraphStats,
    pub fallback_reason_by_file: Vec<String>,
    pub error_code: Option<String>,
    pub error_message: Option<String>,
}

#[frb(dart_metadata=("freezed"))]
pub struct ModelConvertOptions {
    pub embed_textures: bool,
    pub overwrite: bool,
    pub max_texture_size: Option<u32>,
}

impl From<Option<ModelConvertOptions>> for ConvertOptions {
    fn from(value: Option<ModelConvertOptions>) -> Self {
        if let Some(v) = value {
            ConvertOptions {
                embed_textures: v.embed_textures,
                overwrite: v.overwrite,
                max_texture_size: v.max_texture_size,
                cancel_token: None,
            }
        } else {
            ConvertOptions::default()
        }
    }
}

#[derive(Clone)]
struct PreviewSessionStatus {
    ready: bool,
    failed: bool,
    stage: String,
    model_radius: f32,
    error_message: Option<String>,
    cancel_token: ConvertCancelToken,
}

lazy_static::lazy_static! {
    static ref PREVIEW_SESSION_STATUS: Mutex<HashMap<String, PreviewSessionStatus>> =
        Mutex::new(HashMap::new());
}

fn session_bg_color(bg_color: Option<Vec<f32>>) -> Option<[f32; 4]> {
    bg_color.and_then(|c| {
        if c.len() == 4 {
            Some([c[0], c[1], c[2], c[3]])
        } else {
            None
        }
    })
}

fn preview_session_exists(session_id: &str) -> bool {
    PREVIEW_SESSION_STATUS.lock().contains_key(session_id)
}

fn release_stale_preview_sessions(active_session_id: Option<&str>) {
    let stale_statuses = {
        let mut statuses = PREVIEW_SESSION_STATUS.lock();
        let stale_ids = statuses
            .keys()
            .filter(|session_id| {
                active_session_id.is_none_or(|active| active != session_id.as_str())
            })
            .cloned()
            .collect::<Vec<_>>();
        stale_ids
            .into_iter()
            .filter_map(|session_id| statuses.remove(&session_id))
            .collect::<Vec<_>>()
    };
    for status in stale_statuses {
        status.cancel_token.cancel();
    }
    model_render::release_all_sessions_except(active_session_id);
}

/// Initialize the OpenGL context for model rendering.
/// Should be called once at application startup before any model rendering.
/// Returns true if context was initialized, false if already initialized.
pub fn p4k_model_init_context() -> Result<bool> {
    model_render::init_context()
}

pub fn p4k_model_is_supported(file_path: String) -> bool {
    model_convert::is_supported_model(&file_path)
}

pub async fn p4k_model_convert_to_glb(
    p4k_path: String,
    model_path: String,
    output_dir: String,
    options: Option<ModelConvertOptions>,
) -> Result<ModelConvertResult> {
    let options: ConvertOptions = options.into();
    let result = p4k_model_convert_to_glb_without_textures_inner(
        &p4k_path,
        &model_path,
        &output_dir,
        options,
    )
    .await;
    match result {
        Ok(ok) => Ok(ModelConvertResult {
            success: true,
            output_path: Some(ok.output_path),
            error_code: None,
            error_message: None,
            warnings: ok.warnings,
        }),
        Err(e) => Ok(ModelConvertResult {
            success: false,
            output_path: None,
            error_code: Some(e.code().to_string()),
            error_message: Some(e.to_string()),
            warnings: vec![],
        }),
    }
}

async fn p4k_model_convert_to_glb_without_textures_inner(
    p4k_path: &str,
    model_path: &str,
    output_dir: &str,
    options: ConvertOptions,
) -> std::result::Result<model_convert::ConvertOutput, model_convert::ModelConvertError> {
    options.check_cancelled()?;
    fs::create_dir_all(output_dir)
        .map_err(|e| model_convert::ModelConvertError::Io(e.to_string()))?;
    let output_name = Path::new(model_path)
        .file_stem()
        .and_then(|v| v.to_str())
        .unwrap_or("model");
    let output_path = PathBuf::from(output_dir).join(format!("{output_name}.glb"));
    if output_path.exists() && !options.overwrite {
        return Err(model_convert::ModelConvertError::OutputExists);
    }

    let output =
        model_convert::convert_from_p4k_to_scene_without_textures(p4k_path, model_path, options)
            .await?;
    model_convert::gltf_builder::write_glb(
        &output.scene,
        &output.textures,
        &output.materials,
        &output.materials_by_id,
        &output_path,
    )
    .map_err(|e| model_convert::ModelConvertError::Io(e.to_string()))?;

    Ok(model_convert::ConvertOutput {
        output_path: output_path.to_string_lossy().to_string(),
        warnings: output.warnings,
        source_mode: output.source_mode,
        fallback_reason: output.fallback_reason,
    })
}

pub async fn p4k_model_convert_to_glb_bytes(
    p4k_path: String,
    model_path: String,
    options: Option<ModelConvertOptions>,
) -> Result<ModelConvertBytesResult> {
    let options: ConvertOptions = options.into();
    let result = model_convert::convert_from_p4k_to_bytes(&p4k_path, &model_path, options).await;
    match result {
        Ok(ok) => Ok(ModelConvertBytesResult {
            success: true,
            glb_bytes: Some(ok.glb_bytes),
            error_code: None,
            error_message: None,
            warnings: ok.warnings,
        }),
        Err(e) => Ok(ModelConvertBytesResult {
            success: false,
            glb_bytes: None,
            error_code: Some(e.code().to_string()),
            error_message: Some(e.to_string()),
            warnings: vec![],
        }),
    }
}

pub async fn p4k_model_convert_local_batch_and_merge(
    asset_root: String,
    output_dir: String,
    options: Option<ModelConvertOptions>,
) -> Result<LocalBatchConvertResult> {
    let options: ConvertOptions = options.into();
    let result =
        model_convert::convert_local_batch_and_merge(&asset_root, &output_dir, options).await;
    match result {
        Ok(ok) => Ok(LocalBatchConvertResult {
            success: true,
            merged_output_path: Some(ok.merged_output_path),
            assembly_manifest_path: Some(ok.assembly_manifest_path),
            assembly_report_path: Some(ok.assembly_report_path),
            success_count: ok.success_count,
            empty_count: ok.empty_count,
            failed_count: ok.failed_count,
            warnings: ok.warnings,
            files: ok
                .files
                .into_iter()
                .map(|file| LocalBatchFileResult {
                    model_path: file.model_path,
                    output_path: file.output_path,
                    has_geometry: file.has_geometry,
                    error_code: file.error_code,
                    error_message: file.error_message,
                    warnings: file.warnings,
                    source_mode: file.source_mode,
                    fallback_reason: file.fallback_reason,
                })
                .collect(),
            source_mode: ok.source_mode,
            assembly_graph_stats: AssemblyGraphStats {
                nodes: ok.assembly_graph_stats.nodes,
                geometry_nodes: ok.assembly_graph_stats.geometry_nodes,
                object_containers: ok.assembly_graph_stats.object_containers,
                roots: ok.assembly_graph_stats.roots,
            },
            fallback_reason_by_file: ok.fallback_reason_by_file,
            error_code: None,
            error_message: None,
        }),
        Err(e) => Ok(LocalBatchConvertResult {
            success: false,
            merged_output_path: None,
            assembly_manifest_path: None,
            assembly_report_path: None,
            success_count: 0,
            empty_count: 0,
            failed_count: 0,
            warnings: vec![],
            files: vec![],
            source_mode: "failed".to_string(),
            assembly_graph_stats: AssemblyGraphStats {
                nodes: 0,
                geometry_nodes: 0,
                object_containers: 0,
                roots: 0,
            },
            fallback_reason_by_file: vec![],
            error_code: Some(e.code().to_string()),
            error_message: Some(e.to_string()),
        }),
    }
}

pub async fn p4k_model_render_preview(
    glb_path: String,
    width: u32,
    height: u32,
    pitch: f32,
    yaw: f32,
    roll: f32,
) -> Result<ModelRenderResult> {
    let glb_data = tokio::fs::read(&glb_path).await?;

    let rotation = (pitch, yaw, roll);

    match model_render::render_glb_to_rgba(&glb_data, width, height, rotation) {
        Ok(rgba_data) => Ok(ModelRenderResult {
            success: true,
            width,
            height,
            rgba_data: Some(rgba_data),
            error_message: None,
        }),
        Err(e) => Ok(ModelRenderResult {
            success: false,
            width,
            height,
            rgba_data: None,
            error_message: Some(e.to_string()),
        }),
    }
}

pub async fn p4k_model_session_create(
    glb_path: String,
    width: u32,
    height: u32,
    bg_color: Option<Vec<f32>>,
) -> Result<SessionCreateResult> {
    release_stale_preview_sessions(None);
    let glb_data = tokio::fs::read(&glb_path).await?;
    let bg = session_bg_color(bg_color);
    match model_render::create_session(&glb_data, width, height, bg) {
        Ok((session_id, model_radius)) => Ok(SessionCreateResult {
            success: true,
            session_id: Some(session_id),
            model_radius,
            error_message: None,
        }),
        Err(e) => Ok(SessionCreateResult {
            success: false,
            session_id: None,
            model_radius: 1.0,
            error_message: Some(e.to_string()),
        }),
    }
}

pub fn p4k_model_session_create_from_bytes(
    glb_bytes: Vec<u8>,
    width: u32,
    height: u32,
    bg_color: Option<Vec<f32>>,
) -> Result<SessionCreateResult> {
    release_stale_preview_sessions(None);
    let bg = session_bg_color(bg_color);
    match model_render::create_session(&glb_bytes, width, height, bg) {
        Ok((session_id, model_radius)) => Ok(SessionCreateResult {
            success: true,
            session_id: Some(session_id),
            model_radius,
            error_message: None,
        }),
        Err(e) => Ok(SessionCreateResult {
            success: false,
            session_id: None,
            model_radius: 1.0,
            error_message: Some(e.to_string()),
        }),
    }
}

pub async fn p4k_model_session_create_from_p4k(
    p4k_path: String,
    model_path: String,
    width: u32,
    height: u32,
    bg_color: Option<Vec<f32>>,
    options: Option<ModelConvertOptions>,
) -> Result<SessionCreateResult> {
    release_stale_preview_sessions(None);
    let options: ConvertOptions = options.into();
    let bg = session_bg_color(bg_color);
    match model_convert::convert_from_p4k_to_scene(&p4k_path, &model_path, options).await {
        Ok(ok) => match model_render::create_session_from_model_scene(
            &ok.scene,
            &ok.textures,
            &ok.materials,
            &ok.materials_by_id,
            width,
            height,
            bg,
        ) {
            Ok((session_id, model_radius)) => Ok(SessionCreateResult {
                success: true,
                session_id: Some(session_id),
                model_radius,
                error_message: None,
            }),
            Err(e) => Ok(SessionCreateResult {
                success: false,
                session_id: None,
                model_radius: 1.0,
                error_message: Some(e.to_string()),
            }),
        },
        Err(e) => Ok(SessionCreateResult {
            success: false,
            session_id: None,
            model_radius: 1.0,
            error_message: Some(e.to_string()),
        }),
    }
}

pub fn p4k_model_session_start_from_p4k(
    p4k_path: String,
    model_path: String,
    width: u32,
    height: u32,
    bg_color: Option<Vec<f32>>,
    options: Option<ModelConvertOptions>,
) -> Result<SessionStartResult> {
    let session_id = Uuid::new_v4().to_string();
    let cancel_token = ConvertCancelToken::new();
    release_stale_preview_sessions(Some(&session_id));
    PREVIEW_SESSION_STATUS.lock().insert(
        session_id.clone(),
        PreviewSessionStatus {
            ready: false,
            failed: false,
            stage: "queued".to_string(),
            model_radius: 1.0,
            error_message: None,
            cancel_token: cancel_token.clone(),
        },
    );

    let task_session_id = session_id.clone();
    let bg = session_bg_color(bg_color);
    let mut options: ConvertOptions = options.into();
    options.cancel_token = Some(cancel_token.clone());
    let spawn_result = std::thread::Builder::new()
        .name("sctb-model-preview".to_string())
        .spawn(move || {
            let runtime = match tokio::runtime::Builder::new_current_thread()
                .enable_all()
                .build()
            {
                Ok(runtime) => runtime,
                Err(err) => {
                    let mut status = PREVIEW_SESSION_STATUS.lock();
                    if let Some(entry) = status.get_mut(&task_session_id) {
                        entry.failed = true;
                        entry.stage = "failed".to_string();
                        entry.error_message =
                            Some(format!("failed to start model preview runtime: {err}"));
                    }
                    return;
                }
            };
            runtime.block_on(async move {
                if cancel_token.is_cancelled() || !preview_session_exists(&task_session_id) {
                    return;
                }
                {
                    let mut status = PREVIEW_SESSION_STATUS.lock();
                    if let Some(entry) = status.get_mut(&task_session_id) {
                        entry.stage = "building_fast_preview".to_string();
                    } else {
                        return;
                    }
                }

                let preview_result = model_convert::convert_from_p4k_to_scene_without_textures(
                    &p4k_path,
                    &model_path,
                    options.clone(),
                )
                .await
                .and_then(|output| {
                    if cancel_token.is_cancelled() || !preview_session_exists(&task_session_id) {
                        return Err(model_convert::ModelConvertError::Cancelled);
                    }
                    model_convert::gltf_builder::build_glb_bytes(
                        &output.scene,
                        &output.textures,
                        &output.materials,
                        &output.materials_by_id,
                    )
                    .map_err(|e| model_convert::ModelConvertError::Io(e.to_string()))
                });
                let preview_glb_bytes = match preview_result {
                    Ok(ok) => ok,
                    Err(err) => {
                        let mut status = PREVIEW_SESSION_STATUS.lock();
                        if let Some(entry) = status.get_mut(&task_session_id) {
                            entry.failed = true;
                            entry.stage = "failed".to_string();
                            entry.error_message = Some(err.to_string());
                        }
                        return;
                    }
                };
                if !preview_session_exists(&task_session_id) {
                    return;
                }
                if cancel_token.is_cancelled() {
                    return;
                }

                {
                    let mut status = PREVIEW_SESSION_STATUS.lock();
                    if let Some(entry) = status.get_mut(&task_session_id) {
                        entry.stage = "building_fast_renderer".to_string();
                    } else {
                        return;
                    }
                }

                match model_render::create_session_with_id(
                    task_session_id.clone(),
                    &preview_glb_bytes,
                    width,
                    height,
                    bg,
                ) {
                    Ok((_, model_radius)) => {
                        let mut status = PREVIEW_SESSION_STATUS.lock();
                        if let Some(entry) = status.get_mut(&task_session_id) {
                            entry.ready = true;
                            entry.stage = "ready".to_string();
                            entry.model_radius = model_radius;
                        }
                    }
                    Err(err) => {
                        let mut status = PREVIEW_SESSION_STATUS.lock();
                        if let Some(entry) = status.get_mut(&task_session_id) {
                            entry.failed = true;
                            entry.stage = "failed".to_string();
                            entry.error_message = Some(err.to_string());
                        }
                    }
                }
                if cancel_token.is_cancelled() || !preview_session_exists(&task_session_id) {
                    model_render::release_session(&task_session_id);
                }
            });
        });
    if let Err(err) = spawn_result {
        PREVIEW_SESSION_STATUS.lock().remove(&session_id);
        return Ok(SessionStartResult {
            success: false,
            session_id: None,
            error_message: Some(format!("failed to start model preview thread: {err}")),
        });
    }

    Ok(SessionStartResult {
        success: true,
        session_id: Some(session_id),
        error_message: None,
    })
}

pub fn p4k_model_session_status(session_id: String) -> Result<SessionStatusResult> {
    if let Some(status) = PREVIEW_SESSION_STATUS.lock().get(&session_id).cloned() {
        return Ok(SessionStatusResult {
            exists: true,
            ready: status.ready,
            failed: status.failed,
            stage: status.stage,
            model_radius: status.model_radius,
            error_message: status.error_message,
        });
    }
    let exists = model_render::session_exists(&session_id);
    Ok(SessionStatusResult {
        exists,
        ready: exists,
        failed: false,
        stage: if exists { "ready" } else { "missing" }.to_string(),
        model_radius: 1.0,
        error_message: None,
    })
}

pub fn p4k_model_session_render(
    session_id: String,
    camera_x: f32,
    camera_y: f32,
    camera_z: f32,
    target_x: f32,
    target_y: f32,
    target_z: f32,
) -> Result<ModelRenderResult> {
    let camera_pos = [camera_x, camera_y, camera_z];
    let camera_target = [target_x, target_y, target_z];
    match model_render::render_session(&session_id, camera_pos, camera_target) {
        Ok((rgba_data, width, height)) => Ok(ModelRenderResult {
            success: true,
            width,
            height,
            rgba_data: Some(rgba_data),
            error_message: None,
        }),
        Err(e) => Ok(ModelRenderResult {
            success: false,
            width: 0,
            height: 0,
            rgba_data: None,
            error_message: Some(e.to_string()),
        }),
    }
}

pub fn p4k_model_session_render_resized(
    session_id: String,
    width: u32,
    height: u32,
    camera_x: f32,
    camera_y: f32,
    camera_z: f32,
    target_x: f32,
    target_y: f32,
    target_z: f32,
) -> Result<ModelRenderResult> {
    let camera_pos = [camera_x, camera_y, camera_z];
    let camera_target = [target_x, target_y, target_z];
    match model_render::render_session_resized(
        &session_id,
        width,
        height,
        camera_pos,
        camera_target,
    ) {
        Ok((rgba_data, width, height)) => Ok(ModelRenderResult {
            success: true,
            width,
            height,
            rgba_data: Some(rgba_data),
            error_message: None,
        }),
        Err(e) => Ok(ModelRenderResult {
            success: false,
            width: 0,
            height: 0,
            rgba_data: None,
            error_message: Some(e.to_string()),
        }),
    }
}

pub fn p4k_model_session_release(session_id: String) -> bool {
    if let Some(status) = PREVIEW_SESSION_STATUS.lock().remove(&session_id) {
        status.cancel_token.cancel();
    }
    model_render::release_session(&session_id)
}

pub fn p4k_model_session_exists(session_id: String) -> bool {
    model_render::session_exists(&session_id)
}
