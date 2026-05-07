use anyhow::{Result, anyhow};
use std::collections::HashMap;
use std::sync::Arc;

use crate::model_convert::{
    DecodedTexture as ConvertTexture, GltfMaterialData, SceneData, ScenePrimitive,
};
use bytemuck::{Pod, Zeroable};
use parking_lot::Mutex;
use renderling::glam::{Mat4, Quat, Vec2, Vec3, Vec4};
use renderling::{camera::Camera, context::Context, gltf::GltfDocument, light::Lux, stage::Stage};
use uuid::Uuid;
use wgpu::util::DeviceExt;

pub struct RenderSession {
    backend: RenderSessionBackend,
    pub width: u32,
    pub height: u32,
    pub model_center: Vec3,
    pub model_radius: f32,
}

enum RenderSessionBackend {
    Wgpu(WgpuModelSession),
    Renderling {
        ctx: Context,
        stage: Stage,
        camera: Camera,
    },
}

#[derive(Clone, Copy)]
struct ParsedModelVertex {
    position: Vec3,
    normal: Vec3,
    uv: Vec2,
}

#[derive(Clone, Copy)]
struct ParsedModelTriangle {
    vertices: [ParsedModelVertex; 3],
    color: Vec3,
    alpha: f32,
    alpha_cutoff: f32,
    texture_strength: f32,
    texture_index: Option<usize>,
}

struct ParsedModelScene {
    triangles: Vec<ParsedModelTriangle>,
    textures: Vec<ParsedTexture>,
}

#[derive(Clone, Copy)]
struct ParsedMaterial {
    color: Vec3,
    alpha: f32,
    alpha_cutoff: f32,
    texture_strength: f32,
    texture_index: Option<usize>,
}

struct ParsedTexture {
    width: u32,
    height: u32,
    rgba: Vec<u8>,
}

struct WgpuModelSession {
    shared: Arc<WgpuSharedContext>,
    uniform_buffer: wgpu::Buffer,
    target: wgpu::Texture,
    target_view: wgpu::TextureView,
    _msaa_target: wgpu::Texture,
    msaa_target_view: wgpu::TextureView,
    _depth: wgpu::Texture,
    depth_view: wgpu::TextureView,
    batches: Vec<WgpuBatch>,
    edge_batches: Vec<WgpuBatch>,
    bg: [u8; 4],
    width: u32,
    height: u32,
}

struct WgpuBatch {
    vertex_buffer: wgpu::Buffer,
    vertex_count: u32,
    bind_group: wgpu::BindGroup,
}

struct WgpuSharedContext {
    device: wgpu::Device,
    queue: wgpu::Queue,
    bind_group_layout: wgpu::BindGroupLayout,
    pipeline: wgpu::RenderPipeline,
    edge_pipeline: wgpu::RenderPipeline,
}

#[repr(C)]
#[derive(Clone, Copy, Pod, Zeroable)]
struct WgpuVertex {
    position: [f32; 3],
    normal: [f32; 3],
    color: [f32; 3],
    uv: [f32; 2],
    alpha: f32,
    alpha_cutoff: f32,
    texture_strength: f32,
}

#[repr(C)]
#[derive(Clone, Copy, Pod, Zeroable)]
struct WgpuUniforms {
    mvp: [[f32; 4]; 4],
    light_dir: [f32; 4],
    camera_pos: [f32; 4],
}

const WGPU_BATCH_TRIANGLES: usize = 64 * 1024;
const WGPU_EDGE_BATCH_VERTICES: usize = 256 * 1024;
const WGPU_MAX_EDGE_VERTICES: usize = 320 * 1024;
const WGPU_SAMPLE_COUNT: u32 = 4;

fn wgpu_vertex_buffer_layout() -> wgpu::VertexBufferLayout<'static> {
    wgpu::VertexBufferLayout {
        array_stride: std::mem::size_of::<WgpuVertex>() as u64,
        step_mode: wgpu::VertexStepMode::Vertex,
        attributes: &[
            wgpu::VertexAttribute {
                offset: 0,
                shader_location: 0,
                format: wgpu::VertexFormat::Float32x3,
            },
            wgpu::VertexAttribute {
                offset: 12,
                shader_location: 1,
                format: wgpu::VertexFormat::Float32x3,
            },
            wgpu::VertexAttribute {
                offset: 24,
                shader_location: 2,
                format: wgpu::VertexFormat::Float32x3,
            },
            wgpu::VertexAttribute {
                offset: 36,
                shader_location: 3,
                format: wgpu::VertexFormat::Float32x2,
            },
            wgpu::VertexAttribute {
                offset: 44,
                shader_location: 4,
                format: wgpu::VertexFormat::Float32,
            },
            wgpu::VertexAttribute {
                offset: 48,
                shader_location: 5,
                format: wgpu::VertexFormat::Float32,
            },
            wgpu::VertexAttribute {
                offset: 52,
                shader_location: 6,
                format: wgpu::VertexFormat::Float32,
            },
        ],
    }
}

#[derive(Clone, Copy, Eq, Hash, PartialEq)]
struct EdgeKey {
    a: [u32; 3],
    b: [u32; 3],
}

struct EdgeUse {
    a: Vec3,
    b: Vec3,
    normal: Vec3,
}

// SAFETY: We ensure the context is only used from a single thread at a time via the Mutex
unsafe impl Send for RenderSession {}

lazy_static::lazy_static! {
    // 每个 session 有独立的锁，减少锁竞争
    pub static ref SESSIONS: Arc<Mutex<HashMap<String, Arc<Mutex<RenderSession>>>>> = Arc::new(Mutex::new(HashMap::new()));
    static ref GLOBAL_CONTEXT: Arc<Mutex<Option<Context>>> = Arc::new(Mutex::new(None));
    static ref WGPU_SHARED_CONTEXT: Mutex<Option<Arc<WgpuSharedContext>>> = Mutex::new(None);
    static ref RENDER_PANIC_HOOK_LOCK: Mutex<()> = Mutex::new(());
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
            return Self::new_wgpu(width, height, glb_data, bg_color);
        }
        Self::new_renderling(width, height, glb_data, bg_color)
    }

    fn new_wgpu(
        width: u32,
        height: u32,
        glb_data: &[u8],
        bg_color: Option<[f32; 4]>,
    ) -> Result<Self> {
        let scene = load_parsed_model_scene(glb_data)?;
        let (model_center, model_radius) = parsed_model_bounds(&scene.triangles)?;
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
            backend: RenderSessionBackend::Wgpu(WgpuModelSession::new(width, height, &scene, bg)?),
            width,
            height,
            model_center,
            model_radius: model_radius.max(1.0),
        })
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

    fn render(&self, camera_pos: [f32; 3], camera_target: [f32; 3]) -> Result<Vec<u8>> {
        match &self.backend {
            RenderSessionBackend::Wgpu(session) => session.render(
                Vec3::from(camera_pos),
                Vec3::from(camera_target),
                self.model_radius,
            ),
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
        }
    }
}

