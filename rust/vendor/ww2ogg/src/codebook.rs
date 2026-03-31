//! Vorbis codebook library for rebuilding Wwise audio.
//!
//! Wwise audio files use a stripped Vorbis format that references external codebook
//! libraries instead of embedding the full codebook data. This module loads and provides
//! access to these codebook libraries.
//!
//! # Codebook Selection
//!
//! Different games use different codebook libraries. If conversion produces garbled
//! audio or fails with size mismatch errors, try a different codebook:
//!
//! - [`CodebookLibrary::default_codebooks()`] - Standard Vorbis codebooks (most common)
//! - [`CodebookLibrary::aotuv_codebooks()`] - aoTuV 6.03 tuned codebooks (some games)
//! - [`CodebookLibrary::from_file()`] - Load custom codebooks from a file
//!
//! # Example
//!
//! ```no_run
//! use ww2ogg::CodebookLibrary;
//!
//! // Try default codebooks first
//! let codebooks = CodebookLibrary::default_codebooks()?;
//!
//! // If that doesn't work, try aoTuV
//! let codebooks = CodebookLibrary::aotuv_codebooks()?;
//!
//! // Or load from a custom file
//! let codebooks = CodebookLibrary::from_file("custom_codebooks.bin")?;
//! # Ok::<(), ww2ogg::WemError>(())
//! ```

use crate::bit_ogg_stream::BitOggStream;
use crate::bit_reader::{BitRead, BitSliceReader};
use crate::error::{WemError, WemResult};
use crate::vorbis_helpers::{book_map_type1_quantvals, ilog};
use std::io::Write;
use std::path::Path;

/// Embedded default packed codebooks.
static DEFAULT_CODEBOOKS: &[u8] = include_bytes!("codebooks/packed_codebooks.bin");

/// Embedded aoTuV 6.03 packed codebooks.
static AOTUV_CODEBOOKS: &[u8] = include_bytes!("codebooks/packed_codebooks_aoTuV_603.bin");

/// Provides Vorbis codebook data for rebuilding audio streams from Wwise files.
///
/// Wwise audio files reference codebooks by ID rather than embedding them. This struct
/// provides access to the codebook data needed to rebuild the Vorbis headers.
///
/// # Built-in Libraries
///
/// Two codebook libraries are embedded in the crate:
///
/// - [`default_codebooks()`](Self::default_codebooks) - Standard Vorbis codebooks
/// - [`aotuv_codebooks()`](Self::aotuv_codebooks) - aoTuV 6.03 tuned codebooks
///
/// # Custom Codebooks
///
/// For games that use custom codebook libraries, you can load from a file:
///
/// ```no_run
/// use ww2ogg::CodebookLibrary;
///
/// let codebooks = CodebookLibrary::from_file("packed_codebooks_custom.bin")?;
/// # Ok::<(), ww2ogg::WemError>(())
/// ```
///
/// # Inline Codebooks
///
/// Some Wwise files embed codebooks directly. For these, use [`empty()`](Self::empty)
/// and enable the `inline_codebooks` option on the converter.
pub struct CodebookLibrary {
    codebook_data: Vec<u8>,
    codebook_offsets: Vec<u32>,
}

impl CodebookLibrary {
    /// Creates an empty codebook library for use with inline codebooks.
    ///
    /// Use this constructor when the audio file contains its own codebook data.
    pub fn empty() -> Self {
        Self {
            codebook_data: Vec::new(),
            codebook_offsets: Vec::new(),
        }
    }

    /// Returns the default packed codebooks library.
    ///
    /// This is the standard codebook library that works with most Wwise audio files.
    /// If conversion fails with size mismatch errors or produces garbled audio,
    /// try [`CodebookLibrary::aotuv_codebooks`] instead.
    pub fn default_codebooks() -> WemResult<Self> {
        Self::from_bytes(DEFAULT_CODEBOOKS)
    }

    /// Returns the aoTuV 6.03 packed codebooks library.
    ///
    /// Some Wwise audio files are encoded with aoTuV (Aoyumi's tuned Vorbis) codebooks.
    /// Use this library if the default codebooks produce errors or garbled audio.
    pub fn aotuv_codebooks() -> WemResult<Self> {
        Self::from_bytes(AOTUV_CODEBOOKS)
    }

