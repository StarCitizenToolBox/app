use anyhow::{anyhow, Result};

use super::{ChunkType, FileSignature, ModelFile, ParsedChunk};

pub const CHUNK_TYPE_BASE_746: u32 = 0xCCCB_F000;
pub const CHUNK_TYPE_MESH: u32 = 0xCCCC_0000;
pub const CHUNK_TYPE_DATA_STREAM: u32 = 0xCCCC_0016;

#[derive(Debug, Clone, Copy)]
pub struct CgfChunkHeader {
    pub chunk_type: ChunkType,
    pub chunk_type_raw: u32,
    pub version: u16,
    pub id: i32,
    pub size: u32,
    pub offset: usize,
}

pub fn parse_cgf_headers(data: &[u8]) -> Result<Vec<CgfChunkHeader>> {
    let model = ModelFile::parse(data)?;
    if model.header.signature != FileSignature::CrCh {
        return Err(anyhow!("unsupported file signature: expected CrCh"));
    }

    let mut headers = Vec::with_capacity(model.chunks.len());
    for chunk in model.chunks {
        headers.push(match chunk {
            ParsedChunk {
                chunk_type_raw,
                version,
                id: Some(id),
                size: Some(size),
                offset,
                ..
            } => CgfChunkHeader {
                chunk_type: ChunkType::from_raw(chunk_type_raw),
                chunk_type_raw,
                version: version as u16,
                id,
                size,
                offset,
            },
            ParsedChunk {
                chunk_type_raw,
                version,
                offset,
                ..
            } => CgfChunkHeader {
                chunk_type: ChunkType::from_raw(chunk_type_raw),
                chunk_type_raw,
                version: version as u16,
                id: -1,
                size: 0,
                offset,
            },
        });
    }
    Ok(headers)
}

pub fn find_chunk_by_id(headers: &[CgfChunkHeader], id: i32) -> Option<&CgfChunkHeader> {
    headers.iter().find(|h| h.id == id)
}

pub fn chunk_slice<'a>(data: &'a [u8], header: CgfChunkHeader) -> Result<&'a [u8]> {
    let offset = header.offset;
    let size = header.size as usize;
    let end = offset
        .checked_add(size)
        .ok_or_else(|| anyhow!("chunk range overflow"))?;
    if end > data.len() {
        return Err(anyhow!(
            "unsupported chunk format: chunk range is out of file"
        ));
    }
    Ok(&data[offset..end])
}

pub fn read_u16_le(data: &[u8], offset: usize) -> Result<u16> {
    let bytes: [u8; 2] = data
        .get(offset..offset + 2)
        .ok_or_else(|| anyhow!("unexpected EOF"))?
        .try_into()
        .map_err(|_| anyhow!("unexpected EOF"))?;
    Ok(u16::from_le_bytes(bytes))
}

pub fn read_i32_le(data: &[u8], offset: usize) -> Result<i32> {
    let bytes: [u8; 4] = data
        .get(offset..offset + 4)
        .ok_or_else(|| anyhow!("unexpected EOF"))?
        .try_into()
        .map_err(|_| anyhow!("unexpected EOF"))?;
    Ok(i32::from_le_bytes(bytes))
}

pub fn read_u32_le(data: &[u8], offset: usize) -> Result<u32> {
    let bytes: [u8; 4] = data
        .get(offset..offset + 4)
        .ok_or_else(|| anyhow!("unexpected EOF"))?
        .try_into()
        .map_err(|_| anyhow!("unexpected EOF"))?;
    Ok(u32::from_le_bytes(bytes))
}

pub fn read_u16_from(data: &[u8], offset: usize) -> Result<u16> {
    read_u16_le(data, offset)
}

pub fn read_i16_from(data: &[u8], offset: usize) -> Result<i16> {
    let bytes: [u8; 2] = data
        .get(offset..offset + 2)
        .ok_or_else(|| anyhow!("unexpected EOF"))?
        .try_into()
        .map_err(|_| anyhow!("unexpected EOF"))?;
    Ok(i16::from_le_bytes(bytes))
}

pub fn read_u32_from(data: &[u8], offset: usize) -> Result<u32> {
    read_u32_le(data, offset)
}

pub fn read_f32_from(data: &[u8], offset: usize) -> Result<f32> {
    Ok(f32::from_bits(read_u32_from(data, offset)?))
}

pub fn read_i32_chunk(chunk: &[u8], cursor: &mut usize) -> Result<i32> {
    let value = read_i32_le(chunk, *cursor)?;
    *cursor += 4;
    Ok(value)
}

pub fn read_u32_chunk(chunk: &[u8], cursor: &mut usize) -> Result<u32> {
    let value = read_u32_le(chunk, *cursor)?;
    *cursor += 4;
    Ok(value)
}

pub fn read_f32_chunk(chunk: &[u8], cursor: &mut usize) -> Result<f32> {
    let value = read_f32_from(chunk, *cursor)?;
    *cursor += 4;
    Ok(value)
}

pub fn swap_axes_4x4(m: [f32; 16]) -> [f32; 16] {
    [
        m[0], -m[2], -m[1], -m[3], //
        -m[8], m[10], m[9], m[11], //
        -m[4], m[6], m[5], m[7], //
        -m[12], m[14], m[13], m[15],
    ]
}

pub fn row_major_4x4_to_gltf_column_major(m: [f32; 16]) -> [f32; 16] {
    [
        m[0], m[4], m[8], m[12], //
        m[1], m[5], m[9], m[13], //
        m[2], m[6], m[10], m[14], //
        m[3], m[7], m[11], m[15],
    ]
}

pub fn gltf_trs_from_row_major_matrix(m: [f32; 16]) -> ([f32; 3], [f32; 4], [f32; 3]) {
    let translation = swap_axes_for_position([m[3], m[7], m[11]]);
    let rotation = [
        [m[0], m[1], m[2]],
        [m[4], m[5], m[6]],
        [m[8], m[9], m[10]],
    ];
    let rotation = swap_axes_for_layout(matrix3_to_quaternion(rotation));
    (translation, rotation, [1.0, 1.0, 1.0])
}

pub fn gltf_trs_from_rotation_translation(
    rotation: [[f32; 3]; 3],
    translation: [f32; 3],
) -> ([f32; 3], [f32; 4], [f32; 3]) {
    (
        swap_axes_for_position(translation),
        swap_axes_for_layout(matrix3_to_quaternion(rotation)),
        [1.0, 1.0, 1.0],
    )
}

fn swap_axes_for_position(val: [f32; 3]) -> [f32; 3] {
    [-val[0], val[2], val[1]]
}

fn swap_axes_for_layout(val: [f32; 4]) -> [f32; 4] {
    [-val[0], -val[2], val[1], val[3]]
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

pub fn skip_chunk_bytes(chunk: &[u8], cursor: &mut usize, count: usize) -> Result<()> {
    let end = (*cursor)
        .checked_add(count)
        .ok_or_else(|| anyhow!("chunk range overflow"))?;
    if end > chunk.len() {
        return Err(anyhow!("unexpected EOF"));
    }
    *cursor = end;
    Ok(())
}
