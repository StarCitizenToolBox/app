use std::collections::HashMap;
use std::fs;
use std::io::Cursor;
use std::fmt::Write as _;
use std::path::Path;

use anyhow::{anyhow, Result};
use image::codecs::png::PngEncoder;
use image::{ColorType, ImageEncoder};
use serde_json::{json, Map, Value};

use super::{DecodedTexture, GltfMaterialData, SceneData, SceneMesh, ScenePrimitive};

#[derive(Clone, Copy, Debug)]
struct ValidationConfig {
    verify_indices: bool,
}

impl ValidationConfig {
    fn from_env() -> Self {
        let verify_indices = std::env::var("SCTOOLBOX_GLB_VALIDATE_INDICES")
            .map(|value| parse_truthy_flag(&value))
            .unwrap_or(false);
        Self { verify_indices }
    }

    #[cfg(test)]
    fn test_mode(verify_indices: bool) -> Self {
        Self { verify_indices }
    }
}

fn parse_truthy_flag(value: &str) -> bool {
    matches!(
        value.trim().to_ascii_lowercase().as_str(),
        "1" | "true" | "yes" | "on"
    )
}

pub fn write_glb(
    scene: &SceneData,
    textures: &[DecodedTexture],
    materials: &[GltfMaterialData],
    materials_by_id: &HashMap<i32, usize>,
    output: &Path,
) -> Result<()> {
    write_glb_with_config(
        scene,
        textures,
        materials,
        materials_by_id,
        output,
        ValidationConfig::from_env(),
    )
}

