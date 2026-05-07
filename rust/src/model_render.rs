use anyhow::{anyhow, Result};
use std::collections::HashMap;
use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::Arc;

use parking_lot::Mutex;
use renderling::glam::{EulerRot, Mat4, Quat, Vec2, Vec3, Vec4};
use renderling::{camera::Camera, context::Context, gltf::GltfDocument, light::Lux, stage::Stage};
use uuid::Uuid;

pub struct RenderSession {
    backend: RenderSessionBackend,
    pub width: u32,
    pub height: u32,
    pub model_center: Vec3,
    pub model_radius: f32,
}

enum RenderSessionBackend {
    Renderling {
        ctx: Context,
        stage: Stage,
        camera: Camera,
    },
    Software {
        scene: SoftwareScene,
        bg: [u8; 4],
    },
}

#[derive(Clone, Copy)]
struct SoftwareVertex {
    position: Vec3,
    normal: Vec3,
    uv: Vec2,
}

#[derive(Clone, Copy)]
struct SoftwareTriangle {
    vertices: [SoftwareVertex; 3],
    base_color: Vec3,
    base_texture: Option<usize>,
    normal_texture: Option<usize>,
    emissive_factor: Vec3,
    emissive_strength: f32,
    specular_factor: Vec3,
    glossiness: f32,
}

struct SoftwareScene {
    triangles: Vec<SoftwareTriangle>,
    textures: Vec<SoftwareTexture>,
}

struct SoftwareTexture {
    width: u32,
    height: u32,
    rgba: Vec<u8>,
}

#[derive(Clone, Copy)]
struct SoftwareMaterial {
    base_color: Vec3,
    base_texture: Option<usize>,
    normal_texture: Option<usize>,
    emissive_factor: Vec3,
    emissive_strength: f32,
    specular_factor: Vec3,
    glossiness: f32,
}

// SAFETY: We ensure the context is only used from a single thread at a time via the Mutex
unsafe impl Send for RenderSession {}

lazy_static::lazy_static! {
    // 每个 session 有独立的锁，减少锁竞争
    pub static ref SESSIONS: Arc<Mutex<HashMap<String, Arc<Mutex<RenderSession>>>>> = Arc::new(Mutex::new(HashMap::new()));
    static ref GLOBAL_CONTEXT: Arc<Mutex<Option<Context>>> = Arc::new(Mutex::new(None));
    static ref RENDER_PANIC_HOOK_LOCK: Mutex<()> = Mutex::new(());
    static ref SOFTWARE_NORMAL_MAP_STRENGTH: f32 =
        if std::env::var("SCTB_MODEL_SOFTWARE_NORMALS")
            .map(|value| value == "1" || value.eq_ignore_ascii_case("true"))
            .unwrap_or(false)
        {
            0.28
        } else {
            0.0
        };
}

static RENDERLING_ONESHOT_UNAVAILABLE: AtomicBool = AtomicBool::new(false);

const SPECULAR_STRENGTH: f32 = 0.06;
const EMISSIVE_STRENGTH: f32 = 0.18;

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
                    let primitive_min = primitive.bounding_box.0;
                    let primitive_max = primitive.bounding_box.1;
                    for x in [primitive_min.x, primitive_max.x] {
                        for y in [primitive_min.y, primitive_max.y] {
                            for z in [primitive_min.z, primitive_max.z] {
                                let corner = transform.transform_point3(Vec3::new(x, y, z));
                                min = min.min(corner);
                                max = max.max(corner);
                            }
                        }
                    }
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
        if !prefers_renderling_session() {
            return Self::new_software(width, height, glb_data, bg_color);
        }
        Self::new_renderling(width, height, glb_data, bg_color)
    }

    fn new_renderling(
        width: u32,
        height: u32,
        glb_data: &[u8],
        bg_color: Option<[f32; 4]>,
    ) -> Result<Self> {
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
        let model_center = (min + max) * 0.5;
        let model_radius = (max - min).length() / 2.0;

        // Create camera with default perspective
        let (projection, view) =
            renderling::camera::default_perspective(width as f32, height as f32);
        let camera = stage
            .new_camera()
            .with_projection_and_view(projection, view);

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
            backend: RenderSessionBackend::Renderling { ctx, stage, camera },
            width,
            height,
            model_center,
            model_radius: model_radius.max(1.0),
        })
    }

    fn new_software(
        width: u32,
        height: u32,
        glb_data: &[u8],
        bg_color: Option<[f32; 4]>,
    ) -> Result<Self> {
        let scene = load_software_scene(glb_data)?;
        let (model_center, model_radius) = software_bounds(&scene.triangles)?;
        let bg = bg_color
            .map(|color| {
                [
                    (color[0] * 255.0).clamp(0.0, 255.0) as u8,
                    (color[1] * 255.0).clamp(0.0, 255.0) as u8,
                    (color[2] * 255.0).clamp(0.0, 255.0) as u8,
                    (color[3] * 255.0).clamp(0.0, 255.0) as u8,
                ]
            })
            .unwrap_or([59, 71, 80, 255]);
        Ok(Self {
            backend: RenderSessionBackend::Software { scene, bg },
            width,
            height,
            model_center,
            model_radius: model_radius.max(1.0),
        })
    }

    fn render(&self, camera_pos: [f32; 3], camera_target: [f32; 3]) -> Result<Vec<u8>> {
        match &self.backend {
            RenderSessionBackend::Renderling { ctx, stage, camera } => {
                // Update camera view matrix
                let view =
                    Mat4::look_at_rh(Vec3::from(camera_pos), Vec3::from(camera_target), Vec3::Y);
                camera.set_view(view);

                // Get the next frame
                let frame = ctx
                    .get_next_frame()
                    .map_err(|e| anyhow!("Failed to get next frame: {:?}", e))?;

                // Render the stage
                stage.render(&frame.view());

                // Read the rendered image
                let img = futures_lite::future::block_on(frame.read_image())
                    .map_err(|e| anyhow!("Failed to read image: {:?}", e))?;

                frame.present();

                // Convert to raw RGBA bytes
                Ok(img.into_raw())
            }
            RenderSessionBackend::Software { scene, bg } => render_software_scene_camera(
                scene,
                self.width,
                self.height,
                Vec3::from(camera_pos),
                Vec3::from(camera_target),
                self.model_radius,
                *bg,
            ),
        }
    }
}

