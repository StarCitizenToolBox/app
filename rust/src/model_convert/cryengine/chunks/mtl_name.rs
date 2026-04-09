use anyhow::{anyhow, Result};

use crate::model_convert::cryengine::cgf::{
    chunk_slice, read_u32_from, skip_chunk_bytes, CgfChunkHeader,
};
use crate::model_convert::cryengine::ChunkType;

#[derive(Debug, Clone)]
pub struct CgfMtlNameChunk {
    pub id: i32,
    pub name: String,
    pub num_children: u32,
    pub child_ids: Vec<u32>,
    pub child_names: Vec<String>,
    pub mat_type: Option<u32>,
    pub physics_types: Vec<u32>,
    pub asset_id: Option<String>,
}

pub fn parse_cgf_mtl_name_chunks(
    data: &[u8],
    headers: &[CgfChunkHeader],
) -> Result<Vec<CgfMtlNameChunk>> {
    let mut chunks = Vec::new();
    for header in headers {
        if header.chunk_type != ChunkType::MtlName {
            continue;
        }
        chunks.push(parse_mtl_name_chunk(data, *header)?);
    }
    Ok(chunks)
}

fn parse_mtl_name_chunk(data: &[u8], header: CgfChunkHeader) -> Result<CgfMtlNameChunk> {
    let chunk = chunk_slice(data, header)?;
    let mut cursor = 0usize;

    match header.version {
        0x0800 => {
            let mat_type = read_u32_from(chunk, cursor)?;
            cursor += 4;
            let _flags2 = read_u32_from(chunk, cursor)?;
            cursor += 4;
            let name = read_fixed_string(chunk, &mut cursor, 128)?;
            let physics_type = read_u32_from(chunk, cursor)?;
            cursor += 4;
            let num_children = read_u32_from(chunk, cursor)?;
            cursor += 4;
            let mut child_ids = Vec::with_capacity(num_children as usize);
            for _ in 0..num_children {
                child_ids.push(read_u32_from(chunk, cursor)?);
                cursor += 4;
            }
            skip_chunk_bytes(chunk, &mut cursor, 32)?;
            Ok(CgfMtlNameChunk {
                id: header.id,
                name,
                num_children,
                child_ids,
                child_names: Vec::new(),
                mat_type: Some(mat_type),
                physics_types: vec![physics_type],
                asset_id: None,
            })
        }
        0x0802 => {
            let name = read_fixed_string(chunk, &mut cursor, 128)?;
            let num_children = read_u32_from(chunk, cursor)?;
            cursor += 4;
            let mut physics_types = Vec::with_capacity(num_children as usize);
            for _ in 0..num_children {
                physics_types.push(read_u32_from(chunk, cursor)?);
                cursor += 4;
            }
            Ok(CgfMtlNameChunk {
                id: header.id,
                name,
                num_children,
                child_ids: Vec::new(),
                child_names: Vec::new(),
                mat_type: None,
                physics_types,
                asset_id: None,
            })
        }
        0x0804 => {
            let asset_id = read_fixed_string(chunk, &mut cursor, 38)?;
            let name = if asset_id.is_empty() {
                "unknown".to_string()
            } else {
                asset_id.clone()
            };
            skip_chunk_bytes(chunk, &mut cursor, 26)?;
            let num_children = read_u32_from(chunk, cursor)?;
            cursor += 4;
            if num_children > 0 {
                skip_chunk_bytes(chunk, &mut cursor, (num_children as usize) * 4)?;
            }
            let mut child_names = Vec::with_capacity(num_children as usize + 1);
            if cursor < chunk.len() {
                child_names.push(read_cstring(chunk, &mut cursor)?);
            }
            for _ in 0..num_children {
                if cursor >= chunk.len() {
                    break;
                }
                child_names.push(read_cstring(chunk, &mut cursor)?);
            }
            Ok(CgfMtlNameChunk {
                id: header.id,
                name,
                num_children,
                child_ids: Vec::new(),
                child_names,
                mat_type: None,
                physics_types: Vec::new(),
                asset_id: if asset_id.is_empty() {
                    None
                } else {
                    Some(asset_id)
                },
            })
        }
        _ => {
            let name = read_fixed_string(chunk, &mut cursor, 128).unwrap_or_default();
            Ok(CgfMtlNameChunk {
                id: header.id,
                name,
                num_children: 0,
                child_ids: Vec::new(),
                child_names: Vec::new(),
                mat_type: None,
                physics_types: Vec::new(),
                asset_id: None,
            })
        }
    }
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

fn read_cstring(chunk: &[u8], cursor: &mut usize) -> Result<String> {
    if *cursor >= chunk.len() {
        return Err(anyhow!("unexpected EOF"));
    }
    let start = *cursor;
    let mut end = start;
    while end < chunk.len() && chunk[end] != 0 {
        end += 1;
    }
    *cursor = if end < chunk.len() { end + 1 } else { end };
    Ok(String::from_utf8_lossy(&chunk[start..end]).to_string())
}
