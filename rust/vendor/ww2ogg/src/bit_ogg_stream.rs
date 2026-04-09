//! Ogg bitstream writer with proper page formatting.

use crate::error::{WemError, WemResult};
use crate::ogg_crc;
use std::io::Write;

const HEADER_BYTES: usize = 27;
const MAX_SEGMENTS: usize = 255;
const SEGMENT_SIZE: usize = 255;

/// Writes bits to an Ogg stream with proper page formatting.
pub struct BitOggStream<W: Write> {
    writer: W,
    page_buffer: Vec<u8>,
    bit_buffer: u8,
    bits_stored: u8,
    payload_bytes: usize,
    granule: u64,
    seq_no: u32,
    first: bool,
    continued: bool,
}

impl<W: Write> BitOggStream<W> {
    /// Create a new BitOggStream writing to the given writer.
    pub fn new(writer: W) -> Self {
        Self {
            writer,
            page_buffer: vec![0u8; HEADER_BYTES + MAX_SEGMENTS + SEGMENT_SIZE * MAX_SEGMENTS],
            bit_buffer: 0,
            bits_stored: 0,
            payload_bytes: 0,
            granule: 0,
            seq_no: 0,
            first: true,
            continued: false,
        }
    }

    /// Set the granule position for the next page.
    pub fn set_granule(&mut self, granule: u64) {
        self.granule = granule;
    }

    /// Write a single bit.
    pub fn write_bit(&mut self, bit: bool) -> WemResult<()> {
        if bit {
            self.bit_buffer |= 1 << self.bits_stored;
        }
        self.bits_stored += 1;

        if self.bits_stored == 8 {
            self.flush_bits()?;
        }
        Ok(())
    }

    /// Write multiple bits from a u32 value.
    pub fn write_bits(&mut self, value: u32, count: u8) -> WemResult<()> {
        for i in 0..count {
            self.write_bit((value & (1u32 << i)) != 0)?;
        }
        Ok(())
    }

    /// Flush any pending bits to the page buffer.
    pub fn flush_bits(&mut self) -> WemResult<()> {
        if self.bits_stored != 0 {
            if self.payload_bytes == SEGMENT_SIZE * MAX_SEGMENTS {
                return Err(WemError::parse("ran out of space in an Ogg packet"));
            }

            self.page_buffer[HEADER_BYTES + MAX_SEGMENTS + self.payload_bytes] = self.bit_buffer;
            self.payload_bytes += 1;
            self.bits_stored = 0;
            self.bit_buffer = 0;
        }
        Ok(())
    }

    /// Flush the current page to the output.
    pub fn flush_page(&mut self, next_continued: bool, last: bool) -> WemResult<()> {
        if self.payload_bytes != SEGMENT_SIZE * MAX_SEGMENTS {
            self.flush_bits()?;
        }

        if self.payload_bytes != 0 {
            let mut segments = (self.payload_bytes + SEGMENT_SIZE) / SEGMENT_SIZE;
            if segments == MAX_SEGMENTS + 1 {
                segments = MAX_SEGMENTS;
            }

            // Move payload back
            for i in 0..self.payload_bytes {
                self.page_buffer[HEADER_BYTES + segments + i] =
                    self.page_buffer[HEADER_BYTES + MAX_SEGMENTS + i];
            }

            // OggS header
            self.page_buffer[0] = b'O';
            self.page_buffer[1] = b'g';
            self.page_buffer[2] = b'g';
            self.page_buffer[3] = b'S';
            self.page_buffer[4] = 0; // stream_structure_version

            let mut flags = 0u8;
            if self.continued {
                flags |= 1;
            }
            if self.first {
                flags |= 2;
            }
            if last {
                flags |= 4;
            }
            self.page_buffer[5] = flags;

            // Granule position (64-bit little-endian)
            self.page_buffer[6..14].copy_from_slice(&self.granule.to_le_bytes());

            // Stream serial number (always 1)
            self.page_buffer[14..18].copy_from_slice(&1u32.to_le_bytes());

            // Page sequence number
            self.page_buffer[18..22].copy_from_slice(&self.seq_no.to_le_bytes());

            // Checksum placeholder (will be computed)
            self.page_buffer[22..26].copy_from_slice(&0u32.to_le_bytes());

            // Segment count
            self.page_buffer[26] = segments as u8;

            // Lacing values
            let mut bytes_left = self.payload_bytes;
            for i in 0..segments {
                if bytes_left >= SEGMENT_SIZE {
                    bytes_left -= SEGMENT_SIZE;
                    self.page_buffer[27 + i] = SEGMENT_SIZE as u8;
                } else {
                    self.page_buffer[27 + i] = bytes_left as u8;
                }
            }

            // Compute and write checksum
            let total_size = HEADER_BYTES + segments + self.payload_bytes;
            let checksum = ogg_crc::compute(&self.page_buffer[..total_size]);
            self.page_buffer[22..26].copy_from_slice(&checksum.to_le_bytes());

            // Write to output
            self.writer.write_all(&self.page_buffer[..total_size])?;

            self.seq_no += 1;
            self.first = false;
            self.continued = next_continued;
            self.payload_bytes = 0;
        }
        Ok(())
    }