fn prefers_renderling_session() -> bool {
    std::env::var("SCTB_MODEL_SESSION_RENDERER")
        .or_else(|_| std::env::var("SCTB_MODEL_RENDERER"))
        .map(|value| value.eq_ignore_ascii_case("renderling"))
        .unwrap_or(false)
}

fn software_normal_map_strength() -> f32 {
    *SOFTWARE_NORMAL_MAP_STRENGTH
}

pub fn create_session(
    glb_data: &[u8],
    width: u32,
    height: u32,
    bg_color: Option<[f32; 4]>,
) -> Result<(String, f32)> {
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
    if width == 0 || height == 0 {
        return Err(anyhow!("renderer: invalid output size {width}x{height}"));
    }

    if std::env::var("SCTB_MODEL_RENDERER")
        .map(|value| value.eq_ignore_ascii_case("software"))
        .unwrap_or(false)
        || RENDERLING_ONESHOT_UNAVAILABLE.load(Ordering::Relaxed)
    {
        return software_render_glb_to_rgba(glb_data, width, height, rotation);
    }

    let _hook_guard = RENDER_PANIC_HOOK_LOCK.lock();
    let previous_hook = std::panic::take_hook();
    std::panic::set_hook(Box::new(|_| {}));
    let render_result = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
        render_glb_to_rgba_inner(glb_data, width, height, rotation)
    }));
    std::panic::set_hook(previous_hook);
    drop(_hook_guard);

    match render_result {
        Ok(Ok(rgba)) => Ok(rgba),
        Ok(Err(err)) => {
            RENDERLING_ONESHOT_UNAVAILABLE.store(true, Ordering::Relaxed);
            software_render_glb_to_rgba(glb_data, width, height, rotation)
                .map_err(|fallback_err| anyhow!("{err}; software fallback failed: {fallback_err}"))
        }
        Err(panic) => {
            RENDERLING_ONESHOT_UNAVAILABLE.store(true, Ordering::Relaxed);
            software_render_glb_to_rgba(glb_data, width, height, rotation).map_err(|fallback_err| {
                anyhow!(
                    "renderer panicked: {}; software fallback failed: {fallback_err}",
                    panic_message(panic)
                )
            })
        }
    }
}

fn render_glb_to_rgba_inner(
    glb_data: &[u8],
    width: u32,
    height: u32,
    rotation: (f32, f32, f32),
) -> Result<Vec<u8>> {
    let session = RenderSession::new(width, height, glb_data, None)?;
    let (pitch, yaw, _roll) = rotation;
    let distance = session.model_radius * 3.0;
    let target = session.model_center;
    let camera_pos = [
        target.x + distance * yaw.cos() * pitch.cos(),
        target.y + distance * pitch.sin(),
        target.z + distance * yaw.sin() * pitch.cos(),
    ];
    session.render(camera_pos, target.to_array())
}

fn panic_message(panic: Box<dyn std::any::Any + Send>) -> String {
    if let Some(message) = panic.downcast_ref::<&str>() {
        (*message).to_string()
    } else if let Some(message) = panic.downcast_ref::<String>() {
        message.clone()
    } else {
        "unknown panic".to_string()
    }
}

fn software_render_glb_to_rgba(
    glb_data: &[u8],
    width: u32,
    height: u32,
    rotation: (f32, f32, f32),
) -> Result<Vec<u8>> {
    let scene = load_software_scene(glb_data)?;
    render_software_scene_rotation(&scene, width, height, rotation, [59, 71, 80, 255])
}

fn load_software_scene(glb_data: &[u8]) -> Result<SoftwareScene> {
    let (json, bin) = parse_glb_chunks(glb_data)?;
    let nodes = json
        .get("nodes")
        .and_then(|v| v.as_array())
        .ok_or_else(|| anyhow!("software render: missing nodes"))?;
    let scenes = json
        .get("scenes")
        .and_then(|v| v.as_array())
        .ok_or_else(|| anyhow!("software render: missing scenes"))?;
    let scene_index = json.get("scene").and_then(|v| v.as_u64()).unwrap_or(0) as usize;
    let scene_nodes = scenes
        .get(scene_index)
        .and_then(|scene| scene.get("nodes"))
        .and_then(|v| v.as_array())
        .ok_or_else(|| anyhow!("software render: missing scene nodes"))?;

    let textures = load_software_textures(&json, &bin);
    let mut triangles = Vec::<SoftwareTriangle>::new();
    for root in scene_nodes.iter().filter_map(|v| v.as_u64()) {
        collect_node_triangles(
            &json,
            &bin,
            nodes,
            root as usize,
            Mat4::IDENTITY,
            &mut triangles,
        )?;
    }
    if triangles.is_empty() {
        return Err(anyhow!("software render: no triangles"));
    }
    Ok(SoftwareScene {
        triangles,
        textures,
    })
}

fn software_bounds(triangles: &[SoftwareTriangle]) -> Result<(Vec3, f32)> {
    let mut min = Vec3::splat(f32::INFINITY);
    let mut max = Vec3::splat(f32::NEG_INFINITY);
    for tri in triangles {
        for vertex in &tri.vertices {
            min = min.min(vertex.position);
            max = max.max(vertex.position);
        }
    }
    if min.x.is_infinite() {
        return Err(anyhow!("software render: invalid bounds"));
    }
    let center = (min + max) * 0.5;
    let radius = (max - min).length() * 0.5;
    Ok((center, radius))
}