impl ParsedModelScene {
    fn from_converted(
        scene: &SceneData,
        textures: &[ConvertTexture],
        materials: &[GltfMaterialData],
        materials_by_id: &HashMap<i32, usize>,
    ) -> Result<Self> {
        let parsed_textures = textures
            .iter()
            .filter(|texture| texture.width > 0 && texture.height > 0 && !texture.rgba8.is_empty())
            .map(|texture| ParsedTexture {
                width: texture.width,
                height: texture.height,
                rgba: texture.rgba8.clone(),
            })
            .collect::<Vec<_>>();
        let mut triangles = Vec::new();
        for mesh in &scene.meshes {
            let transform = mesh_transform(mesh);
            let normal_transform = transform.inverse().transpose();
            let primitives = if mesh.primitives.is_empty() {
                vec![ScenePrimitive {
                    first_index: 0,
                    num_indices: mesh.indices.len() as u32,
                    first_vertex: 0,
                    num_vertices: mesh.positions.len() as u32,
                    material_id: -1,
                }]
            } else {
                mesh.primitives.clone()
            };

            for primitive in primitives {
                let first = primitive.first_index as usize;
                let count = primitive.num_indices as usize;
                let end = first.saturating_add(count);
                if count == 0 || end > mesh.indices.len() {
                    continue;
                }
                let material_index = materials_by_id
                    .get(&primitive.material_id)
                    .copied()
                    .unwrap_or(0);
                let Some(material) = converted_material(materials.get(material_index)) else {
                    continue;
                };
                for face in mesh.indices[first..end].chunks_exact(3) {
                    let Some(a) =
                        converted_vertex(mesh, face[0] as usize, transform, normal_transform)
                    else {
                        continue;
                    };
                    let Some(b) =
                        converted_vertex(mesh, face[1] as usize, transform, normal_transform)
                    else {
                        continue;
                    };
                    let Some(c) =
                        converted_vertex(mesh, face[2] as usize, transform, normal_transform)
                    else {
                        continue;
                    };
                    triangles.push(ParsedModelTriangle {
                        vertices: [a, b, c],
                        color: material.color,
                        alpha: material.alpha,
                        alpha_cutoff: material.alpha_cutoff,
                        texture_strength: material.texture_strength,
                        texture_index: material.texture_index,
                    });
                }
            }
        }
        if triangles.is_empty() {
            return Err(anyhow!("model geometry: no triangles"));
        }
        triangles = filter_small_triangle_islands(triangles);
        Ok(Self {
            triangles,
            textures: parsed_textures,
        })
    }
}

fn mesh_transform(mesh: &crate::model_convert::SceneMesh) -> Mat4 {
    if let Some(matrix) = mesh.node_matrix {
        Mat4::from_cols_array(&matrix)
    } else {
        let translation = mesh.node_translation.unwrap_or([0.0, 0.0, 0.0]);
        let rotation = mesh.node_rotation.unwrap_or([0.0, 0.0, 0.0, 1.0]);
        let scale = mesh.node_scale.unwrap_or([1.0, 1.0, 1.0]);
        Mat4::from_scale_rotation_translation(
            Vec3::from(scale),
            Quat::from_array(rotation),
            Vec3::from(translation),
        )
    }
}

fn converted_vertex(
    mesh: &crate::model_convert::SceneMesh,
    index: usize,
    transform: Mat4,
    normal_transform: Mat4,
) -> Option<ParsedModelVertex> {
    let position = Vec3::from(*mesh.positions.get(index)?);
    let normal = mesh
        .normals
        .get(index)
        .copied()
        .map(Vec3::from)
        .unwrap_or(Vec3::Y);
    let uv = mesh
        .uvs
        .get(index)
        .copied()
        .map(Vec2::from)
        .unwrap_or(Vec2::ZERO);
    Some(ParsedModelVertex {
        position: transform.transform_point3(position),
        normal: normal_transform
            .transform_vector3(normal)
            .normalize_or_zero(),
        uv,
    })
}

fn converted_material(material: Option<&GltfMaterialData>) -> Option<ParsedMaterial> {
    let Some(material) = material else {
        return Some(ParsedMaterial {
            color: Vec3::new(0.62, 0.68, 0.72),
            alpha: 1.0,
            alpha_cutoff: 0.0,
            texture_strength: 0.0,
            texture_index: None,
        });
    };
    if material.no_draw {
        return None;
    }
    let alpha_mode = material.alpha_mode.as_deref().unwrap_or("OPAQUE");
    let alpha_cutoff = material.alpha_cutoff.unwrap_or(0.5);
    let factor = material
        .base_color_factor
        .unwrap_or([0.62, 0.68, 0.72, 1.0]);
    let alpha = factor[3];
    if alpha <= 0.0
        || (alpha_mode == "MASK" && alpha <= alpha_cutoff)
        || (alpha_mode == "BLEND" && alpha < 0.75)
    {
        return None;
    }
    Some(ParsedMaterial {
        color: Vec3::new(factor[0], factor[1], factor[2]),
        alpha,
        alpha_cutoff: if alpha_mode == "MASK" {
            alpha_cutoff
        } else if alpha_mode == "BLEND" {
            0.05
        } else {
            0.0
        },
        texture_strength: preview_texture_strength_name(
            material.name.as_deref().unwrap_or_default(),
        ),
        texture_index: material.base_color_texture.or(material.diffuse_texture),
    })
}

fn prefers_renderling_session() -> bool {
    std::env::var("SCTB_MODEL_SESSION_RENDERER")
        .or_else(|_| std::env::var("SCTB_MODEL_RENDERER"))
        .map(|value| value.eq_ignore_ascii_case("renderling"))
        .unwrap_or(false)
}

