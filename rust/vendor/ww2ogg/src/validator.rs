//! Vorbis validation for converted audio streams.
//!
//! This module provides validation for converted Ogg Vorbis audio by attempting
//! to decode the output and checking for common issues like wrong codebook selection.
//!
//! # Why Validate?
//!
//! When converting Wwise audio, using the wrong codebook library will produce
//! output that appears valid but contains garbled audio. Validation catches this
//! by actually decoding the audio and checking for corruption.
//!
//! # Example
//!
//! ```no_run
//! use std::fs::File;
//! use std::io::{BufReader, Read};
//! use ww2ogg::{WwiseRiffVorbis, CodebookLibrary, validate};
//!
//! fn convert_and_validate(wem_path: &str) -> Result<Vec<u8>, ww2ogg::WemError> {
//!     let input = BufReader::new(File::open(wem_path)?);
//!     let codebooks = CodebookLibrary::default_codebooks()?;
//!     let mut converter = WwiseRiffVorbis::new(input, codebooks)?;
//!
//!     let mut ogg_data = Vec::new();
//!     converter.generate_ogg(&mut ogg_data)?;
//!
//!     // Validate the output
//!     validate(&ogg_data)?;
//!
//!     Ok(ogg_data)
//! }
//! ```
//!
//! # Auto-Detection Pattern
//!
//! A common pattern is to try default codebooks first, then fall back to aoTuV:
//!
//! ```no_run
//! use std::io::Cursor;
//! use ww2ogg::{WwiseRiffVorbis, CodebookLibrary, validate};
//!
//! fn convert_with_auto_detect(wem_data: &[u8]) -> Result<Vec<u8>, ww2ogg::WemError> {
//!     // Try default codebooks first
//!     let input = Cursor::new(wem_data);
//!     let codebooks = CodebookLibrary::default_codebooks()?;
//!     let mut converter = WwiseRiffVorbis::new(input, codebooks)?;
//!
//!     let mut ogg_data = Vec::new();
//!     converter.generate_ogg(&mut ogg_data)?;
//!
//!     if validate(&ogg_data).is_ok() {
//!         return Ok(ogg_data);
//!     }
//!
//!     // Fall back to aoTuV codebooks
//!     let input = Cursor::new(wem_data);
//!     let codebooks = CodebookLibrary::aotuv_codebooks()?;
//!     let mut converter = WwiseRiffVorbis::new(input, codebooks)?;
//!
//!     let mut ogg_data = Vec::new();
//!     converter.generate_ogg(&mut ogg_data)?;
//!     validate(&ogg_data)?;
//!
//!     Ok(ogg_data)
//! }
//! ```

use crate::error::{WemError, WemResult};
use lewton::inside_ogg::OggStreamReader;
use std::io::{Cursor, Read, Seek};

/// Validates an Ogg Vorbis stream by attempting to decode audio samples.
///
/// This function reads up to 10 packets of audio data and checks for:
/// - Valid Ogg/Vorbis stream structure
/// - Decodable audio samples (no NaN/Infinity values)
/// - Reasonable sample values (not clipping excessively)
///
/// If more than 10% of samples in any packet are invalid, validation fails.
///
/// # Arguments
///
/// * `data` - The Ogg Vorbis data to validate as a byte slice
///
/// # Returns
///
/// * `Ok(())` - The audio is valid and can be decoded
/// * `Err(WemError::Codebook)` - Validation failed (likely wrong codebook)
///
/// # Example
///
/// ```no_run
/// use ww2ogg::validate;
///
/// fn check_audio(ogg_data: &[u8]) {
///     match validate(ogg_data) {
///         Ok(()) => println!("Audio is valid!"),
///         Err(e) => println!("Validation failed: {}", e),
///     }
/// }
/// ```
pub fn validate(data: &[u8]) -> WemResult<()> {
    validate_reader(Cursor::new(data))
}

/// Validates an Ogg Vorbis stream from a reader.
///
/// See [`validate`] for details on the validation process.
pub fn validate_reader<R: Read + Seek>(reader: R) -> WemResult<()> {
    let mut ogg_reader = OggStreamReader::new(reader).map_err(|e| {
        WemError::codebook(format!(
            "Vorbis decode failed: {} - likely wrong codebook",
            e
        ))
    })?;

    let mut total_samples = 0u64;
    let mut reads = 0;
    const MAX_READS: usize = 10;

    while reads < MAX_READS {
        let packet = match ogg_reader.read_dec_packet_itl() {
            Ok(Some(samples)) => samples,
            Ok(None) => break, // End of stream
            Err(e) => {
                return Err(WemError::codebook(format!(
                    "Vorbis decode failed: {} - likely wrong codebook",
                    e
                )));
            }
        };

        if packet.is_empty() {
            continue;
        }

        let samples_read = packet.len();
        total_samples += samples_read as u64;
        reads += 1;

        // Check for invalid samples (excessive clipping at max values)
        let mut bad_samples = 0;
        for &sample in &packet {
            // Check for samples at absolute max (potential clipping/corruption)
            if sample == i16::MIN || sample == i16::MAX {
                bad_samples += 1;
            }
        }

        if bad_samples > samples_read / 10 {
            return Err(WemError::codebook(format!(
                "Decoded audio has {}/{} invalid samples - likely wrong codebook",
                bad_samples, samples_read
            )));
        }
    }

    if total_samples == 0 {
        return Err(WemError::codebook(
            "No audio samples could be decoded - likely wrong codebook".to_string(),
        ));
    }

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_validate_empty_fails() {
        let result = validate(&[]);
        assert!(result.is_err());
    }

    #[test]
    fn test_validate_garbage_fails() {
        let garbage = vec![0u8; 1000];
        let result = validate(&garbage);
        assert!(result.is_err());
    }
}