fn render_software_scene_rotation(
    scene: &SoftwareScene,
    width: u32,
    height: u32,
    rotation: (f32, f32, f32),
    bg: [u8; 4],
) -> Result<Vec<u8>> {
    let view_rot = Mat4::from_quat(Quat::from_euler(
        EulerRot::XYZ,
        rotation.0,
        rotation.1,
        rotation.2,
    ));
    let mut min = Vec3::splat(f32::INFINITY);
    let mut max = Vec3::splat(f32::NEG_INFINITY);
    for tri in &scene.triangles {
        for vertex in &tri.vertices {
            let p = view_rot.transform_point3(vertex.position);
            min = min.min(p);
            max = max.max(p);
        }
    }
    if min.x.is_infinite() {
        return Err(anyhow!("software render: invalid bounds"));
    }
    let center = (min + max) * 0.5;
    let extent = (max - min).max(Vec3::splat(1.0));
    let scale = 0.84 * (width.min(height) as f32) / extent.x.max(extent.y).max(1.0);

    let mut rgba = vec![0u8; width as usize * height as usize * 4];
    for pixel in rgba.chunks_exact_mut(4) {
        pixel.copy_from_slice(&bg);
    }
    let mut depth = vec![f32::INFINITY; width as usize * height as usize];

    for tri in &scene.triangles {
        let projected = SoftwareTriangle {
            vertices: tri.vertices.map(|vertex| {
                let p = view_rot.transform_point3(vertex.position) - center;
                SoftwareVertex {
                    position: Vec3::new(
                        width as f32 * 0.5 + p.x * scale,
                        height as f32 * 0.5 - p.y * scale,
                        p.z,
                    ),
                    normal: view_rot
                        .transform_vector3(vertex.normal)
                        .normalize_or_zero(),
                    uv: vertex.uv,
                }
            }),
            base_color: tri.base_color,
            base_texture: tri.base_texture,
            normal_texture: tri.normal_texture,
            emissive_factor: tri.emissive_factor,
            emissive_strength: tri.emissive_strength,
            specular_factor: tri.specular_factor,
            glossiness: tri.glossiness,
        };
        rasterize_triangle(
            &projected,
            &scene.textures,
            width,
            height,
            &mut rgba,
            &mut depth,
        );
    }

    Ok(rgba)
}

fn render_software_scene_camera(
    scene: &SoftwareScene,
    width: u32,
    height: u32,
    camera_pos: Vec3,
    camera_target: Vec3,
    model_radius: f32,
    bg: [u8; 4],
) -> Result<Vec<u8>> {
    let view = Mat4::look_at_rh(camera_pos, camera_target, Vec3::Y);
    let scale = 0.48 * (width.min(height) as f32) / model_radius.max(1.0);
    let mut rgba = vec![0u8; width as usize * height as usize * 4];
    for pixel in rgba.chunks_exact_mut(4) {
        pixel.copy_from_slice(&bg);
    }
    let mut depth = vec![f32::INFINITY; width as usize * height as usize];

    for tri in &scene.triangles {
        let projected = SoftwareTriangle {
            vertices: tri.vertices.map(|vertex| {
                let p = view.transform_point3(vertex.position);
                SoftwareVertex {
                    position: Vec3::new(
                        width as f32 * 0.5 + p.x * scale,
                        height as f32 * 0.5 - p.y * scale,
                        -p.z,
                    ),
                    normal: view.transform_vector3(vertex.normal).normalize_or_zero(),
                    uv: vertex.uv,
                }
            }),
            base_color: tri.base_color,
            base_texture: tri.base_texture,
            normal_texture: tri.normal_texture,
            emissive_factor: tri.emissive_factor,
            emissive_strength: tri.emissive_strength,
            specular_factor: tri.specular_factor,
            glossiness: tri.glossiness,
        };
        rasterize_triangle(
            &projected,
            &scene.textures,
            width,
            height,
            &mut rgba,
            &mut depth,
        );
    }

    Ok(rgba)
}

fn parse_glb_chunks(glb_data: &[u8]) -> Result<(serde_json::Value, Vec<u8>)> {
    if glb_data.len() < 20 || glb_data.get(0..4) != Some(b"glTF") {
        return Err(anyhow!("software render: invalid GLB header"));
    }
    let total_len = read_u32_at(glb_data, 8)? as usize;
    if total_len != glb_data.len() {
        return Err(anyhow!("software render: invalid GLB length"));
    }

    let mut cursor = 12usize;
    let mut json = None;
    let mut bin = Vec::new();
    while cursor + 8 <= glb_data.len() {
        let chunk_len = read_u32_at(glb_data, cursor)? as usize;
        let chunk_type = read_u32_at(glb_data, cursor + 4)?;
        cursor += 8;
        let end = cursor
            .checked_add(chunk_len)
            .ok_or_else(|| anyhow!("software render: chunk overflow"))?;
        let chunk = glb_data
            .get(cursor..end)
            .ok_or_else(|| anyhow!("software render: truncated chunk"))?;
        cursor = end;
        match chunk_type {
            0x4E4F534A => {
                let text = String::from_utf8_lossy(chunk)
                    .trim_end_matches('\0')
                    .trim_end()
                    .to_string();
                json = Some(serde_json::from_str(&text)?);
            }
            0x004E4942 => bin = chunk.to_vec(),
            _ => {}
        }
    }
    Ok((
        json.ok_or_else(|| anyhow!("software render: missing JSON"))?,
        bin,
    ))
}

fn load_software_textures(json: &serde_json::Value, bin: &[u8]) -> Vec<SoftwareTexture> {
    let Some(images) = json.get("images").and_then(|v| v.as_array()) else {
        return Vec::new();
    };
    images
        .iter()
        .map(|image| {
            image
                .get("bufferView")
                .and_then(|v| v.as_u64())
                .and_then(|buffer_view| {
                    read_buffer_view_bytes(json, bin, buffer_view as usize).ok()
                })
                .and_then(|bytes| image::load_from_memory(bytes).ok())
                .map(|dynamic| {
                    let rgba = dynamic.to_rgba8();
                    SoftwareTexture {
                        width: rgba.width(),
                        height: rgba.height(),
                        rgba: rgba.into_raw(),
                    }
                })
                .unwrap_or_else(|| SoftwareTexture {
                    width: 1,
                    height: 1,
                    rgba: vec![255, 255, 255, 255],
                })
        })
        .collect()
}