fn write_glb_with_config(
    scene: &SceneData,
    textures: &[DecodedTexture],
    materials: &[GltfMaterialData],
    materials_by_id: &HashMap<i32, usize>,
    output: &Path,
    config: ValidationConfig,
) -> Result<()> {
    if scene.meshes.is_empty() {
        return Err(anyhow!("empty scene"));
    }
    if let Some(parent) = output.parent() {
        fs::create_dir_all(parent)?;
    }

    if config.verify_indices {
        for mesh in &scene.meshes {
            validate_index_bounds(mesh)?;
        }
    }

    let mut bin = Vec::<u8>::new();
    let mut buffer_views = Vec::<Value>::new();
    let mut accessors = Vec::<Value>::new();
    let mut mesh_entries = Vec::<Value>::new();
    let mut node_entries = Vec::<Value>::new();

    for mesh in &scene.meshes {
        let base_name = mesh.node_name.as_deref().or(mesh.name.as_deref()).unwrap_or("mesh");
        let pos_accessor = push_vec3_accessor(
            base_name,
            "vertex",
            &mut bin,
            &mut buffer_views,
            &mut accessors,
            &mesh.positions,
        );

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

        let uses_uv = primitives.iter().any(|primitive| {
            materials_by_id
                .get(&primitive.material_id)
                .and_then(|material_index| materials.get(*material_index))
                .map(material_uses_uv)
                .unwrap_or(false)
        });

        let uv_accessor = if uses_uv && !mesh.uvs.is_empty() {
            Some(push_vec2_accessor(
                base_name,
                "uv",
                &mut bin,
                &mut buffer_views,
                &mut accessors,
                &mesh.uvs,
            ))
        } else {
            None
        };

        let normal_accessor = push_vec3_accessor(
            base_name,
            "normal",
            &mut bin,
            &mut buffer_views,
            &mut accessors,
            &mesh.normals,
        );
        let indices_view = push_u32_view(
            base_name,
            "index",
            &mut bin,
            &mut buffer_views,
            &mesh.indices,
            Some(34963),
        );

        let mut primitive_entries = Vec::<Value>::new();
        for primitive in primitives {
            let first = primitive.first_index as usize;
            let count = primitive.num_indices as usize;
            let end = first.saturating_add(count);
            if count == 0 || end > mesh.indices.len() {
                continue;
            }
            let index_source = mesh
                .index_accessor_source
                .as_deref()
                .unwrap_or(&mesh.indices);
            let (index_min, index_max) = scalar_min_max(&index_source[first..end]);

            let index_accessor = push_index_accessor_from_view(
                base_name,
                &mut accessors,
                indices_view,
                first * 4,
                count,
                first,
                end,
                index_min,
                index_max,
            );

            let material_index = materials_by_id
                .get(&primitive.material_id)
                .copied()
                .unwrap_or(0);

            let mut attributes = Map::<String, Value>::new();
            attributes.insert("POSITION".to_string(), Value::from(pos_accessor as u64));
            attributes.insert("NORMAL".to_string(), Value::from(normal_accessor as u64));
            if let Some(uv_accessor) = uv_accessor {
                let material_index = materials_by_id
                    .get(&primitive.material_id)
                    .copied()
                    .unwrap_or(0);
                if materials
                    .get(material_index)
                    .map(material_uses_uv)
                    .unwrap_or(false)
                {
                    attributes.insert("TEXCOORD_0".to_string(), Value::from(uv_accessor as u64));
                }
            }

            primitive_entries.push(json!({
                "attributes": Value::Object(attributes),
                "indices": index_accessor,
                "material": material_index
            }));
        }

        if primitive_entries.is_empty() {
            return Err(anyhow!("mesh has no valid primitive ranges"));
        }

        let mesh_index = mesh_entries.len();
        mesh_entries.push(json!({
            "name": mesh.name.clone().unwrap_or_else(|| format!("mesh_{mesh_index}")),
            "primitives": primitive_entries
        }));
        let mut node = Map::<String, Value>::new();
        if let Some(name) = mesh.node_name.as_ref().or(mesh.name.as_ref()) {
            node.insert("name".to_string(), Value::from(name.clone()));
        }
        node.insert("mesh".to_string(), Value::from(mesh_index as u64));
        if let (Some(rotation), Some(scale), Some(translation)) =
            (mesh.node_rotation, mesh.node_scale, mesh.node_translation)
        {
            node.insert("rotation".to_string(), json!(rotation));
            node.insert("scale".to_string(), json!(scale));
            node.insert("translation".to_string(), json!(translation));
        } else if let Some(matrix) = mesh.node_matrix {
            node.insert("matrix".to_string(), json!(matrix));
        }
        node_entries.push(Value::Object(node));
    }

    let mut images = Vec::<Value>::new();
    let mut tex_entries = Vec::<Value>::new();
    for tex in textures {
        images.push(json!({
            "name": format!("{}/image", tex.label.as_deref().unwrap_or(&tex.name)),
            "uri": tex.uri,
            "mimeType": "image/vnd-ms.dds"
        }));
        tex_entries.push(json!({
            "name": format!("{}/texture", tex.label.as_deref().unwrap_or(&tex.name)),
            "source": images.len() - 1
        }));
    }

    let material_entries = build_material_entries(materials, tex_entries.len());

    let scene_node_ids = (0..node_entries.len()).collect::<Vec<_>>();
    let json_doc = json!({
        "asset": {"generator":"Cryengine Converter","version":"2.0"},
        "extensionsUsed": [
            "KHR_materials_specular",
            "KHR_materials_pbrSpecularGlossiness",
            "KHR_materials_emissive_strength"
        ],
        "scene": 0,
        "scenes": [{"name":"Scene","nodes": scene_node_ids}],
        "nodes": node_entries,
        "materials": material_entries,
        "meshes": mesh_entries,
        "textures": tex_entries,
        "images": images,
        "accessors": accessors,
        "bufferViews": buffer_views,
        "buffers": [{"byteLength": bin.len()}]
    });

    let mut json_bytes = serialize_json_like_csharp(&json_doc)?;
    align_4_with(&mut json_bytes, b' ');
    align_4(&mut bin);

    let total_len = 12 + 8 + json_bytes.len() + 8 + bin.len();
    let mut glb = Vec::<u8>::with_capacity(total_len);
    glb.extend_from_slice(b"glTF");
    glb.extend_from_slice(&2u32.to_le_bytes());
    glb.extend_from_slice(&(total_len as u32).to_le_bytes());

    glb.extend_from_slice(&(json_bytes.len() as u32).to_le_bytes());
    glb.extend_from_slice(&0x4E4F534Au32.to_le_bytes());
    glb.extend_from_slice(&json_bytes);

    glb.extend_from_slice(&(bin.len() as u32).to_le_bytes());
    glb.extend_from_slice(&0x004E4942u32.to_le_bytes());
    glb.extend_from_slice(&bin);

    fs::write(output, glb)?;
    Ok(())
}

fn build_material_entries(materials: &[GltfMaterialData], texture_count: usize) -> Vec<Value> {
    if materials.is_empty() {
        return vec![default_material()];
    }
    materials
        .iter()
        .enumerate()
        .map(|(index, mat)| build_material_entry(index, mat, texture_count))
        .collect()
}

