//! Wwise RIFF/RIFX Vorbis converter.
//!
//! This module provides the main [`WwiseRiffVorbis`] converter that transforms
//! Wwise audio files (.wem) to standard Ogg Vorbis format.
//!
//! # How It Works
//!
//! Wwise audio files use a modified Vorbis format:
//!
//! 1. **RIFF/RIFX Container** - Standard RIFF format with chunks for format info,
//!    cue points, sample loops, and audio data
//! 2. **Stripped Headers** - Vorbis identification and setup headers are stripped
//!    and replaced with compact Wwise-specific data
//! 3. **External Codebooks** - Codebook data is referenced by ID from an external
//!    library rather than embedded in the file
//! 4. **Modified Packets** - Audio packets may use a modified format with different
//!    mode/window handling
//!
//! This converter rebuilds the standard Vorbis headers and converts the audio
//! packets back to standard Ogg Vorbis format.
//!
//! # Example
//!
//! ```no_run
//! use std::fs::File;
//! use std::io::BufReader;
//! use ww2ogg::{WwiseRiffVorbis, CodebookLibrary};
//!
//! # fn main() -> Result<(), ww2ogg::WemError> {
//! let input = BufReader::new(File::open("audio.wem")?);
//! let codebooks = CodebookLibrary::default_codebooks()?;
//!
//! let mut converter = WwiseRiffVorbis::new(input, codebooks)?;
//!
//! let mut output = File::create("audio.ogg")?;
//! converter.generate_ogg(&mut output)?;
//! # Ok(())
//! # }
//! ```

use crate::bit_ogg_stream::BitOggStream;
use crate::bit_reader::BitReader;
use crate::codebook::CodebookLibrary;
use crate::error::{WemError, WemResult};
use crate::packet::{Packet, Packet8};
use crate::vorbis_helpers::ilog;
use std::io::{Read, Seek, SeekFrom, Write};

const VERSION: &str = "0.24";
const VORBIS_BYTES: &[u8] = b"vorbis";

/// Specifies how to handle Wwise modified Vorbis packet format.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Default)]
pub enum ForcePacketFormat {
    /// Automatically detect packet format from the file header.
    #[default]
    NoForce,
    /// Force interpretation as modified Wwise packets.
    ForceModPackets,
    /// Force interpretation as standard Vorbis packets.
    ForceNoModPackets,
}

/// Configuration options for Wwise to Ogg conversion.
///
/// Use this struct to configure the conversion behavior instead of passing
/// multiple boolean parameters.
///
/// # Example
///
/// ```
/// use ww2ogg::{ConversionOptions, ForcePacketFormat};
///
/// let options = ConversionOptions::default()
///     .with_inline_codebooks(true)
///     .with_force_packet_format(ForcePacketFormat::ForceModPackets);
/// ```
#[derive(Debug, Clone, Default)]
pub struct ConversionOptions {
    /// If true, codebooks are embedded inline in the audio data rather than
    /// being referenced from an external codebook library.
    pub inline_codebooks: bool,

    /// If true, the setup packet contains the full Vorbis setup data
    /// rather than the stripped Wwise format.
    pub full_setup: bool,

    /// How to handle Wwise modified packet format detection.
    pub force_packet_format: ForcePacketFormat,
}

impl ConversionOptions {
    /// Create new default options.
    pub fn new() -> Self {
        Self::default()
    }

    /// Set whether codebooks are inline in the data.
    pub fn with_inline_codebooks(mut self, value: bool) -> Self {
        self.inline_codebooks = value;
        self
    }

    /// Set whether the setup packet contains full Vorbis setup.
    pub fn with_full_setup(mut self, value: bool) -> Self {
        self.full_setup = value;
        self
    }

    /// Set the packet format detection mode.
    pub fn with_force_packet_format(mut self, format: ForcePacketFormat) -> Self {
        self.force_packet_format = format;
        self
    }
}

/// Builder for creating [`WwiseRiffVorbis`] converters with custom options.
///
/// This provides a fluent API for configuring the converter.
///
/// # Example
///
/// ```ignore
/// use std::fs::File;
/// use ww2ogg::{WwiseRiffVorbis, CodebookLibrary};
///
/// let input = File::open("input.wem")?;
/// let codebooks = CodebookLibrary::aotuv_codebooks()?;
///
/// let converter = WwiseRiffVorbis::builder(input, codebooks)
///     .inline_codebooks(false)
///     .full_setup(false)
///     .build()?;
/// # Ok::<(), ww2ogg::WemError>(())
/// ```
pub struct WwiseRiffVorbisBuilder<R> {
    input: R,
    codebooks: CodebookLibrary,
    options: ConversionOptions,
}

impl<R: Read + Seek> WwiseRiffVorbisBuilder<R> {
    /// Create a new builder with the given input and codebook library.
    pub fn new(input: R, codebooks: CodebookLibrary) -> Self {
        Self {
            input,
            codebooks,
            options: ConversionOptions::default(),
        }
    }

    /// Set whether codebooks are inline in the data.
    pub fn inline_codebooks(mut self, value: bool) -> Self {
        self.options.inline_codebooks = value;
        self
    }

    /// Set whether the setup packet contains full Vorbis setup.
    pub fn full_setup(mut self, value: bool) -> Self {
        self.options.full_setup = value;
        self
    }

    /// Set the packet format detection mode.
    pub fn force_packet_format(mut self, format: ForcePacketFormat) -> Self {
        self.options.force_packet_format = format;
        self
    }

    /// Set all options from a ConversionOptions struct.
    pub fn options(mut self, options: ConversionOptions) -> Self {
        self.options = options;
        self
    }

    /// Build the converter, parsing the input stream.
    pub fn build(self) -> WemResult<WwiseRiffVorbis<R>> {
        WwiseRiffVorbis::with_options(
            self.input,
            self.codebooks,
            self.options.inline_codebooks,
            self.options.full_setup,
            self.options.force_packet_format,
        )
    }
}

/// Location and size of a RIFF chunk.
#[derive(Debug, Clone, Copy, Default)]
struct ChunkLocation {
    /// Byte offset from the start of the file.
    offset: u64,
    /// Size of the chunk data in bytes.
    size: u64,
}

impl ChunkLocation {
    /// Create a new chunk location.
    fn new(offset: u64, size: u64) -> Self {
        Self { offset, size }
    }
}

/// Collection of RIFF chunk locations found in the file.
#[derive(Debug, Clone, Default)]
struct ChunkInfo {
    /// Format chunk ("fmt ") - required.
    fmt: Option<ChunkLocation>,
    /// Cue points chunk ("cue ").
    cue: Option<ChunkLocation>,
    /// List chunk ("LIST").
    list: Option<ChunkLocation>,
    /// Sample chunk ("smpl").
    smpl: Option<ChunkLocation>,
    /// Vorbis info chunk ("vorb").
    vorb: Option<ChunkLocation>,
    /// Audio data chunk ("data") - required.
    data: Option<ChunkLocation>,
}