fn read_buffer_view_bytes<'a>(
    json: &serde_json::Value,
    bin: &'a [u8],
    buffer_view_index: usize,
) -> Result<&'a [u8]> {
    let buffer_view = json
        .get("bufferViews")
        .and_then(|v| v.as_array())
        .and_then(|views| views.get(buffer_view_index))
        .ok_or_else(|| anyhow!("software render: invalid bufferView {buffer_view_index}"))?;
    let offset = buffer_view
        .get("byteOffset")
        .and_then(|v| v.as_u64())
        .unwrap_or(0) as usize;
    let length = buffer_view
        .get("byteLength")
        .and_then(|v| v.as_u64())
        .ok_or_else(|| anyhow!("software render: bufferView without byteLength"))?
        as usize;
    bin.get(offset..offset + length)
        .ok_or_else(|| anyhow!("software render: bufferView out of bounds"))
}

fn collect_node_triangles(
    json: &serde_json::Value,
    bin: &[u8],
    nodes: &[serde_json::Value],
    node_index: usize,
    parent_transform: Mat4,
    out: &mut Vec<SoftwareTriangle>,
) -> Result<()> {
    let Some(node) = nodes.get(node_index) else {
        return Ok(());
    };
    let transform = parent_transform * node_transform(node);
    if let Some(mesh_index) = node.get("mesh").and_then(|v| v.as_u64()) {
        collect_mesh_triangles(json, bin, mesh_index as usize, transform, out)?;
    }
    if let Some(children) = node.get("children").and_then(|v| v.as_array()) {
        for child in children.iter().filter_map(|v| v.as_u64()) {
            collect_node_triangles(json, bin, nodes, child as usize, transform, out)?;
        }
    }
    Ok(())
}

fn node_transform(node: &serde_json::Value) -> Mat4 {
    if let Some(matrix) = node.get("matrix").and_then(|v| v.as_array()) {
        let mut values = [0.0f32; 16];
        for (i, value) in matrix.iter().take(16).enumerate() {
            values[i] = value.as_f64().unwrap_or(0.0) as f32;
        }
        return Mat4::from_cols_array(&values);
    }
    let translation = read_json_vec3(node.get("translation")).unwrap_or(Vec3::ZERO);
    let scale = read_json_vec3(node.get("scale")).unwrap_or(Vec3::ONE);
    let rotation = node
        .get("rotation")
        .and_then(|v| v.as_array())
        .map(|values| {
            Quat::from_xyzw(
                values.first().and_then(|v| v.as_f64()).unwrap_or(0.0) as f32,
                values.get(1).and_then(|v| v.as_f64()).unwrap_or(0.0) as f32,
                values.get(2).and_then(|v| v.as_f64()).unwrap_or(0.0) as f32,
                values.get(3).and_then(|v| v.as_f64()).unwrap_or(1.0) as f32,
            )
        })
        .unwrap_or(Quat::IDENTITY);
    Mat4::from_scale_rotation_translation(scale, rotation, translation)
}

fn collect_mesh_triangles(
    json: &serde_json::Value,
    bin: &[u8],
    mesh_index: usize,
    transform: Mat4,
    out: &mut Vec<SoftwareTriangle>,
) -> Result<()> {
    let primitives = json
        .get("meshes")
        .and_then(|v| v.as_array())
        .and_then(|meshes| meshes.get(mesh_index))
        .and_then(|mesh| mesh.get("primitives"))
        .and_then(|v| v.as_array())
        .ok_or_else(|| anyhow!("software render: invalid mesh {mesh_index}"))?;
    for primitive in primitives {
        let Some(pos_accessor) = primitive
            .get("attributes")
            .and_then(|attrs| attrs.get("POSITION"))
            .and_then(|v| v.as_u64())
        else {
            continue;
        };
        let positions = read_vec3_accessor(json, bin, pos_accessor as usize)?;
        let normals = primitive
            .get("attributes")
            .and_then(|attrs| attrs.get("NORMAL"))
            .and_then(|v| v.as_u64())
            .and_then(|accessor| read_vec3_accessor(json, bin, accessor as usize).ok());
        let uvs = primitive
            .get("attributes")
            .and_then(|attrs| attrs.get("TEXCOORD_0"))
            .and_then(|v| v.as_u64())
            .and_then(|accessor| read_vec2_accessor(json, bin, accessor as usize).ok());
        let Some(material) = primitive
            .get("material")
            .and_then(|v| v.as_u64())
            .map(|material_index| software_material(json, material_index as usize))
            .unwrap_or(Some(SoftwareMaterial {
                base_color: Vec3::new(0.62, 0.68, 0.72),
                base_texture: None,
                normal_texture: None,
                emissive_factor: Vec3::ZERO,
                emissive_strength: 0.0,
                specular_factor: Vec3::ZERO,
                glossiness: 0.0,
            }))
        else {
            continue;
        };
        let indices = primitive
            .get("indices")
            .and_then(|v| v.as_u64())
            .and_then(|accessor| read_index_accessor(json, bin, accessor as usize).ok());

        if let Some(indices) = indices {
            for face in indices.chunks_exact(3) {
                let Some(a) = positions.get(face[0] as usize) else {
                    continue;
                };
                let Some(b) = positions.get(face[1] as usize) else {
                    continue;
                };
                let Some(c) = positions.get(face[2] as usize) else {
                    continue;
                };
                let face_normal = (*b - *a).cross(*c - *a).normalize_or_zero();
                let na = normals
                    .as_ref()
                    .and_then(|values| values.get(face[0] as usize))
                    .copied()
                    .unwrap_or(face_normal);
                let nb = normals
                    .as_ref()
                    .and_then(|values| values.get(face[1] as usize))
                    .copied()
                    .unwrap_or(face_normal);
                let nc = normals
                    .as_ref()
                    .and_then(|values| values.get(face[2] as usize))
                    .copied()
                    .unwrap_or(face_normal);
                let ua = uvs
                    .as_ref()
                    .and_then(|values| values.get(face[0] as usize))
                    .copied()
                    .unwrap_or(Vec2::ZERO);
                let ub = uvs
                    .as_ref()
                    .and_then(|values| values.get(face[1] as usize))
                    .copied()
                    .unwrap_or(Vec2::ZERO);
                let uc = uvs
                    .as_ref()
                    .and_then(|values| values.get(face[2] as usize))
                    .copied()
                    .unwrap_or(Vec2::ZERO);
                out.push(SoftwareTriangle {
                    vertices: [
                        SoftwareVertex {
                            position: transform.transform_point3(*a),
                            normal: transform.transform_vector3(na).normalize_or_zero(),
                            uv: ua,
                        },
                        SoftwareVertex {
                            position: transform.transform_point3(*b),
                            normal: transform.transform_vector3(nb).normalize_or_zero(),
                            uv: ub,
                        },
                        SoftwareVertex {
                            position: transform.transform_point3(*c),
                            normal: transform.transform_vector3(nc).normalize_or_zero(),
                            uv: uc,
                        },
                    ],
                    base_color: material.base_color,
                    base_texture: material.base_texture,
                    normal_texture: material.normal_texture,
                    emissive_factor: material.emissive_factor,
                    emissive_strength: material.emissive_strength,
                    specular_factor: material.specular_factor,
                    glossiness: material.glossiness,
                });
            }
        } else {
            for (face_index, face) in positions.chunks_exact(3).enumerate() {
                let face_normal = (face[1] - face[0])
                    .cross(face[2] - face[0])
                    .normalize_or_zero();
                let uv_base = face_index * 3;
                out.push(SoftwareTriangle {
                    vertices: [
                        SoftwareVertex {
                            position: transform.transform_point3(face[0]),
                            normal: transform.transform_vector3(face_normal).normalize_or_zero(),
                            uv: uvs
                                .as_ref()
                                .and_then(|values| values.get(uv_base))
                                .copied()
                                .unwrap_or(Vec2::ZERO),
                        },
                        SoftwareVertex {
                            position: transform.transform_point3(face[1]),
                            normal: transform.transform_vector3(face_normal).normalize_or_zero(),
                            uv: uvs
                                .as_ref()
                                .and_then(|values| values.get(uv_base + 1))
                                .copied()
                                .unwrap_or(Vec2::ZERO),
                        },
                        SoftwareVertex {
                            position: transform.transform_point3(face[2]),
                            normal: transform.transform_vector3(face_normal).normalize_or_zero(),
                            uv: uvs
                                .as_ref()
                                .and_then(|values| values.get(uv_base + 2))
                                .copied()
                                .unwrap_or(Vec2::ZERO),
                        },
                    ],
                    base_color: material.base_color,
                    base_texture: material.base_texture,
                    normal_texture: material.normal_texture,
                    emissive_factor: material.emissive_factor,
                    emissive_strength: material.emissive_strength,
                    specular_factor: material.specular_factor,
                    glossiness: material.glossiness,
                });
            }
        }
    }
    Ok(())
}