fn default_material() -> Value {
    json!({
        "pbrMetallicRoughness": {
            "baseColorFactor": [1.0,1.0,1.0,1.0],
            "metallicFactor": 0.0,
            "roughnessFactor": 1.0
        }
    })
}

fn material_uses_uv(material: &GltfMaterialData) -> bool {
    material.base_color_texture.is_some()
        || material.diffuse_texture.is_some()
        || material.normal_texture.is_some()
        || material.specular_glossiness_texture.is_some()
}

fn build_material_entry(index: usize, material: &GltfMaterialData, texture_count: usize) -> Value {
    let mut pbr = Map::<String, Value>::new();
    let base_color = material.base_color_factor.unwrap_or([1.0, 1.0, 1.0, 1.0]);
    pbr.insert("baseColorFactor".to_string(), json!(base_color));
    if let Some(index) = valid_texture_index(material.base_color_texture, texture_count) {
        pbr.insert("baseColorTexture".to_string(), json!({ "index": index }));
    }
    pbr.insert("metallicFactor".to_string(), json!(0.0));
    let glossiness = material.glossiness_factor.unwrap_or(0.0).clamp(0.0, 1.0);
    let roughness = material
        .pbr_roughness_factor
        .unwrap_or_else(|| 1.0 - glossiness)
        .clamp(0.0, 1.0);
    pbr.insert("roughnessFactor".to_string(), json!(roughness));

    let mut out = Map::<String, Value>::new();
    out.insert(
        "name".to_string(),
        Value::from(material.name.clone().unwrap_or_else(|| format!("material{index}"))),
    );
    out.insert("pbrMetallicRoughness".to_string(), Value::Object(pbr));
    if let Some(index) = valid_texture_index(material.normal_texture, texture_count) {
        out.insert("normalTexture".to_string(), json!({ "index": index }));
    }
    if let Some(alpha_cutoff) = material.alpha_cutoff {
        out.insert("alphaCutoff".to_string(), json!(alpha_cutoff));
    }
    out.insert(
        "doubleSided".to_string(),
        json!(material.double_sided.unwrap_or(false)),
    );

    let mut extensions = Map::<String, Value>::new();
    let mut spec_gloss = Map::<String, Value>::new();
    spec_gloss.insert("diffuseFactor".to_string(), json!(base_color));
    if let Some(index) = valid_texture_index(material.diffuse_texture, texture_count) {
        spec_gloss.insert("diffuseTexture".to_string(), json!({ "index": index }));
    }
    spec_gloss.insert(
        "specularFactor".to_string(),
        json!(material.specular_factor.unwrap_or([1.0, 1.0, 1.0])),
    );
    spec_gloss.insert("glossinessFactor".to_string(), json!(glossiness));
    if let Some(index) = valid_texture_index(material.specular_glossiness_texture, texture_count) {
        spec_gloss.insert("specularGlossinessTexture".to_string(), json!({ "index": index }));
    }
    extensions.insert(
        "KHR_materials_pbrSpecularGlossiness".to_string(),
        Value::Object(spec_gloss),
    );
    if let Some(emissive_strength) = material.emissive_strength {
        if emissive_strength > 0.0 {
            extensions.insert(
                "KHR_materials_emissive_strength".to_string(),
                json!({ "emissiveStrength": emissive_strength }),
            );
        }
    }
    out.insert("extensions".to_string(), Value::Object(extensions));
    out.insert(
        "alphaMode".to_string(),
        json!(material.alpha_mode.as_deref().unwrap_or("OPAQUE")),
    );
    if material.no_draw {
        out.insert("alphaMode".to_string(), json!("MASK"));
        out.insert("alphaCutoff".to_string(), json!(1.0));
        if let Some(pbr) = out.get_mut("pbrMetallicRoughness").and_then(Value::as_object_mut) {
            pbr.insert("baseColorFactor".to_string(), json!([0.0, 0.0, 0.0, 0.0]));
        }
    }

    Value::Object(out)
}

fn valid_texture_index(index: Option<usize>, texture_count: usize) -> Option<usize> {
    index.filter(|idx| *idx < texture_count)
}

