use anyhow::{anyhow, Result};

use super::types::{WwiseCodec, WwiseHeader};

fn read_u16_le(data: &[u8], offset: usize) -> Option<u16> {
    data.get(offset..offset + 2)
        .map(|s| u16::from_le_bytes([s[0], s[1]]))
}

fn read_u32_le(data: &[u8], offset: usize) -> Option<u32> {
    data.get(offset..offset + 4)
        .map(|s| u32::from_le_bytes([s[0], s[1], s[2], s[3]]))
}

pub(super) fn parse_wem_header(wem: &[u8]) -> Result<WwiseHeader> {
    if wem.len() < 44 {
        return Err(anyhow!("wem file too small"));
    }

    if &wem[0..4] != b"RIFF" || &wem[8..12] != b"WAVE" {
        return Err(anyhow!("invalid wem header (not RIFF/WAVE)"));
    }

    let mut codec = WwiseCodec::Unsupported(0);
    let mut channels = 0u16;
    let mut sample_rate = 0u32;
    let mut avg_bytes_per_sec = 0u32;
    let mut block_align = 0u16;
    let mut bits_per_sample = 0u16;
    let mut data_chunk: Option<Vec<u8>> = None;
    let mut has_fmt = false;

    let mut offset = 12usize;
    while offset + 8 <= wem.len() {
        let id = &wem[offset..offset + 4];
        let size = read_u32_le(wem, offset + 4).ok_or_else(|| anyhow!("invalid chunk size"))? as usize;
        let chunk_start = offset + 8;
        let chunk_end = chunk_start + size;
        if chunk_end > wem.len() {
            break;
        }

        if id == b"fmt " && size >= 16 {
            let audio_format =
                read_u16_le(wem, chunk_start).ok_or_else(|| anyhow!("invalid fmt chunk"))?;
            channels =
                read_u16_le(wem, chunk_start + 2).ok_or_else(|| anyhow!("invalid fmt chunk"))?;
            sample_rate = read_u32_le(wem, chunk_start + 4)
                .ok_or_else(|| anyhow!("invalid fmt chunk"))?;
            avg_bytes_per_sec = read_u32_le(wem, chunk_start + 8)
                .ok_or_else(|| anyhow!("invalid fmt chunk"))?;
            block_align = read_u16_le(wem, chunk_start + 12)
                .ok_or_else(|| anyhow!("invalid fmt chunk"))?;
            bits_per_sample = read_u16_le(wem, chunk_start + 14)
                .ok_or_else(|| anyhow!("invalid fmt chunk"))?;
            codec = match audio_format {
                0x0001 | 0xFFFE => WwiseCodec::Pcm,
                0xFFFF => WwiseCodec::Vorbis,
                other => WwiseCodec::Unsupported(other),
            };
            has_fmt = true;
        } else if id == b"data" {
            data_chunk = Some(wem[chunk_start..chunk_end].to_vec());
            break;
        }

        offset = chunk_end + (size & 1);
    }

    if !has_fmt {
        return Err(anyhow!("wem missing fmt chunk"));
    }
    let payload = data_chunk.ok_or_else(|| anyhow!("wem missing data chunk"))?;

    Ok(WwiseHeader {
        codec,
        channels,
        sample_rate,
        avg_bytes_per_sec,
        block_align,
        bits_per_sample,
        data_chunk: payload,
    })
}