/// Converts Wwise RIFF/RIFX Vorbis audio files (.wem) to standard Ogg Vorbis format.
///
/// This is the main converter type. Create an instance by calling [`new()`](Self::new)
/// or using the [`builder()`](Self::builder) pattern, then call [`generate_ogg()`](Self::generate_ogg)
/// to perform the conversion.
///
/// # Example
///
/// ```no_run
/// use std::fs::File;
/// use std::io::BufReader;
/// use ww2ogg::{WwiseRiffVorbis, CodebookLibrary};
///
/// # fn main() -> Result<(), ww2ogg::WemError> {
/// // Basic usage with default options
/// let input = BufReader::new(File::open("input.wem")?);
/// let codebooks = CodebookLibrary::default_codebooks()?;
/// let mut converter = WwiseRiffVorbis::new(input, codebooks)?;
///
/// let mut output = File::create("output.ogg")?;
/// converter.generate_ogg(&mut output)?;
/// # Ok(())
/// # }
/// ```
///
/// # Advanced Usage
///
/// For files that need special handling, use the builder pattern:
///
/// ```no_run
/// use std::fs::File;
/// use ww2ogg::{WwiseRiffVorbis, CodebookLibrary, ForcePacketFormat};
///
/// # fn main() -> Result<(), ww2ogg::WemError> {
/// let input = File::open("special.wem")?;
/// let codebooks = CodebookLibrary::aotuv_codebooks()?;
///
/// let mut converter = WwiseRiffVorbis::builder(input, codebooks)
///     .inline_codebooks(true)   // Codebooks embedded in file
///     .full_setup(true)         // Full Vorbis setup present
///     .force_packet_format(ForcePacketFormat::ForceModPackets)
///     .build()?;
///
/// let mut output = File::create("output.ogg")?;
/// converter.generate_ogg(&mut output)?;
/// # Ok(())
/// # }
/// ```
#[allow(dead_code)]
pub struct WwiseRiffVorbis<R: Read + Seek> {
    input: R,
    codebooks: CodebookLibrary,
    inline_codebooks: bool,
    full_setup: bool,
    little_endian: bool,
    file_size: u64,
    riff_size: u64,

    /// RIFF chunk locations
    chunks: ChunkInfo,

    // RIFF fmt
    channels: u16,
    sample_rate: u32,
    avg_bytes_per_second: u32,
    ext_unk: u16,
    subtype: u32,

    // Cue info
    cue_count: u32,

    // Smpl info
    loop_count: u32,
    loop_start: u32,
    loop_end: u32,

    // Vorbis info
    sample_count: u32,
    uid: u32,
    blocksize_0_pow: u8,
    blocksize_1_pow: u8,
    setup_packet_offset: u32,
    first_audio_packet_offset: u32,

    // Flags
    no_granule: bool,
    mod_packets: bool,
    header_triad_present: bool,
    old_packet_headers: bool,
}

impl<R: Read + Seek> WwiseRiffVorbis<R> {
    /// Creates a new WwiseRiffVorbis converter and parses the input stream.
    ///
    /// This uses default options. For more control, use [`builder()`](Self::builder).
    pub fn new(input: R, codebooks: CodebookLibrary) -> WemResult<Self> {
        Self::with_options(input, codebooks, false, false, ForcePacketFormat::NoForce)
    }

    /// Creates a builder for configuring and constructing a converter.
    ///
    /// # Example
    ///
    /// ```ignore
    /// use std::fs::File;
    /// use ww2ogg::{WwiseRiffVorbis, CodebookLibrary};
    ///
    /// let input = File::open("input.wem")?;
    /// let codebooks = CodebookLibrary::aotuv_codebooks()?;
    ///
    /// let converter = WwiseRiffVorbis::builder(input, codebooks)
    ///     .inline_codebooks(false)
    ///     .full_setup(false)
    ///     .build()?;
    /// # Ok::<(), ww2ogg::WemError>(())
    /// ```
    pub fn builder(input: R, codebooks: CodebookLibrary) -> WwiseRiffVorbisBuilder<R> {
        WwiseRiffVorbisBuilder::new(input, codebooks)
    }

    /// Creates a new WwiseRiffVorbis converter with all options.
    ///
    /// Consider using [`builder()`](Self::builder) for a more ergonomic API.
    pub fn with_options(
        mut input: R,
        codebooks: CodebookLibrary,
        inline_codebooks: bool,
        full_setup: bool,
        force_packet_format: ForcePacketFormat,
    ) -> WemResult<Self> {
        // Get file size
        input.seek(SeekFrom::End(0))?;
        let file_size = input.stream_position()?;
        input.seek(SeekFrom::Start(0))?;

        // Check RIFF header
        let mut riff_head = [0u8; 4];
        input.read_exact(&mut riff_head)?;

        let little_endian = if &riff_head == b"RIFX" {
            false
        } else if &riff_head == b"RIFF" {
            true
        } else {
            return Err(WemError::parse("missing RIFF"));
        };

        let riff_size = Self::read_u32_static(&mut input, little_endian)? as u64 + 8;

        if riff_size > file_size {
            return Err(WemError::parse("RIFF truncated"));
        }

        let mut wave_head = [0u8; 4];
        input.read_exact(&mut wave_head)?;

        if &wave_head != b"WAVE" {
            return Err(WemError::parse("missing WAVE"));
        }

        let mut converter = Self {
            input,
            codebooks,
            inline_codebooks,
            full_setup,
            little_endian,
            file_size,
            riff_size,
            chunks: ChunkInfo::default(),
            channels: 0,
            sample_rate: 0,
            avg_bytes_per_second: 0,
            ext_unk: 0,
            subtype: 0,
            cue_count: 0,
            loop_count: 0,
            loop_start: 0,
            loop_end: 0,
            sample_count: 0,
            uid: 0,
            blocksize_0_pow: 0,
            blocksize_1_pow: 0,
            setup_packet_offset: 0,
            first_audio_packet_offset: 0,
            no_granule: false,
            mod_packets: false,
            header_triad_present: false,
            old_packet_headers: false,
        };

        converter.read_chunks()?;
        converter.parse_fmt_chunk()?;
        converter.parse_cue_chunk()?;
        converter.parse_smpl_chunk()?;
        converter.parse_vorb_chunk(force_packet_format)?;
        converter.validate_loops()?;

        Ok(converter)
    }

    // Helper methods for reading values
    fn read_u32_static(input: &mut R, little_endian: bool) -> WemResult<u32> {
        let mut buf = [0u8; 4];
        input.read_exact(&mut buf)?;
        Ok(if little_endian {
            u32::from_le_bytes(buf)
        } else {
            u32::from_be_bytes(buf)
        })
    }

    fn read_u32(&mut self) -> WemResult<u32> {
        Self::read_u32_static(&mut self.input, self.little_endian)
    }