fn push_vec3_accessor(
    base_name: &str,
    channel: &str,
    bin: &mut Vec<u8>,
    buffer_views: &mut Vec<Value>,
    accessors: &mut Vec<Value>,
    values: &[[f32; 3]],
) -> usize {
    let transformed: Vec<[f32; 3]> = match channel {
        "vertex" | "normal" => values.iter().map(|v| swap_axes_for_position(*v)).collect(),
        _ => values.to_vec(),
    };
    let view = push_f32x3_view(base_name, channel, bin, buffer_views, &transformed);
    let (min, max) = vec3_min_max(&transformed);
    let accessor = accessors.len();
    accessors.push(json!({
        "name": format!("{base_name}/{channel}/accessor[0:{}]", values.len()),
        "bufferView": view,
        "byteOffset": 0,
        "componentType": 5126,
        "count": values.len(),
        "min": min,
        "max": max,
        "type": "VEC3"
    }));
    accessor
}

fn push_vec2_accessor(
    base_name: &str,
    channel: &str,
    bin: &mut Vec<u8>,
    buffer_views: &mut Vec<Value>,
    accessors: &mut Vec<Value>,
    values: &[[f32; 2]],
) -> usize {
    let view = push_f32x2_view(base_name, channel, bin, buffer_views, values);
    let (min, max) = vec2_min_max(values);
    let accessor = accessors.len();
    accessors.push(json!({
        "name": format!("{base_name}/{channel}/accessor[0:{}]", values.len()),
        "bufferView": view,
        "byteOffset": 0,
        "componentType": 5126,
        "count": values.len(),
        "min": min,
        "max": max,
        "type": "VEC2"
    }));
    accessor
}

fn push_indices_accessor(
    base_name: &str,
    bin: &mut Vec<u8>,
    buffer_views: &mut Vec<Value>,
    accessors: &mut Vec<Value>,
    values: &[u32],
) -> usize {
    let view = push_u32_view(base_name, "index", bin, buffer_views, values, Some(34963));
    let accessor = accessors.len();
    let (min, max) = scalar_min_max(values);
    accessors.push(json!({
        "name": format!("{base_name}/index/accessor[0:{}]", values.len()),
        "bufferView": view,
        "byteOffset": 0,
        "componentType": 5125,
        "count": values.len(),
        "min": [min],
        "max": [max],
        "type": "SCALAR"
    }));
    accessor
}

fn push_index_accessor_from_view(
    base_name: &str,
    accessors: &mut Vec<Value>,
    view: usize,
    byte_offset: usize,
    count: usize,
    start: usize,
    end: usize,
    min: u32,
    max: u32,
) -> usize {
    let accessor = accessors.len();
    accessors.push(json!({
        "name": format!("{base_name}/index/accessor[{start}:{end}]"),
        "bufferView": view,
        "byteOffset": byte_offset,
        "componentType": 5125,
        "count": count,
        "min": [min],
        "max": [max],
        "type": "SCALAR",
    }));
    accessor
}

fn push_u16x4_accessor(
    base_name: &str,
    channel: &str,
    bin: &mut Vec<u8>,
    buffer_views: &mut Vec<Value>,
    accessors: &mut Vec<Value>,
    values: &[[u16; 4]],
) -> usize {
    let view = push_u16x4_view(base_name, channel, bin, buffer_views, values);
    let (min, max) = u16x4_min_max(values);
    let accessor = accessors.len();
    accessors.push(json!({
        "name": format!("{base_name}/{channel}/accessor[0:{}]", values.len()),
        "bufferView": view,
        "byteOffset": 0,
        "componentType": 5123,
        "count": values.len(),
        "min": min,
        "max": max,
        "type": "VEC4"
    }));
    accessor
}

fn push_f32x4_accessor(
    base_name: &str,
    channel: &str,
    bin: &mut Vec<u8>,
    buffer_views: &mut Vec<Value>,
    accessors: &mut Vec<Value>,
    values: &[[f32; 4]],
) -> usize {
    let view = push_f32x4_view(base_name, channel, bin, buffer_views, values);
    let (min, max) = f32x4_min_max(values);
    let accessor = accessors.len();
    accessors.push(json!({
        "name": format!("{base_name}/{channel}/accessor[0:{}]", values.len()),
        "bufferView": view,
        "byteOffset": 0,
        "componentType": 5126,
        "count": values.len(),
        "min": min,
        "max": max,
        "type": "VEC4"
    }));
    accessor
}

