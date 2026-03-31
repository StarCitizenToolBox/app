use anyhow::{anyhow, Result};

use super::{
    cryengine::{
        chunks::node_mesh_combo::{
            node_transform_to_gltf_trs, parse_node_mesh_combo_chunk, IvoNodeMeshComboChunk,
            resolve_node_mesh_combo_transforms,
        },
        ivo::{collect_skin_chunks, find_node_mesh_combo_chunk},
        FileSignature, ModelFile,
    },
    SceneData, SceneMesh, ScenePrimitive,
};

const FILE_SIGNATURE_IVO: &[u8; 4] = b"#ivo";
const IVO_FILE_VERSION_900: u32 = 0x900;
const IVO_FILE_VERSION_901: u32 = 0x901;

const CHUNK_TYPE_IVO_SKIN: u32 = 0xB875B2D9;
const STREAM_IVO_NORMALS: u32 = 0x9CF3F615;
const STREAM_IVO_NORMALS2: u32 = 0x38A581FE;
const STREAM_IVO_INDICES: u32 = 0xEECDC168;
const STREAM_IVO_TANGENTS: u32 = 0xB95E9A1B;
const STREAM_IVO_QTANGENTS: u32 = 0xEE057252;
const STREAM_IVO_BONEMAP: u32 = 0x677C7B23;
const STREAM_IVO_BONEMAP32: u32 = 0x6ECA3708;
const STREAM_IVO_VERTS_UVS: u32 = 0x91329AE9;
const STREAM_IVO_VERTS_UVS2: u32 = 0xB3A70D5E;
const STREAM_IVO_COLORS2: u32 = 0xD9EED421;
const STREAM_IVO_UNKNOWN: u32 = 0x9D51C5EE;

#[derive(Debug, Clone, Copy)]
struct IvoChunkHeader {
    chunk_type: u32,
    version: u32,
    offset: usize,
}

#[derive(Debug, Clone, Copy)]
struct IvoMeshDetails {
    flags2: u32,
    num_vertices: usize,
    num_indices: usize,
    num_submeshes: usize,
    bounding_box_min: [f32; 3],
    bounding_box_max: [f32; 3],
    scaling_box_min: [f32; 3],
    scaling_box_max: [f32; 3],
    vertex_format: u32,
}

#[derive(Debug, Clone, Copy)]
struct IvoMeshSubset {
    material_id: i32,
    node_parent_index: u16,
    first_index: usize,
    num_indices: usize,
    first_vertex: usize,
    num_vertices: usize,
}

pub fn parse_static_scene(data: &[u8]) -> Result<SceneData> {
    parse_static_scene_with_layout(data, None)
}

pub fn parse_static_scene_with_layout(
    data: &[u8],
    layout_data: Option<&[u8]>,
) -> Result<SceneData> {
    if data.len() < 16 {
        return Err(anyhow!("unsupported binary format: header is too short"));
    }
    if &data[0..4] != FILE_SIGNATURE_IVO {
        return Err(anyhow!("unsupported file signature: expected #ivo"));
    }

    // Some files embed a CrCh segment; keep using the mature parser when possible.
    if let Some(offset) = find_embedded_crch(data) {
        let mut scene = super::cgf_parser::parse_static_scene(&data[offset..])?;
        scene.warnings.push(format!(
            "IVO native best-effort: parsed embedded CrCh segment at offset {offset}"
        ));
        return Ok(scene);
    }

    parse_ivo_scene_with_layout(data, layout_data)
}

fn parse_ivo_scene_with_layout(data: &[u8], layout_data: Option<&[u8]>) -> Result<SceneData> {
    let model = ModelFile::parse(data)?;
    if model.header.signature != FileSignature::Ivo {
        return Err(anyhow!("native IVO parser expected #ivo model"));
    }
    let file_version = model.header.version;

    let mut warnings = Vec::new();
    if file_version != IVO_FILE_VERSION_900 && file_version != IVO_FILE_VERSION_901 {
        warnings.push(format!(
            "IVO native best-effort: unvalidated file version 0x{file_version:X}"
        ));
    }

    let mut skin_chunks = collect_skin_chunks(&model, data)?;
    skin_chunks.sort_by_key(|chunk| chunk.header.offset);

    if skin_chunks.is_empty() {
        return Err(anyhow!("native IVO parser found no skin mesh chunks"));
    }

    let layout_bytes = layout_data.unwrap_or(data);
    let layout_model = ModelFile::parse(layout_bytes)?;
    let combo_chunk = find_node_mesh_combo_chunk(&layout_model);
    let combo_layout = combo_chunk
        .and_then(|chunk| match parse_node_mesh_combo_chunk(layout_bytes, chunk) {
            Ok(parsed) => Some(parsed),
            Err(err) => {
                warnings.push(format!(
                    "IVO native best-effort: failed to parse NodeMeshCombo layout at offset {}: {}",
                    chunk.offset, err
                ));
                None
            }
        });

    let mut meshes = Vec::new();
    for chunk in &skin_chunks {
        let header = IvoChunkHeader {
            chunk_type: chunk.header.chunk_type_raw,
            version: chunk.header.version,
            offset: chunk.header.offset,
        };
        let chunk_end = chunk.end;

        match parse_skin_mesh_source(data, header, chunk_end, &mut warnings) {
            Ok(source) => {
                if let Some(combo_layout) = combo_layout.as_ref() {
                    let transforms = if let Some(combo) = combo_chunk {
                        match resolve_node_mesh_combo_transforms(layout_bytes, combo) {
                            Ok(transforms) => transforms,
                            Err(err) => {
                                warnings.push(format!(
                                    "IVO native best-effort: failed to resolve NodeMeshCombo transforms at offset {}: {}",
                                    combo.offset, err
                                ));
                                Default::default()
                            }
                        }
                    } else {
                        Default::default()
                    };
                    meshes.extend(build_meshes_from_combo(
                        combo_layout,
                        &source,
                        &transforms,
                        &mut warnings,
                    ));
                } else {
                    meshes.extend(build_meshes_from_skin_source(&source));
                }
            }
            Err(err) => warnings.push(format!(
                "skip IVO skin chunk at offset {} (type 0x{:X}, version 0x{:X}): {}",
                header.offset, header.chunk_type, header.version, err
            )),
        }
    }

    if meshes.is_empty() {
        return Err(anyhow!("native IVO parser produced no meshes"));
    }

    Ok(SceneData { meshes, warnings })
}