    fn read_u16(&mut self) -> WemResult<u16> {
        let mut buf = [0u8; 2];
        self.input.read_exact(&mut buf)?;
        Ok(if self.little_endian {
            u16::from_le_bytes(buf)
        } else {
            u16::from_be_bytes(buf)
        })
    }

    fn read_byte(&mut self) -> WemResult<u8> {
        let mut buf = [0u8; 1];
        self.input.read_exact(&mut buf)?;
        Ok(buf[0])
    }

    fn read_chunks(&mut self) -> WemResult<()> {
        let mut chunk_offset: u64 = 12;

        while chunk_offset < self.riff_size {
            self.input.seek(SeekFrom::Start(chunk_offset))?;

            if chunk_offset + 8 > self.riff_size {
                return Err(WemError::parse("chunk header truncated"));
            }

            let mut chunk_type = [0u8; 4];
            self.input.read_exact(&mut chunk_type)?;
            let chunk_size = self.read_u32()? as u64;

            let data_offset = chunk_offset + 8;
            match &chunk_type {
                b"fmt " => {
                    self.chunks.fmt = Some(ChunkLocation::new(data_offset, chunk_size));
                }
                b"cue " => {
                    self.chunks.cue = Some(ChunkLocation::new(data_offset, chunk_size));
                }
                b"LIST" => {
                    self.chunks.list = Some(ChunkLocation::new(data_offset, chunk_size));
                }
                b"smpl" => {
                    self.chunks.smpl = Some(ChunkLocation::new(data_offset, chunk_size));
                }
                b"vorb" => {
                    self.chunks.vorb = Some(ChunkLocation::new(data_offset, chunk_size));
                }
                b"data" => {
                    self.chunks.data = Some(ChunkLocation::new(data_offset, chunk_size));
                }
                _ => {}
            }

            chunk_offset = chunk_offset + 8 + chunk_size;
        }

        if chunk_offset > self.riff_size {
            return Err(WemError::parse("chunk truncated"));
        }

        if self.chunks.fmt.is_none() || self.chunks.data.is_none() {
            return Err(WemError::parse("expected fmt, data chunks"));
        }

        Ok(())
    }

    fn parse_fmt_chunk(&mut self) -> WemResult<()> {
        let fmt = self
            .chunks
            .fmt
            .ok_or_else(|| WemError::parse("missing fmt chunk"))?;
        let fmt_size = fmt.size;

        if self.chunks.vorb.is_none() && fmt_size != 0x42 {
            return Err(WemError::parse("expected 0x42 fmt if vorb missing"));
        }

        if self.chunks.vorb.is_some() && fmt_size != 0x28 && fmt_size != 0x18 && fmt_size != 0x12 {
            return Err(WemError::parse("bad fmt size"));
        }

        // If vorb chunk is missing but fmt is 0x42, vorb data is embedded in fmt
        if self.chunks.vorb.is_none() && fmt_size == 0x42 {
            self.chunks.vorb = Some(ChunkLocation::new(fmt.offset + 0x18, fmt_size - 0x18));
        }

        self.input.seek(SeekFrom::Start(fmt.offset))?;

        if self.read_u16()? != 0xFFFF {
            return Err(WemError::parse("bad codec id"));
        }

        self.channels = self.read_u16()?;
        self.sample_rate = self.read_u32()?;
        self.avg_bytes_per_second = self.read_u32()?;

        if self.read_u16()? != 0 {
            return Err(WemError::parse("bad block align"));
        }

        if self.read_u16()? != 0 {
            return Err(WemError::parse("expected 0 bps"));
        }

        if self.read_u16()? != (fmt_size - 0x12) as u16 {
            return Err(WemError::parse("bad extra fmt length"));
        }

        if fmt_size - 0x12 >= 2 {
            self.ext_unk = self.read_u16()?;

            if fmt_size - 0x12 >= 6 {
                self.subtype = self.read_u32()?;
            }
        }

        if fmt_size == 0x28 {
            let mut unknown = [0u8; 16];
            let expected: [u8; 16] = [
                1, 0, 0, 0, 0, 0, 0x10, 0, 0x80, 0, 0, 0xAA, 0, 0x38, 0x9b, 0x71,
            ];
            self.input.read_exact(&mut unknown)?;

            if unknown != expected {
                return Err(WemError::parse("expected signature in extra fmt?"));
            }
        }

        Ok(())
    }

    fn parse_cue_chunk(&mut self) -> WemResult<()> {
        if let Some(cue) = self.chunks.cue {
            self.input.seek(SeekFrom::Start(cue.offset))?;
            self.cue_count = self.read_u32()?;
        }
        Ok(())
    }

    fn parse_smpl_chunk(&mut self) -> WemResult<()> {
        if let Some(smpl) = self.chunks.smpl {
            self.input.seek(SeekFrom::Start(smpl.offset + 0x1C))?;
            self.loop_count = self.read_u32()?;

            if self.loop_count != 1 {
                return Err(WemError::parse("expected one loop"));
            }

            self.input.seek(SeekFrom::Start(smpl.offset + 0x2C))?;
            self.loop_start = self.read_u32()?;
            self.loop_end = self.read_u32()?;
        }
        Ok(())
    }

    fn parse_vorb_chunk(&mut self, force_packet_format: ForcePacketFormat) -> WemResult<()> {
        let vorb = self
            .chunks
            .vorb
            .ok_or_else(|| WemError::parse("missing vorb chunk"))?;
        let vorb_size = vorb.size;

        match vorb_size {
            0x28 | 0x2A | 0x2C | 0x32 | 0x34 => {
                self.input.seek(SeekFrom::Start(vorb.offset))?;
            }
            _ => return Err(WemError::parse("bad vorb size")),
        }

        self.sample_count = self.read_u32()?;

        match vorb_size {
            0x2A => {
                self.no_granule = true;
                self.input.seek(SeekFrom::Start(vorb.offset + 0x4))?;
                let mod_signal = self.read_u32()?;

                if mod_signal != 0x4A
                    && mod_signal != 0x4B
                    && mod_signal != 0x69
                    && mod_signal != 0x70
                {
                    self.mod_packets = true;
                }

                self.input.seek(SeekFrom::Start(vorb.offset + 0x10))?;
            }
            _ => {
                self.input.seek(SeekFrom::Start(vorb.offset + 0x18))?;
            }
        }

        if force_packet_format == ForcePacketFormat::ForceNoModPackets {
            self.mod_packets = false;
        } else if force_packet_format == ForcePacketFormat::ForceModPackets {
            self.mod_packets = true;
        }

        self.setup_packet_offset = self.read_u32()?;
        self.first_audio_packet_offset = self.read_u32()?;

        match vorb_size {
            0x2A => {
                self.input.seek(SeekFrom::Start(vorb.offset + 0x24))?;
            }
            0x32 | 0x34 => {
                self.input.seek(SeekFrom::Start(vorb.offset + 0x2C))?;
            }
            _ => {}
        }

        match vorb_size {
            0x28 | 0x2C => {
                self.header_triad_present = true;
                self.old_packet_headers = true;
            }
            0x2A | 0x32 | 0x34 => {
                self.uid = self.read_u32()?;
                self.blocksize_0_pow = self.read_byte()?;
                self.blocksize_1_pow = self.read_byte()?;
            }
            _ => {}
        }

        Ok(())
    }