fn push_f32x3_view(
    base_name: &str,
    channel: &str,
    bin: &mut Vec<u8>,
    buffer_views: &mut Vec<Value>,
    values: &[[f32; 3]],
) -> usize {
    align_4(bin);
    let offset = bin.len();
    for v in values {
        bin.extend_from_slice(&v[0].to_le_bytes());
        bin.extend_from_slice(&v[1].to_le_bytes());
        bin.extend_from_slice(&v[2].to_le_bytes());
    }
    let view_index = buffer_views.len();
    buffer_views.push(json!({
        "name": format!("{base_name}/{channel}/bufferView"),
        "buffer": 0,
        "byteLength": values.len() * 12,
        "byteOffset": offset,
        "target": 34962
    }));
    view_index
}

fn push_f32x2_view(
    base_name: &str,
    channel: &str,
    bin: &mut Vec<u8>,
    buffer_views: &mut Vec<Value>,
    values: &[[f32; 2]],
) -> usize {
    align_4(bin);
    let offset = bin.len();
    for v in values {
        bin.extend_from_slice(&v[0].to_le_bytes());
        bin.extend_from_slice(&v[1].to_le_bytes());
    }
    let view_index = buffer_views.len();
    buffer_views.push(json!({
        "name": format!("{base_name}/{channel}/bufferView"),
        "buffer": 0,
        "byteLength": values.len() * 8,
        "byteOffset": offset,
        "target": 34962
    }));
    view_index
}

fn push_u16x4_view(
    base_name: &str,
    channel: &str,
    bin: &mut Vec<u8>,
    buffer_views: &mut Vec<Value>,
    values: &[[u16; 4]],
) -> usize {
    align_4(bin);
    let offset = bin.len();
    for v in values {
        bin.extend_from_slice(&v[0].to_le_bytes());
        bin.extend_from_slice(&v[1].to_le_bytes());
        bin.extend_from_slice(&v[2].to_le_bytes());
        bin.extend_from_slice(&v[3].to_le_bytes());
    }
    let view_index = buffer_views.len();
    buffer_views.push(json!({
        "name": format!("{base_name}/{channel}/bufferView"),
        "buffer": 0,
        "byteLength": values.len() * 8,
        "byteOffset": offset,
        "target": 34962
    }));
    view_index
}

fn push_f32x4_view(
    base_name: &str,
    channel: &str,
    bin: &mut Vec<u8>,
    buffer_views: &mut Vec<Value>,
    values: &[[f32; 4]],
) -> usize {
    align_4(bin);
    let offset = bin.len();
    for v in values {
        bin.extend_from_slice(&v[0].to_le_bytes());
        bin.extend_from_slice(&v[1].to_le_bytes());
        bin.extend_from_slice(&v[2].to_le_bytes());
        bin.extend_from_slice(&v[3].to_le_bytes());
    }
    let view_index = buffer_views.len();
    buffer_views.push(json!({
        "name": format!("{base_name}/{channel}/bufferView"),
        "buffer": 0,
        "byteLength": values.len() * 16,
        "byteOffset": offset,
        "target": 34962
    }));
    view_index
}

fn push_u32_view(
    base_name: &str,
    channel: &str,
    bin: &mut Vec<u8>,
    buffer_views: &mut Vec<Value>,
    values: &[u32],
    target: Option<u32>,
) -> usize {
    align_4(bin);
    let offset = bin.len();
    for v in values {
        bin.extend_from_slice(&v.to_le_bytes());
    }

    let view_index = buffer_views.len();
    let mut view = json!({
        "name": format!("${base_name}/{channel}/bufferView"),
        "buffer": 0,
        "byteLength": values.len() * 4,
        "byteOffset": offset
    });
    if let Some(target) = target {
        view["target"] = json!(target);
    }
    buffer_views.push(view);
    view_index
}

fn validate_index_bounds(mesh: &SceneMesh) -> Result<()> {
    let vertex_count = mesh.positions.len();
    if vertex_count == 0 {
        return Err(anyhow!("mesh has no vertex positions"));
    }
    for (element, &index) in mesh.indices.iter().enumerate() {
        if (index as usize) >= vertex_count {
            return Err(anyhow!(
                "index {index} at element {element} references a vertex outside the {vertex_count}-vertex range",
            ));
        }
    }
    Ok(())
}

fn encode_png(tex: &DecodedTexture) -> Result<Vec<u8>> {
    let mut out = Cursor::new(Vec::<u8>::new());
    let encoder = PngEncoder::new(&mut out);
    encoder.write_image(&tex.rgba8, tex.width, tex.height, ColorType::Rgba8.into())?;
    Ok(out.into_inner())
}

fn align_4(buf: &mut Vec<u8>) {
    while buf.len() % 4 != 0 {
        buf.push(0);
    }
}

