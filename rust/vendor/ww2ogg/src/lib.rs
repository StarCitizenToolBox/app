//! # ww2ogg
//!
//! Convert Wwise RIFF/RIFX Vorbis audio files (.wem) to standard Ogg Vorbis format.
//!
//! This is a Rust port of ww2ogg, which converts Wwise audio containers back to
//! standard Ogg Vorbis streams by rebuilding the Vorbis headers and converting
//! the audio packets.
//!
//! ## Overview
//!
//! Wwise (by Audiokinetic) is a popular audio middleware used in games. It stores
//! audio in a modified Vorbis format that strips the standard headers and references
//! external codebook libraries. This crate converts these files back to standard
//! Ogg Vorbis that can be played by any audio player.
//!
//! ## Quick Start
//!
//! ```no_run
//! use std::fs::File;
//! use std::io::{BufReader, BufWriter};
//! use ww2ogg::{WwiseRiffVorbis, CodebookLibrary};
//!
//! fn main() -> Result<(), ww2ogg::WemError> {
//!     // Open input .wem file
//!     let input = BufReader::new(File::open("input.wem")?);
//!
//!     // Load the default codebook library
//!     let codebooks = CodebookLibrary::default_codebooks()?;
//!
//!     // Create converter and parse the input
//!     let mut converter = WwiseRiffVorbis::new(input, codebooks)?;
//!
//!     // Convert to Ogg Vorbis
//!     let mut output = BufWriter::new(File::create("output.ogg")?);
//!     converter.generate_ogg(&mut output)?;
//!
//!     Ok(())
//! }
//! ```
//!
//! ## Codebook Libraries
//!
//! Wwise audio files reference external codebook libraries. Two are provided:
//!
//! - [`CodebookLibrary::default_codebooks()`] - Standard codebooks (try this first)
//! - [`CodebookLibrary::aotuv_codebooks()`] - aoTuV 6.03 codebooks (for some games)
//!
//! If conversion produces garbled audio, try the other codebook library.
//!
//! ## Validation
//!
//! Use [`validate()`] to verify the converted audio is valid:
//!
//! ```no_run
//! use ww2ogg::validate;
//!
//! fn check_output(ogg_data: &[u8]) -> Result<(), ww2ogg::WemError> {
//!     validate(ogg_data)?;
//!     println!("Audio is valid!");
//!     Ok(())
//! }
//! ```
//!
//! ## Builder Pattern
//!
//! For advanced configuration, use the builder pattern:
//!
//! ```no_run
//! use std::fs::File;
//! use ww2ogg::{WwiseRiffVorbis, CodebookLibrary, ForcePacketFormat};
//!
//! # fn main() -> Result<(), ww2ogg::WemError> {
//! let input = File::open("input.wem")?;
//! let codebooks = CodebookLibrary::aotuv_codebooks()?;
//!
//! let mut converter = WwiseRiffVorbis::builder(input, codebooks)
//!     .inline_codebooks(false)
//!     .full_setup(false)
//!     .force_packet_format(ForcePacketFormat::NoForce)
//!     .build()?;
//! # Ok(())
//! # }
//! ```
//!
//! ## Error Handling
//!
//! All operations return [`WemResult<T>`], which is an alias for `Result<T, WemError>`.
//! Common errors include:
//!
//! - [`WemError::Parse`] - Invalid or corrupted input file
//! - [`WemError::SizeMismatch`] - Wrong codebook library (try the other one)
//! - [`WemError::InvalidCodebookId`] - Try `--inline-codebooks` option
//! - [`WemError::Codebook`] - Validation failed, likely wrong codebook

mod bit_ogg_stream;
mod bit_reader;
mod codebook;
mod error;
mod ogg_crc;
mod packet;
pub mod validator;
mod vorbis_helpers;
mod wwise_riff_vorbis;

pub use codebook::CodebookLibrary;
pub use error::{WemError, WemResult};
pub use validator::validate;
pub use wwise_riff_vorbis::{
    ConversionOptions, ForcePacketFormat, WwiseRiffVorbis, WwiseRiffVorbisBuilder,
};