    /// Finish writing and flush any remaining data.
    pub fn finish(mut self) -> WemResult<W> {
        self.flush_page(false, false)?;
        Ok(self.writer)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_write_single_bits() {
        let mut output = Vec::new();
        let mut stream = BitOggStream::new(&mut output);

        // Write 8 bits: 0b10110100 = 180
        stream.write_bit(false).unwrap(); // bit 0
        stream.write_bit(false).unwrap(); // bit 1
        stream.write_bit(true).unwrap(); // bit 2
        stream.write_bit(false).unwrap(); // bit 3
        stream.write_bit(true).unwrap(); // bit 4
        stream.write_bit(true).unwrap(); // bit 5
        stream.write_bit(false).unwrap(); // bit 6
        stream.write_bit(true).unwrap(); // bit 7

        stream.flush_page(false, false).unwrap();

        // Check OggS header
        assert_eq!(&output[0..4], b"OggS");
        // Check version
        assert_eq!(output[4], 0);
        // Check flags (first page = 0x02)
        assert_eq!(output[5], 0x02);
        // Check segment count
        assert_eq!(output[26], 1);
        // Check lacing value (1 byte payload)
        assert_eq!(output[27], 1);
        // Check payload
        assert_eq!(output[28], 0b10110100);
    }

    #[test]
    fn test_write_bits_value() {
        let mut output = Vec::new();
        let mut stream = BitOggStream::new(&mut output);

        // Write 16 bits: 0x1234
        stream.write_bits(0x1234, 16).unwrap();
        stream.flush_page(false, false).unwrap();

        // Payload should be at offset 28 (27 header + 1 segment table entry)
        assert_eq!(output[28], 0x34); // LSB first
        assert_eq!(output[29], 0x12);
    }

    #[test]
    fn test_granule_position() {
        let mut output = Vec::new();
        let mut stream = BitOggStream::new(&mut output);

        stream.set_granule(0x123456789ABCDEF0);
        stream.write_bits(0xFF, 8).unwrap();
        stream.flush_page(false, false).unwrap();

        // Granule is at bytes 6-13 (little-endian)
        let granule = u64::from_le_bytes([
            output[6], output[7], output[8], output[9], output[10], output[11], output[12],
            output[13],
        ]);
        assert_eq!(granule, 0x123456789ABCDEF0);
    }

    #[test]
    fn test_page_flags() {
        // Test first page flag
        let mut output = Vec::new();
        {
            let mut stream = BitOggStream::new(&mut output);
            stream.write_bits(0xFF, 8).unwrap();
            stream.flush_page(false, false).unwrap();
        }
        assert_eq!(output[5] & 0x02, 0x02); // first page flag

        // Test last page flag
        let mut output = Vec::new();
        {
            let mut stream = BitOggStream::new(&mut output);
            stream.write_bits(0xFF, 8).unwrap();
            stream.flush_page(false, true).unwrap(); // last = true
        }
        assert_eq!(output[5] & 0x04, 0x04); // last page flag

        // Test continuation flag
        let mut output = Vec::new();
        {
            let mut stream = BitOggStream::new(&mut output);
            stream.write_bits(0xFF, 8).unwrap();
            stream.flush_page(true, false).unwrap(); // next_continued = true
            stream.write_bits(0xFF, 8).unwrap();
            stream.flush_page(false, false).unwrap();
        }
        // Second page should have continuation flag
        // First page is 28+1=29 bytes
        let first_page_size = 27 + 1 + 1; // header + segment table + payload
        assert_eq!(output[first_page_size + 5] & 0x01, 0x01);
    }

    #[test]
    fn test_sequence_number() {
        let mut output = Vec::new();
        let mut stream = BitOggStream::new(&mut output);

        // Write first page
        stream.write_bits(0xFF, 8).unwrap();
        stream.flush_page(false, false).unwrap();

        // Write second page
        stream.write_bits(0xFF, 8).unwrap();
        stream.flush_page(false, false).unwrap();

        // First page seq_no at bytes 18-21
        let seq0 = u32::from_le_bytes([output[18], output[19], output[20], output[21]]);
        assert_eq!(seq0, 0);

        // Second page starts at offset 29
        let page2_start = 29;
        let seq1 = u32::from_le_bytes([
            output[page2_start + 18],
            output[page2_start + 19],
            output[page2_start + 20],
            output[page2_start + 21],
        ]);
        assert_eq!(seq1, 1);
    }

    #[test]
    fn test_crc_is_computed() {
        let mut output = Vec::new();
        let mut stream = BitOggStream::new(&mut output);

        stream.write_bits(0xDEADBEEF, 32).unwrap();
        stream.flush_page(false, false).unwrap();

        // CRC is at bytes 22-25, should not be zero
        let crc = u32::from_le_bytes([output[22], output[23], output[24], output[25]]);
        assert_ne!(crc, 0);

        // Verify CRC by zeroing it and recomputing
        let mut page = output.clone();
        page[22] = 0;
        page[23] = 0;
        page[24] = 0;
        page[25] = 0;
        let computed_crc = crate::ogg_crc::compute(&page);
        assert_eq!(crc, computed_crc);
    }

    #[test]
    fn test_serial_number_is_one() {
        let mut output = Vec::new();
        let mut stream = BitOggStream::new(&mut output);

        stream.write_bits(0xFF, 8).unwrap();
        stream.flush_page(false, false).unwrap();

        // Serial number at bytes 14-17
        let serial = u32::from_le_bytes([output[14], output[15], output[16], output[17]]);
        assert_eq!(serial, 1);
    }
}