fn parse_skin_mesh_source(
    data: &[u8],
    header: IvoChunkHeader,
    chunk_end: usize,
    warnings: &mut Vec<String>,
) -> Result<IvoSkinMeshSource> {
    if chunk_end <= header.offset {
        return Err(anyhow!("IVO chunk has invalid bounds"));
    }

    let mut cursor = header.offset;
    skip_bytes(data, &mut cursor, 4, chunk_end)?;
    let details = read_mesh_details(data, &mut cursor, chunk_end)?;
    skip_bytes(data, &mut cursor, 92, chunk_end)?;

    let subset_start = cursor;
    // IVO 900+ mesh subsets are stored back-to-back without padding; the C# reader
    // consumes 48 bytes per subset via ReadMeshSubset().
    let (subsets, subset_end) =
        read_mesh_subsets_with_stride(data, subset_start, details.num_submeshes, 48, chunk_end)?;
    cursor = subset_end;

    let mut positions = None;
    let mut uvs = None;
    let mut normals = None;
    let mut indices = None;
    let mut skin_data: Option<(Vec<[u16; 4]>, Vec<[f32; 4]>)> = None;
    let mut has_read_indices = false;
    let mut logged_unknown_stream = false;

    while cursor + 8 <= chunk_end {
        let stream_type = read_u32_le(data, cursor)?;
        cursor += 4;
        let bytes_per_element = read_u32_le(data, cursor)? as usize;
        cursor += 4;

        match stream_type {
            STREAM_IVO_INDICES => {
                let payload_len = checked_payload_len(bytes_per_element, details.num_indices)?;
                ensure_within(chunk_end, cursor, payload_len)?;
                if !has_read_indices {
                    indices = Some(read_indices(
                        data,
                        cursor,
                        details.num_indices,
                        bytes_per_element,
                    )?);
                    has_read_indices = true;
                }
                cursor += payload_len;
                cursor = align_cursor(cursor, chunk_end, 8)?;
            }
            STREAM_IVO_VERTS_UVS | STREAM_IVO_VERTS_UVS2 => {
                let payload_len = checked_payload_len(bytes_per_element, details.num_vertices)?;
                ensure_within(chunk_end, cursor, payload_len)?;
                let (parsed_positions, parsed_uvs) =
                    read_positions_uvs(data, cursor, details.num_vertices, bytes_per_element)?;
                positions = Some(parsed_positions);
                uvs = Some(parsed_uvs);
                cursor += payload_len;
                cursor = align_cursor(cursor, chunk_end, 8)?;
            }
            STREAM_IVO_NORMALS | STREAM_IVO_NORMALS2 => {
                let payload_len = checked_payload_len(bytes_per_element, details.num_vertices)?;
                ensure_within(chunk_end, cursor, payload_len)?;
                normals = Some(read_normals(
                    data,
                    cursor,
                    details.num_vertices,
                    bytes_per_element,
                )?);
                cursor += payload_len;
                cursor = align_cursor(cursor, chunk_end, 8)?;
            }
            STREAM_IVO_UNKNOWN => {
                let payload_len = checked_payload_len(bytes_per_element, details.num_vertices)?;
                ensure_within(chunk_end, cursor, payload_len)?;
                cursor += payload_len;
                cursor = align_cursor(cursor, chunk_end, 8)?;
            }
            STREAM_IVO_TANGENTS | STREAM_IVO_QTANGENTS => {
                let payload_len = checked_payload_len(bytes_per_element, details.num_vertices)?;
                ensure_within(chunk_end, cursor, payload_len)?;
                if stream_type == STREAM_IVO_QTANGENTS {
                    normals = Some(read_qtangent_normals(
                        data,
                        cursor,
                        details.num_vertices,
                        bytes_per_element,
                    )?);
                }
                cursor += payload_len;
                cursor = align_cursor(cursor, chunk_end, 8)?;
            }
            STREAM_IVO_BONEMAP | STREAM_IVO_BONEMAP32 => {
                let payload_len = checked_payload_len(bytes_per_element, details.num_vertices)?;
                ensure_within(chunk_end, cursor, payload_len)?;
                if skin_data.is_none() {
                    skin_data = Some(read_skin_data(
                        data,
                        cursor,
                        details.num_vertices,
                        bytes_per_element,
                    )?);
                }
                cursor += payload_len;
                cursor = align_cursor(cursor, chunk_end, 8)?;
            }
            STREAM_IVO_COLORS2 => {
                let payload_len = checked_payload_len(bytes_per_element, details.num_vertices)?;
                ensure_within(chunk_end, cursor, payload_len)?;
                cursor += payload_len;
                cursor = align_cursor(cursor, chunk_end, 8)?;
            }
            other => {
                if !logged_unknown_stream {
                    warnings.push(format!(
                        "IVO native best-effort: unknown datastream 0x{other:08X} in skin chunk at offset {}; stopping chunk parse",
                        header.offset
                    ));
                    logged_unknown_stream = true;
                }
                cursor = chunk_end;
            }
        }
    }

    let positions =
        positions.ok_or_else(|| anyhow!("IVO mesh is missing positions/uv datastream"))?;
    let uvs = uvs.ok_or_else(|| anyhow!("IVO mesh is missing positions/uv datastream"))?;
    let indices = indices.ok_or_else(|| anyhow!("IVO mesh is missing index datastream"))?;
    let normals = normals.unwrap_or_else(|| {
        warnings.push(format!(
            "IVO native best-effort: rebuilt normals for skin chunk at offset {}",
            header.offset
        ));
        build_normals_from_geometry(&positions, &indices)
    });

    let positions = scale_ivo_positions(
        positions,
        details.bounding_box_min,
        details.bounding_box_max,
        Some((details.scaling_box_min, details.scaling_box_max)),
    );

    let (joints, weights) = skin_data
        .map(|(j, w)| (Some(j), Some(w)))
        .unwrap_or((None, None));
    if details.flags2 & 0x4 != 0 && details.flags2 & 0x1 == 0 {
        warnings.push(format!(
            "IVO native best-effort: flags2=0x{:X} suggests normals may be omitted for chunk at offset {}",
            details.flags2, header.offset
        ));
    }

    Ok(IvoSkinMeshSource {
        positions,
        normals,
        uvs,
        joints,
        weights,
        indices,
        subsets,
        num_indices: details.num_indices,
        num_vertices: details.num_vertices,
        bounding_box_min: details.bounding_box_min,
        bounding_box_max: details.bounding_box_max,
        scaling_box_min: details.scaling_box_min,
        scaling_box_max: details.scaling_box_max,
    })
}