fn software_material(json: &serde_json::Value, material_index: usize) -> Option<SoftwareMaterial> {
    let Some(material) = json
        .get("materials")
        .and_then(|v| v.as_array())
        .and_then(|materials| materials.get(material_index))
    else {
        return Some(SoftwareMaterial {
            base_color: Vec3::new(0.62, 0.68, 0.72),
            base_texture: None,
            normal_texture: None,
            emissive_factor: Vec3::ZERO,
            emissive_strength: 0.0,
            specular_factor: Vec3::ZERO,
            glossiness: 0.0,
        });
    };
    if is_preview_hidden_material(material) {
        return None;
    }
    let alpha_mode = material
        .get("alphaMode")
        .and_then(|v| v.as_str())
        .unwrap_or("OPAQUE");
    let alpha_cutoff = material
        .get("alphaCutoff")
        .and_then(|v| v.as_f64())
        .unwrap_or(0.5) as f32;
    let common = software_material_common(json, material);
    if let Some(values) = material
        .get("pbrMetallicRoughness")
        .and_then(|pbr| pbr.get("baseColorFactor"))
        .and_then(|v| v.as_array())
    {
        let alpha = read_factor_alpha(values, 1.0);
        if alpha <= 0.0
            || (alpha_mode == "MASK" && alpha <= alpha_cutoff)
            || (alpha_mode == "BLEND" && alpha < 0.75)
        {
            return None;
        }
        return Some(SoftwareMaterial {
            base_color: read_factor_rgb(values, Vec3::ONE),
            ..common
        });
    }
    if let Some(values) = material
        .get("extensions")
        .and_then(|ext| ext.get("KHR_materials_pbrSpecularGlossiness"))
        .and_then(|pbr| pbr.get("diffuseFactor"))
        .and_then(|v| v.as_array())
    {
        let alpha = read_factor_alpha(values, 1.0);
        if alpha <= 0.0
            || (alpha_mode == "MASK" && alpha <= alpha_cutoff)
            || (alpha_mode == "BLEND" && alpha < 0.75)
        {
            return None;
        }
        return Some(SoftwareMaterial {
            base_color: read_factor_rgb(values, Vec3::ONE),
            ..common
        });
    }
    if let Some(values) = material.get("emissiveFactor").and_then(|v| v.as_array()) {
        let emissive = read_factor_rgb(values, Vec3::ZERO);
        if emissive.length_squared() > 0.0 {
            return Some(SoftwareMaterial {
                base_color: emissive,
                ..common
            });
        }
    }
    Some(SoftwareMaterial {
        base_color: Vec3::new(0.62, 0.68, 0.72),
        ..common
    })
}

