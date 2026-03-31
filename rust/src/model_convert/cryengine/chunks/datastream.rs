use anyhow::{anyhow, Result};

use crate::model_convert::cryengine::cgf::{
    chunk_slice, find_chunk_by_id, read_f32_from, read_i16_from, read_u16_from, read_u32_from,
    CgfChunkHeader, CHUNK_TYPE_DATA_STREAM,
};

pub const STREAM_VERTICES: u32 = 0;
pub const STREAM_NORMALS: u32 = 1;
pub const STREAM_UVS: u32 = 2;
pub const STREAM_INDICES: u32 = 5;
pub const STREAM_VERTS_UVS: u32 = 15;

pub(crate) fn parse_positions_stream(
    data: &[u8],
    headers: &[CgfChunkHeader],
    chunk_id: i32,
    expected_count: usize,
) -> Result<Vec<[f32; 3]>> {
    let (stream_type, num_elements, bytes_per_element, _sc_flag, payload) =
        parse_datastream_chunk(data, headers, chunk_id)?;
    if stream_type != STREAM_VERTICES {
        return Err(anyhow!(
            "unsupported data stream type: expected {}, got {}",
            STREAM_VERTICES,
            stream_type
        ));
    }
    if num_elements != expected_count {
        return Err(anyhow!(
            "mesh/data stream mismatch: expected {expected_count} elements, got {num_elements}"
        ));
    }

    let mut out = Vec::with_capacity(num_elements);
    match bytes_per_element {
        12 => {
            let needed = num_elements
                .checked_mul(12usize)
                .ok_or_else(|| anyhow!("data stream size overflow"))?;
            if payload.len() < needed {
                return Err(anyhow!("unsupported data stream format: payload truncated"));
            }
            for i in 0..num_elements {
                let base = i * 12;
                out.push([
                    read_f32_from(payload, base)?,
                    read_f32_from(payload, base + 4)?,
                    read_f32_from(payload, base + 8)?,
                ]);
            }
        }
        8 => {
            let needed = num_elements
                .checked_mul(8usize)
                .ok_or_else(|| anyhow!("data stream size overflow"))?;
            if payload.len() < needed {
                return Err(anyhow!("unsupported data stream format: payload truncated"));
            }
            for i in 0..num_elements {
                let base = i * 8;
                out.push([
                    half_to_f32(read_u16_from(payload, base)?),
                    half_to_f32(read_u16_from(payload, base + 2)?),
                    half_to_f32(read_u16_from(payload, base + 4)?),
                ]);
            }
        }
        16 => {
            let needed = num_elements
                .checked_mul(16usize)
                .ok_or_else(|| anyhow!("data stream size overflow"))?;
            if payload.len() < needed {
                return Err(anyhow!("unsupported data stream format: payload truncated"));
            }
            for i in 0..num_elements {
                let base = i * 16;
                out.push([
                    read_f32_from(payload, base)?,
                    read_f32_from(payload, base + 4)?,
                    read_f32_from(payload, base + 8)?,
                ]);
            }
        }
        4 => {
            out.resize(num_elements, [0.0, 0.0, 0.0]);
        }
        _ => {
            return Err(anyhow!(
                "unsupported data stream format: vertices bytes-per-element={bytes_per_element}"
            ))
        }
    }
    Ok(out)
}

