use anyhow::{anyhow, Result};

use crate::model_convert::cryengine::cgf::{
    chunk_slice, find_chunk_by_id, read_i32_le, CgfChunkHeader,
};
use crate::model_convert::ScenePrimitive;

pub(crate) fn parse_mesh_subsets_chunk(
    data: &[u8],
    headers: &[CgfChunkHeader],
    chunk_id: i32,
    expected_subset_count: usize,
    total_indices: usize,
    total_vertices: usize,
) -> Result<Vec<ScenePrimitive>> {
    let header = find_chunk_by_id(headers, chunk_id)
        .ok_or_else(|| anyhow!("missing mesh subsets chunk id {chunk_id}"))?;
    let chunk = chunk_slice(data, *header)?;
    if chunk.len() < 20 {
        return Err(anyhow!("mesh subsets chunk too small"));
    }

    let stride_candidates = [20usize, 24, 32, 36, 40];
    let header_candidates = [0usize, 4, 8, 12];
    let mut best = Vec::<ScenePrimitive>::new();

    for stride in stride_candidates {
        for header_size in header_candidates {
            if header_size >= chunk.len() || (chunk.len() - header_size) < stride {
                continue;
            }

            let candidate_count = if expected_subset_count > 0 {
                expected_subset_count
            } else {
                (chunk.len() - header_size) / stride
            };
            if candidate_count == 0 {
                continue;
            }
            if header_size + candidate_count * stride > chunk.len() {
                continue;
            }

            let mut parsed = Vec::new();
            for i in 0..candidate_count {
                let base = header_size + i * stride;
                let first_index = read_i32_le(chunk, base)?;
                let num_indices = read_i32_le(chunk, base + 4)?;
                let first_vertex = read_i32_le(chunk, base + 8)?;
                let num_vertices = read_i32_le(chunk, base + 12)?;
                let material_id = read_i32_le(chunk, base + 16)?;
                if first_index < 0 || num_indices <= 0 || first_vertex < 0 || num_vertices <= 0 {
                    continue;
                }
                let first_index = first_index as usize;
                let num_indices = num_indices as usize;
                let first_vertex = first_vertex as usize;
                let num_vertices = num_vertices as usize;
                if first_index.saturating_add(num_indices) > total_indices {
                    continue;
                }
                if first_vertex.saturating_add(num_vertices) > total_vertices {
                    continue;
                }

                parsed.push(ScenePrimitive {
                    first_index: first_index as u32,
                    num_indices: num_indices as u32,
                    first_vertex: first_vertex as u32,
                    num_vertices: num_vertices as u32,
                    material_id,
                });
            }

            if parsed.len() > best.len() {
                best = parsed;
            }
        }
    }

    if best.is_empty() {
        return Err(anyhow!("no valid subset entries"));
    }
    Ok(best)
}
