//! Wwise audio packet header structures.
//!
//! Wwise audio files use different packet header formats depending on the version.
//! This module provides readers for both the modern 2/6 byte format and the old 8 byte format.

use crate::error::WemResult;
use std::io::{Read, Seek, SeekFrom};

/// Modern packet header (2 or 6 bytes).
///
/// Used in newer Wwise audio files.
/// - 2 bytes when `no_granule` is true: just the packet size
/// - 6 bytes otherwise: 2 byte size + 4 byte granule position
pub struct Packet {
    /// Size of the header in bytes (2 or 6).
    pub header_size: u64,
    /// Offset to the packet payload data.
    pub offset: u64,
    /// Size of the packet payload in bytes.
    pub size: u32,
    /// Granule position (sample position) for this packet.
    pub granule: u32,
    /// Offset to the next packet.
    pub next_offset: u64,
}

impl Packet {
    /// Read a packet header from the stream at the given offset.
    ///
    /// # Arguments
    /// * `stream` - Seekable stream to read from
    /// * `offset` - Position in the stream where the packet header starts
    /// * `little_endian` - Whether to interpret bytes as little-endian
    /// * `no_granule` - If true, only read 2-byte header (size only)
    pub fn read<R: Read + Seek>(
        stream: &mut R,
        offset: u64,
        little_endian: bool,
        no_granule: bool,
    ) -> WemResult<Self> {
        stream.seek(SeekFrom::Start(offset))?;

        let mut buffer = [0u8; 6];

        if no_granule {
            stream.read_exact(&mut buffer[..2])?;

            let size = if little_endian {
                u16::from_le_bytes([buffer[0], buffer[1]]) as u32
            } else {
                u16::from_be_bytes([buffer[0], buffer[1]]) as u32
            };

            Ok(Self {
                header_size: 2,
                offset: offset + 2,
                size,
                granule: 0,
                next_offset: offset + 2 + size as u64,
            })
        } else {
            stream.read_exact(&mut buffer)?;

            let size = if little_endian {
                u16::from_le_bytes([buffer[0], buffer[1]]) as u32
            } else {
                u16::from_be_bytes([buffer[0], buffer[1]]) as u32
            };

            let granule = if little_endian {
                u32::from_le_bytes([buffer[2], buffer[3], buffer[4], buffer[5]])
            } else {
                u32::from_be_bytes([buffer[2], buffer[3], buffer[4], buffer[5]])
            };

            Ok(Self {
                header_size: 6,
                offset: offset + 6,
                size,
                granule,
                next_offset: offset + 6 + size as u64,
            })
        }
    }
}

/// Old 8-byte packet header.
///
/// Used in older Wwise audio files with header triad present.
/// Contains 4-byte size and 4-byte granule position.
pub struct Packet8 {
    /// Size of the header in bytes (always 8).
    pub header_size: u64,
    /// Offset to the packet payload data.
    pub offset: u64,
    /// Size of the packet payload in bytes.
    pub size: u32,
    /// Granule position (sample position) for this packet.
    pub granule: u32,
    /// Offset to the next packet.
    pub next_offset: u64,
}

