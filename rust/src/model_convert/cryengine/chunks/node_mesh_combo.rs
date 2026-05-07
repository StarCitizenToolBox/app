use anyhow::{Result, anyhow};
use std::collections::HashMap;

use crate::model_convert::cryengine::{ChunkType, ModelFile, ParsedChunk};

#[derive(Debug, Clone, Copy)]
pub struct IvoNodeMeshComboNode {
    pub node_index: u16,
    pub parent_index: Option<u16>,
    pub world_to_bone: [f32; 12],
    pub bone_to_world: [f32; 12],
    pub mesh_chunk_id: u16,
    pub geometry_type: u16,
}

#[derive(Debug, Clone, Copy)]
pub struct NodeTransform {
    pub rotation: [[f32; 3]; 3],
    pub translation: [f32; 3],
}

#[derive(Debug, Clone)]
pub struct IvoNodeMeshComboChunk {
    pub header: ParsedChunk,
    pub zero_pad: i32,
    pub number_of_nodes: usize,
    pub number_of_meshes: i32,
    pub unknown2: usize,
    pub number_of_mesh_subsets: usize,
    pub string_table_size: i32,
    pub unknown1: i32,
    pub unknown3: i32,
    pub nodes: Vec<IvoNodeMeshComboNode>,
    pub unknown_indices: Vec<u16>,
    pub material_indices: Vec<u16>,
    pub node_names: Vec<String>,
}

pub fn parse_node_mesh_combo_chunk(
    data: &[u8],
    header: ParsedChunk,
) -> Result<IvoNodeMeshComboChunk> {
    if !matches!(header.chunk_type, ChunkType::NodeMeshCombo) {
        return Err(anyhow!("chunk is not a NodeMeshCombo chunk"));
    }

    let model = ModelFile::parse(data)?;
    let chunk_index = model
        .chunks
        .iter()
        .position(|chunk| {
            chunk.offset == header.offset
                && chunk.chunk_type_raw == header.chunk_type_raw
                && chunk.version == header.version
        })
        .ok_or_else(|| anyhow!("NodeMeshCombo chunk not found in chunk table"))?;
    let (start, end) = model.chunk_data_bounds(data, chunk_index)?;
    let chunk = data
        .get(start..end)
        .ok_or_else(|| anyhow!("unexpected EOF while reading NodeMeshCombo"))?;
    let mut cursor = 0usize;

    let zero_pad = read_i32_le(chunk, cursor)?;
    cursor += 4;
    let number_of_nodes = read_i32_le(chunk, cursor)?.max(0) as usize;
    cursor += 4;
    let number_of_meshes = read_i32_le(chunk, cursor)?;
    cursor += 4;
    let unknown2 = read_i32_le(chunk, cursor)?.max(0) as usize;
    cursor += 4;
    let number_of_mesh_subsets = read_i32_le(chunk, cursor)?.max(0) as usize;
    cursor += 4;
    let string_table_size = read_i32_le(chunk, cursor)?;
    cursor += 4;
    let unknown1 = read_i32_le(chunk, cursor)?;
    cursor += 4;
    let unknown3 = read_i32_le(chunk, cursor)?;
    cursor += 4;

    let mut nodes = Vec::with_capacity(number_of_nodes);
    for node_index in 0..number_of_nodes {
        ensure_within(chunk.len(), cursor, 208)?;
        cursor += 32; // pre-matrix metadata
        let world_to_bone = read_matrix3x4(chunk, cursor)?;
        cursor += 48;
        let bone_to_world = read_matrix3x4(chunk, cursor)?;
        cursor += 48;
        cursor += 12; // scale component
        cursor += 4; // id
        cursor += 4; // unknown2
        let parent_index_raw = read_u16_le(chunk, cursor)?;
        cursor += 2;
        let geometry_type = read_u16_le(chunk, cursor)?;
        cursor += 2;
        cursor += 56; // bbox and remaining node metadata

        nodes.push(IvoNodeMeshComboNode {
            node_index: node_index as u16,
            parent_index: if parent_index_raw == 0xFFFF {
                None
            } else {
                Some(parent_index_raw)
            },
            world_to_bone,
            bone_to_world,
            mesh_chunk_id: 0,
            geometry_type,
        });
    }

    cursor += 32; // post-node table footer before index tables

    let mut unknown_indices = Vec::with_capacity(unknown2);
    for _ in 0..unknown2 {
        unknown_indices.push(read_u16_le(chunk, cursor)?);
        cursor += 2;
    }

    let mut material_indices = Vec::with_capacity(number_of_mesh_subsets);
    for _ in 0..number_of_mesh_subsets {
        material_indices.push(read_u16_le(chunk, cursor)?);
        cursor += 2;
    }

    let mut node_names = Vec::with_capacity(number_of_nodes);
    for _ in 0..number_of_nodes {
        let mut bytes = Vec::new();
        loop {
            let byte = *chunk
                .get(cursor)
                .ok_or_else(|| anyhow!("unexpected EOF while reading NodeNames"))?;
            cursor += 1;
            if byte == 0 {
                break;
            }
            bytes.push(byte);
        }
        node_names.push(String::from_utf8_lossy(&bytes).to_string());
    }

    Ok(IvoNodeMeshComboChunk {
        header,
        zero_pad,
        number_of_nodes,
        number_of_meshes,
        unknown2,
        number_of_mesh_subsets,
        string_table_size,
        unknown1,
        unknown3,
        nodes,
        unknown_indices,
        material_indices,
        node_names,
    })
}