    /// Loads a codebook library from raw bytes.
    ///
    /// The format is: codebook data followed by an offset table,
    /// with the table offset stored in the last 4 bytes.
    pub fn from_bytes(data: &[u8]) -> WemResult<Self> {
        if data.len() < 4 {
            return Err(WemError::parse("codebook file too small"));
        }

        let file_size = data.len();
        let offset_offset = u32::from_le_bytes([
            data[file_size - 4],
            data[file_size - 3],
            data[file_size - 2],
            data[file_size - 1],
        ]) as usize;

        if offset_offset >= file_size {
            return Err(WemError::parse("invalid codebook offset table pointer"));
        }

        let codebook_count = (file_size - offset_offset) / 4;
        let codebook_data = data[..offset_offset].to_vec();

        let mut codebook_offsets = Vec::with_capacity(codebook_count);
        for i in 0..codebook_count {
            let pos = offset_offset + i * 4;
            let offset =
                u32::from_le_bytes([data[pos], data[pos + 1], data[pos + 2], data[pos + 3]]);
            codebook_offsets.push(offset);
        }

        Ok(Self {
            codebook_data,
            codebook_offsets,
        })
    }

    /// Loads a codebook library from a file path.
    ///
    /// # Arguments
    /// * `path` - Path to a packed codebooks binary file
    ///
    /// # Errors
    /// Returns an error if the file cannot be read or has an invalid format.
    pub fn from_file<P: AsRef<Path>>(path: P) -> WemResult<Self> {
        let data = std::fs::read(path.as_ref())
            .map_err(|e| WemError::file_open(format!("{}: {}", path.as_ref().display(), e)))?;
        Self::from_bytes(&data)
    }

    /// Returns the number of codebooks in the library.
    pub fn codebook_count(&self) -> usize {
        if self.codebook_offsets.is_empty() {
            0
        } else {
            self.codebook_offsets.len() - 1
        }
    }

    /// Gets the raw codebook data for a given index.
    fn get_codebook(&self, index: usize) -> WemResult<&[u8]> {
        if self.codebook_offsets.is_empty() {
            return Err(WemError::parse("codebook library not loaded"));
        }

        if index >= self.codebook_count() {
            return Err(WemError::invalid_codebook_id(index as i32));
        }

        let start = self.codebook_offsets[index] as usize;
        let end = self.codebook_offsets[index + 1] as usize;

        if end > self.codebook_data.len() || start > end {
            return Err(WemError::parse("invalid codebook offset"));
        }

        Ok(&self.codebook_data[start..end])
    }

    /// Gets the size of a codebook by index, or -1 if invalid.
    pub fn get_codebook_size(&self, index: usize) -> i32 {
        if self.codebook_offsets.is_empty() || index >= self.codebook_count() {
            return -1;
        }

        let start = self.codebook_offsets[index];
        let end = self.codebook_offsets[index + 1];
        (end - start) as i32
    }

    /// Rebuild a codebook from the library by index and write to output.
    pub fn rebuild<W: Write>(&self, index: usize, output: &mut BitOggStream<W>) -> WemResult<()> {
        let codebook = self.get_codebook(index)?;
        let mut reader = BitSliceReader::new(codebook);
        self.rebuild_internal(&mut reader, Some(codebook.len() as u32), output)
    }

    /// Copy a codebook directly from input to output (for inline/full setup).
    pub fn copy<B: BitRead, W: Write>(
        &self,
        input: &mut B,
        output: &mut BitOggStream<W>,
    ) -> WemResult<()> {
        // IN: 24 bit identifier, 16 bit dimensions, 24 bit entry count
        let id = input.read_bits(24)?;
        let dimensions = input.read_bits(16)?;
        let entries = input.read_bits(24)?;

        if id != 0x564342 {
            // "BCV" in little-endian
            return Err(WemError::parse("invalid codebook identifier"));
        }

        // OUT: same
        output.write_bits(id, 24)?;
        output.write_bits(dimensions, 16)?;
        output.write_bits(entries, 24)?;

        self.copy_codebook_data(input, output, entries, dimensions)
    }

    /// Rebuild a codebook from stripped format using a bit reader.
    ///
    /// This is used for inline codebooks that are not in the library.
    pub fn rebuild_from_reader<B: BitRead, W: Write>(
        &self,
        input: &mut B,
        output: &mut BitOggStream<W>,
    ) -> WemResult<()> {
        self.rebuild_internal(input, None, output)
    }

    /// Internal rebuild method with optional size validation.
    fn rebuild_internal<B: BitRead, W: Write>(
        &self,
        input: &mut B,
        codebook_size: Option<u32>,
        output: &mut BitOggStream<W>,
    ) -> WemResult<()> {
        // IN: 4 bit dimensions, 14 bit entry count
        let dimensions = input.read_bits(4)?;
        let entries = input.read_bits(14)?;

        // OUT: 24 bit identifier, 16 bit dimensions, 24 bit entry count
        output.write_bits(0x564342, 24)?; // "BCV"
        output.write_bits(dimensions, 16)?;
        output.write_bits(entries, 24)?;

        self.rebuild_codebook_data(input, output, entries, dimensions, codebook_size)
    }

