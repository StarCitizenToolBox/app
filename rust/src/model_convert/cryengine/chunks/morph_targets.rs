use anyhow::{anyhow, Result};

use crate::model_convert::cryengine::cgf::{
    chunk_slice, read_f32_from, read_u32_chunk, CgfChunkHeader,
};
use crate::model_convert::cryengine::ChunkType;

#[derive(Debug, Clone, Copy)]
pub struct MeshMorphTargetVertex {
    pub vertex_id: u32,
    pub vertex: [f32; 3],
}

#[derive(Debug, Clone)]
pub struct CgfCompiledMorphTargetsChunk {
    pub id: i32,
    pub number_of_morph_targets: u32,
    pub morph_target_vertices: Vec<MeshMorphTargetVertex>,
}

pub fn parse_compiled_morph_targets_chunk(
    data: &[u8],
    header: CgfChunkHeader,
) -> Result<CgfCompiledMorphTargetsChunk> {
    if !matches!(
        header.chunk_type,
        ChunkType::CompiledMorphTargets | ChunkType::CompiledMorphTargetsSc
    ) {
        return Err(anyhow!("chunk is not a CompiledMorphTargets chunk"));
    }

    let chunk = chunk_slice(data, header)?;
    let mut cursor = 0usize;
    let number_of_morph_targets = read_u32_chunk(chunk, &mut cursor)?;
    let mut morph_target_vertices = Vec::new();
    if number_of_morph_targets > 0 {
        morph_target_vertices.reserve(number_of_morph_targets as usize);
        for _ in 0..number_of_morph_targets {
            morph_target_vertices.push(read_morph_target_vertex(chunk, &mut cursor)?);
        }
    }

    Ok(CgfCompiledMorphTargetsChunk {
        id: header.id,
        number_of_morph_targets,
        morph_target_vertices,
    })
}

fn read_morph_target_vertex(chunk: &[u8], cursor: &mut usize) -> Result<MeshMorphTargetVertex> {
    let vertex_id = read_u32_chunk(chunk, cursor)?;
    let vertex = [
        read_f32_from(chunk, *cursor)?,
        read_f32_from(chunk, *cursor + 4)?,
        read_f32_from(chunk, *cursor + 8)?,
    ];
    *cursor += 12;
    Ok(MeshMorphTargetVertex { vertex_id, vertex })
}