    fn validate_loops(&mut self) -> WemResult<()> {
        if self.loop_count != 0 {
            if self.loop_end == 0 {
                self.loop_end = self.sample_count;
            } else {
                self.loop_end += 1;
            }

            if self.loop_start >= self.sample_count
                || self.loop_end > self.sample_count
                || self.loop_start > self.loop_end
            {
                return Err(WemError::parse("loops out of range"));
            }
        }
        Ok(())
    }

    /// Generates a standard Ogg Vorbis stream from the parsed Wwise audio data.
    ///
    /// This method performs the actual conversion, writing a complete Ogg Vorbis
    /// stream to the provided output. The output includes:
    ///
    /// 1. **Identification header** - Vorbis version, channels, sample rate, etc.
    /// 2. **Comment header** - Vendor string identifying this converter
    /// 3. **Setup header** - Codebooks, floor/residue/mapping configuration
    /// 4. **Audio packets** - Converted audio data with proper granule positions
    ///
    /// # Arguments
    ///
    /// * `output` - Any type implementing [`Write`], such as a file or buffer
    ///
    /// # Errors
    ///
    /// Returns an error if:
    /// - The audio data is corrupted or truncated
    /// - A referenced codebook ID is not found in the library
    /// - The codebook data doesn't match (wrong codebook library)
    ///
    /// # Example
    ///
    /// ```no_run
    /// use std::fs::File;
    /// use std::io::{BufReader, BufWriter};
    /// use ww2ogg::{WwiseRiffVorbis, CodebookLibrary};
    ///
    /// # fn main() -> Result<(), ww2ogg::WemError> {
    /// let input = BufReader::new(File::open("input.wem")?);
    /// let codebooks = CodebookLibrary::default_codebooks()?;
    /// let mut converter = WwiseRiffVorbis::new(input, codebooks)?;
    ///
    /// // Write to a file
    /// let output = BufWriter::new(File::create("output.ogg")?);
    /// converter.generate_ogg(output)?;
    /// # Ok(())
    /// # }
    /// ```
    ///
    /// You can also write to a `Vec<u8>` for in-memory processing:
    ///
    /// ```no_run
    /// use std::io::Cursor;
    /// use ww2ogg::{WwiseRiffVorbis, CodebookLibrary};
    ///
    /// # fn convert(wem_data: &[u8]) -> Result<Vec<u8>, ww2ogg::WemError> {
    /// let input = Cursor::new(wem_data);
    /// let codebooks = CodebookLibrary::default_codebooks()?;
    /// let mut converter = WwiseRiffVorbis::new(input, codebooks)?;
    ///
    /// let mut ogg_data = Vec::new();
    /// converter.generate_ogg(&mut ogg_data)?;
    /// # Ok(ogg_data)
    /// # }
    /// ```
    pub fn generate_ogg<W: Write>(&mut self, output: W) -> WemResult<()> {
        let data = self
            .chunks
            .data
            .ok_or_else(|| WemError::parse("missing data chunk"))?;
        let data_offset = data.offset;
        let data_size = data.size;
        let data_end = data_offset + data_size;

        let mut ogg = BitOggStream::new(output);
        let mut mode_blockflag: Option<Vec<bool>> = None;
        let mut mode_bits = 0i32;
        let mut prev_blockflag = false;

        if self.header_triad_present {
            self.generate_ogg_header_with_triad(&mut ogg)?;
        } else {
            let (mf, mb) = self.generate_ogg_header(&mut ogg)?;
            mode_blockflag = Some(mf);
            mode_bits = mb;
        }

        // For granule calculation
        let blocksize_0 = 1u32 << self.blocksize_0_pow;
        let blocksize_1 = 1u32 << self.blocksize_1_pow;
        let mut granule_pos: i64 = 0;
        let mut prev_blocksize: u32 = 0;
        let mut first_packet = true;

        // Audio pages
        let mut offset = data_offset + self.first_audio_packet_offset as u64;

        while offset < data_end {
            let (packet_header_size, size, packet_payload_offset, granule, next_offset) =
                if self.old_packet_headers {
                    let packet = Packet8::read(&mut self.input, offset, self.little_endian)?;
                    (
                        packet.header_size,
                        packet.size,
                        packet.offset,
                        packet.granule,
                        packet.next_offset,
                    )
                } else {
                    let packet =
                        Packet::read(&mut self.input, offset, self.little_endian, self.no_granule)?;
                    (
                        packet.header_size,
                        packet.size,
                        packet.offset,
                        packet.granule,
                        packet.next_offset,
                    )
                };

            if offset + packet_header_size > data_end {
                return Err(WemError::parse("page header truncated"));
            }

            offset = packet_payload_offset;
            self.input.seek(SeekFrom::Start(offset))?;

            // Determine granule for this page
            let is_last_packet = next_offset >= data_end;

            if self.no_granule {
                // Calculate granule from block sizes
                let curr_blocksize = if let Some(ref mbf) = mode_blockflag {
                    if mode_bits > 0 && size > 0 {
                        // Read mode number from first byte
                        let first_byte = self.read_byte()?;
                        self.input.seek(SeekFrom::Start(offset))?; // Seek back

                        let mode_number = if self.mod_packets {
                            (first_byte as u32) & ((1 << mode_bits) - 1)
                        } else {
                            ((first_byte as u32) >> 1) & ((1 << mode_bits) - 1)
                        };

                        if (mode_number as usize) < mbf.len() {
                            if mbf[mode_number as usize] {
                                blocksize_1
                            } else {
                                blocksize_0
                            }
                        } else {
                            blocksize_0
                        }
                    } else {
                        blocksize_0
                    }
                } else {
                    blocksize_0
                };

                // Calculate samples for this packet
                if first_packet {
                    first_packet = false;
                } else {
                    granule_pos += ((prev_blocksize + curr_blocksize) / 4) as i64;
                }

                prev_blocksize = curr_blocksize;

                if is_last_packet && self.sample_count > 0 {
                    ogg.set_granule(self.sample_count as u64);
                } else {
                    ogg.set_granule(granule_pos as u64);
                }
            } else {
                // Use granule from packet
                ogg.set_granule(if granule == 0xFFFFFFFF {
                    1
                } else {
                    granule as u64
                });
            }

            // First byte handling
            if self.mod_packets {
                let mbf = mode_blockflag
                    .as_ref()
                    .ok_or_else(|| WemError::parse("didn't load mode_blockflag"))?;

                // OUT: 1 bit packet type (0 == audio)
                ogg.write_bits(0, 1)?;

                self.input.seek(SeekFrom::Start(offset))?;
                let mut bit_reader = BitReader::new(&mut self.input);

                // IN/OUT: N bit mode number
                let mode_number = bit_reader.read_bits(mode_bits as u8)?;
                ogg.write_bits(mode_number, mode_bits as u8)?;

                // IN: remaining bits of first byte
                let remainder = bit_reader.read_bits((8 - mode_bits) as u8)?;

                if mbf[mode_number as usize] {
                    // Long window, peek at next frame
                    let next_blockflag = if next_offset + packet_header_size <= data_end {
                        let next_packet = Packet::read(
                            &mut self.input,
                            next_offset,
                            self.little_endian,
                            self.no_granule,
                        )?;
                        if next_packet.size > 0 {
                            self.input.seek(SeekFrom::Start(next_packet.offset))?;
                            let mut next_bit_reader = BitReader::new(&mut self.input);
                            let next_mode_number = next_bit_reader.read_bits(mode_bits as u8)?;
                            mbf[next_mode_number as usize]
                        } else {
                            false
                        }
                    } else {
                        false
                    };

                    // OUT: previous/next window type bits
                    ogg.write_bits(if prev_blockflag { 1 } else { 0 }, 1)?;
                    ogg.write_bits(if next_blockflag { 1 } else { 0 }, 1)?;

                    self.input.seek(SeekFrom::Start(offset + 1))?;
                }

                prev_blockflag = mbf[mode_number as usize];
                ogg.write_bits(remainder, (8 - mode_bits) as u8)?;
            } else {
                let v = self.read_byte()?;
                ogg.write_bits(v as u32, 8)?;
            }

            // Remainder of packet
            for _ in 1..size {
                let v = self.read_byte()?;
                ogg.write_bits(v as u32, 8)?;
            }

            offset = next_offset;
            ogg.flush_page(false, offset == data_end)?;
        }

        if offset > data_end {
            return Err(WemError::parse("page truncated"));
        }

        Ok(())
    }