fn software_material_common(
    json: &serde_json::Value,
    material: &serde_json::Value,
) -> SoftwareMaterial {
    let spec_gloss = material
        .get("extensions")
        .and_then(|ext| ext.get("KHR_materials_pbrSpecularGlossiness"));
    let specular_factor = spec_gloss
        .and_then(|pbr| pbr.get("specularFactor"))
        .and_then(|v| v.as_array())
        .map(|values| read_factor_rgb(values, Vec3::ZERO))
        .unwrap_or(Vec3::ZERO);
    let glossiness = spec_gloss
        .and_then(|pbr| pbr.get("glossinessFactor"))
        .and_then(|v| v.as_f64())
        .unwrap_or(0.0)
        .clamp(0.0, 1.0) as f32;
    let emissive_factor = material
        .get("emissiveFactor")
        .and_then(|v| v.as_array())
        .map(|values| read_factor_rgb(values, Vec3::ZERO))
        .unwrap_or(Vec3::ZERO);
    let emissive_strength = material
        .get("extensions")
        .and_then(|ext| ext.get("KHR_materials_emissive_strength"))
        .and_then(|ext| ext.get("emissiveStrength"))
        .and_then(|v| v.as_f64())
        .unwrap_or(0.0)
        .clamp(0.0, 4.0) as f32;
    SoftwareMaterial {
        base_color: Vec3::new(0.62, 0.68, 0.72),
        base_texture: material_base_texture(json, material),
        normal_texture: material_normal_texture(json, material),
        emissive_factor,
        emissive_strength,
        specular_factor,
        glossiness,
    }
}

fn material_base_texture(json: &serde_json::Value, material: &serde_json::Value) -> Option<usize> {
    material
        .get("pbrMetallicRoughness")
        .and_then(|pbr| pbr.get("baseColorTexture"))
        .and_then(|tex| tex.get("index"))
        .and_then(|v| v.as_u64())
        .or_else(|| {
            material
                .get("extensions")
                .and_then(|ext| ext.get("KHR_materials_pbrSpecularGlossiness"))
                .and_then(|pbr| pbr.get("diffuseTexture"))
                .and_then(|tex| tex.get("index"))
                .and_then(|v| v.as_u64())
        })
        .and_then(|texture_index| gltf_texture_source(json, texture_index as usize))
}

fn material_normal_texture(
    json: &serde_json::Value,
    material: &serde_json::Value,
) -> Option<usize> {
    material
        .get("normalTexture")
        .and_then(|tex| tex.get("index"))
        .and_then(|v| v.as_u64())
        .and_then(|texture_index| gltf_texture_source(json, texture_index as usize))
}

fn gltf_texture_source(json: &serde_json::Value, texture_index: usize) -> Option<usize> {
    json.get("textures")
        .and_then(|v| v.as_array())
        .and_then(|textures| textures.get(texture_index))
        .and_then(|texture| texture.get("source"))
        .and_then(|v| v.as_u64())
        .map(|v| v as usize)
}

fn is_preview_hidden_material(material: &serde_json::Value) -> bool {
    let name = material
        .get("name")
        .and_then(|v| v.as_str())
        .unwrap_or_default()
        .to_ascii_lowercase();
    name.contains("internal")
        || name.ends_with("_int")
        || name.contains("_int_")
        || name.contains("pom_int")
        || name.contains("pipes_int")
        || name.contains("holo_console")
}

fn read_factor_rgb(values: &[serde_json::Value], fallback: Vec3) -> Vec3 {
    if values.len() < 3 {
        return fallback;
    }
    Vec3::new(
        values[0].as_f64().unwrap_or(fallback.x as f64) as f32,
        values[1].as_f64().unwrap_or(fallback.y as f64) as f32,
        values[2].as_f64().unwrap_or(fallback.z as f64) as f32,
    )
    .clamp(Vec3::splat(0.04), Vec3::ONE)
}

fn read_factor_alpha(values: &[serde_json::Value], fallback: f32) -> f32 {
    values
        .get(3)
        .and_then(|v| v.as_f64())
        .unwrap_or(fallback as f64)
        .clamp(0.0, 1.0) as f32
}

fn read_vec3_accessor(
    json: &serde_json::Value,
    bin: &[u8],
    accessor_index: usize,
) -> Result<Vec<Vec3>> {
    let (offset, stride, count, component_type, accessor_type) =
        accessor_layout(json, accessor_index, 12)?;
    if component_type != 5126 || accessor_type != "VEC3" {
        return Err(anyhow!("software render: unsupported POSITION accessor"));
    }
    let mut out = Vec::with_capacity(count);
    for i in 0..count {
        let base = offset + i * stride;
        out.push(Vec3::new(
            read_f32_at(bin, base)?,
            read_f32_at(bin, base + 4)?,
            read_f32_at(bin, base + 8)?,
        ));
    }
    Ok(out)
}

fn read_vec2_accessor(
    json: &serde_json::Value,
    bin: &[u8],
    accessor_index: usize,
) -> Result<Vec<Vec2>> {
    let (offset, stride, count, component_type, accessor_type) =
        accessor_layout(json, accessor_index, 8)?;
    if component_type != 5126 || accessor_type != "VEC2" {
        return Err(anyhow!("software render: unsupported TEXCOORD_0 accessor"));
    }
    let mut out = Vec::with_capacity(count);
    for i in 0..count {
        let base = offset + i * stride;
        out.push(Vec2::new(
            read_f32_at(bin, base)?,
            read_f32_at(bin, base + 4)?,
        ));
    }
    Ok(out)
}

fn read_index_accessor(
    json: &serde_json::Value,
    bin: &[u8],
    accessor_index: usize,
) -> Result<Vec<u32>> {
    let (offset, stride, count, component_type, accessor_type) =
        accessor_layout(json, accessor_index, 4)?;
    if accessor_type != "SCALAR" {
        return Err(anyhow!("software render: unsupported index accessor type"));
    }
    let mut out = Vec::with_capacity(count);
    for i in 0..count {
        let base = offset + i * stride;
        let value = match component_type {
            5121 => *bin
                .get(base)
                .ok_or_else(|| anyhow!("software render: index out of bounds"))?
                as u32,
            5123 => read_u16_at(bin, base)? as u32,
            5125 => read_u32_at(bin, base)?,
            _ => return Err(anyhow!("software render: unsupported index component type")),
        };
        out.push(value);
    }
    Ok(out)
}