pub fn resolve_node_mesh_combo_transforms(
    data: &[u8],
    header: ParsedChunk,
) -> Result<HashMap<u16, NodeTransform>> {
    let parsed = parse_node_mesh_combo_chunk(data, header)?;
    let mut transforms = HashMap::<u16, NodeTransform>::new();
    for node in &parsed.nodes {
        let world = matrix3x4_to_transform(&node.bone_to_world);
        let local = node
            .parent_index
            .and_then(|parent_index| parsed.nodes.get(parent_index as usize))
            .map(|parent| {
                let parent_world = matrix3x4_to_transform(&parent.bone_to_world);
                world_to_local_transform(parent_world, world)
            })
            .unwrap_or(world);
        transforms.insert(node.node_index, local);
    }
    Ok(transforms)
}

pub fn node_mesh_combo_node_name(node_index: u16, fallback_index: usize) -> Option<String> {
    if node_index == u16::MAX {
        None
    } else {
        Some(format!("ivo_node_{}", fallback_index))
    }
}

pub fn node_transform_to_gltf_matrix(transform: NodeTransform) -> [f32; 16] {
    let r = convert_rotation_axes(transform.rotation);
    let t = swap_axes_for_position(transform.translation);
    [
        r[0][0], r[1][0], r[2][0], 0.0, //
        r[0][1], r[1][1], r[2][1], 0.0, //
        r[0][2], r[1][2], r[2][2], 0.0, //
        t[0], t[1], t[2], 1.0,
    ]
}

pub fn node_transform_to_gltf_trs(transform: NodeTransform) -> ([f32; 3], [f32; 4], [f32; 3]) {
    let translation = swap_axes_for_position(transform.translation);
    let rotation = matrix3_to_quaternion(convert_rotation_axes(transform.rotation));
    (translation, rotation, [1.0, 1.0, 1.0])
}

fn swap_axes_for_position(val: [f32; 3]) -> [f32; 3] {
    [val[0], val[2], -val[1]]
}

fn convert_rotation_axes(r: [[f32; 3]; 3]) -> [[f32; 3]; 3] {
    [
        [r[0][0], r[0][2], -r[0][1]],
        [r[2][0], r[2][2], -r[2][1]],
        [-r[1][0], -r[1][2], r[1][1]],
    ]
}

fn matrix3_to_quaternion(m: [[f32; 3]; 3]) -> [f32; 4] {
    let trace = m[0][0] + m[1][1] + m[2][2];
    let (x, y, z, w);
    if trace > 0.0 {
        let s = (trace + 1.0).sqrt() * 2.0;
        w = 0.25 * s;
        x = (m[2][1] - m[1][2]) / s;
        y = (m[0][2] - m[2][0]) / s;
        z = (m[1][0] - m[0][1]) / s;
    } else if m[0][0] > m[1][1] && m[0][0] > m[2][2] {
        let s = (1.0 + m[0][0] - m[1][1] - m[2][2]).sqrt() * 2.0;
        w = (m[2][1] - m[1][2]) / s;
        x = 0.25 * s;
        y = (m[0][1] + m[1][0]) / s;
        z = (m[0][2] + m[2][0]) / s;
    } else if m[1][1] > m[2][2] {
        let s = (1.0 + m[1][1] - m[0][0] - m[2][2]).sqrt() * 2.0;
        w = (m[0][2] - m[2][0]) / s;
        x = (m[0][1] + m[1][0]) / s;
        y = 0.25 * s;
        z = (m[1][2] + m[2][1]) / s;
    } else {
        let s = (1.0 + m[2][2] - m[0][0] - m[1][1]).sqrt() * 2.0;
        w = (m[1][0] - m[0][1]) / s;
        x = (m[0][2] + m[2][0]) / s;
        y = (m[1][2] + m[2][1]) / s;
        z = 0.25 * s;
    }
    [x, y, z, w]
}

fn ensure_within(total_len: usize, start: usize, size: usize) -> Result<()> {
    let end = start
        .checked_add(size)
        .ok_or_else(|| anyhow!("offset overflow"))?;
    if end > total_len {
        return Err(anyhow!("unexpected EOF while reading chunk payload"));
    }
    Ok(())
}

fn read_u16_le(data: &[u8], offset: usize) -> Result<u16> {
    let bytes = data
        .get(offset..offset + 2)
        .ok_or_else(|| anyhow!("unexpected EOF while reading u16"))?;
    Ok(u16::from_le_bytes([bytes[0], bytes[1]]))
}