    /// Generates a time-windowed Ogg Vorbis stream.
    ///
    /// This method allows extracting a segment by sample-time window, without
    /// writing the full audio stream. It still parses packet headers sequentially
    /// to keep packet/window state valid.
    pub fn generate_ogg_window<W: Write>(
        &mut self,
        output: W,
        start_seconds: f64,
        duration_seconds: f64,
    ) -> WemResult<()> {
        let start_seconds = if start_seconds.is_finite() {
            start_seconds.max(0.0)
        } else {
            0.0
        };
        let duration_seconds = if duration_seconds.is_finite() {
            duration_seconds.max(0.0)
        } else {
            0.0
        };
        let target_start_granule = (start_seconds * self.sample_rate as f64) as u64;
        let target_end_granule = if duration_seconds > 0.0 {
            Some(target_start_granule.saturating_add(
                (duration_seconds * self.sample_rate as f64) as u64,
            ))
        } else {
            None
        };

        let data = self
            .chunks
            .data
            .ok_or_else(|| WemError::parse("missing data chunk"))?;
        let data_offset = data.offset;
        let data_size = data.size;
        let data_end = data_offset + data_size;

        let mut ogg = BitOggStream::new(output);
        let mut mode_blockflag: Option<Vec<bool>> = None;
        let mut mode_bits = 0i32;
        let mut prev_blockflag = false;

        if self.header_triad_present {
            self.generate_ogg_header_with_triad(&mut ogg)?;
        } else {
            let (mf, mb) = self.generate_ogg_header(&mut ogg)?;
            mode_blockflag = Some(mf);
            mode_bits = mb;
        }

        // For granule calculation.
        let blocksize_0 = 1u32 << self.blocksize_0_pow;
        let mut granule_pos: i64 = 0;
        let mut prev_blocksize: u32 = 0;
        let mut first_packet = true;
        let mut previous_packet_granule = 0u64;
        let mut wrote_any_packet = false;

        // Audio pages.
        let mut offset = data_offset + self.first_audio_packet_offset as u64;
        while offset < data_end {
            let (packet_header_size, size, packet_payload_offset, granule, next_offset) =
                if self.old_packet_headers {
                    let packet = Packet8::read(&mut self.input, offset, self.little_endian)?;
                    (
                        packet.header_size,
                        packet.size,
                        packet.offset,
                        packet.granule,
                        packet.next_offset,
                    )
                } else {
                    let packet =
                        Packet::read(&mut self.input, offset, self.little_endian, self.no_granule)?;
                    (
                        packet.header_size,
                        packet.size,
                        packet.offset,
                        packet.granule,
                        packet.next_offset,
                    )
                };

            if offset + packet_header_size > data_end {
                return Err(WemError::parse("page header truncated"));
            }

            let packet_start_offset = packet_payload_offset;
            let is_last_packet = next_offset >= data_end;

            // Determine granule for this page.
            let packet_granule = if self.no_granule {
                let curr_blocksize = if let Some(ref mbf) = mode_blockflag {
                    if mode_bits > 0 && size > 0 {
                        self.input.seek(SeekFrom::Start(packet_start_offset))?;
                        let first_byte = self.read_byte()?;
                        let mode_number = if self.mod_packets {
                            (first_byte as u32) & ((1 << mode_bits) - 1)
                        } else {
                            ((first_byte as u32) >> 1) & ((1 << mode_bits) - 1)
                        };
                        if (mode_number as usize) < mbf.len() && mbf[mode_number as usize] {
                            1u32 << self.blocksize_1_pow
                        } else {
                            blocksize_0
                        }
                    } else {
                        blocksize_0
                    }
                } else {
                    blocksize_0
                };

                if first_packet {
                    first_packet = false;
                } else {
                    granule_pos += ((prev_blocksize + curr_blocksize) / 4) as i64;
                }
                prev_blocksize = curr_blocksize;
                if is_last_packet && self.sample_count > 0 {
                    self.sample_count as u64
                } else {
                    granule_pos.max(0) as u64
                }
            } else if granule == 0xFFFFFFFF {
                1
            } else {
                granule as u64
            };

            let in_window = packet_granule > target_start_granule
                && target_end_granule
                    .map(|end| previous_packet_granule < end)
                    .unwrap_or(true);

            if in_window {
                self.input.seek(SeekFrom::Start(packet_start_offset))?;
                ogg.set_granule(packet_granule);

                // First byte handling.
                if self.mod_packets {
                    let mbf = mode_blockflag
                        .as_ref()
                        .ok_or_else(|| WemError::parse("didn't load mode_blockflag"))?;

                    // OUT: 1 bit packet type (0 == audio)
                    ogg.write_bits(0, 1)?;

                    self.input.seek(SeekFrom::Start(packet_start_offset))?;
                    let mut bit_reader = BitReader::new(&mut self.input);

                    // IN/OUT: N bit mode number
                    let mode_number = bit_reader.read_bits(mode_bits as u8)?;
                    ogg.write_bits(mode_number, mode_bits as u8)?;

                    // IN: remaining bits of first byte
                    let remainder = bit_reader.read_bits((8 - mode_bits) as u8)?;

                    if mbf[mode_number as usize] {
                        // Long window, peek at next frame.
                        let next_blockflag = if next_offset + packet_header_size <= data_end {
                            let next_packet = Packet::read(
                                &mut self.input,
                                next_offset,
                                self.little_endian,
                                self.no_granule,
                            )?;
                            if next_packet.size > 0 {
                                self.input.seek(SeekFrom::Start(next_packet.offset))?;
                                let mut next_bit_reader = BitReader::new(&mut self.input);
                                let next_mode_number = next_bit_reader.read_bits(mode_bits as u8)?;
                                mbf[next_mode_number as usize]
                            } else {
                                false
                            }
                        } else {
                            false
                        };

                        // OUT: previous/next window type bits.
                        ogg.write_bits(if prev_blockflag { 1 } else { 0 }, 1)?;
                        ogg.write_bits(if next_blockflag { 1 } else { 0 }, 1)?;
                        self.input.seek(SeekFrom::Start(packet_start_offset + 1))?;
                    }

                    prev_blockflag = mbf[mode_number as usize];
                    ogg.write_bits(remainder, (8 - mode_bits) as u8)?;
                } else {
                    let v = self.read_byte()?;
                    ogg.write_bits(v as u32, 8)?;
                }

                // Remainder of packet.
                for _ in 1..size {
                    let v = self.read_byte()?;
                    ogg.write_bits(v as u32, 8)?;
                }

                let reached_window_end = target_end_granule
                    .map(|end| packet_granule >= end)
                    .unwrap_or(false);
                let eos = reached_window_end || next_offset >= data_end;
                ogg.flush_page(false, eos)?;
                wrote_any_packet = true;
                if reached_window_end {
                    break;
                }
            } else if self.mod_packets && mode_bits > 0 {
                // Maintain previous blockflag state even while skipping packets.
                if let Some(ref mbf) = mode_blockflag {
                    self.input.seek(SeekFrom::Start(packet_start_offset))?;
                    let first_byte = self.read_byte()?;
                    let mode_number = (first_byte as u32) & ((1 << mode_bits) - 1);
                    if (mode_number as usize) < mbf.len() {
                        prev_blockflag = mbf[mode_number as usize];
                    }
                }
            }

            previous_packet_granule = packet_granule;
            offset = next_offset;
        }

        if !wrote_any_packet {
            return Err(WemError::parse("no packets in requested window"));
        }
        if offset > data_end {
            return Err(WemError::parse("page truncated"));
        }
        Ok(())
    }