fn accessor_layout(
    json: &serde_json::Value,
    accessor_index: usize,
    default_stride: usize,
) -> Result<(usize, usize, usize, u64, String)> {
    let accessor = json
        .get("accessors")
        .and_then(|v| v.as_array())
        .and_then(|accessors| accessors.get(accessor_index))
        .ok_or_else(|| anyhow!("software render: invalid accessor {accessor_index}"))?;
    let buffer_view_index = accessor
        .get("bufferView")
        .and_then(|v| v.as_u64())
        .ok_or_else(|| anyhow!("software render: accessor without bufferView"))?
        as usize;
    let buffer_view = json
        .get("bufferViews")
        .and_then(|v| v.as_array())
        .and_then(|views| views.get(buffer_view_index))
        .ok_or_else(|| anyhow!("software render: invalid bufferView {buffer_view_index}"))?;
    let view_offset = buffer_view
        .get("byteOffset")
        .and_then(|v| v.as_u64())
        .unwrap_or(0) as usize;
    let accessor_offset = accessor
        .get("byteOffset")
        .and_then(|v| v.as_u64())
        .unwrap_or(0) as usize;
    let stride = buffer_view
        .get("byteStride")
        .and_then(|v| v.as_u64())
        .map(|v| v as usize)
        .unwrap_or(default_stride);
    let count = accessor.get("count").and_then(|v| v.as_u64()).unwrap_or(0) as usize;
    let component_type = accessor
        .get("componentType")
        .and_then(|v| v.as_u64())
        .unwrap_or(0);
    let accessor_type = accessor
        .get("type")
        .and_then(|v| v.as_str())
        .unwrap_or_default()
        .to_string();
    Ok((
        view_offset + accessor_offset,
        stride,
        count,
        component_type,
        accessor_type,
    ))
}

fn rasterize_triangle(
    tri: &SoftwareTriangle,
    textures: &[SoftwareTexture],
    width: u32,
    height: u32,
    rgba: &mut [u8],
    depth: &mut [f32],
) {
    let p0 = Vec2::new(tri.vertices[0].position.x, tri.vertices[0].position.y);
    let p1 = Vec2::new(tri.vertices[1].position.x, tri.vertices[1].position.y);
    let p2 = Vec2::new(tri.vertices[2].position.x, tri.vertices[2].position.y);
    let area = edge(p0, p1, p2);
    if area.abs() < 0.01 {
        draw_point(p0, tri.vertices[0].position.z, width, height, rgba, depth);
        draw_point(p1, tri.vertices[1].position.z, width, height, rgba, depth);
        draw_point(p2, tri.vertices[2].position.z, width, height, rgba, depth);
        return;
    }

    let min_x = p0.x.min(p1.x).min(p2.x).floor().max(0.0) as i32;
    let max_x = p0.x.max(p1.x).max(p2.x).ceil().min(width as f32 - 1.0) as i32;
    let min_y = p0.y.min(p1.y).min(p2.y).floor().max(0.0) as i32;
    let max_y = p0.y.max(p1.y).max(p2.y).ceil().min(height as f32 - 1.0) as i32;
    if min_x > max_x || min_y > max_y {
        return;
    }

    let light_dir = Vec3::new(-0.35, 0.45, 0.82).normalize();
    let normal_map_strength = software_normal_map_strength();
    let tangent_frame = if normal_map_strength > 0.0 {
        triangle_tangent_frame(tri)
    } else {
        None
    };

    for y in min_y..=max_y {
        for x in min_x..=max_x {
            let p = Vec2::new(x as f32 + 0.5, y as f32 + 0.5);
            let w0 = edge(p1, p2, p) / area;
            let w1 = edge(p2, p0, p) / area;
            let w2 = edge(p0, p1, p) / area;
            if w0 >= -0.0001 && w1 >= -0.0001 && w2 >= -0.0001 {
                let z = w0 * tri.vertices[0].position.z
                    + w1 * tri.vertices[1].position.z
                    + w2 * tri.vertices[2].position.z;
                let idx = y as usize * width as usize + x as usize;
                if z < depth[idx] {
                    depth[idx] = z;
                    let vertex_normal = (tri.vertices[0].normal * w0
                        + tri.vertices[1].normal * w1
                        + tri.vertices[2].normal * w2)
                        .normalize_or_zero();
                    let uv =
                        tri.vertices[0].uv * w0 + tri.vertices[1].uv * w1 + tri.vertices[2].uv * w2;
                    let normal = if normal_map_strength > 0.0 {
                        tri.normal_texture
                            .and_then(|texture_index| textures.get(texture_index))
                            .and_then(|texture| tangent_frame.map(|frame| (texture, frame)))
                            .map(|(texture, (tangent, bitangent))| {
                                let mapped = sample_normal_texture(texture, uv);
                                let tangent = (tangent
                                    - vertex_normal * tangent.dot(vertex_normal))
                                .normalize_or_zero();
                                let bitangent = (bitangent
                                    - vertex_normal * bitangent.dot(vertex_normal)
                                    - tangent * bitangent.dot(tangent))
                                .normalize_or_zero();
                                let mapped_normal = (tangent * mapped.x
                                    + bitangent * mapped.y
                                    + vertex_normal * mapped.z)
                                    .normalize_or_zero();
                                vertex_normal
                                    .lerp(mapped_normal, normal_map_strength)
                                    .normalize_or_zero()
                            })
                            .filter(|normal| normal.length_squared() > 0.0)
                            .unwrap_or(vertex_normal)
                    } else {
                        vertex_normal
                    };
                    let diffuse = normal.dot(light_dir).max(0.0);
                    let facing = normal.z.abs();
                    let edge_factor = w0.min(w1).min(w2).mul_add(24.0, 0.0).clamp(0.9, 1.0);
                    let view_dir = Vec3::Z;
                    let half_dir = (light_dir + view_dir).normalize_or_zero();
                    let specular = normal
                        .dot(half_dir)
                        .max(0.0)
                        .powf(8.0 + 56.0 * tri.glossiness)
                        * tri.glossiness;
                    let shade =
                        (0.2 + 0.56 * diffuse + 0.2 * facing).clamp(0.18, 0.98) * edge_factor;
                    let texel = tri
                        .base_texture
                        .and_then(|texture_index| textures.get(texture_index))
                        .map(|texture| sample_texture(texture, uv))
                        .unwrap_or(Vec4::ONE);
                    if texel.w < 0.1 {
                        continue;
                    }
                    let base = tri.base_color * Vec3::new(texel.x, texel.y, texel.z);
                    let lit = base * shade
                        + tri.specular_factor * specular * SPECULAR_STRENGTH
                        + tri.emissive_factor * tri.emissive_strength * EMISSIVE_STRENGTH;
                    let color = [
                        (lit.x * 255.0).clamp(0.0, 255.0) as u8,
                        (lit.y * 255.0).clamp(0.0, 255.0) as u8,
                        (lit.z * 255.0).clamp(0.0, 255.0) as u8,
                        255u8,
                    ];
                    rgba[idx * 4..idx * 4 + 4].copy_from_slice(&color);
                }
            }
        }
    }
}

