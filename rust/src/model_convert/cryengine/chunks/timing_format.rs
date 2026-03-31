use anyhow::{anyhow, Result};

use crate::model_convert::cryengine::cgf::{
    chunk_slice, read_f32_chunk, read_i32_chunk, CgfChunkHeader,
};
use crate::model_convert::cryengine::ChunkType;

#[derive(Debug, Clone, Default)]
pub struct RangeEntity {
    pub name: String,
    pub start: i32,
    pub end: i32,
}

#[derive(Debug, Clone)]
pub struct CgfTimingFormatChunk {
    pub id: i32,
    pub secs_per_tick: f32,
    pub ticks_per_frame: i32,
    pub global_range: RangeEntity,
    pub num_sub_ranges: i32,
}

pub fn parse_timing_format_chunk(data: &[u8], header: CgfChunkHeader) -> Result<CgfTimingFormatChunk> {
    if !matches!(header.chunk_type, ChunkType::Timing) {
        return Err(anyhow!("chunk is not a Timing chunk"));
    }

    let chunk = chunk_slice(data, header)?;
    let mut cursor = 0usize;
    let secs_per_tick = read_f32_chunk(chunk, &mut cursor)?;
    let ticks_per_frame = read_i32_chunk(chunk, &mut cursor)?;
    let name = read_fixed_string(chunk, &mut cursor, 32)?;
    let start = read_i32_chunk(chunk, &mut cursor)?;
    let end = read_i32_chunk(chunk, &mut cursor)?;

    Ok(CgfTimingFormatChunk {
        id: header.id,
        secs_per_tick,
        ticks_per_frame,
        global_range: RangeEntity { name, start, end },
        num_sub_ranges: 0,
    })
}

fn read_fixed_string(chunk: &[u8], cursor: &mut usize, len: usize) -> Result<String> {
    let end = (*cursor)
        .checked_add(len)
        .ok_or_else(|| anyhow!("chunk range overflow"))?;
    if end > chunk.len() {
        return Err(anyhow!("unexpected EOF"));
    }
    let raw = &chunk[*cursor..end];
    *cursor = end;
    let nul = raw.iter().position(|&b| b == 0).unwrap_or(raw.len());
    Ok(String::from_utf8_lossy(&raw[..nul]).trim().to_string())
}