fn wgpu_shared_context() -> Result<Arc<WgpuSharedContext>> {
    {
        let shared = WGPU_SHARED_CONTEXT.lock();
        if let Some(context) = shared.as_ref() {
            return Ok(context.clone());
        }
    }

    let mut shared = WGPU_SHARED_CONTEXT.lock();
    if let Some(context) = shared.as_ref() {
        return Ok(context.clone());
    }

    let instance = wgpu::Instance::new(&wgpu::InstanceDescriptor {
        backends: wgpu::Backends::PRIMARY,
        ..Default::default()
    });
    let adapter =
        futures_lite::future::block_on(instance.request_adapter(&wgpu::RequestAdapterOptions {
            power_preference: wgpu::PowerPreference::HighPerformance,
            compatible_surface: None,
            force_fallback_adapter: false,
        }))
        .map_err(|e| anyhow!("wgpu renderer: no adapter: {e:?}"))?;
    let (device, queue) =
        futures_lite::future::block_on(adapter.request_device(&wgpu::DeviceDescriptor {
            label: Some("sctb model renderer device"),
            required_features: wgpu::Features::empty(),
            required_limits: wgpu::Limits::downlevel_defaults().using_resolution(adapter.limits()),
            memory_hints: wgpu::MemoryHints::Performance,
            trace: wgpu::Trace::Off,
        }))
        .map_err(|e| anyhow!("wgpu renderer: request device failed: {e:?}"))?;

    let bind_group_layout = device.create_bind_group_layout(&wgpu::BindGroupLayoutDescriptor {
        label: Some("sctb model renderer bind layout"),
        entries: &[
            wgpu::BindGroupLayoutEntry {
                binding: 0,
                visibility: wgpu::ShaderStages::VERTEX | wgpu::ShaderStages::FRAGMENT,
                ty: wgpu::BindingType::Buffer {
                    ty: wgpu::BufferBindingType::Uniform,
                    has_dynamic_offset: false,
                    min_binding_size: None,
                },
                count: None,
            },
            wgpu::BindGroupLayoutEntry {
                binding: 1,
                visibility: wgpu::ShaderStages::FRAGMENT,
                ty: wgpu::BindingType::Texture {
                    sample_type: wgpu::TextureSampleType::Float { filterable: true },
                    view_dimension: wgpu::TextureViewDimension::D2,
                    multisampled: false,
                },
                count: None,
            },
            wgpu::BindGroupLayoutEntry {
                binding: 2,
                visibility: wgpu::ShaderStages::FRAGMENT,
                ty: wgpu::BindingType::Sampler(wgpu::SamplerBindingType::Filtering),
                count: None,
            },
        ],
    });

    let shader = device.create_shader_module(wgpu::ShaderModuleDescriptor {
        label: Some("sctb model renderer shader"),
        source: wgpu::ShaderSource::Wgsl(include_str!("shaders/model.wgsl").into()),
    });
    let pipeline_layout = device.create_pipeline_layout(&wgpu::PipelineLayoutDescriptor {
        label: Some("sctb model renderer pipeline layout"),
        bind_group_layouts: &[&bind_group_layout],
        push_constant_ranges: &[],
    });
    let pipeline = device.create_render_pipeline(&wgpu::RenderPipelineDescriptor {
        label: Some("sctb model renderer pipeline"),
        layout: Some(&pipeline_layout),
        vertex: wgpu::VertexState {
            module: &shader,
            entry_point: Some("vs_main"),
            compilation_options: Default::default(),
            buffers: &[wgpu_vertex_buffer_layout()],
        },
        fragment: Some(wgpu::FragmentState {
            module: &shader,
            entry_point: Some("fs_main"),
            compilation_options: Default::default(),
            targets: &[Some(wgpu::ColorTargetState {
                format: wgpu::TextureFormat::Rgba8Unorm,
                blend: Some(wgpu::BlendState::REPLACE),
                write_mask: wgpu::ColorWrites::ALL,
            })],
        }),
        primitive: wgpu::PrimitiveState {
            topology: wgpu::PrimitiveTopology::TriangleList,
            cull_mode: None,
            ..Default::default()
        },
        depth_stencil: Some(wgpu::DepthStencilState {
            format: wgpu::TextureFormat::Depth32Float,
            depth_write_enabled: true,
            depth_compare: wgpu::CompareFunction::Less,
            stencil: Default::default(),
            bias: Default::default(),
        }),
        multisample: wgpu::MultisampleState {
            count: WGPU_SAMPLE_COUNT,
            ..Default::default()
        },
        multiview: None,
        cache: None,
    });
    let edge_pipeline = device.create_render_pipeline(&wgpu::RenderPipelineDescriptor {
        label: Some("sctb model renderer edge pipeline"),
        layout: Some(&pipeline_layout),
        vertex: wgpu::VertexState {
            module: &shader,
            entry_point: Some("vs_main"),
            compilation_options: Default::default(),
            buffers: &[wgpu_vertex_buffer_layout()],
        },
        fragment: Some(wgpu::FragmentState {
            module: &shader,
            entry_point: Some("fs_main"),
            compilation_options: Default::default(),
            targets: &[Some(wgpu::ColorTargetState {
                format: wgpu::TextureFormat::Rgba8Unorm,
                blend: Some(wgpu::BlendState::ALPHA_BLENDING),
                write_mask: wgpu::ColorWrites::ALL,
            })],
        }),
        primitive: wgpu::PrimitiveState {
            topology: wgpu::PrimitiveTopology::LineList,
            cull_mode: None,
            ..Default::default()
        },
        depth_stencil: Some(wgpu::DepthStencilState {
            format: wgpu::TextureFormat::Depth32Float,
            depth_write_enabled: false,
            depth_compare: wgpu::CompareFunction::LessEqual,
            stencil: Default::default(),
            bias: Default::default(),
        }),
        multisample: wgpu::MultisampleState {
            count: WGPU_SAMPLE_COUNT,
            ..Default::default()
        },
        multiview: None,
        cache: None,
    });

    let context = Arc::new(WgpuSharedContext {
        device,
        queue,
        bind_group_layout,
        pipeline,
        edge_pipeline,
    });
    *shared = Some(context.clone());
    Ok(context)
}

impl WgpuModelSession {
    fn new(width: u32, height: u32, scene: &ParsedModelScene, bg: [u8; 4]) -> Result<Self> {
        if width == 0 || height == 0 {
            return Err(anyhow!(
                "wgpu renderer: invalid output size {width}x{height}"
            ));
        }

        let shared = wgpu_shared_context()?;
        let device = &shared.device;
        let queue = &shared.queue;

        let target = create_wgpu_target(device, width, height, 1);
        let target_view = target.create_view(&wgpu::TextureViewDescriptor::default());
        let msaa_target = create_wgpu_target(device, width, height, WGPU_SAMPLE_COUNT);
        let msaa_target_view = msaa_target.create_view(&wgpu::TextureViewDescriptor::default());
        let depth = create_wgpu_depth(device, width, height, WGPU_SAMPLE_COUNT);
        let depth_view = depth.create_view(&wgpu::TextureViewDescriptor::default());

        let uniforms = WgpuUniforms {
            mvp: Mat4::IDENTITY.to_cols_array_2d(),
            light_dir: [-0.45, -0.75, -0.35, 0.0],
            camera_pos: [0.0, 0.0, 1.0, 0.0],
        };
        let uniform_buffer = device.create_buffer_init(&wgpu::util::BufferInitDescriptor {
            label: Some("sctb model renderer uniforms"),
            contents: bytemuck::bytes_of(&uniforms),
            usage: wgpu::BufferUsages::UNIFORM | wgpu::BufferUsages::COPY_DST,
        });
        let texture_bind_groups = create_wgpu_texture_bind_groups(
            device,
            queue,
            &shared.bind_group_layout,
            &uniform_buffer,
            &scene.textures,
        )?;
        if texture_bind_groups.is_empty() {
            return Err(anyhow!(
                "wgpu renderer: missing fallback texture bind group"
            ));
        }
        let batches = create_wgpu_batches(device, &scene.triangles, &texture_bind_groups)?;
        let edge_batches =
            create_wgpu_edge_batches(device, &scene.triangles, &texture_bind_groups)?;
        Ok(Self {
            shared,
            uniform_buffer,
            target,
            target_view,
            _msaa_target: msaa_target,
            msaa_target_view,
            _depth: depth,
            depth_view,
            batches,
            edge_batches,
            bg,
            width,
            height,
        })
    }

