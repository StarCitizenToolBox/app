//! Bit-level reader for Vorbis data.
//!
//! Reads individual bits LSB-first from byte slices or streams.

use crate::error::{WemError, WemResult};
use std::io::Read;

/// Trait for reading bits from a source.
pub trait BitRead {
    /// Read a single bit.
    fn read_bit(&mut self) -> WemResult<bool>;

    /// Get the total number of bits read so far.
    fn total_bits_read(&self) -> u64;

    /// Read multiple bits (up to 32) and return as u32.
    fn read_bits(&mut self, count: u8) -> WemResult<u32> {
        if count > 32 {
            return Err(WemError::parse("Cannot read more than 32 bits at once"));
        }

        let mut result = 0u32;
        for i in 0..count {
            if self.read_bit()? {
                result |= 1u32 << i;
            }
        }

        Ok(result)
    }
}

/// Reads individual bits (LSB first) from memory or a stream.
pub struct BitReader<R: Read> {
    reader: R,
    current_byte: u8,
    bit_pos: u8,
    bytes_read: u64,
}

impl<R: Read> BitReader<R> {
    /// Create a new BitReader from a Read source.
    pub fn new(reader: R) -> Self {
        Self {
            reader,
            current_byte: 0,
            bit_pos: 0,
            bytes_read: 0,
        }
    }

    /// Get the total number of bits read so far.
    pub fn total_bits_read(&self) -> u64 {
        if self.bit_pos == 0 {
            self.bytes_read * 8
        } else {
            (self.bytes_read - 1) * 8 + self.bit_pos as u64
        }
    }

    /// Read a single bit.
    pub fn read_bit(&mut self) -> WemResult<bool> {
        if self.bit_pos == 0 {
            let mut buf = [0u8; 1];
            self.reader
                .read_exact(&mut buf)
                .map_err(|_| WemError::end_of_stream("Out of bits"))?;
            self.current_byte = buf[0];
            self.bytes_read += 1;
        }

        let bit = (self.current_byte & (1 << self.bit_pos)) != 0;
        self.bit_pos += 1;

        if self.bit_pos == 8 {
            self.bit_pos = 0;
        }

        Ok(bit)
    }

    /// Read multiple bits (up to 32) and return as u32.
    pub fn read_bits(&mut self, count: u8) -> WemResult<u32> {
        BitRead::read_bits(self, count)
    }
}

impl<R: Read> BitRead for BitReader<R> {
    fn read_bit(&mut self) -> WemResult<bool> {
        BitReader::read_bit(self)
    }

    fn total_bits_read(&self) -> u64 {
        BitReader::total_bits_read(self)
    }
}

/// BitReader that works on a byte slice (no I/O).
pub struct BitSliceReader<'a> {
    data: &'a [u8],
    byte_pos: usize,
    bit_pos: u8,
}

impl<'a> BitSliceReader<'a> {
    /// Create a new BitSliceReader from a byte slice.
    pub fn new(data: &'a [u8]) -> Self {
        Self {
            data,
            byte_pos: 0,
            bit_pos: 0,
        }
    }

    /// Get the total number of bits read so far.
    pub fn total_bits_read(&self) -> u64 {
        self.byte_pos as u64 * 8 + self.bit_pos as u64
    }

    /// Read a single bit.
    pub fn read_bit(&mut self) -> WemResult<bool> {
        if self.byte_pos >= self.data.len() {
            return Err(WemError::end_of_stream("Out of bits"));
        }

        let bit = (self.data[self.byte_pos] & (1 << self.bit_pos)) != 0;
        self.bit_pos += 1;

        if self.bit_pos == 8 {
            self.bit_pos = 0;
            self.byte_pos += 1;
        }

        Ok(bit)
    }
}

