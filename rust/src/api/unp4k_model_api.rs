use anyhow::Result;
use flutter_rust_bridge::frb;

use crate::model_convert::{self, ConvertOptions};
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
            }
        } else {
            ConvertOptions::default()
        }
    }
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
    let result =
        model_convert::convert_from_p4k(&p4k_path, &model_path, &output_dir, options).await;
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

pub async fn p4k_model_convert_local_batch_and_merge(
    _asset_root: String,
    _output_dir: String,
    _options: Option<ModelConvertOptions>,
) -> Result<LocalBatchConvertResult> {
    Ok(LocalBatchConvertResult {
        success: false,
        merged_output_path: None,
        assembly_manifest_path: None,
        assembly_report_path: None,
        success_count: 0,
        empty_count: 0,
        failed_count: 0,
        warnings: vec![
            "assembly/merge export has been removed; use single GLB export instead".to_string(),
        ],
        files: vec![],
        source_mode: "unsupported".to_string(),
        assembly_graph_stats: AssemblyGraphStats {
            nodes: 0,
            geometry_nodes: 0,
            object_containers: 0,
            roots: 0,
        },
        fallback_reason_by_file: vec![],
        error_code: Some("ERR_ASSEMBLY_REMOVED".to_string()),
        error_message: Some(
            "assembly/merge export has been removed; use single GLB export instead".to_string(),
        ),
    })
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
    let glb_data = tokio::fs::read(&glb_path).await?;
    let bg = bg_color.and_then(|c| {
        if c.len() == 4 {
            Some([c[0], c[1], c[2], c[3]])
        } else {
            None
        }
    });
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

pub fn p4k_model_session_release(session_id: String) -> bool {
    model_render::release_session(&session_id)
}

pub fn p4k_model_session_exists(session_id: String) -> bool {
    model_render::session_exists(&session_id)
}