    fn render(&self, camera_pos: Vec3, camera_target: Vec3, model_radius: f32) -> Result<Vec<u8>> {
        let aspect = self.width as f32 / self.height as f32;
        let projection =
            Mat4::perspective_rh(35.0_f32.to_radians(), aspect, 0.01, model_radius * 20.0);
        let view = Mat4::look_at_rh(camera_pos, camera_target, Vec3::Y);
        let uniforms = WgpuUniforms {
            mvp: (projection * view).to_cols_array_2d(),
            light_dir: [-0.45, -0.75, -0.35, 0.0],
            camera_pos: [camera_pos.x, camera_pos.y, camera_pos.z, 0.0],
        };
        self.shared
            .queue
            .write_buffer(&self.uniform_buffer, 0, bytemuck::bytes_of(&uniforms));

        let mut encoder =
            self.shared
                .device
                .create_command_encoder(&wgpu::CommandEncoderDescriptor {
                    label: Some("sctb model renderer frame"),
                });
        {
            let mut pass = encoder.begin_render_pass(&wgpu::RenderPassDescriptor {
                label: Some("sctb model renderer pass"),
                color_attachments: &[Some(wgpu::RenderPassColorAttachment {
                    view: &self.msaa_target_view,
                    resolve_target: Some(&self.target_view),
                    depth_slice: None,
                    ops: wgpu::Operations {
                        load: wgpu::LoadOp::Clear(wgpu::Color {
                            r: self.bg[0] as f64 / 255.0,
                            g: self.bg[1] as f64 / 255.0,
                            b: self.bg[2] as f64 / 255.0,
                            a: self.bg[3] as f64 / 255.0,
                        }),
                        store: wgpu::StoreOp::Store,
                    },
                })],
                depth_stencil_attachment: Some(wgpu::RenderPassDepthStencilAttachment {
                    view: &self.depth_view,
                    depth_ops: Some(wgpu::Operations {
                        load: wgpu::LoadOp::Clear(1.0),
                        store: wgpu::StoreOp::Discard,
                    }),
                    stencil_ops: None,
                }),
                ..Default::default()
            });
            pass.set_pipeline(&self.shared.pipeline);
            for batch in &self.batches {
                pass.set_bind_group(0, &batch.bind_group, &[]);
                pass.set_vertex_buffer(0, batch.vertex_buffer.slice(..));
                pass.draw(0..batch.vertex_count, 0..1);
            }
            pass.set_pipeline(&self.shared.edge_pipeline);
            for batch in &self.edge_batches {
                pass.set_bind_group(0, &batch.bind_group, &[]);
                pass.set_vertex_buffer(0, batch.vertex_buffer.slice(..));
                pass.draw(0..batch.vertex_count, 0..1);
            }
        }

        let padded_bytes_per_row = align_to(
            self.width as usize * 4,
            wgpu::COPY_BYTES_PER_ROW_ALIGNMENT as usize,
        );
        let output_buffer_size = (padded_bytes_per_row * self.height as usize) as u64;
        let output_buffer = self.shared.device.create_buffer(&wgpu::BufferDescriptor {
            label: Some("sctb model renderer readback"),
            size: output_buffer_size,
            usage: wgpu::BufferUsages::COPY_DST | wgpu::BufferUsages::MAP_READ,
            mapped_at_creation: false,
        });
        encoder.copy_texture_to_buffer(
            self.target.as_image_copy(),
            wgpu::TexelCopyBufferInfo {
                buffer: &output_buffer,
                layout: wgpu::TexelCopyBufferLayout {
                    offset: 0,
                    bytes_per_row: Some(padded_bytes_per_row as u32),
                    rows_per_image: None,
                },
            },
            wgpu::Extent3d {
                width: self.width,
                height: self.height,
                depth_or_array_layers: 1,
            },
        );
        self.shared.queue.submit(std::iter::once(encoder.finish()));

        let slice = output_buffer.slice(..);
        let (sender, receiver) = futures::channel::oneshot::channel();
        slice.map_async(wgpu::MapMode::Read, move |result| {
            let _ = sender.send(result);
        });
        self.shared
            .device
            .poll(wgpu::PollType::Wait)
            .map_err(|e| anyhow!("wgpu renderer: poll failed: {e:?}"))?;
        futures::executor::block_on(receiver)
            .map_err(|_| anyhow!("wgpu renderer: readback channel closed"))?
            .map_err(|e| anyhow!("wgpu renderer: map readback failed: {e:?}"))?;
        let mapped = slice.get_mapped_range();
        let mut rgba = Vec::with_capacity((self.width * self.height * 4) as usize);
        for row in mapped
            .chunks(padded_bytes_per_row)
            .take(self.height as usize)
        {
            rgba.extend_from_slice(&row[..self.width as usize * 4]);
        }
        drop(mapped);
        output_buffer.unmap();
        Ok(rgba)
    }
}

fn create_wgpu_batches(
    device: &wgpu::Device,
    triangles: &[ParsedModelTriangle],
    texture_bind_groups: &[wgpu::BindGroup],
) -> Result<Vec<WgpuBatch>> {
    if triangles.is_empty() {
        return Err(anyhow!("wgpu renderer: no triangles"));
    }

    let mut batches = Vec::new();
    let mut vertices = Vec::with_capacity(WGPU_BATCH_TRIANGLES * 3);
    let mut batch_index = 0usize;
    let mut current_texture = usize::MAX;

    for triangle in triangles {
        let texture = triangle
            .texture_index
            .map(|index| index + 1)
            .filter(|index| *index < texture_bind_groups.len())
            .unwrap_or(0);
        if !vertices.is_empty()
            && (texture != current_texture || vertices.len() / 3 >= WGPU_BATCH_TRIANGLES)
        {
            push_wgpu_batch(
                device,
                texture_bind_groups,
                &mut batches,
                &mut vertices,
                current_texture,
                batch_index,
            )?;
            batch_index += 1;
        }
        current_texture = texture;
        for vertex in triangle.vertices {
            vertices.push(WgpuVertex {
                position: vertex.position.to_array(),
                normal: vertex.normal.normalize_or_zero().to_array(),
                color: triangle.color.to_array(),
                uv: vertex.uv.to_array(),
                alpha: triangle.alpha,
                alpha_cutoff: triangle.alpha_cutoff,
                texture_strength: triangle.texture_strength,
            });
        }
    }
    if !vertices.is_empty() {
        push_wgpu_batch(
            device,
            texture_bind_groups,
            &mut batches,
            &mut vertices,
            current_texture,
            batch_index,
        )?;
    }
    Ok(batches)
}