fn sample_texture(texture: &SoftwareTexture, uv: Vec2) -> Vec4 {
    if texture.width == 0 || texture.height == 0 || texture.rgba.is_empty() {
        return Vec4::ONE;
    }
    let u = uv.x.rem_euclid(1.0);
    let v = (1.0 - uv.y).rem_euclid(1.0);
    let x = u * texture.width.saturating_sub(1) as f32;
    let y = v * texture.height.saturating_sub(1) as f32;
    let x0 = x.floor() as u32;
    let y0 = y.floor() as u32;
    let x1 = (x0 + 1).min(texture.width - 1);
    let y1 = (y0 + 1).min(texture.height - 1);
    let tx = x - x0 as f32;
    let ty = y - y0 as f32;
    let top = texture_pixel(texture, x0, y0).lerp(texture_pixel(texture, x1, y0), tx);
    let bottom = texture_pixel(texture, x0, y1).lerp(texture_pixel(texture, x1, y1), tx);
    top.lerp(bottom, ty)
}

fn sample_normal_texture(texture: &SoftwareTexture, uv: Vec2) -> Vec3 {
    let texel = sample_texture(texture, uv);
    Vec3::new(
        texel.x.mul_add(2.0, -1.0),
        texel.y.mul_add(2.0, -1.0),
        texel.z.mul_add(2.0, -1.0),
    )
    .normalize_or_zero()
}

fn triangle_tangent_frame(tri: &SoftwareTriangle) -> Option<(Vec3, Vec3)> {
    let p0 = tri.vertices[0].position;
    let p1 = tri.vertices[1].position;
    let p2 = tri.vertices[2].position;
    let uv0 = tri.vertices[0].uv;
    let uv1 = tri.vertices[1].uv;
    let uv2 = tri.vertices[2].uv;
    let dp1 = p1 - p0;
    let dp2 = p2 - p0;
    let duv1 = uv1 - uv0;
    let duv2 = uv2 - uv0;
    let denom = duv1.x * duv2.y - duv1.y * duv2.x;
    if denom.abs() < 1e-6 {
        return None;
    }
    let inv = 1.0 / denom;
    let tangent = (dp1 * duv2.y - dp2 * duv1.y) * inv;
    let bitangent = (dp2 * duv1.x - dp1 * duv2.x) * inv;
    let tangent = tangent.normalize_or_zero();
    let bitangent = bitangent.normalize_or_zero();
    if tangent.length_squared() == 0.0 || bitangent.length_squared() == 0.0 {
        None
    } else {
        Some((tangent, bitangent))
    }
}

fn texture_pixel(texture: &SoftwareTexture, x: u32, y: u32) -> Vec4 {
    let idx = (y as usize * texture.width as usize + x as usize) * 4;
    let px = texture
        .rgba
        .get(idx..idx + 4)
        .unwrap_or(&[255, 255, 255, 255]);
    Vec4::new(
        px[0] as f32 / 255.0,
        px[1] as f32 / 255.0,
        px[2] as f32 / 255.0,
        px[3] as f32 / 255.0,
    )
}

fn draw_point(point: Vec2, z: f32, width: u32, height: u32, rgba: &mut [u8], depth: &mut [f32]) {
    let x = point.x.round() as i32;
    let y = point.y.round() as i32;
    if x < 0 || y < 0 || x >= width as i32 || y >= height as i32 {
        return;
    }
    let idx = y as usize * width as usize + x as usize;
    if z < depth[idx] {
        depth[idx] = z;
        rgba[idx * 4..idx * 4 + 4].copy_from_slice(&[148, 177, 196, 255]);
    }
}

fn edge(a: Vec2, b: Vec2, c: Vec2) -> f32 {
    (c.x - a.x) * (b.y - a.y) - (c.y - a.y) * (b.x - a.x)
}

fn read_json_vec3(value: Option<&serde_json::Value>) -> Option<Vec3> {
    let values = value?.as_array()?;
    Some(Vec3::new(
        values.first()?.as_f64()? as f32,
        values.get(1)?.as_f64()? as f32,
        values.get(2)?.as_f64()? as f32,
    ))
}

fn read_u16_at(data: &[u8], offset: usize) -> Result<u16> {
    let bytes: [u8; 2] = data
        .get(offset..offset + 2)
        .ok_or_else(|| anyhow!("software render: unexpected EOF"))?
        .try_into()
        .map_err(|_| anyhow!("software render: unexpected EOF"))?;
    Ok(u16::from_le_bytes(bytes))
}

fn read_u32_at(data: &[u8], offset: usize) -> Result<u32> {
    let bytes: [u8; 4] = data
        .get(offset..offset + 4)
        .ok_or_else(|| anyhow!("software render: unexpected EOF"))?
        .try_into()
        .map_err(|_| anyhow!("software render: unexpected EOF"))?;
    Ok(u32::from_le_bytes(bytes))
}

fn read_f32_at(data: &[u8], offset: usize) -> Result<f32> {
    Ok(f32::from_bits(read_u32_at(data, offset)?))
}