#[derive(Debug, Clone)]
struct IvoSkinMeshSource {
    positions: Vec<[f32; 3]>,
    normals: Vec<[f32; 3]>,
    uvs: Vec<[f32; 2]>,
    joints: Option<Vec<[u16; 4]>>,
    weights: Option<Vec<[f32; 4]>>,
    indices: Vec<u32>,
    subsets: Vec<IvoMeshSubset>,
    num_indices: usize,
    num_vertices: usize,
    bounding_box_min: [f32; 3],
    bounding_box_max: [f32; 3],
    scaling_box_min: [f32; 3],
    scaling_box_max: [f32; 3],
}

fn build_meshes_from_skin_source(source: &IvoSkinMeshSource) -> Vec<SceneMesh> {
    let primitive_groups =
        build_primitives_by_node(&source.subsets, source.num_indices, source.num_vertices);
    let mut meshes = Vec::new();
    for (node_index, primitives) in primitive_groups {
        meshes.push(SceneMesh {
            positions: source.positions.clone(),
            normals: source.normals.clone(),
            uvs: source.uvs.clone(),
            joints: source.joints.clone(),
            weights: source.weights.clone(),
            indices: source.indices.clone(),
            index_accessor_source: None,
            primitives,
            name: Some(format!("ivo_node_{node_index}")),
            node_name: Some(format!("ivo_node_{node_index}")),
            node_translation: None,
            node_rotation: None,
            node_scale: None,
            node_matrix: None,
        });
    }
    if meshes.is_empty() {
        meshes.push(SceneMesh {
            positions: source.positions.clone(),
            normals: source.normals.clone(),
            uvs: source.uvs.clone(),
            joints: source.joints.clone(),
            weights: source.weights.clone(),
            indices: source.indices.clone(),
            index_accessor_source: None,
            primitives: vec![ScenePrimitive {
                first_index: 0,
                num_indices: source.num_indices as u32,
                first_vertex: 0,
                num_vertices: source.num_vertices as u32,
                material_id: -1,
            }],
            name: Some("ivo_node_0/mesh".to_string()),
            node_name: Some("ivo_node_0".to_string()),
            node_translation: None,
            node_rotation: None,
            node_scale: None,
            node_matrix: None,
        });
    }
    meshes
}

fn build_meshes_from_combo(
    combo: &IvoNodeMeshComboChunk,
    source: &IvoSkinMeshSource,
    transforms: &std::collections::HashMap<u16, crate::model_convert::cryengine::chunks::node_mesh_combo::NodeTransform>,
    warnings: &mut Vec<String>,
) -> Vec<SceneMesh> {
    let mut meshes = Vec::new();
    for node in &combo.nodes {
        if node.parent_index.is_some() {
            continue;
        }
        let matching_subsets: Vec<_> = source
            .subsets
            .iter()
            .filter(|subset| subset.node_parent_index == node.node_index)
            .collect();

        let mut primitives = Vec::new();
        let mut positions = Vec::new();
        let mut normals = Vec::new();
        let mut uvs = Vec::new();
        let mut joints = source.joints.as_ref().map(|_| Vec::new());
        let mut weights = source.weights.as_ref().map(|_| Vec::new());
        let mut local_index_map = std::collections::HashMap::<u32, u32>::new();
        let mut vertex_offset = 0usize;

        for subset in matching_subsets {
            if subset.num_indices == 0 || subset.num_vertices == 0 {
                continue;
            }
            if subset
                .first_index
                .checked_add(subset.num_indices)
                .is_none_or(|end| end > source.num_indices)
            {
                continue;
            }
            if subset
                .first_vertex
                .checked_add(subset.num_vertices)
                .is_none_or(|end| end > source.num_vertices)
            {
                continue;
            }

            let vertex_start = subset.first_vertex;
            let vertex_end = vertex_start + subset.num_vertices;
            positions.extend_from_slice(&source.positions[vertex_start..vertex_end]);
            normals.extend_from_slice(&source.normals[vertex_start..vertex_end]);
            uvs.extend_from_slice(&source.uvs[vertex_start..vertex_end]);
            if let (Some(dst), Some(src)) = (joints.as_mut(), source.joints.as_ref()) {
                dst.extend_from_slice(&src[vertex_start..vertex_end]);
            }
            if let (Some(dst), Some(src)) = (weights.as_mut(), source.weights.as_ref()) {
                dst.extend_from_slice(&src[vertex_start..vertex_end]);
            }

            let first_global_index = source.indices[subset.first_index];
            for i in 0..subset.num_indices {
                let global_index = source.indices[subset.first_index + i];
                let local_index = (global_index - first_global_index) + vertex_offset as u32;
                local_index_map.insert(global_index, local_index);
            }

            primitives.push(ScenePrimitive {
                first_index: subset.first_index as u32,
                num_indices: subset.num_indices as u32,
                first_vertex: vertex_offset as u32,
                num_vertices: subset.num_vertices as u32,
                material_id: subset.material_id,
            });

            vertex_offset += subset.num_vertices;
        }

        if primitives.is_empty() {
            continue;
        }

        let indices = source
            .indices
            .iter()
            .map(|index| local_index_map.get(index).copied().unwrap_or(*index))
            .collect::<Vec<_>>();

        let display_name = combo
            .node_names
            .get(node.node_index as usize)
            .and_then(|name| if name.is_empty() { None } else { Some(name.clone()) })
            .or_else(|| Some(format!("ivo_node_{}", node.node_index)));
        let trs = transforms
            .get(&node.node_index)
            .copied()
            .map(node_transform_to_gltf_trs);
        let display_name = display_name.unwrap_or_else(|| format!("ivo_node_{}", node.node_index));
        meshes.push(SceneMesh {
            positions,
            normals,
            uvs,
            joints,
            weights,
            indices,
            index_accessor_source: Some(source.indices.clone()),
            primitives,
            name: Some(format!("{display_name}/mesh")),
            node_name: Some(display_name),
            node_translation: trs.map(|trs| trs.0),
            node_rotation: trs.map(|trs| trs.1),
            node_scale: trs.map(|trs| trs.2),
            node_matrix: None,
        });
    }

    if meshes.is_empty() {
        warnings.push("IVO native best-effort: NodeMeshCombo produced no mesh subsets; falling back to subset grouping".to_string());
        meshes = build_meshes_from_skin_source(source);
    }

    meshes
}

