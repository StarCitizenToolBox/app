use anyhow::Result;
use flutter_rust_bridge::frb;
use parking_lot::Mutex;
use std::collections::HashMap;
use std::fs;
use std::path::{Path, PathBuf};
use std::sync::{
    Arc,
    atomic::{AtomicBool, Ordering},
};
use uuid::Uuid;

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
pub struct ModelConvertOptions {
    pub embed_textures: bool,
    pub overwrite: bool,
    pub max_texture_size: Option<u32>,
}

#[derive(Clone)]
struct ConvertCancelToken {
    cancelled: Arc<AtomicBool>,
}

impl ConvertCancelToken {
    fn new() -> Self {
        Self {
            cancelled: Arc::new(AtomicBool::new(false)),
        }
    }

    fn cancel(&self) {
        self.cancelled.store(true, Ordering::Relaxed);
    }

    fn is_cancelled(&self) -> bool {
        self.cancelled.load(Ordering::Relaxed)
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
    starbreaker_3d::api::is_supported_geometry_path(&file_path)
}

fn normalized_model_path(path: &str) -> String {
    path.trim_start_matches(['\\', '/']).replace('/', "\\")
}

fn starbreaker_export_options(options: Option<ModelConvertOptions>) -> starbreaker_3d::ExportOptions {
    let options = options.unwrap_or(ModelConvertOptions {
        embed_textures: true,
        overwrite: false,
        max_texture_size: Some(4096),
    });
    let texture_mip = match options.max_texture_size {
        None => 0,
        Some(size) if size <= 1024 => 2,
        Some(size) if size <= 2048 => 1,
        _ => 0,
    };

    starbreaker_3d::ExportOptions {
        kind: starbreaker_3d::ExportKind::Bundled,
        format: starbreaker_3d::ExportFormat::Glb,
        material_mode: if options.embed_textures {
            starbreaker_3d::MaterialMode::Textures
        } else {
            starbreaker_3d::MaterialMode::Colors
        },
        include_attachments: false,
        include_interior: false,
        include_lights: false,
        include_nodraw: false,
        include_shields: false,
        lod_level: 0,
        texture_mip,
        threads: 0,
        include_animations: false,
        apply_default_animation_pose: true,
        default_animation_tags: vec!["landing_gear_extend".to_string()],
        decomposed_package_subdir: None,
    }
}

fn model_error_code(message: &str) -> &'static str {
    if message.contains("UnsupportedFormat")
        || message.contains("unsupported")
        || message.contains("not supported")
    {
        "ERR_UNSUPPORTED_FORMAT"
    } else {
        "ERR_MODEL_PARSE_FAILED"
    }
}

fn convert_model_to_glb_bytes_blocking(
    p4k_path: String,
    model_path: String,
    options: Option<ModelConvertOptions>,
) -> Result<Vec<u8>> {
    let p4k = starbreaker_p4k::MappedP4k::open(&p4k_path)?;
    let opts = starbreaker_export_options(options);
    let model_path = normalized_model_path(&model_path);
    starbreaker_3d::api::export_geometry_glb(&p4k, &model_path, None, &opts)
        .map_err(|e| anyhow::anyhow!(e.to_string()))
}

pub async fn p4k_model_convert_to_glb(
    p4k_path: String,
    model_path: String,
    output_dir: String,
    options: Option<ModelConvertOptions>,
) -> Result<ModelConvertResult> {
    let overwrite = options.as_ref().map(|v| v.overwrite).unwrap_or(false);
    let output_name = Path::new(&model_path)
        .file_stem()
        .and_then(|v| v.to_str())
        .unwrap_or("model")
        .to_string();
    let output_path = PathBuf::from(&output_dir).join(format!("{output_name}.glb"));

    let result = async {
        fs::create_dir_all(&output_dir)?;
        if output_path.exists() && !overwrite {
            return Err(anyhow::anyhow!("Output already exists"));
        }
        let glb = tokio::task::spawn_blocking(move || {
            convert_model_to_glb_bytes_blocking(p4k_path, model_path, options)
        })
        .await??;
        fs::write(&output_path, glb)?;
        Ok::<_, anyhow::Error>(output_path.to_string_lossy().to_string())
    }
    .await;
    match result {
        Ok(output_path) => Ok(ModelConvertResult {
            success: true,
            output_path: Some(output_path),
            error_code: None,
            error_message: None,
            warnings: vec!["generated by StarBreaker".to_string()],
        }),
        Err(e) => Ok(ModelConvertResult {
            success: false,
            output_path: None,
            error_code: Some(model_error_code(&e.to_string()).to_string()),
            error_message: Some(e.to_string()),
            warnings: vec![],
        }),
    }
}

pub async fn p4k_model_convert_to_glb_bytes(
    p4k_path: String,
    model_path: String,
    options: Option<ModelConvertOptions>,
) -> Result<ModelConvertBytesResult> {
    let result = tokio::task::spawn_blocking(move || {
        convert_model_to_glb_bytes_blocking(p4k_path, model_path, options)
    })
    .await?;
    match result {
        Ok(glb_bytes) => Ok(ModelConvertBytesResult {
            success: true,
            glb_bytes: Some(glb_bytes),
            error_code: None,
            error_message: None,
            warnings: vec!["generated by StarBreaker".to_string()],
        }),
        Err(e) => Ok(ModelConvertBytesResult {
            success: false,
            glb_bytes: None,
            error_code: Some(model_error_code(&e.to_string()).to_string()),
            error_message: Some(e.to_string()),
            warnings: vec![],
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
    let bg = session_bg_color(bg_color);
    match tokio::task::spawn_blocking(move || {
        convert_model_to_glb_bytes_blocking(p4k_path, model_path, options)
    })
    .await?
    {
        Ok(glb_bytes) => match model_render::create_session(&glb_bytes, width, height, bg) {
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

                let preview_result = tokio::task::spawn_blocking(move || {
                    convert_model_to_glb_bytes_blocking(p4k_path, model_path, options)
                })
                .await
                .map_err(|e| anyhow::anyhow!(e.to_string()))
                .and_then(|result| result);
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