impl Packet8 {
    /// Read an 8-byte packet header from the stream at the given offset.
    ///
    /// # Arguments
    /// * `stream` - Seekable stream to read from
    /// * `offset` - Position in the stream where the packet header starts
    /// * `little_endian` - Whether to interpret bytes as little-endian
    pub fn read<R: Read + Seek>(
        stream: &mut R,
        offset: u64,
        little_endian: bool,
    ) -> WemResult<Self> {
        stream.seek(SeekFrom::Start(offset))?;

        let mut buffer = [0u8; 8];
        stream.read_exact(&mut buffer)?;

        let (size, granule) = if little_endian {
            (
                u32::from_le_bytes([buffer[0], buffer[1], buffer[2], buffer[3]]),
                u32::from_le_bytes([buffer[4], buffer[5], buffer[6], buffer[7]]),
            )
        } else {
            (
                u32::from_be_bytes([buffer[0], buffer[1], buffer[2], buffer[3]]),
                u32::from_be_bytes([buffer[4], buffer[5], buffer[6], buffer[7]]),
            )
        };

        Ok(Self {
            header_size: 8,
            offset: offset + 8,
            size,
            granule,
            next_offset: offset + 8 + size as u64,
        })
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::io::Cursor;

    #[test]
    fn test_packet_no_granule_little_endian() {
        // 2-byte header: size = 0x0102 = 258
        let data = vec![0x02, 0x01];
        let mut cursor = Cursor::new(data);

        let packet = Packet::read(&mut cursor, 0, true, true).unwrap();

        assert_eq!(packet.header_size, 2);
        assert_eq!(packet.offset, 2);
        assert_eq!(packet.size, 258);
        assert_eq!(packet.granule, 0);
        assert_eq!(packet.next_offset, 2 + 258);
    }

    #[test]
    fn test_packet_no_granule_big_endian() {
        // 2-byte header: size = 0x0102 = 258
        let data = vec![0x01, 0x02];
        let mut cursor = Cursor::new(data);

        let packet = Packet::read(&mut cursor, 0, false, true).unwrap();

        assert_eq!(packet.header_size, 2);
        assert_eq!(packet.size, 258);
        assert_eq!(packet.granule, 0);
    }

    #[test]
    fn test_packet_with_granule_little_endian() {
        // 6-byte header: size = 0x0100 = 256, granule = 0x04030201
        let data = vec![0x00, 0x01, 0x01, 0x02, 0x03, 0x04];
        let mut cursor = Cursor::new(data);

        let packet = Packet::read(&mut cursor, 0, true, false).unwrap();

        assert_eq!(packet.header_size, 6);
        assert_eq!(packet.offset, 6);
        assert_eq!(packet.size, 256);
        assert_eq!(packet.granule, 0x04030201);
        assert_eq!(packet.next_offset, 6 + 256);
    }

    #[test]
    fn test_packet_with_granule_big_endian() {
        // 6-byte header: size = 0x0100 = 256, granule = 0x01020304
        let data = vec![0x01, 0x00, 0x01, 0x02, 0x03, 0x04];
        let mut cursor = Cursor::new(data);

        let packet = Packet::read(&mut cursor, 0, false, false).unwrap();

        assert_eq!(packet.header_size, 6);
        assert_eq!(packet.size, 256);
        assert_eq!(packet.granule, 0x01020304);
    }

    #[test]
    fn test_packet_at_offset() {
        // Put packet header at offset 10
        let mut data = vec![0u8; 16];
        data[10] = 0x80; // size low byte
        data[11] = 0x00; // size high byte = 128

        let mut cursor = Cursor::new(data);
        let packet = Packet::read(&mut cursor, 10, true, true).unwrap();

        assert_eq!(packet.offset, 12); // 10 + 2
        assert_eq!(packet.size, 128);
        assert_eq!(packet.next_offset, 12 + 128);
    }

    #[test]
    fn test_packet8_little_endian() {
        // 8-byte header: size = 0x00000100 = 256, granule = 0x12345678
        let data = vec![0x00, 0x01, 0x00, 0x00, 0x78, 0x56, 0x34, 0x12];
        let mut cursor = Cursor::new(data);

        let packet = Packet8::read(&mut cursor, 0, true).unwrap();

        assert_eq!(packet.header_size, 8);
        assert_eq!(packet.offset, 8);
        assert_eq!(packet.size, 256);
        assert_eq!(packet.granule, 0x12345678);
        assert_eq!(packet.next_offset, 8 + 256);
    }

    #[test]
    fn test_packet8_big_endian() {
        // 8-byte header: size = 0x00000100 = 256, granule = 0x12345678
        let data = vec![0x00, 0x00, 0x01, 0x00, 0x12, 0x34, 0x56, 0x78];
        let mut cursor = Cursor::new(data);

        let packet = Packet8::read(&mut cursor, 0, false).unwrap();

        assert_eq!(packet.header_size, 8);
        assert_eq!(packet.size, 256);
        assert_eq!(packet.granule, 0x12345678);
    }

    #[test]
    fn test_packet8_at_offset() {
        // Put packet header at offset 20
        let mut data = vec![0u8; 30];
        data[20] = 0x40; // size bytes (little-endian)
        data[21] = 0x00;
        data[22] = 0x00;
        data[23] = 0x00; // size = 64
        data[24] = 0x00; // granule bytes
        data[25] = 0x10;
        data[26] = 0x00;
        data[27] = 0x00; // granule = 4096

        let mut cursor = Cursor::new(data);
        let packet = Packet8::read(&mut cursor, 20, true).unwrap();

        assert_eq!(packet.offset, 28); // 20 + 8
        assert_eq!(packet.size, 64);
        assert_eq!(packet.granule, 4096);
        assert_eq!(packet.next_offset, 28 + 64);
    }

    #[test]
    fn test_packet_read_error_on_short_data() {
        let data = vec![0x00]; // Only 1 byte, need at least 2
        let mut cursor = Cursor::new(data);

        let result = Packet::read(&mut cursor, 0, true, true);
        assert!(result.is_err());
    }

    #[test]
    fn test_packet8_read_error_on_short_data() {
        let data = vec![0x00; 4]; // Only 4 bytes, need 8
        let mut cursor = Cursor::new(data);

        let result = Packet8::read(&mut cursor, 0, true);
        assert!(result.is_err());
    }
}