pub(crate) fn parse_normals_stream(
    data: &[u8],
    headers: &[CgfChunkHeader],
    chunk_id: i32,
    expected_count: usize,
) -> Result<Vec<[f32; 3]>> {
    let (stream_type, num_elements, bytes_per_element, _sc_flag, payload) =
        parse_datastream_chunk(data, headers, chunk_id)?;
    if stream_type != STREAM_NORMALS {
        return Err(anyhow!(
            "unsupported data stream type: expected {}, got {}",
            STREAM_NORMALS,
            stream_type
        ));
    }
    if num_elements != expected_count {
        return Err(anyhow!(
            "mesh/data stream mismatch: expected {expected_count} elements, got {num_elements}"
        ));
    }

    let mut out = Vec::with_capacity(num_elements);
    match bytes_per_element {
        12 => {
            let needed = num_elements
                .checked_mul(12usize)
                .ok_or_else(|| anyhow!("data stream size overflow"))?;
            if payload.len() < needed {
                return Err(anyhow!("unsupported data stream format: payload truncated"));
            }
            for i in 0..num_elements {
                let base = i * 12;
                out.push([
                    read_f32_from(payload, base)?,
                    read_f32_from(payload, base + 4)?,
                    read_f32_from(payload, base + 8)?,
                ]);
            }
        }
        6 => {
            let needed = num_elements
                .checked_mul(6usize)
                .ok_or_else(|| anyhow!("data stream size overflow"))?;
            if payload.len() < needed {
                return Err(anyhow!("unsupported data stream format: payload truncated"));
            }
            for i in 0..num_elements {
                let base = i * 6;
                out.push([
                    snorm16_to_f32(read_i16_from(payload, base)?),
                    snorm16_to_f32(read_i16_from(payload, base + 2)?),
                    snorm16_to_f32(read_i16_from(payload, base + 4)?),
                ]);
            }
        }
        4 => {
            let needed = num_elements
                .checked_mul(4usize)
                .ok_or_else(|| anyhow!("data stream size overflow"))?;
            if payload.len() < needed {
                return Err(anyhow!("unsupported data stream format: payload truncated"));
            }
            for i in 0..num_elements {
                let base = i * 4;
                let x = cry_half_to_f32(read_u16_from(payload, base)?);
                let y = cry_half_to_f32(read_u16_from(payload, base + 2)?);
                let zz = (1.0f32 - x * x - y * y).max(0.0);
                out.push([x, y, zz.sqrt()]);
            }
        }
        _ => {
            return Err(anyhow!(
                "unsupported data stream format: normals bytes-per-element={bytes_per_element}"
            ))
        }
    }
    Ok(out)
}

pub(crate) fn parse_uv_stream(
    data: &[u8],
    headers: &[CgfChunkHeader],
    chunk_id: i32,
    expected_count: usize,
) -> Result<Vec<[f32; 2]>> {
    let (stream_type, num_elements, bytes_per_element, sc_flag, payload) =
        parse_datastream_chunk(data, headers, chunk_id)?;
    if stream_type != STREAM_UVS && stream_type != STREAM_VERTS_UVS {
        return Err(anyhow!(
            "unsupported data stream type: expected {} or {}, got {}",
            STREAM_UVS, STREAM_VERTS_UVS, stream_type
        ));
    }
    if num_elements != expected_count {
        return Err(anyhow!(
            "mesh/data stream mismatch: expected {expected_count} elements, got {num_elements}"
        ));
    }

    if stream_type == STREAM_VERTS_UVS {
        let (_, uvs) = parse_verts_uv_payload(num_elements, bytes_per_element, sc_flag, payload)?;
        return Ok(uvs);
    }

    let mut out = Vec::with_capacity(num_elements);
    match bytes_per_element {
        8 => {
            let needed = num_elements
                .checked_mul(8usize)
                .ok_or_else(|| anyhow!("data stream size overflow"))?;
            if payload.len() < needed {
                return Err(anyhow!("unsupported data stream format: payload truncated"));
            }
            for i in 0..num_elements {
                let base = i * 8;
                out.push([read_f32_from(payload, base)?, read_f32_from(payload, base + 4)?]);
            }
        }
        4 => {
            let needed = num_elements
                .checked_mul(4usize)
                .ok_or_else(|| anyhow!("data stream size overflow"))?;
            if payload.len() < needed {
                return Err(anyhow!("unsupported data stream format: payload truncated"));
            }
            for i in 0..num_elements {
                let base = i * 4;
                out.push([
                    half_to_f32(read_u16_from(payload, base)?),
                    half_to_f32(read_u16_from(payload, base + 2)?),
                ]);
            }
        }
        _ => {
            return Err(anyhow!(
                "unsupported data stream format: UV bytes-per-element={bytes_per_element}"
            ))
        }
    }
    Ok(out)
}