fn read_mesh_details(data: &[u8], cursor: &mut usize, chunk_end: usize) -> Result<IvoMeshDetails> {
    ensure_within(chunk_end, *cursor, 72)?;

    let flags2 = read_u32_le(data, *cursor)?;
    *cursor += 4;
    let num_vertices = read_u32_le(data, *cursor)? as usize;
    *cursor += 4;
    let num_indices = read_u32_le(data, *cursor)? as usize;
    *cursor += 4;
    let num_submeshes = read_u32_le(data, *cursor)? as usize;
    *cursor += 4;
    let _unknown = read_i32_le(data, *cursor)?;
    *cursor += 4;
    let bounding_box_min = read_vector3(data, cursor)?;
    let bounding_box_max = read_vector3(data, cursor)?;
    let scaling_box_min = read_vector3(data, cursor)?;
    let scaling_box_max = read_vector3(data, cursor)?;
    let vertex_format = read_u32_le(data, *cursor)?;
    *cursor += 4;

    Ok(IvoMeshDetails {
        flags2,
        num_vertices,
        num_indices,
        num_submeshes,
        bounding_box_min,
        bounding_box_max,
        scaling_box_min,
        scaling_box_max,
        vertex_format,
    })
}

fn read_mesh_subset(data: &[u8], cursor: &mut usize, chunk_end: usize) -> Result<IvoMeshSubset> {
    ensure_within(chunk_end, *cursor, 48)?;

    let material_id = read_u16_le(data, *cursor)? as i32;
    *cursor += 2;
    let node_parent_index = read_u16_le(data, *cursor)?;
    *cursor += 2;
    let first_index = read_i32_le(data, *cursor)?;
    *cursor += 4;
    let num_indices = read_i32_le(data, *cursor)?;
    *cursor += 4;
    let first_vertex = read_i32_le(data, *cursor)?;
    *cursor += 4;
    skip_bytes(data, cursor, 4, chunk_end)?; // unknown
    let num_vertices = read_i32_le(data, *cursor)?;
    *cursor += 4;
    skip_bytes(data, cursor, 4 + 12 + 4 + 4, chunk_end)?;

    Ok(IvoMeshSubset {
        material_id,
        node_parent_index,
        first_index: first_index.max(0) as usize,
        num_indices: num_indices.max(0) as usize,
        first_vertex: first_vertex.max(0) as usize,
        num_vertices: num_vertices.max(0) as usize,
    })
}

fn read_mesh_subsets_with_stride(
    data: &[u8],
    start: usize,
    count: usize,
    stride: usize,
    chunk_end: usize,
) -> Result<(Vec<IvoMeshSubset>, usize)> {
    if stride < 40 {
        return Err(anyhow!("invalid IVO subset stride: {stride}"));
    }
    let mut cursor = start;
    let mut subsets = Vec::with_capacity(count);
    for _ in 0..count {
        let before = cursor;
        subsets.push(read_mesh_subset(data, &mut cursor, chunk_end)?);
        let consumed = cursor
            .checked_sub(before)
            .ok_or_else(|| anyhow!("IVO subset cursor underflow"))?;
        if stride > consumed {
            skip_bytes(data, &mut cursor, stride - consumed, chunk_end)?;
        }
    }
    Ok((subsets, cursor))
}

fn read_indices(
    data: &[u8],
    start: usize,
    count: usize,
    bytes_per_element: usize,
) -> Result<Vec<u32>> {
    let mut out = Vec::with_capacity(count);
    match bytes_per_element {
        2 => {
            for i in 0..count {
                out.push(read_u16_le(data, start + i * 2)? as u32);
            }
        }
        4 => {
            for i in 0..count {
                out.push(read_u32_le(data, start + i * 4)?);
            }
        }
        _ => {
            return Err(anyhow!(
                "unsupported IVO index stream format: bytes-per-element={bytes_per_element}"
            ));
        }
    }
    Ok(out)
}

fn read_positions_uvs(
    data: &[u8],
    start: usize,
    count: usize,
    bytes_per_element: usize,
) -> Result<(Vec<[f32; 3]>, Vec<[f32; 2]>)> {
    let mut positions = Vec::with_capacity(count);
    let mut uvs = Vec::with_capacity(count);

    match bytes_per_element {
        20 => {
            for i in 0..count {
                let base = start + i * 20;
                positions.push([
                    read_f32_le(data, base)?,
                    read_f32_le(data, base + 4)?,
                    read_f32_le(data, base + 8)?,
                ]);
                uvs.push([
                    half_to_f32(read_u16_le(data, base + 16)?),
                    half_to_f32(read_u16_le(data, base + 18)?),
                ]);
            }
        }
        16 => {
            for i in 0..count {
                let base = start + i * 16;
                positions.push([
                    snorm16_to_f32(read_i16_le(data, base)?),
                    snorm16_to_f32(read_i16_le(data, base + 2)?),
                    snorm16_to_f32(read_i16_le(data, base + 4)?),
                ]);
                uvs.push([
                    half_to_f32(read_u16_le(data, base + 12)?),
                    half_to_f32(read_u16_le(data, base + 14)?),
                ]);
            }
        }
        _ => {
            return Err(anyhow!(
                "unsupported IVO verts/uv stream format: bytes-per-element={bytes_per_element}"
            ));
        }
    }

    Ok((positions, uvs))
}

