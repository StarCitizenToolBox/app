use thiserror::Error;

#[derive(Debug, Clone)]
pub struct ScenePrimitive {
    pub first_index: u32,
    pub num_indices: u32,
    pub first_vertex: u32,
    pub num_vertices: u32,
    pub material_id: i32,
}

#[derive(Debug, Clone)]
pub struct SceneMesh {
    pub positions: Vec<[f32; 3]>,
    pub normals: Vec<[f32; 3]>,
    pub uvs: Vec<[f32; 2]>,
    pub joints: Option<Vec<[u16; 4]>>,
    pub weights: Option<Vec<[f32; 4]>>,
    pub indices: Vec<u32>,
    pub index_accessor_source: Option<Vec<u32>>,
    pub primitives: Vec<ScenePrimitive>,
    pub name: Option<String>,
    pub node_name: Option<String>,
    pub node_translation: Option<[f32; 3]>,
    pub node_rotation: Option<[f32; 4]>,
    pub node_scale: Option<[f32; 3]>,
    pub node_matrix: Option<[f32; 16]>,
}

#[derive(Debug, Clone)]
pub struct SceneNode {
    pub name: String,
    pub parent: Option<String>,
    pub translation: Option<[f32; 3]>,
    pub rotation: Option<[f32; 4]>,
    pub scale: Option<[f32; 3]>,
    pub matrix: Option<[f32; 16]>,
}

#[derive(Debug, Clone)]
pub struct SceneData {
    pub nodes: Vec<SceneNode>,
    pub meshes: Vec<SceneMesh>,
    pub warnings: Vec<String>,
}

#[derive(Debug, Clone, Default)]
pub struct MaterialData {
    pub name: Option<String>,
    pub diffuse: Option<[f32; 3]>,
    pub specular: Option<[f32; 3]>,
    pub emissive_color: Option<[f32; 3]>,
    pub glow_amount: Option<f32>,
    pub opacity: Option<f32>,
    pub shininess: Option<f32>,
    pub alpha_test: Option<f32>,
    pub material_flags: Option<u32>,
    pub shader: Option<String>,
    pub string_gen_mask: Option<String>,
    pub no_draw: bool,
    pub base_color: Option<String>,
    pub base_color_candidates: Vec<String>,
    pub normal: Option<String>,
    pub normal_candidates: Vec<String>,
    pub specular_texture: Option<String>,
    pub specular_texture_candidates: Vec<String>,
    pub occlusion: Option<String>,
    pub occlusion_candidates: Vec<String>,
    pub emissive: Option<String>,
    pub emissive_candidates: Vec<String>,
    pub opacity_texture: Option<String>,
    pub opacity_texture_candidates: Vec<String>,
    pub sub_materials: Vec<MaterialData>,
}

#[derive(Debug, Clone)]
pub struct DecodedTexture {
    pub name: String,
    pub uri: String,
    pub label: Option<String>,
    pub width: u32,
    pub height: u32,
    pub rgba8: Vec<u8>,
}

#[derive(Debug, Clone, Default)]
pub struct GltfMaterialData {
    pub name: Option<String>,
    pub base_color_factor: Option<[f32; 4]>,
    pub emissive_factor: Option<[f32; 3]>,
    pub specular_factor: Option<[f32; 3]>,
    pub glossiness_factor: Option<f32>,
    pub pbr_roughness_factor: Option<f32>,
    pub double_sided: Option<bool>,
    pub alpha_mode: Option<String>,
    pub alpha_cutoff: Option<f32>,
    pub emissive_strength: Option<f32>,
    pub no_draw: bool,
    pub base_color_texture: Option<usize>,
    pub diffuse_texture: Option<usize>,
    pub normal_texture: Option<usize>,
    pub emissive_texture: Option<usize>,
    pub occlusion_texture: Option<usize>,
    pub opacity_texture: Option<usize>,
    pub specular_glossiness_texture: Option<usize>,
}

#[derive(Debug, Clone)]
pub struct ConvertOptions {
    pub embed_textures: bool,
    pub overwrite: bool,
    pub max_texture_size: Option<u32>,
}

impl Default for ConvertOptions {
    fn default() -> Self {
        Self {
            embed_textures: true,
            overwrite: false,
            max_texture_size: Some(4096),
        }
    }
}

#[derive(Debug, Clone)]
pub struct ConvertOutput {
    pub output_path: String,
    pub warnings: Vec<String>,
    pub source_mode: String,
    pub fallback_reason: Option<String>,
}

#[derive(Debug, Clone)]
pub struct ConvertBytesOutput {
    pub glb_bytes: Vec<u8>,
    pub warnings: Vec<String>,
    pub source_mode: String,
    pub fallback_reason: Option<String>,
}

#[derive(Debug, Clone)]
pub struct BatchFileOutput {
    pub model_path: String,
    pub output_path: Option<String>,
    pub has_geometry: bool,
    pub error_code: Option<String>,
    pub error_message: Option<String>,
    pub warnings: Vec<String>,
    pub source_mode: String,
    pub fallback_reason: Option<String>,
}

#[derive(Debug, Clone, Default)]
pub struct BatchAssemblyStats {
    pub nodes: i32,
    pub geometry_nodes: i32,
    pub object_containers: i32,
    pub roots: i32,
}

#[derive(Debug, Clone)]
pub struct BatchConvertOutput {
    pub merged_output_path: String,
    pub assembly_manifest_path: String,
    pub assembly_report_path: String,
    pub success_count: i32,
    pub empty_count: i32,
    pub failed_count: i32,
    pub warnings: Vec<String>,
    pub files: Vec<BatchFileOutput>,
    pub source_mode: String,
    pub assembly_graph_stats: BatchAssemblyStats,
    pub fallback_reason_by_file: Vec<String>,
}

#[derive(Error, Debug)]
pub enum ModelConvertError {
    #[error("Unsupported file format")]
    UnsupportedFormat,
    #[error("Binary model not supported: {0}")]
    ParserBinaryNotSupported(String),
    #[error("Model parse failed: {0}")]
    ModelParseFailed(String),
    #[error("Texture decode failed: {0}")]
    TextureDecodeFailed(String),
    #[error("Texture is too large")]
    TextureTooLarge,
    #[error("Output already exists")]
    OutputExists,
    #[error("I/O failed: {0}")]
    Io(String),
}

impl ModelConvertError {
    pub fn code(&self) -> &'static str {
        match self {
            Self::UnsupportedFormat => "ERR_UNSUPPORTED_FORMAT",
            Self::ParserBinaryNotSupported(_) => "ERR_PARSER_BINARY_NOT_SUPPORTED",
            Self::ModelParseFailed(_) => "ERR_MODEL_PARSE_FAILED",
            Self::TextureDecodeFailed(_) => "ERR_TEX_DECODE_FAILED",
            Self::TextureTooLarge => "ERR_TEX_TOO_LARGE",
            Self::OutputExists => "ERR_OUTPUT_EXISTS",
            Self::Io(_) => "ERR_IO",
        }
    }
}