fn create_wgpu_edge_batches(
    device: &wgpu::Device,
    triangles: &[ParsedModelTriangle],
    texture_bind_groups: &[wgpu::BindGroup],
) -> Result<Vec<WgpuBatch>> {
    let mut edge_uses: HashMap<EdgeKey, Vec<EdgeUse>> = HashMap::new();
    for triangle in triangles {
        let points = [
            triangle.vertices[0].position,
            triangle.vertices[1].position,
            triangle.vertices[2].position,
        ];
        let face_normal = (points[1] - points[0])
            .cross(points[2] - points[0])
            .normalize_or_zero();
        for (a, b) in [(0, 1), (1, 2), (2, 0)] {
            edge_uses
                .entry(edge_key(points[a], points[b]))
                .or_default()
                .push(EdgeUse {
                    a: points[a],
                    b: points[b],
                    normal: face_normal,
                });
        }
    }

    let mut edges = edge_uses
        .into_values()
        .filter_map(|uses| {
            let first = uses.first()?;
            let keep = uses.len() == 1
                || uses
                    .iter()
                    .skip(1)
                    .any(|edge| first.normal.dot(edge.normal) < 0.72);
            keep.then_some((first.a, first.b))
        })
        .collect::<Vec<_>>();
    edges.sort_by(|(a0, b0), (a1, b1)| {
        let l0 = (*b0 - *a0).length_squared();
        let l1 = (*b1 - *a1).length_squared();
        l1.partial_cmp(&l0).unwrap_or(std::cmp::Ordering::Equal)
    });
    edges.truncate(WGPU_MAX_EDGE_VERTICES / 2);

    let mut batches = Vec::new();
    let mut vertices = Vec::with_capacity(WGPU_EDGE_BATCH_VERTICES.min(edges.len() * 2));
    let mut batch_index = 0usize;
    for (a, b) in edges {
        if vertices.len() + 2 > WGPU_EDGE_BATCH_VERTICES {
            push_wgpu_edge_batch(
                device,
                texture_bind_groups,
                &mut batches,
                &mut vertices,
                batch_index,
            )?;
            batch_index += 1;
        }
        let normal = (b - a).normalize_or_zero();
        for point in [a, b] {
            vertices.push(WgpuVertex {
                position: point.to_array(),
                normal: normal.to_array(),
                color: [0.0, 0.0, 0.0],
                uv: [0.0, 0.0],
                alpha: 1.0,
                alpha_cutoff: 0.0,
                texture_strength: -1.0,
            });
        }
    }
    if !vertices.is_empty() {
        push_wgpu_edge_batch(
            device,
            texture_bind_groups,
            &mut batches,
            &mut vertices,
            batch_index,
        )?;
    }
    Ok(batches)
}

fn edge_key(a: Vec3, b: Vec3) -> EdgeKey {
    let a = vec3_bits(a);
    let b = vec3_bits(b);
    if a <= b {
        EdgeKey { a, b }
    } else {
        EdgeKey { a: b, b: a }
    }
}

fn vec3_bits(value: Vec3) -> [u32; 3] {
    [
        normalized_zero_bits(value.x),
        normalized_zero_bits(value.y),
        normalized_zero_bits(value.z),
    ]
}

fn normalized_zero_bits(value: f32) -> u32 {
    if value == 0.0 {
        0.0f32.to_bits()
    } else {
        value.to_bits()
    }
}

fn push_wgpu_batch(
    device: &wgpu::Device,
    texture_bind_groups: &[wgpu::BindGroup],
    batches: &mut Vec<WgpuBatch>,
    vertices: &mut Vec<WgpuVertex>,
    texture: usize,
    batch_index: usize,
) -> Result<()> {
    let vertex_buffer = device.create_buffer_init(&wgpu::util::BufferInitDescriptor {
        label: Some(&format!("sctb model renderer vertices {batch_index}")),
        contents: bytemuck::cast_slice(vertices),
        usage: wgpu::BufferUsages::VERTEX,
    });
    let bind_group = texture_bind_groups
        .get(texture)
        .ok_or_else(|| anyhow!("wgpu renderer: invalid texture bind group {texture}"))?
        .clone();
    batches.push(WgpuBatch {
        vertex_buffer,
        vertex_count: vertices.len() as u32,
        bind_group,
    });
    vertices.clear();
    Ok(())
}

fn push_wgpu_edge_batch(
    device: &wgpu::Device,
    texture_bind_groups: &[wgpu::BindGroup],
    batches: &mut Vec<WgpuBatch>,
    vertices: &mut Vec<WgpuVertex>,
    batch_index: usize,
) -> Result<()> {
    let vertex_buffer = device.create_buffer_init(&wgpu::util::BufferInitDescriptor {
        label: Some(&format!("sctb model renderer edge vertices {batch_index}")),
        contents: bytemuck::cast_slice(vertices),
        usage: wgpu::BufferUsages::VERTEX,
    });
    let bind_group = texture_bind_groups
        .first()
        .ok_or_else(|| anyhow!("wgpu renderer: missing edge bind group"))?
        .clone();
    batches.push(WgpuBatch {
        vertex_buffer,
        vertex_count: vertices.len() as u32,
        bind_group,
    });
    vertices.clear();
    Ok(())
}

fn create_wgpu_texture_bind_groups(
    device: &wgpu::Device,
    queue: &wgpu::Queue,
    layout: &wgpu::BindGroupLayout,
    uniform_buffer: &wgpu::Buffer,
    parsed_textures: &[ParsedTexture],
) -> Result<Vec<wgpu::BindGroup>> {
    let sampler = device.create_sampler(&wgpu::SamplerDescriptor {
        label: Some("sctb model renderer texture sampler"),
        address_mode_u: wgpu::AddressMode::Repeat,
        address_mode_v: wgpu::AddressMode::Repeat,
        address_mode_w: wgpu::AddressMode::Repeat,
        mag_filter: wgpu::FilterMode::Linear,
        min_filter: wgpu::FilterMode::Linear,
        mipmap_filter: wgpu::FilterMode::Nearest,
        ..Default::default()
    });

    let mut bind_groups = Vec::with_capacity(parsed_textures.len() + 1);
    let fallback = ParsedTexture {
        width: 1,
        height: 1,
        rgba: vec![255, 255, 255, 255],
    };
    for (index, texture) in std::iter::once(&fallback)
        .chain(parsed_textures.iter())
        .enumerate()
    {
        let texture = create_wgpu_texture(device, queue, texture, index)?;
        let view = texture.create_view(&wgpu::TextureViewDescriptor::default());
        bind_groups.push(device.create_bind_group(&wgpu::BindGroupDescriptor {
            label: Some(&format!("sctb model renderer texture bind group {index}")),
            layout,
            entries: &[
                wgpu::BindGroupEntry {
                    binding: 0,
                    resource: uniform_buffer.as_entire_binding(),
                },
                wgpu::BindGroupEntry {
                    binding: 1,
                    resource: wgpu::BindingResource::TextureView(&view),
                },
                wgpu::BindGroupEntry {
                    binding: 2,
                    resource: wgpu::BindingResource::Sampler(&sampler),
                },
            ],
        }));
    }
    Ok(bind_groups)
}

fn create_wgpu_texture(
    device: &wgpu::Device,
    queue: &wgpu::Queue,
    parsed: &ParsedTexture,
    index: usize,
) -> Result<wgpu::Texture> {
    if parsed.width == 0 || parsed.height == 0 || parsed.rgba.len() < 4 {
        return Err(anyhow!("wgpu renderer: invalid texture {index}"));
    }
    let texture = device.create_texture(&wgpu::TextureDescriptor {
        label: Some(&format!("sctb model renderer texture {index}")),
        size: wgpu::Extent3d {
            width: parsed.width,
            height: parsed.height,
            depth_or_array_layers: 1,
        },
        mip_level_count: 1,
        sample_count: 1,
        dimension: wgpu::TextureDimension::D2,
        format: wgpu::TextureFormat::Rgba8UnormSrgb,
        usage: wgpu::TextureUsages::TEXTURE_BINDING | wgpu::TextureUsages::COPY_DST,
        view_formats: &[],
    });
    queue.write_texture(
        texture.as_image_copy(),
        &parsed.rgba,
        wgpu::TexelCopyBufferLayout {
            offset: 0,
            bytes_per_row: Some(parsed.width * 4),
            rows_per_image: Some(parsed.height),
        },
        wgpu::Extent3d {
            width: parsed.width,
            height: parsed.height,
            depth_or_array_layers: 1,
        },
    );
    Ok(texture)
}