pub(crate) fn parse_indices_stream(
    data: &[u8],
    headers: &[CgfChunkHeader],
    chunk_id: i32,
    expected_stream_type: u32,
    expected_count: usize,
) -> Result<Vec<u32>> {
    let (stream_type, num_elements, bytes_per_element, _sc_flag, payload) =
        parse_datastream_chunk(data, headers, chunk_id)?;
    if stream_type != expected_stream_type {
        return Err(anyhow!(
            "unsupported data stream type: expected {expected_stream_type}, got {stream_type}"
        ));
    }
    if num_elements != expected_count {
        return Err(anyhow!(
            "mesh/data stream mismatch: expected {expected_count} elements, got {num_elements}"
        ));
    }

    let mut out = Vec::with_capacity(num_elements);
    match bytes_per_element {
        2 => {
            let needed = num_elements
                .checked_mul(2usize)
                .ok_or_else(|| anyhow!("data stream size overflow"))?;
            if payload.len() < needed {
                return Err(anyhow!("unsupported data stream format: payload truncated"));
            }
            for i in 0..num_elements {
                let base = i * 2;
                out.push(read_u16_from(payload, base)? as u32);
            }
        }
        4 => {
            let needed = num_elements
                .checked_mul(4usize)
                .ok_or_else(|| anyhow!("data stream size overflow"))?;
            if payload.len() < needed {
                return Err(anyhow!("unsupported data stream format: payload truncated"));
            }
            for i in 0..num_elements {
                let base = i * 4;
                out.push(read_u32_from(payload, base)?);
            }
        }
        _ => {
            return Err(anyhow!(
                "unsupported data stream format: indices bytes-per-element={bytes_per_element}"
            ))
        }
    }

    Ok(out)
}

pub(crate) fn parse_verts_uv_stream(
    data: &[u8],
    headers: &[CgfChunkHeader],
    chunk_id: i32,
    expected_count: usize,
) -> Result<(Vec<[f32; 3]>, Vec<[f32; 2]>)> {
    let (stream_type, num_elements, bytes_per_element, sc_flag, payload) =
        parse_datastream_chunk(data, headers, chunk_id)?;
    if stream_type != STREAM_VERTS_UVS {
        return Err(anyhow!(
            "unsupported data stream type: expected {}, got {}",
            STREAM_VERTS_UVS,
            stream_type
        ));
    }
    if num_elements != expected_count {
        return Err(anyhow!(
            "mesh/data stream mismatch: expected {expected_count} elements, got {num_elements}"
        ));
    }
    parse_verts_uv_payload(num_elements, bytes_per_element, sc_flag, payload)
}

pub(crate) fn parse_verts_uv_payload(
    num_elements: usize,
    bytes_per_element: u16,
    star_citizen_flag: u16,
    payload: &[u8],
) -> Result<(Vec<[f32; 3]>, Vec<[f32; 2]>)> {
    let mut positions = Vec::with_capacity(num_elements);
    let mut uvs = Vec::with_capacity(num_elements);
    match bytes_per_element {
        16 => {
            let needed = num_elements
                .checked_mul(16usize)
                .ok_or_else(|| anyhow!("data stream size overflow"))?;
            if payload.len() < needed {
                return Err(anyhow!("unsupported data stream format: payload truncated"));
            }
            for i in 0..num_elements {
                let base = i * 16;
                let read_half = if star_citizen_flag == 257 {
                    dymek_half_to_f32
                } else {
                    half_to_f32
                };
                positions.push([
                    read_half(read_u16_from(payload, base)?),
                    read_half(read_u16_from(payload, base + 2)?),
                    read_half(read_u16_from(payload, base + 4)?),
                ]);
                uvs.push([
                    half_to_f32(read_u16_from(payload, base + 12)?),
                    half_to_f32(read_u16_from(payload, base + 14)?),
                ]);
            }
        }
        20 => {
            let needed = num_elements
                .checked_mul(20usize)
                .ok_or_else(|| anyhow!("data stream size overflow"))?;
            if payload.len() < needed {
                return Err(anyhow!("unsupported data stream format: payload truncated"));
            }
            for i in 0..num_elements {
                let base = i * 20;
                positions.push([
                    read_f32_from(payload, base)?,
                    read_f32_from(payload, base + 4)?,
                    read_f32_from(payload, base + 8)?,
                ]);
                uvs.push([
                    half_to_f32(read_u16_from(payload, base + 16)?),
                    half_to_f32(read_u16_from(payload, base + 18)?),
                ]);
            }
        }
        _ => {
            return Err(anyhow!(
                "unsupported data stream format: VERTSUVS bytes-per-element={bytes_per_element}"
            ))
        }
    }
    Ok((positions, uvs))
}