    fn copy_codebook_data<B: BitRead, W: Write>(
        &self,
        input: &mut B,
        output: &mut BitOggStream<W>,
        entries: u32,
        dimensions: u32,
    ) -> WemResult<()> {
        // IN/OUT: 1 bit ordered flag
        let ordered = input.read_bits(1)?;
        output.write_bits(ordered, 1)?;

        if ordered != 0 {
            // IN/OUT: 5 bit initial length
            let initial_length = input.read_bits(5)?;
            output.write_bits(initial_length, 5)?;

            let mut current_entry = 0u32;
            while current_entry < entries {
                let num_bits = ilog(entries - current_entry);
                let number = input.read_bits(num_bits)?;
                output.write_bits(number, num_bits)?;
                current_entry += number;
            }

            if current_entry > entries {
                return Err(WemError::parse("current_entry out of range"));
            }
        } else {
            // IN/OUT: 1 bit sparse flag
            let sparse = input.read_bits(1)?;
            output.write_bits(sparse, 1)?;

            for _ in 0..entries {
                let mut present_bool = true;

                if sparse != 0 {
                    let present = input.read_bits(1)?;
                    output.write_bits(present, 1)?;
                    present_bool = present != 0;
                }

                if present_bool {
                    let codeword_length = input.read_bits(5)?;
                    output.write_bits(codeword_length, 5)?;
                }
            }
        }

        // Lookup table
        let lookup_type = input.read_bits(4)?;
        output.write_bits(lookup_type, 4)?;

        self.handle_lookup_table(input, output, entries, dimensions, lookup_type, false)
    }

    fn rebuild_codebook_data<B: BitRead, W: Write>(
        &self,
        input: &mut B,
        output: &mut BitOggStream<W>,
        entries: u32,
        dimensions: u32,
        codebook_size: Option<u32>,
    ) -> WemResult<()> {
        // IN/OUT: 1 bit ordered flag
        let ordered = input.read_bits(1)?;
        output.write_bits(ordered, 1)?;

        if ordered != 0 {
            let initial_length = input.read_bits(5)?;
            output.write_bits(initial_length, 5)?;

            let mut current_entry = 0u32;
            while current_entry < entries {
                let num_bits = ilog(entries - current_entry);
                let number = input.read_bits(num_bits)?;
                output.write_bits(number, num_bits)?;
                current_entry += number;
            }

            if current_entry > entries {
                return Err(WemError::parse("current_entry out of range"));
            }
        } else {
            // IN: 3 bit codeword length length, 1 bit sparse flag
            let codeword_length_length = input.read_bits(3)?;
            let sparse = input.read_bits(1)?;

            if codeword_length_length == 0 || codeword_length_length > 5 {
                return Err(WemError::parse("nonsense codeword length"));
            }

            // OUT: 1 bit sparse flag
            output.write_bits(sparse, 1)?;

            for _ in 0..entries {
                let mut present_bool = true;

                if sparse != 0 {
                    let present = input.read_bits(1)?;
                    output.write_bits(present, 1)?;
                    present_bool = present != 0;
                }

                if present_bool {
                    // IN: n bit codeword length-1
                    let codeword_length = input.read_bits(codeword_length_length as u8)?;
                    // OUT: 5 bit codeword length-1
                    output.write_bits(codeword_length, 5)?;
                }
            }
        }

        // Lookup table
        // IN: 1 bit lookup type
        let lookup_type = input.read_bits(1)?;
        // OUT: 4 bit lookup type
        output.write_bits(lookup_type, 4)?;

        self.handle_lookup_table(input, output, entries, dimensions, lookup_type, true)?;

        // Check size if specified
        if let Some(size) = codebook_size {
            if size != 0 {
                let bytes_read = input.total_bits_read() / 8 + 1;
                if bytes_read != size as u64 {
                    return Err(WemError::size_mismatch(size as u64, bytes_read));
                }
            }
        }

        Ok(())
    }