fn create_wgpu_target(
    device: &wgpu::Device,
    width: u32,
    height: u32,
    sample_count: u32,
) -> wgpu::Texture {
    device.create_texture(&wgpu::TextureDescriptor {
        label: Some("sctb model renderer target"),
        size: wgpu::Extent3d {
            width,
            height,
            depth_or_array_layers: 1,
        },
        mip_level_count: 1,
        sample_count,
        dimension: wgpu::TextureDimension::D2,
        format: wgpu::TextureFormat::Rgba8Unorm,
        usage: if sample_count == 1 {
            wgpu::TextureUsages::RENDER_ATTACHMENT | wgpu::TextureUsages::COPY_SRC
        } else {
            wgpu::TextureUsages::RENDER_ATTACHMENT
        },
        view_formats: &[],
    })
}

fn create_wgpu_depth(
    device: &wgpu::Device,
    width: u32,
    height: u32,
    sample_count: u32,
) -> wgpu::Texture {
    device.create_texture(&wgpu::TextureDescriptor {
        label: Some("sctb model renderer depth"),
        size: wgpu::Extent3d {
            width,
            height,
            depth_or_array_layers: 1,
        },
        mip_level_count: 1,
        sample_count,
        dimension: wgpu::TextureDimension::D2,
        format: wgpu::TextureFormat::Depth32Float,
        usage: wgpu::TextureUsages::RENDER_ATTACHMENT,
        view_formats: &[],
    })
}

fn align_to(value: usize, alignment: usize) -> usize {
    value.div_ceil(alignment) * alignment
}

pub fn create_session(
    glb_data: &[u8],
    width: u32,
    height: u32,
    bg_color: Option<[f32; 4]>,
) -> Result<(String, f32)> {
    let session_id = Uuid::new_v4().to_string();
    create_session_with_id(session_id, glb_data, width, height, bg_color)
}

pub fn create_session_with_id(
    session_id: String,
    glb_data: &[u8],
    width: u32,
    height: u32,
    bg_color: Option<[f32; 4]>,
) -> Result<(String, f32)> {
    let session = RenderSession::new(width, height, glb_data, bg_color)?;
    let model_radius = session.model_radius;
    let mut sessions = SESSIONS.lock();
    sessions.insert(session_id.clone(), Arc::new(Mutex::new(session)));
    Ok((session_id, model_radius))
}

pub fn create_session_from_model_scene(
    scene: &SceneData,
    textures: &[ConvertTexture],
    materials: &[GltfMaterialData],
    materials_by_id: &HashMap<i32, usize>,
    width: u32,
    height: u32,
    bg_color: Option<[f32; 4]>,
) -> Result<(String, f32)> {
    let session_id = Uuid::new_v4().to_string();
    create_session_from_model_scene_with_id(
        session_id,
        scene,
        textures,
        materials,
        materials_by_id,
        width,
        height,
        bg_color,
    )
}