    fn write_vorbis_packet_header<W: Write>(
        &self,
        ogg: &mut BitOggStream<W>,
        packet_type: u8,
    ) -> WemResult<()> {
        ogg.write_bits(packet_type as u32, 8)?;
        for b in VORBIS_BYTES {
            ogg.write_bits(*b as u32, 8)?;
        }
        Ok(())
    }

    fn generate_ogg_header<W: Write>(
        &mut self,
        ogg: &mut BitOggStream<W>,
    ) -> WemResult<(Vec<bool>, i32)> {
        // Generate identification packet
        self.write_vorbis_packet_header(ogg, 1)?;
        ogg.write_bits(0, 32)?; // version
        ogg.write_bits(self.channels as u32, 8)?;
        ogg.write_bits(self.sample_rate, 32)?;
        ogg.write_bits(0, 32)?; // bitrate_max
        ogg.write_bits(self.avg_bytes_per_second * 8, 32)?; // bitrate_nominal
        ogg.write_bits(0, 32)?; // bitrate_minimum
        ogg.write_bits(self.blocksize_0_pow as u32, 4)?;
        ogg.write_bits(self.blocksize_1_pow as u32, 4)?;
        ogg.write_bits(1, 1)?; // framing
        ogg.flush_page(false, false)?;

        // Generate comment packet
        self.write_vorbis_packet_header(ogg, 3)?;
        let vendor = format!("converted from Audiokinetic Wwise by ww2ogg {}", VERSION);
        ogg.write_bits(vendor.len() as u32, 32)?;
        for c in vendor.bytes() {
            ogg.write_bits(c as u32, 8)?;
        }

        if self.loop_count == 0 {
            ogg.write_bits(0, 32)?; // no user comments
        } else {
            ogg.write_bits(2, 32)?; // two comments
            let loop_start = format!("LoopStart={}", self.loop_start);
            let loop_end = format!("LoopEnd={}", self.loop_end);

            ogg.write_bits(loop_start.len() as u32, 32)?;
            for c in loop_start.bytes() {
                ogg.write_bits(c as u32, 8)?;
            }

            ogg.write_bits(loop_end.len() as u32, 32)?;
            for c in loop_end.bytes() {
                ogg.write_bits(c as u32, 8)?;
            }
        }

        ogg.write_bits(1, 1)?; // framing
        ogg.flush_page(false, false)?;

        // Generate setup packet
        self.write_vorbis_packet_header(ogg, 5)?;

        let data = self
            .chunks
            .data
            .ok_or_else(|| WemError::parse("missing data chunk"))?;
        let setup_packet = Packet::read(
            &mut self.input,
            data.offset + self.setup_packet_offset as u64,
            self.little_endian,
            self.no_granule,
        )?;
        self.input.seek(SeekFrom::Start(setup_packet.offset))?;

        if setup_packet.granule != 0 {
            return Err(WemError::parse("setup packet granule != 0"));
        }

        let mut setup_reader = BitReader::new(&mut self.input);

        // Codebook count
        let codebook_count_less1 = setup_reader.read_bits(8)?;
        let codebook_count = codebook_count_less1 + 1;
        ogg.write_bits(codebook_count_less1, 8)?;

        // Rebuild codebooks
        if self.inline_codebooks {
            for _ in 0..codebook_count {
                if self.full_setup {
                    self.codebooks.copy(&mut setup_reader, ogg)?;
                } else {
                    self.codebooks.rebuild_from_reader(&mut setup_reader, ogg)?;
                }
            }
        } else {
            for _ in 0..codebook_count {
                let codebook_id = setup_reader.read_bits(10)?;

                match self.codebooks.rebuild(codebook_id as usize, ogg) {
                    Ok(_) => {}
                    Err(WemError::InvalidCodebookId { .. }) => {
                        if codebook_id == 0x342 {
                            let codebook_identifier = setup_reader.read_bits(14)?;
                            if codebook_identifier == 0x1590 {
                                return Err(WemError::parse(
                                    "invalid codebook id 0x342, try --full-setup",
                                ));
                            }
                        }
                        return Err(WemError::invalid_codebook_id(codebook_id as i32));
                    }
                    Err(e) => return Err(e),
                }
            }
        }

        // Time domain transforms placeholder
        ogg.write_bits(0, 6)?; // time_count_less1
        ogg.write_bits(0, 16)?; // dummy_time_value

        let (mode_blockflag, mode_bits) = if self.full_setup {
            // Full setup - just copy remaining bits, no mode info needed
            while setup_reader.total_bits_read() < setup_packet.size as u64 * 8 {
                ogg.write_bits(setup_reader.read_bits(1)?, 1)?;
            }
            (Vec::new(), 0)
        } else {
            // Parse and rebuild floor, residue, mapping, mode data
            Self::rebuild_setup_data(self.channels, &mut setup_reader, ogg, codebook_count)?
        };

        ogg.flush_page(false, false)?;

        if setup_reader.total_bits_read().div_ceil(8) != setup_packet.size as u64 {
            return Err(WemError::parse("didn't read exactly setup packet"));
        }

        if setup_packet.next_offset != data.offset + self.first_audio_packet_offset as u64 {
            return Err(WemError::parse(
                "first audio packet doesn't follow setup packet",
            ));
        }

        Ok((mode_blockflag, mode_bits))
    }