impl BitRead for BitSliceReader<'_> {
    fn read_bit(&mut self) -> WemResult<bool> {
        BitSliceReader::read_bit(self)
    }

    fn total_bits_read(&self) -> u64 {
        BitSliceReader::total_bits_read(self)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::io::Cursor;

    #[test]
    fn test_read_bits_lsb_first() {
        let data = [0b10110100u8, 0b11001010u8];
        let mut reader = BitReader::new(Cursor::new(data));

        // Read 4 bits: should be 0100 = 4
        assert_eq!(reader.read_bits(4).unwrap(), 0b0100);
        // Read 4 bits: should be 1011 = 11
        assert_eq!(reader.read_bits(4).unwrap(), 0b1011);
        // Read 8 bits: should be 11001010 = 202
        assert_eq!(reader.read_bits(8).unwrap(), 0b11001010);
    }

    #[test]
    fn test_slice_reader() {
        let data = [0b10110100u8];
        let mut reader = BitSliceReader::new(&data);

        assert!(!reader.read_bit().unwrap()); // bit 0: 0
        assert!(!reader.read_bit().unwrap()); // bit 1: 0
        assert!(reader.read_bit().unwrap()); // bit 2: 1
        assert!(!reader.read_bit().unwrap()); // bit 3: 0
        assert!(reader.read_bit().unwrap()); // bit 4: 1
        assert!(reader.read_bit().unwrap()); // bit 5: 1
        assert!(!reader.read_bit().unwrap()); // bit 6: 0
        assert!(reader.read_bit().unwrap()); // bit 7: 1
    }

    #[test]
    fn test_read_zero_bits() {
        let data = [0xFF];
        let mut reader = BitReader::new(Cursor::new(data));

        // Reading 0 bits should return 0
        assert_eq!(reader.read_bits(0).unwrap(), 0);
        assert_eq!(reader.total_bits_read(), 0);
    }

    #[test]
    fn test_read_single_bit() {
        let data = [0b00000001u8];
        let mut reader = BitReader::new(Cursor::new(data));

        assert!(reader.read_bit().unwrap()); // bit 0 is 1
        assert!(!reader.read_bit().unwrap()); // bit 1 is 0
    }

    #[test]
    fn test_total_bits_read() {
        let data = [0xFF, 0xFF, 0xFF];
        let mut reader = BitReader::new(Cursor::new(data));

        reader.read_bits(5).unwrap();
        assert_eq!(reader.total_bits_read(), 5);

        reader.read_bits(7).unwrap();
        assert_eq!(reader.total_bits_read(), 12);

        reader.read_bit().unwrap();
        assert_eq!(reader.total_bits_read(), 13);
    }

    #[test]
    fn test_read_across_byte_boundary() {
        // 0xAB = 0b10101011, 0xCD = 0b11001101
        let data = [0xAB, 0xCD];
        let mut reader = BitReader::new(Cursor::new(data));

        // Read 12 bits across byte boundary
        // Bits 0-7 from first byte: 10101011
        // Bits 8-11 from second byte: 1101
        // Combined LSB-first: 110110101011 = 0xDAB
        let value = reader.read_bits(12).unwrap();
        assert_eq!(value, 0xDAB);
    }

    #[test]
    fn test_read_full_32_bits() {
        let data = [0x78, 0x56, 0x34, 0x12];
        let mut reader = BitReader::new(Cursor::new(data));

        // Should read as little-endian 32-bit value
        let value = reader.read_bits(32).unwrap();
        assert_eq!(value, 0x12345678);
    }

    #[test]
    fn test_slice_reader_total_bits() {
        let data = [0xFF, 0xFF];
        let mut reader = BitSliceReader::new(&data);

        reader.read_bits(3).unwrap();
        assert_eq!(reader.total_bits_read(), 3);

        reader.read_bits(10).unwrap();
        assert_eq!(reader.total_bits_read(), 13);
    }

    #[test]
    fn test_slice_reader_read_bits() {
        let data = [0x34, 0x12]; // 0x1234 little-endian
        let mut reader = BitSliceReader::new(&data);

        let value = reader.read_bits(16).unwrap();
        assert_eq!(value, 0x1234);
    }

    #[test]
    fn test_read_past_end_of_stream() {
        let data = [0xFF];
        let mut reader = BitReader::new(Cursor::new(data));

        // Read all 8 bits
        reader.read_bits(8).unwrap();

        // Try to read more - should fail
        let result = reader.read_bit();
        assert!(result.is_err());
    }

    #[test]
    fn test_slice_reader_past_end() {
        let data = [0xFF];
        let mut reader = BitSliceReader::new(&data);

        // Read all 8 bits
        for _ in 0..8 {
            reader.read_bit().unwrap();
        }

        // Try to read more - should fail
        let result = reader.read_bit();
        assert!(result.is_err());
    }
}