    fn handle_lookup_table<B: BitRead, W: Write>(
        &self,
        input: &mut B,
        output: &mut BitOggStream<W>,
        entries: u32,
        dimensions: u32,
        lookup_type: u32,
        is_rebuild: bool,
    ) -> WemResult<()> {
        if lookup_type == 1 {
            let min = input.read_bits(32)?;
            let max = input.read_bits(32)?;
            let value_length = input.read_bits(4)?;
            let sequence_flag = input.read_bits(1)?;
            output.write_bits(min, 32)?;
            output.write_bits(max, 32)?;
            output.write_bits(value_length, 4)?;
            output.write_bits(sequence_flag, 1)?;

            let quantvals = book_map_type1_quantvals(entries, dimensions);
            for _ in 0..quantvals {
                let val = input.read_bits((value_length + 1) as u8)?;
                output.write_bits(val, (value_length + 1) as u8)?;
            }
        } else if lookup_type == 2 {
            if !is_rebuild {
                return Err(WemError::parse("didn't expect lookup type 2"));
            } else {
                return Err(WemError::parse("invalid lookup type"));
            }
        } else if lookup_type != 0 {
            return Err(WemError::parse("invalid lookup type"));
        }

        Ok(())
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_load_default_codebooks() {
        let lib = CodebookLibrary::default_codebooks().unwrap();
        assert!(lib.codebook_count() > 0);
    }

    #[test]
    fn test_load_aotuv_codebooks() {
        let lib = CodebookLibrary::aotuv_codebooks().unwrap();
        assert!(lib.codebook_count() > 0);
    }

    #[test]
    fn test_empty_codebook() {
        let lib = CodebookLibrary::empty();
        assert_eq!(lib.codebook_count(), 0);
        assert_eq!(lib.get_codebook_size(0), -1);
    }

    #[test]
    fn test_get_codebook() {
        let lib = CodebookLibrary::default_codebooks().unwrap();
        // First codebook should exist
        let cb = lib.get_codebook(0);
        assert!(cb.is_ok());
        assert!(!cb.unwrap().is_empty());
    }

    #[test]
    fn test_codebook_count_matches_offsets() {
        let lib = CodebookLibrary::default_codebooks().unwrap();
        // codebook_count should be offsets.len() - 1 (last offset is end marker)
        let count = lib.codebook_count();
        assert!(count > 0);

        // All codebooks up to count should be accessible
        for i in 0..count {
            assert!(lib.get_codebook(i).is_ok());
        }

        // Codebook at count should fail
        assert!(lib.get_codebook(count).is_err());
    }

    #[test]
    fn test_get_codebook_size() {
        let lib = CodebookLibrary::default_codebooks().unwrap();

        // First codebook should have positive size
        let size = lib.get_codebook_size(0);
        assert!(size > 0);

        // Size should match actual data length
        let data = lib.get_codebook(0).unwrap();
        assert_eq!(size as usize, data.len());
    }

    #[test]
    fn test_get_codebook_invalid_index() {
        let lib = CodebookLibrary::default_codebooks().unwrap();

        // Very large index should fail
        let result = lib.get_codebook(999999);
        assert!(result.is_err());
    }

    #[test]
    fn test_get_codebook_size_invalid_index() {
        let lib = CodebookLibrary::default_codebooks().unwrap();

        // Invalid index should return -1
        assert_eq!(lib.get_codebook_size(999999), -1);
    }

    #[test]
    fn test_empty_codebook_get_fails() {
        let lib = CodebookLibrary::empty();

        // Any get on empty library should fail
        assert!(lib.get_codebook(0).is_err());
    }

    #[test]
    fn test_from_bytes_too_small() {
        // Less than 4 bytes should fail
        let result = CodebookLibrary::from_bytes(&[0, 1, 2]);
        assert!(result.is_err());
    }

    #[test]
    fn test_from_bytes_invalid_offset() {
        // Create data where offset pointer points past end
        let mut data = vec![0u8; 8];
        // Set last 4 bytes to point to offset 100 (past end)
        data[4] = 100;
        data[5] = 0;
        data[6] = 0;
        data[7] = 0;

        let result = CodebookLibrary::from_bytes(&data);
        assert!(result.is_err());
    }

    #[test]
    fn test_default_and_aotuv_have_same_count() {
        let default = CodebookLibrary::default_codebooks().unwrap();
        let aotuv = CodebookLibrary::aotuv_codebooks().unwrap();

        // Both libraries should have the same number of codebooks
        assert_eq!(default.codebook_count(), aotuv.codebook_count());
    }

    #[test]
    fn test_codebook_data_is_different() {
        let default = CodebookLibrary::default_codebooks().unwrap();
        let aotuv = CodebookLibrary::aotuv_codebooks().unwrap();

        // At least some codebooks should differ between libraries
        let mut found_difference = false;
        for i in 0..default.codebook_count().min(10) {
            let d = default.get_codebook(i).unwrap();
            let a = aotuv.get_codebook(i).unwrap();
            if d != a {
                found_difference = true;
                break;
            }
        }
        assert!(found_difference, "Expected some codebooks to differ");
    }
}