fn read_normals(
    data: &[u8],
    start: usize,
    count: usize,
    bytes_per_element: usize,
) -> Result<Vec<[f32; 3]>> {
    let mut out = Vec::with_capacity(count);
    match bytes_per_element {
        12 => {
            for i in 0..count {
                let base = start + i * 12;
                out.push([
                    read_f32_le(data, base)?,
                    read_f32_le(data, base + 4)?,
                    read_f32_le(data, base + 8)?,
                ]);
            }
        }
        4 => {
            for i in 0..count {
                let base = start + i * 4;
                out.push([
                    half_to_f32(read_u16_le(data, base)?),
                    half_to_f32(read_u16_le(data, base + 2)?),
                    0.0,
                ]);
            }
        }
        _ => {
            return Err(anyhow!(
                "unsupported IVO normal stream format: bytes-per-element={bytes_per_element}"
            ));
        }
    }
    Ok(out)
}

fn read_skin_data(
    data: &[u8],
    start: usize,
    count: usize,
    bytes_per_element: usize,
) -> Result<(Vec<[u16; 4]>, Vec<[f32; 4]>)> {
    let mut joints = Vec::with_capacity(count);
    let mut weights = Vec::with_capacity(count);

    match bytes_per_element {
        8 => {
            for i in 0..count {
                let base = start + i * 8;
                let j = [
                    data.get(base)
                        .copied()
                        .ok_or_else(|| anyhow!("truncated bonemap stream"))?
                        as u16,
                    data.get(base + 1)
                        .copied()
                        .ok_or_else(|| anyhow!("truncated bonemap stream"))?
                        as u16,
                    data.get(base + 2)
                        .copied()
                        .ok_or_else(|| anyhow!("truncated bonemap stream"))?
                        as u16,
                    data.get(base + 3)
                        .copied()
                        .ok_or_else(|| anyhow!("truncated bonemap stream"))?
                        as u16,
                ];
                let w = [
                    data.get(base + 4)
                        .copied()
                        .ok_or_else(|| anyhow!("truncated bonemap stream"))?
                        as f32
                        / 255.0,
                    data.get(base + 5)
                        .copied()
                        .ok_or_else(|| anyhow!("truncated bonemap stream"))?
                        as f32
                        / 255.0,
                    data.get(base + 6)
                        .copied()
                        .ok_or_else(|| anyhow!("truncated bonemap stream"))?
                        as f32
                        / 255.0,
                    data.get(base + 7)
                        .copied()
                        .ok_or_else(|| anyhow!("truncated bonemap stream"))?
                        as f32
                        / 255.0,
                ];
                joints.push(j);
                weights.push(normalize_weights4(w));
            }
        }
        12 => {
            for i in 0..count {
                let base = start + i * 12;
                let j = [
                    read_u16_le(data, base)?,
                    read_u16_le(data, base + 2)?,
                    read_u16_le(data, base + 4)?,
                    read_u16_le(data, base + 6)?,
                ];
                let w = [
                    data.get(base + 8)
                        .copied()
                        .ok_or_else(|| anyhow!("truncated bonemap stream"))?
                        as f32
                        / 255.0,
                    data.get(base + 9)
                        .copied()
                        .ok_or_else(|| anyhow!("truncated bonemap stream"))?
                        as f32
                        / 255.0,
                    data.get(base + 10)
                        .copied()
                        .ok_or_else(|| anyhow!("truncated bonemap stream"))?
                        as f32
                        / 255.0,
                    data.get(base + 11)
                        .copied()
                        .ok_or_else(|| anyhow!("truncated bonemap stream"))?
                        as f32
                        / 255.0,
                ];
                joints.push(j);
                weights.push(normalize_weights4(w));
            }
        }
        24 => {
            for i in 0..count {
                let base = start + i * 24;
                let mut ji = [0u16; 8];
                let mut wi = [0f32; 8];
                for k in 0..8 {
                    ji[k] = read_u16_le(data, base + k * 2)?;
                }
                for k in 0..8 {
                    wi[k] = data
                        .get(base + 16 + k)
                        .copied()
                        .ok_or_else(|| anyhow!("truncated bonemap stream"))?
                        as f32
                        / 255.0;
                }
                // Keep top-4 influences for glTF JOINTS_0/WEIGHTS_0.
                let mut pairs = (0..8).map(|k| (ji[k], wi[k])).collect::<Vec<_>>();
                pairs.sort_by(|a, b| b.1.partial_cmp(&a.1).unwrap_or(std::cmp::Ordering::Equal));
                let j = [pairs[0].0, pairs[1].0, pairs[2].0, pairs[3].0];
                let w = normalize_weights4([pairs[0].1, pairs[1].1, pairs[2].1, pairs[3].1]);
                joints.push(j);
                weights.push(w);
            }
        }
        _ => {
            return Err(anyhow!(
                "unsupported IVO bonemap stream format: bytes-per-element={bytes_per_element}"
            ));
        }
    }

    Ok((joints, weights))
}

fn normalize_weights4(weights: [f32; 4]) -> [f32; 4] {
    let s = weights[0] + weights[1] + weights[2] + weights[3];
    if s <= f32::EPSILON {
        [1.0, 0.0, 0.0, 0.0]
    } else {
        [
            weights[0] / s,
            weights[1] / s,
            weights[2] / s,
            weights[3] / s,
        ]
    }
}

