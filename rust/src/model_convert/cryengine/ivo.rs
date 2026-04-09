use anyhow::{anyhow, Result};

use super::{
    chunks::node_mesh_combo::{parse_node_mesh_combo_chunk, IvoNodeMeshComboNode},
    ChunkType, ModelFile, ParsedChunk,
};

#[derive(Debug, Clone, Copy)]
pub struct IvoSkinChunk {
    pub header: ParsedChunk,
    pub end: usize,
}

pub fn collect_skin_chunks(model: &ModelFile, data: &[u8]) -> Result<Vec<IvoSkinChunk>> {
    let mut out = Vec::new();
    for chunk in &model.chunks {
        if !matches!(chunk.chunk_type, ChunkType::IvoSkin | ChunkType::IvoSkin2) {
            continue;
        }
        let end = model
            .chunks
            .iter()
            .map(|next| next.offset)
            .find(|offset| *offset > chunk.offset)
            .unwrap_or(data.len());
        if end <= chunk.offset || end > data.len() {
            return Err(anyhow!(
                "invalid IVO skin chunk bounds at 0x{:X}",
                chunk.offset
            ));
        }
        out.push(IvoSkinChunk {
            header: *chunk,
            end,
        });
    }
    Ok(out)
}

pub fn find_node_mesh_combo_chunk(model: &ModelFile) -> Option<ParsedChunk> {
    model
        .chunks
        .iter()
        .find(|chunk| chunk.chunk_type == ChunkType::NodeMeshCombo)
        .copied()
}

pub fn parse_node_mesh_combo_nodes(
    data: &[u8],
    chunk: ParsedChunk,
) -> Result<Vec<IvoNodeMeshComboNode>> {
    let parsed = parse_node_mesh_combo_chunk(data, chunk)?;
    Ok(parsed.nodes)
}
