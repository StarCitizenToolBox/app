# ww2ogg-rs

[![CI](https://github.com/coconutbird/ww2ogg-rs/actions/workflows/ci.yml/badge.svg)](https://github.com/coconutbird/ww2ogg-rs/actions/workflows/ci.yml)
[![Crates.io](https://img.shields.io/crates/v/ww2ogg.svg)](https://crates.io/crates/ww2ogg)

A Rust library and CLI tool for converting Wwise RIFF/RIFX Vorbis audio files (.wem) to standard Ogg Vorbis format.

This is a Rust port of [ww2ogg](https://github.com/hcs64/ww2ogg), providing the same functionality with Rust's safety and performance benefits.

## Features

- Convert Wwise audio files (.wem) to standard Ogg Vorbis (.ogg)
- Support for both RIFF (little-endian) and RIFX (big-endian) containers
- Built-in codebook libraries (standard and aoTuV 6.03)
- Audio validation to detect wrong codebook selection
- Library API for integration into other projects
- Command-line tool for batch conversion

## Installation

### From Source

```bash
git clone https://github.com/coconutbird/ww2ogg-rs.git
cd ww2ogg-rs
cargo build --release
```

The binary will be at `target/release/ww2ogg.exe` (Windows) or `target/release/ww2ogg` (Linux/macOS).

## Usage

### Command Line

```bash
# Basic conversion (auto-detects codebook, validates output)
ww2ogg input.wem

# Specify output file
ww2ogg input.wem -o output.ogg

# Use aoTuV codebooks (for some games)
ww2ogg input.wem --pcb-aotuv

# Use custom codebook file
ww2ogg input.wem --pcb path/to/codebooks.bin

# Use inline codebooks (embedded in the .wem file)
ww2ogg input.wem --inline-codebooks

# Force packet format
ww2ogg input.wem --mod-packets
ww2ogg input.wem --no-mod-packets
```

### Library

Add to your `Cargo.toml`:

```toml
[dependencies]
ww2ogg = { path = "ww2ogg" }
```

Basic usage:

```rust
use std::fs::File;
use std::io::{BufReader, BufWriter};
use ww2ogg::{WwiseRiffVorbis, CodebookLibrary};

fn main() -> Result<(), ww2ogg::WemError> {
    // Open input .wem file
    let input = BufReader::new(File::open("input.wem")?);

    // Load the default codebook library
    let codebooks = CodebookLibrary::default_codebooks()?;

    // Create converter and parse the input
    let mut converter = WwiseRiffVorbis::new(input, codebooks)?;

    // Convert to Ogg Vorbis
    let mut output = BufWriter::new(File::create("output.ogg")?);
    converter.generate_ogg(&mut output)?;

    Ok(())
}
```

### Codebook Selection

Different games use different codebook libraries. If conversion produces garbled audio:

```rust
// Try default codebooks first (most common)
let codebooks = CodebookLibrary::default_codebooks()?;

// If that doesn't work, try aoTuV
let codebooks = CodebookLibrary::aotuv_codebooks()?;

// Or load custom codebooks from a file
let codebooks = CodebookLibrary::from_file("custom_codebooks.bin")?;
```

### Validation

Verify converted audio is valid:

```rust
use ww2ogg::validate;

let ogg_data: Vec<u8> = /* converted audio */;
validate(&ogg_data)?; // Returns error if audio is corrupted
```

### Builder Pattern

For advanced configuration:

```rust
use ww2ogg::{WwiseRiffVorbis, CodebookLibrary, ForcePacketFormat};

let input = File::open("input.wem")?;
let codebooks = CodebookLibrary::aotuv_codebooks()?;

let mut converter = WwiseRiffVorbis::builder(input, codebooks)
    .inline_codebooks(false)
    .full_setup(false)
    .force_packet_format(ForcePacketFormat::NoForce)
    .build()?;
```

## Project Structure

```
ww2ogg-rs/
├── ww2ogg/          # Core library
│   └── src/
│       ├── lib.rs                 # Public API
│       ├── wwise_riff_vorbis.rs   # Main converter
│       ├── codebook.rs            # Codebook library
│       ├── validator.rs           # Audio validation
│       └── ...                    # Internal modules
└── ww2ogg-cli/      # Command-line tool
    └── src/
        └── main.rs
```

## License

This project is a Rust port of ww2ogg. See the original project for licensing details.

## Acknowledgments

- [hcs64/ww2ogg](https://github.com/hcs64/ww2ogg) - Original C++ implementation
- [Wwise](https://www.audiokinetic.com/products/wwise/) - Audiokinetic's audio middleware