    fn generate_ogg_header_with_triad<W: Write>(
        &mut self,
        ogg: &mut BitOggStream<W>,
    ) -> WemResult<()> {
        let data = self
            .chunks
            .data
            .ok_or_else(|| WemError::parse("missing data chunk"))?;
        let mut offset = data.offset + self.setup_packet_offset as u64;

        // Copy identification packet
        let info_packet = Packet8::read(&mut self.input, offset, self.little_endian)?;

        if info_packet.granule != 0 {
            return Err(WemError::parse("information packet granule != 0"));
        }

        self.input.seek(SeekFrom::Start(info_packet.offset))?;
        let packet_type = self.read_byte()?;

        if packet_type != 1 {
            return Err(WemError::parse("wrong type for information packet"));
        }

        ogg.write_bits(packet_type as u32, 8)?;

        for _ in 1..info_packet.size {
            let b = self.read_byte()?;
            ogg.write_bits(b as u32, 8)?;
        }

        ogg.flush_page(false, false)?;
        offset = info_packet.next_offset;

        // Copy comment packet
        let comment_packet = Packet8::read(&mut self.input, offset, self.little_endian)?;

        if comment_packet.granule != 0 {
            return Err(WemError::parse("comment packet granule != 0"));
        }

        self.input.seek(SeekFrom::Start(comment_packet.offset))?;
        let packet_type = self.read_byte()?;

        if packet_type != 3 {
            return Err(WemError::parse("wrong type for comment packet"));
        }

        ogg.write_bits(packet_type as u32, 8)?;

        for _ in 1..comment_packet.size {
            let b = self.read_byte()?;
            ogg.write_bits(b as u32, 8)?;
        }

        ogg.flush_page(false, false)?;
        offset = comment_packet.next_offset;

        // Copy setup packet
        let setup_packet = Packet8::read(&mut self.input, offset, self.little_endian)?;

        if setup_packet.granule != 0 {
            return Err(WemError::parse("setup packet granule != 0"));
        }

        self.input.seek(SeekFrom::Start(setup_packet.offset))?;
        let mut setup_reader = BitReader::new(&mut self.input);

        let ptype = setup_reader.read_bits(8)?;

        if ptype != 5 {
            return Err(WemError::parse("wrong type for setup packet"));
        }

        ogg.write_bits(ptype, 8)?;

        // 'vorbis'
        for _ in 0..6 {
            let c = setup_reader.read_bits(8)?;
            ogg.write_bits(c, 8)?;
        }

        // Codebook count
        let codebook_count_less1 = setup_reader.read_bits(8)?;
        let codebook_count = codebook_count_less1 + 1;
        ogg.write_bits(codebook_count_less1, 8)?;

        // Use empty codebook library for copying
        let cbl = CodebookLibrary::empty();

        for _ in 0..codebook_count {
            cbl.copy(&mut setup_reader, ogg)?;
        }

        while setup_reader.total_bits_read() < setup_packet.size as u64 * 8 {
            ogg.write_bits(setup_reader.read_bits(1)?, 1)?;
        }

        ogg.flush_page(false, false)?;

        if setup_packet.next_offset != data.offset + self.first_audio_packet_offset as u64 {
            return Err(WemError::parse(
                "first audio packet doesn't follow setup packet",
            ));
        }

        Ok(())
    }

    fn rebuild_setup_data<B: crate::bit_reader::BitRead, W: Write>(
        channels: u16,
        reader: &mut B,
        ogg: &mut BitOggStream<W>,
        codebook_count: u32,
    ) -> WemResult<(Vec<bool>, i32)> {
        // Floor count
        let floor_count_less1 = reader.read_bits(6)?;
        let floor_count = floor_count_less1 + 1;
        ogg.write_bits(floor_count_less1, 6)?;

        for _ in 0..floor_count {
            ogg.write_bits(1, 16)?; // floor type 1
            Self::rebuild_floor(reader, codebook_count, ogg)?;
        }

        // Residue count
        let residue_count_less1 = reader.read_bits(6)?;
        let residue_count = residue_count_less1 + 1;
        ogg.write_bits(residue_count_less1, 6)?;

        for _ in 0..residue_count {
            Self::rebuild_residue(reader, codebook_count, ogg)?;
        }

        // Mapping count
        let mapping_count_less1 = reader.read_bits(6)?;
        let mapping_count = mapping_count_less1 + 1;
        ogg.write_bits(mapping_count_less1, 6)?;

        for _ in 0..mapping_count {
            Self::rebuild_mapping(channels, reader, floor_count, residue_count, ogg)?;
        }

        // Mode count
        let mode_count_less1 = reader.read_bits(6)?;
        let mode_count = mode_count_less1 + 1;
        ogg.write_bits(mode_count_less1, 6)?;

        let mut mode_blockflag = Vec::with_capacity(mode_count as usize);
        let mode_bits = ilog(mode_count - 1) as i32;

        for _ in 0..mode_count {
            let block_flag = reader.read_bits(1)?;
            ogg.write_bits(block_flag, 1)?;
            mode_blockflag.push(block_flag != 0);

            ogg.write_bits(0, 16)?; // windowtype
            ogg.write_bits(0, 16)?; // transformtype

            let mapping = reader.read_bits(8)?;
            ogg.write_bits(mapping, 8)?;

            if mapping >= mapping_count {
                return Err(WemError::parse("invalid mode mapping"));
            }
        }

        ogg.write_bits(1, 1)?; // framing

        Ok((mode_blockflag, mode_bits))
    }