fn read_qtangent_normals(
    data: &[u8],
    start: usize,
    count: usize,
    bytes_per_element: usize,
) -> Result<Vec<[f32; 3]>> {
    let mut out = Vec::with_capacity(count);
    match bytes_per_element {
        8 => {
            for i in 0..count {
                let base = start + i * 8;
                let qx = snorm16_to_f32(read_i16_le(data, base)?);
                let qy = snorm16_to_f32(read_i16_le(data, base + 2)?);
                let qz = snorm16_to_f32(read_i16_le(data, base + 4)?);
                let qw = snorm16_to_f32(read_i16_le(data, base + 6)?);
                out.push(get_normal_from_qtangent(qx, qy, qz, qw));
            }
        }
        16 => {
            for i in 0..count {
                let base = start + i * 16;
                let qx = read_f32_le(data, base)?;
                let qy = read_f32_le(data, base + 4)?;
                let qz = read_f32_le(data, base + 8)?;
                let qw = read_f32_le(data, base + 12)?;
                out.push(get_normal_from_qtangent(qx, qy, qz, qw));
            }
        }
        _ => {
            return Err(anyhow!(
                "unsupported IVO qtangent stream format: bytes-per-element={bytes_per_element}"
            ));
        }
    }
    Ok(out)
}

fn get_normal_from_qtangent(x: f32, y: f32, z: f32, w: f32) -> [f32; 3] {
    // Port of Cryengine-Converter GetNormalFromQTangent.
    let mut nx = 2.0 * (x * z + y * w);
    let mut ny = 2.0 * (y * z - x * w);
    let mut nz = 2.0 * (z * z + w * w) - 1.0;
    let mut normal = normalize([nx, ny, nz]).unwrap_or([0.0, 0.0, 1.0]);
    if w < 0.0 {
        normal = [-normal[0], -normal[1], -normal[2]];
    }
    normal
}

fn build_primitives_by_node(
    subsets: &[IvoMeshSubset],
    total_indices: usize,
    total_vertices: usize,
) -> Vec<(u16, Vec<ScenePrimitive>)> {
    let mut grouped = std::collections::BTreeMap::<u16, Vec<ScenePrimitive>>::new();
    for subset in subsets {
        if subset.num_indices == 0 || subset.num_vertices == 0 {
            continue;
        }
        if subset
            .first_index
            .checked_add(subset.num_indices)
            .is_none_or(|end| end > total_indices)
        {
            continue;
        }
        if subset
            .first_vertex
            .checked_add(subset.num_vertices)
            .is_none_or(|end| end > total_vertices)
        {
            continue;
        }

        grouped
            .entry(subset.node_parent_index)
            .or_default()
            .push(ScenePrimitive {
                first_index: subset.first_index as u32,
                num_indices: subset.num_indices as u32,
                first_vertex: subset.first_vertex as u32,
                num_vertices: subset.num_vertices as u32,
                material_id: subset.material_id,
            });
    }

    if grouped.is_empty() {
        grouped.entry(0).or_default().push(ScenePrimitive {
            first_index: 0,
            num_indices: total_indices as u32,
            first_vertex: 0,
            num_vertices: total_vertices as u32,
            material_id: -1,
        });
    }

    grouped.into_iter().collect()
}

fn build_normals_from_geometry(positions: &[[f32; 3]], indices: &[u32]) -> Vec<[f32; 3]> {
    let mut normals = vec![[0.0, 0.0, 0.0]; positions.len()];
    for tri in indices.chunks_exact(3) {
        let a = tri[0] as usize;
        let b = tri[1] as usize;
        let c = tri[2] as usize;
        if a >= positions.len() || b >= positions.len() || c >= positions.len() {
            continue;
        }

        let ab = subtract(positions[b], positions[a]);
        let ac = subtract(positions[c], positions[a]);
        let face = cross(ab, ac);

        accumulate(&mut normals[a], face);
        accumulate(&mut normals[b], face);
        accumulate(&mut normals[c], face);
    }

    for normal in &mut normals {
        *normal = normalize(*normal).unwrap_or([0.0, 0.0, 1.0]);
    }
    normals
}

fn subtract(a: [f32; 3], b: [f32; 3]) -> [f32; 3] {
    [a[0] - b[0], a[1] - b[1], a[2] - b[2]]
}

fn cross(a: [f32; 3], b: [f32; 3]) -> [f32; 3] {
    [
        a[1] * b[2] - a[2] * b[1],
        a[2] * b[0] - a[0] * b[2],
        a[0] * b[1] - a[1] * b[0],
    ]
}

fn accumulate(dst: &mut [f32; 3], src: [f32; 3]) {
    dst[0] += src[0];
    dst[1] += src[1];
    dst[2] += src[2];
}

fn normalize(v: [f32; 3]) -> Option<[f32; 3]> {
    let len_sq = v[0] * v[0] + v[1] * v[1] + v[2] * v[2];
    if len_sq <= f32::EPSILON {
        return None;
    }
    let len = len_sq.sqrt();
    Some([v[0] / len, v[1] / len, v[2] / len])
}

fn checked_payload_len(bytes_per_element: usize, count: usize) -> Result<usize> {
    bytes_per_element
        .checked_mul(count)
        .ok_or_else(|| anyhow!("IVO datastream payload size overflow"))
}

fn skip_bytes(data: &[u8], cursor: &mut usize, len: usize, chunk_end: usize) -> Result<()> {
    ensure_within(chunk_end, *cursor, len)?;
    *cursor += len;
    let _ = data;
    Ok(())
}

fn ensure_within(chunk_end: usize, start: usize, len: usize) -> Result<()> {
    let end = start
        .checked_add(len)
        .ok_or_else(|| anyhow!("IVO chunk size overflow"))?;
    if end > chunk_end {
        return Err(anyhow!("IVO chunk is truncated"));
    }
    Ok(())
}

fn align_cursor(cursor: usize, chunk_end: usize, align: usize) -> Result<usize> {
    let aligned = cursor
        .checked_add(align - 1)
        .map(|value| value & !(align - 1))
        .ok_or_else(|| anyhow!("IVO chunk alignment overflow"))?;
    if aligned > chunk_end {
        return Err(anyhow!("IVO chunk alignment exceeds chunk bounds"));
    }
    Ok(aligned)
}