fn align_4_with(buf: &mut Vec<u8>, pad: u8) {
    while buf.len() % 4 != 0 {
        buf.push(pad);
    }
}

fn swap_axes_for_position(value: [f32; 3]) -> [f32; 3] {
    [-value[0], value[2], value[1]]
}

fn scalar_min_max(values: &[u32]) -> (u32, u32) {
    let mut min = u32::MAX;
    let mut max = u32::MIN;
    for &value in values {
        min = min.min(value);
        max = max.max(value);
    }
    (min, max)
}

fn vec2_min_max(values: &[[f32; 2]]) -> ([f32; 2], [f32; 2]) {
    let mut min = [f32::INFINITY; 2];
    let mut max = [f32::NEG_INFINITY; 2];
    for value in values {
        min[0] = min[0].min(value[0]);
        min[1] = min[1].min(value[1]);
        max[0] = max[0].max(value[0]);
        max[1] = max[1].max(value[1]);
    }
    (min, max)
}

fn vec3_min_max(values: &[[f32; 3]]) -> ([f32; 3], [f32; 3]) {
    let mut min = [f32::INFINITY; 3];
    let mut max = [f32::NEG_INFINITY; 3];
    for value in values {
        min[0] = min[0].min(value[0]);
        min[1] = min[1].min(value[1]);
        min[2] = min[2].min(value[2]);
        max[0] = max[0].max(value[0]);
        max[1] = max[1].max(value[1]);
        max[2] = max[2].max(value[2]);
    }
    (min, max)
}

fn u16x4_min_max(values: &[[u16; 4]]) -> ([u16; 4], [u16; 4]) {
    let mut min = [u16::MAX; 4];
    let mut max = [u16::MIN; 4];
    for value in values {
        min[0] = min[0].min(value[0]);
        min[1] = min[1].min(value[1]);
        min[2] = min[2].min(value[2]);
        min[3] = min[3].min(value[3]);
        max[0] = max[0].max(value[0]);
        max[1] = max[1].max(value[1]);
        max[2] = max[2].max(value[2]);
        max[3] = max[3].max(value[3]);
    }
    (min, max)
}

fn f32x4_min_max(values: &[[f32; 4]]) -> ([f32; 4], [f32; 4]) {
    let mut min = [f32::INFINITY; 4];
    let mut max = [f32::NEG_INFINITY; 4];
    for value in values {
        min[0] = min[0].min(value[0]);
        min[1] = min[1].min(value[1]);
        min[2] = min[2].min(value[2]);
        min[3] = min[3].min(value[3]);
        max[0] = max[0].max(value[0]);
        max[1] = max[1].max(value[1]);
        max[2] = max[2].max(value[2]);
        max[3] = max[3].max(value[3]);
    }
    (min, max)
}

fn round_json_floats(value: &mut Value, significant_digits: u32) {
    match value {
        Value::Array(items) => {
            for item in items {
                round_json_floats(item, significant_digits);
            }
        }
        Value::Object(map) => {
            for item in map.values_mut() {
                round_json_floats(item, significant_digits);
            }
        }
        Value::Number(number) => {
            if number.as_i64().is_some() || number.as_u64().is_some() {
                return;
            }
            if let Some(current) = number.as_f64() {
                if current.is_finite() {
                    let rounded = round_to_significant_digits(current, significant_digits);
                    if let Some(number) = serde_json::Number::from_f64(rounded) {
                        *value = Value::Number(number);
                    }
                }
            }
        }
        _ => {}
    }
}

fn round_to_significant_digits(value: f64, digits: u32) -> f64 {
    if value == 0.0 {
        return 0.0;
    }
    let abs = value.abs();
    let log10 = abs.log10().floor();
    let scale = 10f64.powf((digits as f64) - 1.0 - log10);
    let rounded = (value * scale).round() / scale;
    rounded
}

fn serialize_json_like_csharp(value: &Value) -> Result<Vec<u8>> {
    let mut out = String::new();
    write_json_value_like_csharp(value, &mut out)?;
    Ok(out.into_bytes())
}