    fn rebuild_floor<B: crate::bit_reader::BitRead, W: Write>(
        reader: &mut B,
        codebook_count: u32,
        ogg: &mut BitOggStream<W>,
    ) -> WemResult<()> {
        let floor1_partitions = reader.read_bits(5)?;
        ogg.write_bits(floor1_partitions, 5)?;

        let mut floor1_partition_class_list = vec![0u32; floor1_partitions as usize];
        let mut maximum_class = 0u32;

        for partition_class in floor1_partition_class_list.iter_mut() {
            let floor1_partition_class = reader.read_bits(4)?;
            ogg.write_bits(floor1_partition_class, 4)?;
            *partition_class = floor1_partition_class;

            if floor1_partition_class > maximum_class {
                maximum_class = floor1_partition_class;
            }
        }

        let mut floor1_class_dimensions_list = vec![0u32; (maximum_class + 1) as usize];

        for class_dimension in floor1_class_dimensions_list.iter_mut() {
            let class_dimensions_less1 = reader.read_bits(3)?;
            ogg.write_bits(class_dimensions_less1, 3)?;
            *class_dimension = class_dimensions_less1 + 1;

            let class_subclasses = reader.read_bits(2)?;
            ogg.write_bits(class_subclasses, 2)?;

            if class_subclasses != 0 {
                let masterbook = reader.read_bits(8)?;
                ogg.write_bits(masterbook, 8)?;

                if masterbook >= codebook_count {
                    return Err(WemError::parse("invalid floor1 masterbook"));
                }
            }

            for _ in 0..(1u32 << class_subclasses) {
                let subclass_book_plus1 = reader.read_bits(8)?;
                ogg.write_bits(subclass_book_plus1, 8)?;
                let subclass_book = subclass_book_plus1 as i32 - 1;

                if subclass_book >= 0 && subclass_book as u32 >= codebook_count {
                    return Err(WemError::parse("invalid floor1 subclass book"));
                }
            }
        }

        let floor1_multiplier_less1 = reader.read_bits(2)?;
        ogg.write_bits(floor1_multiplier_less1, 2)?;

        let rangebits = reader.read_bits(4)?;
        ogg.write_bits(rangebits, 4)?;

        for &current_class_number in &floor1_partition_class_list {
            for _ in 0..floor1_class_dimensions_list[current_class_number as usize] {
                let x = reader.read_bits(rangebits as u8)?;
                ogg.write_bits(x, rangebits as u8)?;
            }
        }

        Ok(())
    }

    fn rebuild_residue<B: crate::bit_reader::BitRead, W: Write>(
        reader: &mut B,
        codebook_count: u32,
        ogg: &mut BitOggStream<W>,
    ) -> WemResult<()> {
        let residue_type = reader.read_bits(2)?;
        ogg.write_bits(residue_type, 16)?;

        if residue_type > 2 {
            return Err(WemError::parse("invalid residue type"));
        }

        let residue_begin = reader.read_bits(24)?;
        let residue_end = reader.read_bits(24)?;
        let residue_partition_size_less1 = reader.read_bits(24)?;
        let residue_classifications_less1 = reader.read_bits(6)?;
        let residue_classbook = reader.read_bits(8)?;

        let residue_classifications = residue_classifications_less1 + 1;

        ogg.write_bits(residue_begin, 24)?;
        ogg.write_bits(residue_end, 24)?;
        ogg.write_bits(residue_partition_size_less1, 24)?;
        ogg.write_bits(residue_classifications_less1, 6)?;
        ogg.write_bits(residue_classbook, 8)?;

        if residue_classbook >= codebook_count {
            return Err(WemError::parse("invalid residue classbook"));
        }

        let mut residue_cascade = vec![0u32; residue_classifications as usize];

        for cascade in residue_cascade.iter_mut() {
            let low_bits = reader.read_bits(3)?;
            ogg.write_bits(low_bits, 3)?;

            let bitflag = reader.read_bits(1)?;
            ogg.write_bits(bitflag, 1)?;

            let high_bits = if bitflag != 0 {
                let hb = reader.read_bits(5)?;
                ogg.write_bits(hb, 5)?;
                hb
            } else {
                0
            };

            *cascade = high_bits * 8 + low_bits;
        }

        for &cascade in &residue_cascade {
            for k in 0..8 {
                if (cascade & (1 << k)) != 0 {
                    let residue_book = reader.read_bits(8)?;
                    ogg.write_bits(residue_book, 8)?;

                    if residue_book >= codebook_count {
                        return Err(WemError::parse("invalid residue book"));
                    }
                }
            }
        }

        Ok(())
    }

    fn rebuild_mapping<B: crate::bit_reader::BitRead, W: Write>(
        channels: u16,
        reader: &mut B,
        floor_count: u32,
        residue_count: u32,
        ogg: &mut BitOggStream<W>,
    ) -> WemResult<()> {
        ogg.write_bits(0, 16)?; // mapping type 0

        let submaps_flag = reader.read_bits(1)?;
        ogg.write_bits(submaps_flag, 1)?;

        let submaps = if submaps_flag != 0 {
            let submaps_less1 = reader.read_bits(4)?;
            ogg.write_bits(submaps_less1, 4)?;
            submaps_less1 + 1
        } else {
            1
        };

        let square_polar_flag = reader.read_bits(1)?;
        ogg.write_bits(square_polar_flag, 1)?;

        if square_polar_flag != 0 {
            let coupling_steps_less1 = reader.read_bits(8)?;
            let coupling_steps = coupling_steps_less1 + 1;
            ogg.write_bits(coupling_steps_less1, 8)?;

            let coupling_bits = ilog(channels as u32 - 1);

            for _ in 0..coupling_steps {
                let magnitude = reader.read_bits(coupling_bits)?;
                let angle = reader.read_bits(coupling_bits)?;
                ogg.write_bits(magnitude, coupling_bits)?;
                ogg.write_bits(angle, coupling_bits)?;

                if angle == magnitude || magnitude >= channels as u32 || angle >= channels as u32 {
                    return Err(WemError::parse("invalid coupling"));
                }
            }
        }

        let mapping_reserved = reader.read_bits(2)?;
        ogg.write_bits(mapping_reserved, 2)?;

        if mapping_reserved != 0 {
            return Err(WemError::parse("mapping reserved field nonzero"));
        }

        if submaps > 1 {
            for _ in 0..channels {
                let mapping_mux = reader.read_bits(4)?;
                ogg.write_bits(mapping_mux, 4)?;

                if mapping_mux >= submaps {
                    return Err(WemError::parse("mapping_mux >= submaps"));
                }
            }
        }

        for _ in 0..submaps {
            let time_config = reader.read_bits(8)?;
            ogg.write_bits(time_config, 8)?;

            let floor_number = reader.read_bits(8)?;
            ogg.write_bits(floor_number, 8)?;

            if floor_number >= floor_count {
                return Err(WemError::parse("invalid floor mapping"));
            }

            let residue_number = reader.read_bits(8)?;
            ogg.write_bits(residue_number, 8)?;

            if residue_number >= residue_count {
                return Err(WemError::parse("invalid residue mapping"));
            }
        }

        Ok(())
    }
}