fn read_u16_le(data: &[u8], offset: usize) -> Result<u16> {
    let bytes = data
        .get(offset..offset + 2)
        .ok_or_else(|| anyhow!("unexpected EOF while reading u16"))?;
    Ok(u16::from_le_bytes([bytes[0], bytes[1]]))
}

fn read_i16_le(data: &[u8], offset: usize) -> Result<i16> {
    Ok(read_u16_le(data, offset)? as i16)
}

fn read_u32_le(data: &[u8], offset: usize) -> Result<u32> {
    let bytes = data
        .get(offset..offset + 4)
        .ok_or_else(|| anyhow!("unexpected EOF while reading u32"))?;
    Ok(u32::from_le_bytes([bytes[0], bytes[1], bytes[2], bytes[3]]))
}

fn read_i32_le(data: &[u8], offset: usize) -> Result<i32> {
    Ok(read_u32_le(data, offset)? as i32)
}

fn read_f32_le(data: &[u8], offset: usize) -> Result<f32> {
    Ok(f32::from_bits(read_u32_le(data, offset)?))
}

fn read_vector3(data: &[u8], cursor: &mut usize) -> Result<[f32; 3]> {
    let value = [
        read_f32_le(data, *cursor)?,
        read_f32_le(data, *cursor + 4)?,
        read_f32_le(data, *cursor + 8)?,
    ];
    *cursor += 12;
    Ok(value)
}

fn swap_axes_for_position(value: [f32; 3]) -> [f32; 3] {
    [-value[0], value[2], value[1]]
}

fn scale_ivo_positions(
    mut positions: Vec<[f32; 3]>,
    bounding_box_min: [f32; 3],
    bounding_box_max: [f32; 3],
    scaling_box: Option<([f32; 3], [f32; 3])>,
) -> Vec<[f32; 3]> {
    let mut multiplier = [
        ((bounding_box_max[0] - bounding_box_min[0]) / 2.0).abs(),
        ((bounding_box_max[1] - bounding_box_min[1]) / 2.0).abs(),
        ((bounding_box_max[2] - bounding_box_min[2]) / 2.0).abs(),
    ];
    for value in &mut multiplier {
        if *value < 1.0 {
            *value = 1.0;
        }
    }
    let bbox_center = [
        (bounding_box_max[0] + bounding_box_min[0]) / 2.0,
        (bounding_box_max[1] + bounding_box_min[1]) / 2.0,
        (bounding_box_max[2] + bounding_box_min[2]) / 2.0,
    ];
    let (scale, center) = if let Some((min, max)) = scaling_box {
        let mut scale = [
            ((max[0] - min[0]) / 2.0).abs(),
            ((max[1] - min[1]) / 2.0).abs(),
            ((max[2] - min[2]) / 2.0).abs(),
        ];
        for value in &mut scale {
            if *value < 1.0 {
                *value = 1.0;
            }
        }
        let center = [
            (max[0] + min[0]) / 2.0,
            (max[1] + min[1]) / 2.0,
            (max[2] + min[2]) / 2.0,
        ];
        (scale, center)
    } else {
        ([1.0, 1.0, 1.0], [0.0, 0.0, 0.0])
    };

    for value in &mut positions {
        let scaled = [
            if scaling_box.is_some() {
                value[0] * scale[0] + center[0]
            } else {
                value[0] * multiplier[0] + bbox_center[0]
            },
            if scaling_box.is_some() {
                value[1] * scale[1] + center[1]
            } else {
                value[1] * multiplier[1] + bbox_center[1]
            },
            if scaling_box.is_some() {
                value[2] * scale[2] + center[2]
            } else {
                value[2] * multiplier[2] + bbox_center[2]
            },
        ];
        *value = scaled;
    }
    positions
}

fn snorm16_to_f32(value: i16) -> f32 {
    value as f32 / 32767.0
}

fn half_to_f32(bits: u16) -> f32 {
    let sign = ((bits & 0x8000) as u32) << 16;
    let exponent = (bits >> 10) & 0x1F;
    let fraction = (bits & 0x03FF) as u32;

    let f32_bits = match exponent {
        0 => {
            if fraction == 0 {
                sign
            } else {
                let mut mantissa = fraction;
                let mut exp = -14i32;
                while (mantissa & 0x0400) == 0 {
                    mantissa <<= 1;
                    exp -= 1;
                }
                mantissa &= 0x03FF;
                sign | (((exp + 127) as u32) << 23) | (mantissa << 13)
            }
        }
        0x1F => sign | 0x7F80_0000 | (fraction << 13),
        _ => sign | (((exponent as u32) + 112) << 23) | (fraction << 13),
    };

    f32::from_bits(f32_bits)
}

fn find_embedded_crch(data: &[u8]) -> Option<usize> {
    data.windows(4).position(|w| w == b"CrCh")
}

pub fn apply_node_layout(scene: &mut SceneData, layout_data: &[u8]) -> Result<Vec<String>> {
    if layout_data.len() < 16 || &layout_data[0..4] != FILE_SIGNATURE_IVO {
        return Ok(Vec::new());
    }
    let model = ModelFile::parse(layout_data)?;
    if model.header.signature != FileSignature::Ivo {
        return Ok(Vec::new());
    }
    let Some(chunk) = find_node_mesh_combo_chunk(&model) else {
        return Ok(Vec::new());
    };

    let transforms = resolve_node_mesh_combo_transforms(layout_data, chunk)?;
    if transforms.is_empty() {
        return Ok(Vec::new());
    }

    let mut warnings = Vec::new();
    let mut applied = 0usize;
    for mesh in &mut scene.meshes {
        let Some(name) = mesh.name.as_deref() else {
            continue;
        };
        let Some(idx) = parse_ivo_node_index(name) else {
            continue;
        };
        let Some(transform) = transforms.get(&idx) else {
            continue;
        };
        let (translation, rotation, scale) = node_transform_to_gltf_trs(*transform);
        mesh.node_translation = Some(translation);
        mesh.node_rotation = Some(rotation);
        mesh.node_scale = Some(scale);
        mesh.node_matrix = None;
        applied += 1;
    }

    if applied > 0 {
        warnings.push(format!(
            "IVO native best-effort: applied NodeMeshCombo transforms to {applied} mesh node(s)"
        ));
    }
    Ok(warnings)
}

