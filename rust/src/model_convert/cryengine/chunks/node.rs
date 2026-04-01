use anyhow::{anyhow, Result};
use std::collections::{HashMap, HashSet};

use crate::model_convert::cryengine::cgf::{
    chunk_slice, read_f32_chunk, read_i32_chunk, skip_chunk_bytes, CgfChunkHeader,
};
use crate::model_convert::cryengine::ChunkType;

#[derive(Debug, Clone)]
pub struct CgfNodeChunk {
    pub id: i32,
    pub name: String,
    pub object_node_id: i32,
    pub parent_node_id: i32,
    pub num_children: i32,
    pub material_id: i32,
    pub local_matrix: [f32; 16],
    pub world_matrix: [f32; 16],
}

pub fn parse_cgf_node_chunks(data: &[u8], headers: &[CgfChunkHeader]) -> Result<Vec<CgfNodeChunk>> {
    let mut nodes = Vec::new();
    for header in headers {
        if header.chunk_type != ChunkType::Node {
            continue;
        }
        nodes.push(parse_cgf_node_chunk(data, *header)?);
    }

    let mut by_id = HashMap::new();
    for node in &nodes {
        by_id.insert(node.id, node.clone());
    }

    let mut cached_world = HashMap::<i32, [f32; 16]>::new();
    let mut resolving = HashSet::<i32>::new();
    let mut resolved = Vec::with_capacity(nodes.len());
    for node in nodes {
        let world_matrix =
            resolve_cgf_node_world_matrix(node.id, &by_id, &mut cached_world, &mut resolving)
                .unwrap_or(node.local_matrix);
        let mut node = node;
        node.world_matrix = world_matrix;
        resolved.push(node);
    }

    Ok(resolved)
}

fn parse_cgf_node_chunk(data: &[u8], header: CgfChunkHeader) -> Result<CgfNodeChunk> {
    let chunk = chunk_slice(data, header)?;
    if chunk.len() < 16 + 64 + 4 * 7 + 16 * 4 {
        return Err(anyhow!("node chunk too small"));
    }

    let mut cursor = 0usize;
    let name = read_fixed_string(chunk, &mut cursor, 64)?;
    let object_node_id = read_i32_chunk(chunk, &mut cursor)?;
    let parent_node_id = read_i32_chunk(chunk, &mut cursor)?;
    let num_children = read_i32_chunk(chunk, &mut cursor)?;
    let material_id = read_i32_chunk(chunk, &mut cursor)?;
    skip_chunk_bytes(chunk, &mut cursor, 4)?;

    let mut raw_matrix = [0.0f32; 16];
    for value in &mut raw_matrix {
        *value = read_f32_chunk(chunk, &mut cursor)?;
    }
    // CryEngine node matrices are consumed downstream as row-major matrices.
    // Keep the raw layout intact so world-matrix composition and TRS extraction
    // read the translation terms from the expected row-major slots.
    let local_matrix = raw_matrix;

    Ok(CgfNodeChunk {
        id: header.id,
        name,
        object_node_id,
        parent_node_id,
        num_children,
        material_id,
        local_matrix,
        world_matrix: local_matrix,
    })
}

fn resolve_cgf_node_world_matrix(
    node_id: i32,
    nodes: &HashMap<i32, CgfNodeChunk>,
    cached_world: &mut HashMap<i32, [f32; 16]>,
    resolving: &mut HashSet<i32>,
) -> Option<[f32; 16]> {
    if let Some(world) = cached_world.get(&node_id).copied() {
        return Some(world);
    }

    let node = nodes.get(&node_id)?;
    if !resolving.insert(node_id) {
        return Some(node.local_matrix);
    }

    let world = if node.parent_node_id < 0 || node.parent_node_id == node.id {
        node.local_matrix
    } else if let Some(parent_world) =
        resolve_cgf_node_world_matrix(node.parent_node_id, nodes, cached_world, resolving)
    {
        mul_4x4(parent_world, node.local_matrix)
    } else {
        node.local_matrix
    };

    resolving.remove(&node_id);
    cached_world.insert(node_id, world);
    Some(world)
}

fn read_fixed_string(chunk: &[u8], cursor: &mut usize, max_len: usize) -> Result<String> {
    let end = (*cursor)
        .checked_add(max_len)
        .ok_or_else(|| anyhow!("chunk range overflow"))?;
    if end > chunk.len() {
        return Err(anyhow!("unexpected EOF"));
    }
    let raw = &chunk[*cursor..end];
    *cursor = end;
    let nul = raw.iter().position(|&b| b == 0).unwrap_or(raw.len());
    Ok(String::from_utf8_lossy(&raw[..nul]).trim().to_string())
}

fn mul_4x4(a: [f32; 16], b: [f32; 16]) -> [f32; 16] {
    let mut out = [0.0f32; 16];
    for row in 0..4 {
        for col in 0..4 {
            out[row * 4 + col] = a[row * 4] * b[col]
                + a[row * 4 + 1] * b[4 + col]
                + a[row * 4 + 2] * b[8 + col]
                + a[row * 4 + 3] * b[12 + col];
        }
    }
    out
}