pub(crate) fn parse_datastream_chunk<'a>(
    data: &'a [u8],
    headers: &[CgfChunkHeader],
    chunk_id: i32,
) -> Result<(u32, usize, u16, u16, &'a [u8])> {
    let header = find_chunk_by_id(headers, chunk_id)
        .ok_or_else(|| anyhow!("unsupported chunk reference: missing chunk id {chunk_id}"))?;
    if header.chunk_type_raw != CHUNK_TYPE_DATA_STREAM {
        return Err(anyhow!(
            "unsupported chunk reference: id {chunk_id} is not a data stream chunk"
        ));
    }

    let chunk = chunk_slice(data, *header)?;
    if chunk.len() < 24 {
        return Err(anyhow!(
            "unsupported data stream format: stream chunk too small"
        ));
    }

    let stream_type = read_u32_from(chunk, 4)?;
    let num_elements = read_u32_from(chunk, 8)? as usize;
    let bytes_per_element = read_u16_from(chunk, 12)?;
    let star_citizen_flag = read_u16_from(chunk, 14)?;
    let payload = &chunk[24..];

    Ok((
        stream_type,
        num_elements,
        bytes_per_element,
        star_citizen_flag,
        payload,
    ))
}

fn cry_half_to_f32(value: u16) -> f32 {
    let mut mantissa = (value & 0x03FF) as u32;
    let exponent = if (value & 0x7C00) != 0 {
        ((value >> 10) & 0x1F) as u32
    } else if mantissa != 0 {
        let mut e = 1u32;
        while (mantissa & 0x0400) == 0 {
            e = e.saturating_sub(1);
            mantissa <<= 1;
        }
        mantissa &= 0x03FF;
        e
    } else {
        u32::MAX - 111
    };

    let result = (((value as u32) & 0x8000) << 16) | ((exponent + 112) << 23) | (mantissa << 13);
    f32::from_bits(result)
}

fn dymek_half_to_f32(value: u16) -> f32 {
    let int_part = ((value >> 8) as u8) as i8 as f32;
    let frac_byte = (value & 0xFF) as u8;
    let mut frac = 0.0f32;
    for bit_index in 0..8 {
        if ((frac_byte >> (7 - bit_index)) & 1) == 1 {
            frac += 2f32.powi(-(bit_index + 1));
        }
    }
    (int_part + frac) / 127.0
}

fn snorm16_to_f32(v: i16) -> f32 {
    (v as f32 / 32767.0).clamp(-1.0, 1.0)
}

fn half_to_f32(bits: u16) -> f32 {
    let sign = ((bits >> 15) & 0x1) as u32;
    let exp = ((bits >> 10) & 0x1F) as u32;
    let frac = (bits & 0x03FF) as u32;

    let value_bits = if exp == 0 {
        if frac == 0 {
            sign << 31
        } else {
            let mut e = -14i32;
            let mut f = frac;
            while (f & 0x0400) == 0 {
                f <<= 1;
                e -= 1;
            }
            f &= 0x03FF;
            (sign << 31) | (((e + 127) as u32) << 23) | (f << 13)
        }
    } else if exp == 0x1F {
        (sign << 31) | 0x7F80_0000 | (frac << 13)
    } else {
        let e = exp as i32 - 15 + 127;
        (sign << 31) | ((e as u32) << 23) | (frac << 13)
    };

    f32::from_bits(value_bits)
}
