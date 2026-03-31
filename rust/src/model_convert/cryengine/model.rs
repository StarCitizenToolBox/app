use anyhow::{anyhow, Result};

use super::types::{ChunkType, FileSignature};

#[derive(Debug, Clone, Copy)]
pub struct ModelHeader {
    pub signature: FileSignature,
    pub version: u32,
    pub chunk_count: usize,
    pub chunk_table_offset: usize,
}

#[derive(Debug, Clone, Copy)]
pub struct ParsedChunk {
    pub chunk_type: ChunkType,
    pub chunk_type_raw: u32,
    pub version: u32,
    pub offset: usize,
    pub id: Option<i32>,
    pub size: Option<u32>,
}

#[derive(Debug, Clone)]
pub struct ModelFile {
    pub header: ModelHeader,
    pub chunks: Vec<ParsedChunk>,
}

impl ModelFile {
    pub fn parse(data: &[u8]) -> Result<Self> {
        if data.len() < 16 {
            return Err(anyhow!("model header too short"));
        }

        let signature = match &data[0..4] {
            b"CrCh" => FileSignature::CrCh,
            b"#ivo" => FileSignature::Ivo,
            _ => {
                if data.len() >= 8 && &data[0..6] == b"CryTek" {
                    FileSignature::CryTek
                } else {
                    return Err(anyhow!("unsupported file signature"));
                }
            }
        };

        let (version, chunk_count, chunk_table_offset) = match signature {
            FileSignature::CrCh | FileSignature::Ivo => {
                let version = read_u32_le(data, 4)?;
                let chunk_count = read_u32_le(data, 8)? as usize;
                let chunk_table_offset = read_u32_le(data, 12)? as usize;
                (version, chunk_count, chunk_table_offset)
            }
            FileSignature::CryTek => {
                if data.len() < 24 {
                    return Err(anyhow!("CryTek header too short"));
                }
                let version = read_u32_le(data, 12)?;
                let chunk_table_offset = read_u32_le(data, 16)? as usize + 4;
                let chunk_count = read_u32_le(data, 20)? as usize;
                (version, chunk_count, chunk_table_offset)
            }
        };

        let header = ModelHeader {
            signature,
            version,
            chunk_count,
            chunk_table_offset,
        };

        let chunks = parse_chunk_table(data, header)?;
        Ok(Self { header, chunks })
    }

    pub fn chunk_data_bounds(&self, data: &[u8], chunk_index: usize) -> Result<(usize, usize)> {
        let current = self
            .chunks
            .get(chunk_index)
            .ok_or_else(|| anyhow!("chunk index out of range"))?;
        let start = current.offset;

        let mut end = data.len();
        for chunk in self.chunks.iter().skip(chunk_index + 1) {
            if chunk.offset > start {
                end = chunk.offset;
                break;
            }
        }

        if end <= start || end > data.len() {
            return Err(anyhow!("invalid chunk bounds"));
        }
        Ok((start, end))
    }
}

fn parse_chunk_table(data: &[u8], header: ModelHeader) -> Result<Vec<ParsedChunk>> {
    const CHUNK_TYPE_BASE_746: u32 = 0xCCCB_F000;
    let entry_len = 16usize;
    let table_size = header
        .chunk_count
        .checked_mul(entry_len)
        .ok_or_else(|| anyhow!("chunk table overflow"))?;
    let table_end = header
        .chunk_table_offset
        .checked_add(table_size)
        .ok_or_else(|| anyhow!("chunk table overflow"))?;
    if table_end > data.len() {
        return Err(anyhow!("chunk table truncated"));
    }

    let mut chunks = Vec::with_capacity(header.chunk_count);
    for i in 0..header.chunk_count {
        let base = header.chunk_table_offset + i * entry_len;
        let (chunk_type_raw, version, id, size, offset) = match header.signature {
            FileSignature::Ivo => (
                read_u32_le(data, base)?,
                read_u32_le(data, base + 4)?,
                None,
                None,
                read_u64_le(data, base + 8)? as usize,
            ),
            FileSignature::CrCh => {
                let type_low = read_u16_le(data, base)? as u32;
                (
                    CHUNK_TYPE_BASE_746 + type_low,
                    read_u16_le(data, base + 2)? as u32,
                    Some(read_i32_le(data, base + 4)?),
                    Some(read_u32_le(data, base + 8)?),
                    read_u32_le(data, base + 12)? as usize,
                )
            }
            FileSignature::CryTek => (
                read_u32_le(data, base)?,
                read_u32_le(data, base + 4)?,
                None,
                None,
                read_u32_le(data, base + 8)? as usize,
            ),
        };
        if offset >= data.len() {
            return Err(anyhow!("chunk offset out of range at index {i}"));
        }
        chunks.push(ParsedChunk {
            chunk_type: ChunkType::from_raw(chunk_type_raw),
            chunk_type_raw,
            version,
            offset,
            id,
            size,
        });
    }

    chunks.sort_by_key(|c| c.offset);
    Ok(chunks)
}

fn read_u32_le(data: &[u8], offset: usize) -> Result<u32> {
    let bytes: [u8; 4] = data
        .get(offset..offset + 4)
        .ok_or_else(|| anyhow!("unexpected EOF"))?
        .try_into()
        .map_err(|_| anyhow!("unexpected EOF"))?;
    Ok(u32::from_le_bytes(bytes))
}

fn read_u16_le(data: &[u8], offset: usize) -> Result<u16> {
    let bytes: [u8; 2] = data
        .get(offset..offset + 2)
        .ok_or_else(|| anyhow!("unexpected EOF"))?
        .try_into()
        .map_err(|_| anyhow!("unexpected EOF"))?;
    Ok(u16::from_le_bytes(bytes))
}

fn read_i32_le(data: &[u8], offset: usize) -> Result<i32> {
    let bytes: [u8; 4] = data
        .get(offset..offset + 4)
        .ok_or_else(|| anyhow!("unexpected EOF"))?
        .try_into()
        .map_err(|_| anyhow!("unexpected EOF"))?;
    Ok(i32::from_le_bytes(bytes))
}

fn read_u64_le(data: &[u8], offset: usize) -> Result<u64> {
    let bytes: [u8; 8] = data
        .get(offset..offset + 8)
        .ok_or_else(|| anyhow!("unexpected EOF"))?
        .try_into()
        .map_err(|_| anyhow!("unexpected EOF"))?;
    Ok(u64::from_le_bytes(bytes))
}

#[cfg(test)]
mod tests {
    use super::{ChunkType, FileSignature, ModelFile};

    #[test]
    fn parse_ivo_header_and_chunk_table() {
        let mut data = Vec::new();
        data.extend_from_slice(b"#ivo");
        data.extend_from_slice(&0x900u32.to_le_bytes());
        data.extend_from_slice(&1u32.to_le_bytes());
        data.extend_from_slice(&16u32.to_le_bytes());
        data.extend_from_slice(&0xB875_7777u32.to_le_bytes());
        data.extend_from_slice(&0x900u32.to_le_bytes());
        data.extend_from_slice(&32u64.to_le_bytes());
        while data.len() < 64 {
            data.push(0);
        }

        let parsed = ModelFile::parse(&data).expect("parse");
        assert_eq!(parsed.header.signature, FileSignature::Ivo);
        assert_eq!(parsed.header.version, 0x900);
        assert_eq!(parsed.chunks.len(), 1);
        assert_eq!(parsed.chunks[0].chunk_type, ChunkType::IvoSkin2);
        assert_eq!(parsed.chunks[0].offset, 32);
    }
}