fn parse_ivo_node_index(name: &str) -> Option<u16> {
    let prefix = "ivo_node_";
    let suffix = name.strip_prefix(prefix)?;
    suffix.parse::<u16>().ok()
}

#[cfg(test)]
mod tests {
    use super::{
        parse_static_scene, CHUNK_TYPE_IVO_SKIN, STREAM_IVO_INDICES, STREAM_IVO_VERTS_UVS2,
    };

    #[test]
    fn parse_static_scene_rejects_non_ivo() {
        let data = b"CrCh\x46\x07\x00\x00";
        assert!(parse_static_scene(data).is_err());
    }

    #[test]
    fn parse_static_scene_reads_minimal_ivo_triangle() {
        let data = build_minimal_ivo_triangle();
        let scene = parse_static_scene(&data).expect("expected valid ivo parse");
        assert_eq!(scene.meshes.len(), 1);

        let mesh = &scene.meshes[0];
        assert_eq!(mesh.positions.len(), 3);
        assert_eq!(mesh.uvs.len(), 3);
        assert_eq!(mesh.indices, vec![0, 1, 2]);
        assert_eq!(mesh.normals.len(), 3);
        assert_eq!(mesh.primitives.len(), 1);
        assert_eq!(mesh.primitives[0].material_id, 7);
        assert!(
            scene
                .warnings
                .iter()
                .any(|warning| warning.contains("rebuilt normals")),
            "warnings: {:?}",
            scene.warnings
        );
    }

    fn build_minimal_ivo_triangle() -> Vec<u8> {
        let mut chunk = Vec::new();
        push_u32(&mut chunk, 0); // flags
        push_u32(&mut chunk, 4); // mesh flags2
        push_u32(&mut chunk, 3); // num vertices
        push_u32(&mut chunk, 3); // num indices
        push_u32(&mut chunk, 1); // num submeshes
        push_i32(&mut chunk, 0); // unknown
        for value in [
            0.0f32, 0.0, 0.0, // bbox min
            1.0, 1.0, 1.0, // bbox max
            0.0, 0.0, 0.0, // scaling bbox min
            1.0, 1.0, 1.0, // scaling bbox max
        ] {
            push_f32(&mut chunk, value);
        }
        push_u32(&mut chunk, 0); // vertex format
        chunk.extend_from_slice(&[0u8; 92]);

        push_u16(&mut chunk, 7); // mat id
        push_u16(&mut chunk, 0); // node parent
        push_i32(&mut chunk, 0); // first index
        push_i32(&mut chunk, 3); // num indices
        push_i32(&mut chunk, 0); // first vertex
        push_i32(&mut chunk, 0); // unknown
        push_i32(&mut chunk, 3); // num vertices
        push_f32(&mut chunk, 0.0); // radius
        push_f32(&mut chunk, 0.0);
        push_f32(&mut chunk, 0.0);
        push_f32(&mut chunk, 0.0);
        push_i32(&mut chunk, 0);
        push_i32(&mut chunk, 0);

        push_u32(&mut chunk, STREAM_IVO_INDICES);
        push_u32(&mut chunk, 2);
        push_u16(&mut chunk, 0);
        push_u16(&mut chunk, 1);
        push_u16(&mut chunk, 2);
        align_to(&mut chunk, 8);

        push_u32(&mut chunk, STREAM_IVO_VERTS_UVS2);
        push_u32(&mut chunk, 20);
        for (x, y, z, u, v) in [
            (0.0f32, 0.0f32, 0.0f32, 0.0f32, 0.0f32),
            (1.0f32, 0.0f32, 0.0f32, 1.0f32, 0.0f32),
            (0.0f32, 1.0f32, 0.0f32, 0.0f32, 1.0f32),
        ] {
            push_f32(&mut chunk, x);
            push_f32(&mut chunk, y);
            push_f32(&mut chunk, z);
            push_u32(&mut chunk, 0);
            push_u16(&mut chunk, half_bits(u));
            push_u16(&mut chunk, half_bits(v));
        }
        align_to(&mut chunk, 8);

        let chunk_offset = 32u64;

        let mut file = Vec::new();
        file.extend_from_slice(b"#ivo");
        file.extend_from_slice(&0x900u32.to_le_bytes());
        file.extend_from_slice(&1u32.to_le_bytes());
        file.extend_from_slice(&16u32.to_le_bytes());
        file.extend_from_slice(&CHUNK_TYPE_IVO_SKIN.to_le_bytes());
        file.extend_from_slice(&0x900u32.to_le_bytes());
        file.extend_from_slice(&chunk_offset.to_le_bytes());
        file.extend_from_slice(&chunk);
        file
    }

    fn push_u16(out: &mut Vec<u8>, value: u16) {
        out.extend_from_slice(&value.to_le_bytes());
    }

    fn push_u32(out: &mut Vec<u8>, value: u32) {
        out.extend_from_slice(&value.to_le_bytes());
    }

    fn push_i32(out: &mut Vec<u8>, value: i32) {
        out.extend_from_slice(&value.to_le_bytes());
    }

    fn push_f32(out: &mut Vec<u8>, value: f32) {
        out.extend_from_slice(&value.to_le_bytes());
    }

    fn align_to(out: &mut Vec<u8>, align: usize) {
        while out.len() % align != 0 {
            out.push(0);
        }
    }

    fn half_bits(value: f32) -> u16 {
        if value == 0.0 {
            0
        } else if value == 1.0 {
            0x3C00
        } else {
            panic!("test helper half_bits only supports 0.0 or 1.0");
        }
    }

}