pub fn create_session_from_model_scene_with_id(
    session_id: String,
    scene: &SceneData,
    textures: &[ConvertTexture],
    materials: &[GltfMaterialData],
    materials_by_id: &HashMap<i32, usize>,
    width: u32,
    height: u32,
    bg_color: Option<[f32; 4]>,
) -> Result<(String, f32)> {
    let parsed = ParsedModelScene::from_converted(scene, textures, materials, materials_by_id)?;
    let (model_center, model_radius) = parsed_model_bounds(&parsed.triangles)?;
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
    let session = RenderSession {
        backend: RenderSessionBackend::Wgpu(WgpuModelSession::new(width, height, &parsed, bg)?),
        width,
        height,
        model_center,
        model_radius: model_radius.max(1.0),
    };
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

fn has_wgpu_sessions(sessions: &HashMap<String, Arc<Mutex<RenderSession>>>) -> bool {
    sessions
        .values()
        .any(|session| matches!(&session.lock().backend, RenderSessionBackend::Wgpu(_)))
}

fn release_session_inner(session_id: &str, release_shared_if_idle: bool) -> bool {
    // 先从 HashMap 中移除 Arc，阻止新的 render_session 获取引用
    // 已持有 Arc 克隆的渲染操作会继续完成，RenderSession 在最后一个 Arc 释放时 Drop
    let mut sessions = SESSIONS.lock();
    let removed = sessions.remove(session_id).is_some();
    if release_shared_if_idle && !has_wgpu_sessions(&sessions) {
        *WGPU_SHARED_CONTEXT.lock() = None;
    }
    removed
}

pub fn release_session(session_id: &str) -> bool {
    release_session_inner(session_id, true)
}

pub fn release_session_preserve_shared_context(session_id: &str) -> bool {
    release_session_inner(session_id, false)
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
        Ok(Err(err)) => Err(err),
        Err(panic) => Err(anyhow!("renderer panicked: {}", panic_message(panic))),
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
    let distance = session.model_radius * 2.75;
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

fn load_parsed_model_scene(glb_data: &[u8]) -> Result<ParsedModelScene> {
    let (json, bin) = parse_glb_chunks(glb_data)?;
    let nodes = json
        .get("nodes")
        .and_then(|v| v.as_array())
        .ok_or_else(|| anyhow!("model geometry: missing nodes"))?;
    let scenes = json
        .get("scenes")
        .and_then(|v| v.as_array())
        .ok_or_else(|| anyhow!("model geometry: missing scenes"))?;
    let scene_index = json.get("scene").and_then(|v| v.as_u64()).unwrap_or(0) as usize;
    let scene_nodes = scenes
        .get(scene_index)
        .and_then(|scene| scene.get("nodes"))
        .and_then(|v| v.as_array())
        .ok_or_else(|| anyhow!("model geometry: missing scene nodes"))?;

    let textures = load_parsed_textures(&json, &bin);
    let mut triangles = Vec::<ParsedModelTriangle>::new();
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
        return Err(anyhow!("model geometry: no triangles"));
    }
    triangles = filter_small_triangle_islands(triangles);
    Ok(ParsedModelScene {
        triangles,
        textures,
    })
}

fn parsed_model_bounds(triangles: &[ParsedModelTriangle]) -> Result<(Vec3, f32)> {
    let mut min = Vec3::splat(f32::INFINITY);
    let mut max = Vec3::splat(f32::NEG_INFINITY);
    for tri in triangles {
        for vertex in &tri.vertices {
            min = min.min(vertex.position);
            max = max.max(vertex.position);
        }
    }
    if min.x.is_infinite() {
        return Err(anyhow!("model geometry: invalid bounds"));
    }
    let center = (min + max) * 0.5;
    let radius = (max - min).length() * 0.5;
    Ok((center, radius))
}

fn filter_small_triangle_islands(triangles: Vec<ParsedModelTriangle>) -> Vec<ParsedModelTriangle> {
    if triangles.len() < 128 {
        return triangles;
    }
    let Ok((_, model_radius)) = parsed_model_bounds(&triangles) else {
        return triangles;
    };
    let mut parent = (0..triangles.len()).collect::<Vec<_>>();
    let mut rank = vec![0u8; triangles.len()];
    let mut first_by_vertex: HashMap<[u32; 3], usize> = HashMap::new();

    for (index, triangle) in triangles.iter().enumerate() {
        for vertex in &triangle.vertices {
            let key = vec3_bits(vertex.position);
            if let Some(other) = first_by_vertex.insert(key, index) {
                union_components(&mut parent, &mut rank, index, other);
            }
        }
    }

    let mut stats: HashMap<usize, (usize, Vec3, Vec3)> = HashMap::new();
    for (index, triangle) in triangles.iter().enumerate() {
        let root = find_component(&mut parent, index);
        let entry = stats.entry(root).or_insert((
            0,
            Vec3::splat(f32::INFINITY),
            Vec3::splat(f32::NEG_INFINITY),
        ));
        entry.0 += 1;
        for vertex in &triangle.vertices {
            entry.1 = entry.1.min(vertex.position);
            entry.2 = entry.2.max(vertex.position);
        }
    }

    let min_extent = (model_radius * 0.018).max(0.01);
    let min_triangles = 24usize;
    triangles
        .into_iter()
        .enumerate()
        .filter_map(|(index, triangle)| {
            let root = find_component(&mut parent, index);
            let (count, min, max) = stats.get(&root).copied()?;
            let extent = (max - min).length();
            ((count >= min_triangles && extent >= min_extent) || count >= 512).then_some(triangle)
        })
        .collect()
}

fn find_component(parent: &mut [usize], index: usize) -> usize {
    if parent[index] != index {
        parent[index] = find_component(parent, parent[index]);
    }
    parent[index]
}

fn union_components(parent: &mut [usize], rank: &mut [u8], a: usize, b: usize) {
    let mut root_a = find_component(parent, a);
    let mut root_b = find_component(parent, b);
    if root_a == root_b {
        return;
    }
    if rank[root_a] < rank[root_b] {
        std::mem::swap(&mut root_a, &mut root_b);
    }
    parent[root_b] = root_a;
    if rank[root_a] == rank[root_b] {
        rank[root_a] = rank[root_a].saturating_add(1);
    }
}

fn parse_glb_chunks(glb_data: &[u8]) -> Result<(serde_json::Value, &[u8])> {
    if glb_data.len() < 20 || glb_data.get(0..4) != Some(b"glTF") {
        return Err(anyhow!("model geometry: invalid GLB header"));
    }
    let total_len = read_u32_at(glb_data, 8)? as usize;
    if total_len != glb_data.len() {
        return Err(anyhow!("model geometry: invalid GLB length"));
    }

    let mut cursor = 12usize;
    let mut json = None;
    let mut bin = None;
    while cursor + 8 <= glb_data.len() {
        let chunk_len = read_u32_at(glb_data, cursor)? as usize;
        let chunk_type = read_u32_at(glb_data, cursor + 4)?;
        cursor += 8;
        let end = cursor
            .checked_add(chunk_len)
            .ok_or_else(|| anyhow!("model geometry: chunk overflow"))?;
        let chunk = glb_data
            .get(cursor..end)
            .ok_or_else(|| anyhow!("model geometry: truncated chunk"))?;
        cursor = end;
        match chunk_type {
            0x4E4F534A => {
                let text = String::from_utf8_lossy(chunk)
                    .trim_end_matches('\0')
                    .trim_end()
                    .to_string();
                json = Some(serde_json::from_str(&text)?);
            }
            0x004E4942 => bin = Some(chunk),
            _ => {}
        }
    }
    Ok((
        json.ok_or_else(|| anyhow!("model geometry: missing JSON"))?,
        bin.unwrap_or(&[]),
    ))
}

fn load_parsed_textures(json: &serde_json::Value, bin: &[u8]) -> Vec<ParsedTexture> {
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
                    ParsedTexture {
                        width: rgba.width(),
                        height: rgba.height(),
                        rgba: rgba.into_raw(),
                    }
                })
                .unwrap_or_else(|| ParsedTexture {
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
        .ok_or_else(|| anyhow!("model geometry: invalid bufferView {buffer_view_index}"))?;
    let offset = buffer_view
        .get("byteOffset")
        .and_then(|v| v.as_u64())
        .unwrap_or(0) as usize;
    let length = buffer_view
        .get("byteLength")
        .and_then(|v| v.as_u64())
        .ok_or_else(|| anyhow!("model geometry: bufferView without byteLength"))?
        as usize;
    bin.get(offset..offset + length)
        .ok_or_else(|| anyhow!("model geometry: bufferView out of bounds"))
}

fn collect_node_triangles(
    json: &serde_json::Value,
    bin: &[u8],
    nodes: &[serde_json::Value],
    node_index: usize,
    parent_transform: Mat4,
    out: &mut Vec<ParsedModelTriangle>,
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
    out: &mut Vec<ParsedModelTriangle>,
) -> Result<()> {
    let primitives = json
        .get("meshes")
        .and_then(|v| v.as_array())
        .and_then(|meshes| meshes.get(mesh_index))
        .and_then(|mesh| mesh.get("primitives"))
        .and_then(|v| v.as_array())
        .ok_or_else(|| anyhow!("model geometry: invalid mesh {mesh_index}"))?;
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
            .map(|material_index| parsed_material(json, material_index as usize))
            .unwrap_or(Some(ParsedMaterial {
                color: Vec3::new(0.62, 0.68, 0.72),
                alpha: 1.0,
                alpha_cutoff: 0.0,
                texture_strength: 0.0,
                texture_index: None,
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
                out.push(ParsedModelTriangle {
                    vertices: [
                        ParsedModelVertex {
                            position: transform.transform_point3(*a),
                            normal: transform.transform_vector3(na).normalize_or_zero(),
                            uv: ua,
                        },
                        ParsedModelVertex {
                            position: transform.transform_point3(*b),
                            normal: transform.transform_vector3(nb).normalize_or_zero(),
                            uv: ub,
                        },
                        ParsedModelVertex {
                            position: transform.transform_point3(*c),
                            normal: transform.transform_vector3(nc).normalize_or_zero(),
                            uv: uc,
                        },
                    ],
                    color: material.color,
                    alpha: material.alpha,
                    alpha_cutoff: material.alpha_cutoff,
                    texture_strength: material.texture_strength,
                    texture_index: material.texture_index,
                });
            }
        } else {
            for (face_index, face) in positions.chunks_exact(3).enumerate() {
                let face_normal = (face[1] - face[0])
                    .cross(face[2] - face[0])
                    .normalize_or_zero();
                let uv_base = face_index * 3;
                out.push(ParsedModelTriangle {
                    vertices: [
                        ParsedModelVertex {
                            position: transform.transform_point3(face[0]),
                            normal: transform.transform_vector3(face_normal).normalize_or_zero(),
                            uv: uvs
                                .as_ref()
                                .and_then(|values| values.get(uv_base))
                                .copied()
                                .unwrap_or(Vec2::ZERO),
                        },
                        ParsedModelVertex {
                            position: transform.transform_point3(face[1]),
                            normal: transform.transform_vector3(face_normal).normalize_or_zero(),
                            uv: uvs
                                .as_ref()
                                .and_then(|values| values.get(uv_base + 1))
                                .copied()
                                .unwrap_or(Vec2::ZERO),
                        },
                        ParsedModelVertex {
                            position: transform.transform_point3(face[2]),
                            normal: transform.transform_vector3(face_normal).normalize_or_zero(),
                            uv: uvs
                                .as_ref()
                                .and_then(|values| values.get(uv_base + 2))
                                .copied()
                                .unwrap_or(Vec2::ZERO),
                        },
                    ],
                    color: material.color,
                    alpha: material.alpha,
                    alpha_cutoff: material.alpha_cutoff,
                    texture_strength: material.texture_strength,
                    texture_index: material.texture_index,
                });
            }
        }
    }
    Ok(())
}

fn parsed_material(json: &serde_json::Value, material_index: usize) -> Option<ParsedMaterial> {
    let material = json
        .get("materials")
        .and_then(|v| v.as_array())
        .and_then(|materials| materials.get(material_index))?;
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
    let visible_alpha = |values: &[serde_json::Value]| {
        let alpha = read_factor_alpha(values, 1.0);
        alpha > 0.0
            && !(alpha_mode == "MASK" && alpha <= alpha_cutoff)
            && !(alpha_mode == "BLEND" && alpha < 0.75)
    };
    let material_alpha_cutoff = || {
        if alpha_mode == "MASK" {
            alpha_cutoff
        } else if alpha_mode == "BLEND" {
            0.05
        } else {
            0.0
        }
    };
    let texture_strength = preview_texture_strength(material);

    if let Some(values) = material
        .get("pbrMetallicRoughness")
        .and_then(|pbr| pbr.get("baseColorFactor"))
        .and_then(|v| v.as_array())
    {
        return visible_alpha(values).then(|| ParsedMaterial {
            color: read_factor_rgb(values, Vec3::new(0.62, 0.68, 0.72)),
            alpha: read_factor_alpha(values, 1.0),
            alpha_cutoff: material_alpha_cutoff(),
            texture_strength,
            texture_index: parsed_material_base_texture(json, material),
        });
    }
    if let Some(values) = material
        .get("extensions")
        .and_then(|ext| ext.get("KHR_materials_pbrSpecularGlossiness"))
        .and_then(|pbr| pbr.get("diffuseFactor"))
        .and_then(|v| v.as_array())
    {
        return visible_alpha(values).then(|| ParsedMaterial {
            color: read_factor_rgb(values, Vec3::new(0.62, 0.68, 0.72)),
            alpha: read_factor_alpha(values, 1.0),
            alpha_cutoff: material_alpha_cutoff(),
            texture_strength,
            texture_index: parsed_material_base_texture(json, material),
        });
    }
    if let Some(values) = material.get("emissiveFactor").and_then(|v| v.as_array()) {
        let emissive = read_factor_rgb(values, Vec3::ZERO);
        if emissive.length_squared() > 0.0 {
            return Some(ParsedMaterial {
                color: emissive,
                alpha: 1.0,
                alpha_cutoff: material_alpha_cutoff(),
                texture_strength,
                texture_index: parsed_material_base_texture(json, material),
            });
        }
    }

    Some(ParsedMaterial {
        color: Vec3::new(0.62, 0.68, 0.72),
        alpha: 1.0,
        alpha_cutoff: material_alpha_cutoff(),
        texture_strength,
        texture_index: parsed_material_base_texture(json, material),
    })
}

fn preview_texture_strength(material: &serde_json::Value) -> f32 {
    let name = material
        .get("name")
        .and_then(|v| v.as_str())
        .unwrap_or_default()
        .to_ascii_lowercase();
    preview_texture_strength_name(&name)
}

fn preview_texture_strength_name(name: &str) -> f32 {
    let name = name.to_ascii_lowercase();
    if name.contains("decal")
        || name.contains("sponsor")
        || name.contains("nameplate")
        || name.contains("rtt")
        || name.contains("glass")
        || name.contains("mirror")
        || name.contains("glow")
        || name.contains("damage")
    {
        return 0.0;
    }
    if name.starts_with("int_") || name.contains("_alpha") {
        return 0.04;
    }
    0.12
}

fn parsed_material_base_texture(
    json: &serde_json::Value,
    material: &serde_json::Value,
) -> Option<usize> {
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
        .and_then(|texture_index| parsed_texture_source(json, texture_index as usize))
}

fn parsed_texture_source(json: &serde_json::Value, texture_index: usize) -> Option<usize> {
    json.get("textures")
        .and_then(|v| v.as_array())
        .and_then(|textures| textures.get(texture_index))
        .and_then(|texture| texture.get("source"))
        .and_then(|v| v.as_u64())
        .map(|v| v as usize)
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

fn read_vec3_accessor(
    json: &serde_json::Value,
    bin: &[u8],
    accessor_index: usize,
) -> Result<Vec<Vec3>> {
    let (offset, stride, count, component_type, accessor_type) =
        accessor_layout(json, accessor_index, 12)?;
    if component_type != 5126 || accessor_type != "VEC3" {
        return Err(anyhow!("model geometry: unsupported POSITION accessor"));
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
        return Err(anyhow!("model geometry: unsupported TEXCOORD_0 accessor"));
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
        return Err(anyhow!("model geometry: unsupported index accessor type"));
    }
    let mut out = Vec::with_capacity(count);
    for i in 0..count {
        let base = offset + i * stride;
        let value = match component_type {
            5121 => *bin
                .get(base)
                .ok_or_else(|| anyhow!("model geometry: index out of bounds"))?
                as u32,
            5123 => read_u16_at(bin, base)? as u32,
            5125 => read_u32_at(bin, base)?,
            _ => return Err(anyhow!("model geometry: unsupported index component type")),
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
        .ok_or_else(|| anyhow!("model geometry: invalid accessor {accessor_index}"))?;
    let buffer_view_index = accessor
        .get("bufferView")
        .and_then(|v| v.as_u64())
        .ok_or_else(|| anyhow!("model geometry: accessor without bufferView"))?
        as usize;
    let buffer_view = json
        .get("bufferViews")
        .and_then(|v| v.as_array())
        .and_then(|views| views.get(buffer_view_index))
        .ok_or_else(|| anyhow!("model geometry: invalid bufferView {buffer_view_index}"))?;
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
        .ok_or_else(|| anyhow!("model geometry: unexpected EOF"))?
        .try_into()
        .map_err(|_| anyhow!("model geometry: unexpected EOF"))?;
    Ok(u16::from_le_bytes(bytes))
}

fn read_u32_at(data: &[u8], offset: usize) -> Result<u32> {
    let bytes: [u8; 4] = data
        .get(offset..offset + 4)
        .ok_or_else(|| anyhow!("model geometry: unexpected EOF"))?
        .try_into()
        .map_err(|_| anyhow!("model geometry: unexpected EOF"))?;
    Ok(u32::from_le_bytes(bytes))
}

fn read_f32_at(data: &[u8], offset: usize) -> Result<f32> {
    Ok(f32::from_bits(read_u32_at(data, offset)?))
}