fn read_i32_le(data: &[u8], offset: usize) -> Result<i32> {
    let bytes = data
        .get(offset..offset + 4)
        .ok_or_else(|| anyhow!("unexpected EOF while reading i32"))?;
    Ok(i32::from_le_bytes([bytes[0], bytes[1], bytes[2], bytes[3]]))
}

fn read_f32_le(data: &[u8], offset: usize) -> Result<f32> {
    let bytes = data
        .get(offset..offset + 4)
        .ok_or_else(|| anyhow!("unexpected EOF while reading f32"))?;
    Ok(f32::from_bits(u32::from_le_bytes([
        bytes[0], bytes[1], bytes[2], bytes[3],
    ])))
}

fn read_matrix3x4(data: &[u8], offset: usize) -> Result<[f32; 12]> {
    let mut out = [0f32; 12];
    for (i, slot) in out.iter_mut().enumerate() {
        *slot = read_f32_le(data, offset + i * 4)?;
    }
    Ok(out)
}

fn matrix3x4_to_transform(m: &[f32; 12]) -> NodeTransform {
    let rotation = [[m[0], m[1], m[2]], [m[4], m[5], m[6]], [m[8], m[9], m[10]]];
    let translation = [m[3], m[7], m[11]];
    NodeTransform {
        rotation,
        translation,
    }
}

fn world_to_local_transform(parent: NodeTransform, child: NodeTransform) -> NodeTransform {
    let parent_inv_rotation = transpose3(parent.rotation);
    let child_offset = [
        child.translation[0] - parent.translation[0],
        child.translation[1] - parent.translation[1],
        child.translation[2] - parent.translation[2],
    ];
    NodeTransform {
        rotation: mul3(parent_inv_rotation, child.rotation),
        translation: mul3_vec(parent_inv_rotation, child_offset),
    }
}

fn transpose3(m: [[f32; 3]; 3]) -> [[f32; 3]; 3] {
    [
        [m[0][0], m[1][0], m[2][0]],
        [m[0][1], m[1][1], m[2][1]],
        [m[0][2], m[1][2], m[2][2]],
    ]
}

fn mul3(a: [[f32; 3]; 3], b: [[f32; 3]; 3]) -> [[f32; 3]; 3] {
    [
        [
            a[0][0] * b[0][0] + a[0][1] * b[1][0] + a[0][2] * b[2][0],
            a[0][0] * b[0][1] + a[0][1] * b[1][1] + a[0][2] * b[2][1],
            a[0][0] * b[0][2] + a[0][1] * b[1][2] + a[0][2] * b[2][2],
        ],
        [
            a[1][0] * b[0][0] + a[1][1] * b[1][0] + a[1][2] * b[2][0],
            a[1][0] * b[0][1] + a[1][1] * b[1][1] + a[1][2] * b[2][1],
            a[1][0] * b[0][2] + a[1][1] * b[1][2] + a[1][2] * b[2][2],
        ],
        [
            a[2][0] * b[0][0] + a[2][1] * b[1][0] + a[2][2] * b[2][0],
            a[2][0] * b[0][1] + a[2][1] * b[1][1] + a[2][2] * b[2][1],
            a[2][0] * b[0][2] + a[2][1] * b[1][2] + a[2][2] * b[2][2],
        ],
    ]
}

fn mul3_vec(m: [[f32; 3]; 3], v: [f32; 3]) -> [f32; 3] {
    [
        m[0][0] * v[0] + m[0][1] * v[1] + m[0][2] * v[2],
        m[1][0] * v[0] + m[1][1] * v[1] + m[1][2] * v[2],
        m[2][0] * v[0] + m[2][1] * v[1] + m[2][2] * v[2],
    ]
}

#[cfg(test)]
mod tests {
    use super::*;

    fn identity_at(translation: [f32; 3]) -> NodeTransform {
        NodeTransform {
            rotation: [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]],
            translation,
        }
    }

    #[test]
    fn world_to_local_transform_removes_parent_translation() {
        let local =
            world_to_local_transform(identity_at([10.0, 0.0, 0.0]), identity_at([12.0, 3.0, 4.0]));
        assert_eq!(local.translation, [2.0, 3.0, 4.0]);
    }

    #[test]
    fn world_to_local_transform_removes_parent_rotation() {
        let parent = NodeTransform {
            rotation: [[0.0, -1.0, 0.0], [1.0, 0.0, 0.0], [0.0, 0.0, 1.0]],
            translation: [0.0, 0.0, 0.0],
        };
        let child = identity_at([0.0, 2.0, 0.0]);
        let local = world_to_local_transform(parent, child);
        assert!((local.translation[0] - 2.0).abs() < 0.0001);
        assert!(local.translation[1].abs() < 0.0001);
        assert!(local.translation[2].abs() < 0.0001);
    }
}