fn write_json_value_like_csharp(value: &Value, out: &mut String) -> Result<()> {
    match value {
        Value::Null => out.push_str("null"),
        Value::Bool(value) => out.push_str(if *value { "true" } else { "false" }),
        Value::Number(number) => {
            if let Some(value) = number.as_i64() {
                write!(out, "{value}")?;
            } else if let Some(value) = number.as_u64() {
                write!(out, "{value}")?;
            } else {
                let value = number.as_f64().unwrap_or(0.0) as f32;
                let mut buffer = ryu::Buffer::new();
                out.push_str(buffer.format_finite(value));
            }
        }
        Value::String(value) => {
            out.push_str(&serde_json::to_string(value)?);
        }
        Value::Array(items) => {
            out.push('[');
            for (index, item) in items.iter().enumerate() {
                if index != 0 {
                    out.push(',');
                }
                write_json_value_like_csharp(item, out)?;
            }
            out.push(']');
        }
        Value::Object(map) => {
            out.push('{');
            for (index, (key, item)) in map.iter().enumerate() {
                if index != 0 {
                    out.push(',');
                }
                out.push_str(&serde_json::to_string(key)?);
                out.push(':');
                write_json_value_like_csharp(item, out)?;
            }
            out.push('}');
        }
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use std::collections::HashMap;
    use std::env;
    use std::fs;
    use std::path::PathBuf;
    use std::process;
    use std::time::{SystemTime, UNIX_EPOCH};

    use serde_json::Value;

    use super::{write_glb, write_glb_with_config, ValidationConfig};
    use crate::model_convert::{
        DecodedTexture, GltfMaterialData, SceneData, SceneMesh, ScenePrimitive,
    };

    fn sample_scene() -> SceneData {
        SceneData {
            meshes: vec![SceneMesh {
                positions: vec![[0.0, 0.0, 0.0], [1.0, 0.0, 0.0], [0.0, 1.0, 0.0]],
                normals: vec![[0.0, 0.0, 1.0], [0.0, 0.0, 1.0], [0.0, 0.0, 1.0]],
                uvs: vec![[0.0, 0.0], [1.0, 0.0], [0.0, 1.0]],
                joints: None,
                weights: None,
                indices: vec![0, 1, 2],
                index_accessor_source: None,
                primitives: vec![ScenePrimitive {
                    first_index: 0,
                    num_indices: 3,
                    first_vertex: 0,
                    num_vertices: 3,
                    material_id: -1,
                }],
                name: Some("triangle".to_string()),
                node_name: Some("triangle".to_string()),
                node_translation: Some([0.0, 0.0, 0.0]),
                node_rotation: Some([0.0, 0.0, 0.0, 1.0]),
                node_scale: Some([1.0, 1.0, 1.0]),
                node_matrix: None,
            }],
            warnings: vec![],
        }
    }

    fn temp_glb_path(suffix: &str) -> PathBuf {
        let now = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .expect("time went backwards")
            .as_nanos();
        env::temp_dir().join(format!("sctoolbox-{suffix}-{}-{now}.glb", process::id()))
    }

    fn read_u32_le(data: &[u8], offset: usize) -> u32 {
        let bytes: [u8; 4] = data[offset..offset + 4].try_into().expect("u32 slice");
        u32::from_le_bytes(bytes)
    }

    fn extract_json_chunk(glb: &[u8]) -> Value {
        assert!(glb.len() > 20);
        assert_eq!(&glb[0..4], b"glTF");
        assert_eq!(read_u32_le(glb, 4), 2);
        assert_eq!(read_u32_le(glb, 8) as usize, glb.len());

        let json_len = read_u32_le(glb, 12) as usize;
        let json_type = read_u32_le(glb, 16);
        assert_eq!(json_type, 0x4E4F534A);

        let json_bytes = &glb[20..20 + json_len];
        serde_json::from_slice(json_bytes).expect("valid gltf json")
    }

    #[test]
    fn write_glb_writes_valid_glb_without_textures() {
        let output = temp_glb_path("no-texture");
        let scene = sample_scene();
        let materials = vec![GltfMaterialData::default()];
        let mut by_id = HashMap::new();
        by_id.insert(-1, 0usize);
        write_glb(&scene, &[], &materials, &by_id, &output).expect("write glb");

        let glb = fs::read(&output).expect("read glb");
        let doc = extract_json_chunk(&glb);

        assert_eq!(doc["meshes"].as_array().map(|v| v.len()), Some(1));
        assert_eq!(
            doc["meshes"][0]["primitives"].as_array().map(|v| v.len()),
            Some(1)
        );
        assert_eq!(doc["images"].as_array().map(|v| v.len()), Some(0));
        assert_eq!(doc["textures"].as_array().map(|v| v.len()), Some(0));
        assert!(doc["materials"][0]["pbrMetallicRoughness"]["baseColorTexture"].is_null());

        let _ = fs::remove_file(output);
    }

    #[test]
    fn write_glb_embeds_texture_and_material_references_channels() {
        let output = temp_glb_path("with-texture");
        let scene = sample_scene();
        let texture = DecodedTexture {
            name: "ship_diff.png".to_string(),
            uri: "textures\\ship_diff.png".to_string(),
            label: Some("Ship-diffuse".to_string()),
            width: 1,
            height: 1,
            rgba8: vec![255, 0, 0, 255],
        };

        let material = GltfMaterialData {
            name: Some("material0".to_string()),
            base_color_factor: Some([1.0, 1.0, 1.0, 1.0]),
            specular_factor: Some([1.0, 1.0, 1.0]),
            glossiness_factor: Some(0.0),
            pbr_roughness_factor: Some(1.0),
            double_sided: Some(false),
            alpha_mode: Some("OPAQUE".to_string()),
            alpha_cutoff: None,
            emissive_strength: None,
            no_draw: false,
            base_color_texture: Some(0),
            diffuse_texture: Some(0),
            normal_texture: Some(0),
            specular_glossiness_texture: Some(0),
        };
        let mut by_id = HashMap::new();
        by_id.insert(-1, 0usize);

        write_glb(&scene, &[texture], &[material], &by_id, &output).expect("write glb");

        let glb = fs::read(&output).expect("read glb");
        let doc = extract_json_chunk(&glb);

        assert_eq!(doc["images"].as_array().map(|v| v.len()), Some(1));
        assert_eq!(doc["textures"].as_array().map(|v| v.len()), Some(1));
        assert_eq!(
            doc["materials"][0]["pbrMetallicRoughness"]["baseColorTexture"]["index"].as_u64(),
            Some(0)
        );
        assert_eq!(
            doc["materials"][0]["normalTexture"]["index"].as_u64(),
            Some(0)
        );
        assert_eq!(doc["materials"][0]["alphaMode"].as_str(), Some("OPAQUE"));

        let _ = fs::remove_file(output);
    }

    #[test]
    fn write_glb_supports_multiple_meshes_and_primitives() {
        let output = temp_glb_path("multi-mesh-prims");
        let mut scene = sample_scene();
        scene.meshes[0].primitives = vec![
            ScenePrimitive {
                first_index: 0,
                num_indices: 3,
                first_vertex: 0,
                num_vertices: 3,
                material_id: 0,
            },
            ScenePrimitive {
                first_index: 0,
                num_indices: 3,
                first_vertex: 0,
                num_vertices: 3,
                material_id: 1,
            },
        ];
        scene.meshes.push(scene.meshes[0].clone());

        let mut by_id = HashMap::new();
        by_id.insert(0, 0usize);
        by_id.insert(1, 1usize);
        let materials = vec![GltfMaterialData::default(), GltfMaterialData::default()];
        write_glb(&scene, &[], &materials, &by_id, &output).expect("write glb");

        let glb = fs::read(&output).expect("read glb");
        let doc = extract_json_chunk(&glb);

        assert_eq!(doc["meshes"].as_array().map(|v| v.len()), Some(2));
        assert_eq!(
            doc["meshes"][0]["primitives"].as_array().map(|v| v.len()),
            Some(2)
        );
        assert_eq!(
            doc["meshes"][1]["primitives"].as_array().map(|v| v.len()),
            Some(2)
        );
        assert_eq!(doc["nodes"].as_array().map(|v| v.len()), Some(2));

        let _ = fs::remove_file(output);
    }

    #[test]
    fn write_glb_returns_error_on_empty_scene() {
        let output = temp_glb_path("empty");
        let scene = SceneData {
            meshes: vec![],
            warnings: vec![],
        };
        let err = write_glb(&scene, &[], &[], &HashMap::new(), &output)
            .expect_err("expected empty scene error");
        assert!(err.to_string().contains("empty scene"));
    }

    #[test]
    fn write_glb_validation_rejects_out_of_bounds_indices() {
        let output = temp_glb_path("validate-out-of-range");
        let mut scene = sample_scene();
        scene.meshes[0].indices = vec![0, 1, 5];

        let err = write_glb_with_config(
            &scene,
            &[],
            &[],
            &HashMap::new(),
            &output,
            ValidationConfig::test_mode(true),
        )
        .expect_err("expected index validation error");

        assert!(
            err.to_string().contains("index 5"),
            "got unexpected validation message: {err}"
        );
    }
}
