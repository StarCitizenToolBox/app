use anyhow::{anyhow, Result};
use std::collections::HashMap;
use std::sync::Arc;

use parking_lot::Mutex;
use renderling::glam::{Mat4, Vec3, Vec4};
use renderling::{
    camera::Camera,
    context::Context,
    gltf::GltfDocument,
    light::Lux,
    stage::Stage,
};
use uuid::Uuid;

pub struct RenderSession {
    ctx: Context,
    stage: Stage,
    camera: Camera,
    pub width: u32,
    pub height: u32,
    pub model_radius: f32,
}

// SAFETY: We ensure the context is only used from a single thread at a time via the Mutex
unsafe impl Send for RenderSession {}

lazy_static::lazy_static! {
    // 每个 session 有独立的锁，减少锁竞争
    pub static ref SESSIONS: Arc<Mutex<HashMap<String, Arc<Mutex<RenderSession>>>>> = Arc::new(Mutex::new(HashMap::new()));
    static ref GLOBAL_CONTEXT: Arc<Mutex<Option<Context>>> = Arc::new(Mutex::new(None));
}

/// Initialize the global rendering context.
/// This should be called once at application startup.
/// Returns Ok(true) if context was initialized, Ok(false) if already initialized.
pub fn init_context() -> Result<bool> {
    let mut ctx = GLOBAL_CONTEXT.lock();
    if ctx.is_some() {
        return Ok(false); // Already initialized
    }

    // Create a small headless context for initialization
    // Note: Context::headless panics on failure, not returning Result
    let context = futures_lite::future::block_on(Context::headless(1, 1));
    *ctx = Some(context);
    Ok(true)
}

/// Compute the bounding box of a GLTF document
fn compute_bounding_box(document: &GltfDocument) -> (Vec3, Vec3) {
    let mut min = Vec3::splat(f32::INFINITY);
    let mut max = Vec3::splat(f32::NEG_INFINITY);

    // Get the default scene or scene 0
    let scene = document.default_scene.unwrap_or(0);

    // Iterate through all nodes in the scene
    for node in document.recursive_nodes_in_scene(scene) {
        let transform = Mat4::from(node.global_transform());
        if let Some(mesh_index) = node.mesh {
            if let Some(mesh) = document.meshes.get(mesh_index) {
                for primitive in &mesh.primitives {
                    let bbmin = transform.transform_point3(primitive.bounding_box.0);
                    let bbmax = transform.transform_point3(primitive.bounding_box.1);
                    min = min.min(bbmin);
                    max = max.max(bbmax);
                }
            }
        }
    }

    // Fallback if no geometry found
    if min.x.is_infinite() {
        (Vec3::NEG_ONE, Vec3::ONE)
    } else {
        (min, max)
    }
}

impl RenderSession {
    fn new(width: u32, height: u32, glb_data: &[u8], bg_color: Option<[f32; 4]>) -> Result<Self> {
        // Create headless context with the specified size
        // Note: Context::headless panics on failure
        let ctx = futures_lite::future::block_on(Context::headless(width, height));

        // Default background color: #3B4750
        let bg = bg_color.unwrap_or([0.231, 0.278, 0.314, 1.0]);

        // Create a stage for rendering
        let stage = ctx
            .new_stage()
            .with_background_color(Vec4::from(bg))
            .with_lighting(true);

        // Load GLB from bytes
        let document = stage
            .load_gltf_document_from_bytes(glb_data)
            .map_err(|e| anyhow!("Failed to load GLB: {:?}", e))?;

        // Compute bounding box to get model radius
        let (min, max) = compute_bounding_box(&document);
        let model_radius = (max - min).length() / 2.0;

        // Create camera with default perspective
        let (projection, view) = renderling::camera::default_perspective(width as f32, height as f32);
        let camera = stage.new_camera().with_projection_and_view(projection, view);

        // Add balanced lighting for model preview
        // Main key light
        let _light1 = stage
            .new_directional_light()
            .with_direction(Vec3::new(-1.0, -1.0, -0.5).normalize())
            .with_color(Vec4::ONE)
            .with_intensity(Lux::INDOOR_OFFICE_HIGH);

        // Fill light - softer and slightly cooler
        let _light2 = stage
            .new_directional_light()
            .with_direction(Vec3::new(1.0, -0.5, 0.5).normalize())
            .with_color(Vec4::new(0.85, 0.88, 0.95, 1.0))
            .with_intensity(Lux::INDOOR_HALLWAY);

        Ok(Self {
            ctx,
            stage,
            camera,
            width,
            height,
            model_radius: model_radius.max(1.0),
        })
    }

    fn render(&self, camera_pos: [f32; 3], camera_target: [f32; 3]) -> Result<Vec<u8>> {
        // Update camera view matrix
        let view = Mat4::look_at_rh(
            Vec3::from(camera_pos),
            Vec3::from(camera_target),
            Vec3::Y,
        );
        self.camera.set_view(view);

        // Get the next frame
        let frame = self
            .ctx
            .get_next_frame()
            .map_err(|e| anyhow!("Failed to get next frame: {:?}", e))?;

        // Render the stage
        self.stage.render(&frame.view());

        // Read the rendered image
        let img = futures_lite::future::block_on(frame.read_image())
            .map_err(|e| anyhow!("Failed to read image: {:?}", e))?;

        frame.present();

        // Convert to raw RGBA bytes
        Ok(img.into_raw())
    }
}

pub fn create_session(glb_data: &[u8], width: u32, height: u32, bg_color: Option<[f32; 4]>) -> Result<(String, f32)> {
    let session = RenderSession::new(width, height, glb_data, bg_color)?;
    let model_radius = session.model_radius;
    let session_id = Uuid::new_v4().to_string();
    let mut sessions = SESSIONS.lock();
    sessions.insert(session_id.clone(), Arc::new(Mutex::new(session)));
    Ok((session_id, model_radius))
}

pub fn render_session(
    session_id: &str,
    camera_pos: [f32; 3],
    camera_target: [f32; 3],
) -> Result<(Vec<u8>, u32, u32)> {
    // 只在获取 session 引用时持锁
    let session_arc = {
        let sessions = SESSIONS.lock();
        sessions
            .get(session_id)
            .cloned()
            .ok_or_else(|| anyhow!("Session not found: {}", session_id))?
    };
    // 释放全局锁后，使用 session 独立锁进行渲染
    let session = session_arc.lock();
    let rgba_data = session.render(camera_pos, camera_target)?;
    Ok((rgba_data, session.width, session.height))
}

pub fn release_session(session_id: &str) -> bool {
    // 先从 HashMap 中移除 Arc，阻止新的 render_session 获取引用
    // 已持有 Arc 克隆的渲染操作会继续完成，RenderSession 在最后一个 Arc 释放时 Drop
    let mut sessions = SESSIONS.lock();
    sessions.remove(session_id).is_some()
}

pub fn session_exists(session_id: &str) -> bool {
    let sessions = SESSIONS.lock();
    sessions.contains_key(session_id)
}

pub fn render_glb_to_rgba(
    glb_data: &[u8],
    width: u32,
    height: u32,
    rotation: (f32, f32, f32),
) -> Result<Vec<u8>> {
    let session = RenderSession::new(width, height, glb_data, None)?;
    let (pitch, yaw, _roll) = rotation;
    let distance = session.model_radius * 3.0;
    let camera_pos = [
        distance * yaw.cos() * pitch.cos(),
        distance * pitch.sin(),
        distance * yaw.sin() * pitch.cos(),
    ];
    session.render(camera_pos, [0.0, 0.0, 0.0])
}