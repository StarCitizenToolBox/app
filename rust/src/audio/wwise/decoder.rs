use anyhow::{anyhow, Result};
use rayon::prelude::*;
use std::io::Cursor;
use std::sync::Once;

use super::parser::parse_wem_header;
use super::types::WwiseCodec;
use ww2ogg::ForcePacketFormat;

static INIT_RAYON: Once = Once::new();
const CANCELLED_MSG: &str = "wem decode cancelled";

fn ensure_rayon_pool_initialized() {
    INIT_RAYON.call_once(|| {
        let threads = std::thread::available_parallelism()
            .map(|n| n.get())
            .unwrap_or(1)
            .max(1);
        let _ = rayon::ThreadPoolBuilder::new()
            .num_threads(threads)
            .build_global();
    });
}

fn ensure_not_cancelled<F>(is_cancelled: &F) -> Result<()>
where
    F: Fn() -> bool + Sync,
{
    if is_cancelled() {
        Err(anyhow!(CANCELLED_MSG))
    } else {
        Ok(())
    }
}

fn build_wav_from_pcm_i16(channels: u16, sample_rate: u32, pcm: &[i16]) -> Result<Vec<u8>> {
    // Parallelize sample-to-bytes packing to better use multi-core CPUs.
    let mut payload = vec![0u8; pcm.len() * 2];
    payload
        .par_chunks_mut(2)
        .zip(pcm.par_iter())
        .for_each(|(dst, sample)| {
            let b = sample.to_le_bytes();
            dst[0] = b[0];
            dst[1] = b[1];
        });

    let block_align = channels.saturating_mul(2);
    let avg_bytes_per_sec = sample_rate.saturating_mul(block_align as u32);

    let mut wav = Vec::<u8>::with_capacity(44 + payload.len());
    wav.extend_from_slice(b"RIFF");
    wav.extend_from_slice(&(36u32.saturating_add(payload.len() as u32)).to_le_bytes());
    wav.extend_from_slice(b"WAVE");
    wav.extend_from_slice(b"fmt ");
    wav.extend_from_slice(&16u32.to_le_bytes());
    wav.extend_from_slice(&1u16.to_le_bytes()); // PCM
    wav.extend_from_slice(&channels.to_le_bytes());
    wav.extend_from_slice(&sample_rate.to_le_bytes());
    wav.extend_from_slice(&avg_bytes_per_sec.to_le_bytes());
    wav.extend_from_slice(&block_align.to_le_bytes());
    wav.extend_from_slice(&16u16.to_le_bytes());
    wav.extend_from_slice(b"data");
    wav.extend_from_slice(&(payload.len() as u32).to_le_bytes());
    wav.extend_from_slice(&payload);
    Ok(wav)
}

fn build_wav_from_pcm_bytes(header: &super::types::WwiseHeader) -> Vec<u8> {
    let payload = &header.data_chunk;
    let mut wav = Vec::<u8>::with_capacity(44 + payload.len());
    wav.extend_from_slice(b"RIFF");
    wav.extend_from_slice(&(36u32.saturating_add(payload.len() as u32)).to_le_bytes());
    wav.extend_from_slice(b"WAVE");
    wav.extend_from_slice(b"fmt ");
    wav.extend_from_slice(&16u32.to_le_bytes());
    wav.extend_from_slice(&1u16.to_le_bytes()); // PCM
    wav.extend_from_slice(&header.channels.to_le_bytes());
    wav.extend_from_slice(&header.sample_rate.to_le_bytes());
    wav.extend_from_slice(&header.avg_bytes_per_sec.to_le_bytes());
    wav.extend_from_slice(&header.block_align.to_le_bytes());
    wav.extend_from_slice(&header.bits_per_sample.to_le_bytes());
    wav.extend_from_slice(b"data");
    wav.extend_from_slice(&(payload.len() as u32).to_le_bytes());
    wav.extend_from_slice(payload);
    wav
}

fn build_wav_from_pcm_payload(
    channels: u16,
    sample_rate: u32,
    bits_per_sample: u16,
    payload: &[u8],
) -> Vec<u8> {
    let block_align = channels.saturating_mul((bits_per_sample / 8).max(1));
    let avg_bytes_per_sec = sample_rate.saturating_mul(block_align as u32);
    let mut wav = Vec::<u8>::with_capacity(44 + payload.len());
    wav.extend_from_slice(b"RIFF");
    wav.extend_from_slice(&(36u32.saturating_add(payload.len() as u32)).to_le_bytes());
    wav.extend_from_slice(b"WAVE");
    wav.extend_from_slice(b"fmt ");
    wav.extend_from_slice(&16u32.to_le_bytes());
    wav.extend_from_slice(&1u16.to_le_bytes()); // PCM
    wav.extend_from_slice(&channels.to_le_bytes());
    wav.extend_from_slice(&sample_rate.to_le_bytes());
    wav.extend_from_slice(&avg_bytes_per_sec.to_le_bytes());
    wav.extend_from_slice(&block_align.to_le_bytes());
    wav.extend_from_slice(&bits_per_sample.to_le_bytes());
    wav.extend_from_slice(b"data");
    wav.extend_from_slice(&(payload.len() as u32).to_le_bytes());
    wav.extend_from_slice(payload);
    wav
}

pub(crate) fn decode_ogg_bytes_to_wav(ogg_bytes: &[u8]) -> Result<Vec<u8>> {
    let mut ogg = lewton::inside_ogg::OggStreamReader::new(Cursor::new(ogg_bytes))
        .map_err(|e| anyhow!("ogg parse failed: {}", e))?;

    let channels = ogg.ident_hdr.audio_channels as u16;
    let sample_rate = ogg.ident_hdr.audio_sample_rate;
    let mut pcm = Vec::<i16>::new();
    loop {
        match ogg.read_dec_packet_itl() {
            Ok(Some(packet)) => pcm.extend(packet),
            Ok(None) => break,
            Err(e) => return Err(anyhow!("vorbis decode failed: {}", e)),
        }
    }

    if pcm.is_empty() {
        return Err(anyhow!("decoded pcm is empty"));
    }

    build_wav_from_pcm_i16(channels, sample_rate, &pcm)
}

fn decode_wem_pcm_preview_to_wav(
    header: &super::types::WwiseHeader,
    clip_seconds: u32,
) -> Result<Vec<u8>> {
    let bytes_per_frame = if header.block_align > 0 {
        header.block_align as usize
    } else {
        (header.channels as usize).saturating_mul((header.bits_per_sample as usize / 8).max(1))
    };
    if bytes_per_frame == 0 {
        return Ok(build_wav_from_pcm_bytes(header));
    }

    let total_frames = header.data_chunk.len() / bytes_per_frame;
    if total_frames == 0 {
        return Ok(build_wav_from_pcm_bytes(header));
    }

    let clip_frames = (header.sample_rate as usize).saturating_mul(clip_seconds as usize);
    if clip_frames == 0 || clip_frames >= total_frames {
        return Ok(build_wav_from_pcm_bytes(header));
    }

    let start_frame = (total_frames - clip_frames) / 2;
    let start = start_frame.saturating_mul(bytes_per_frame);
    let end = start
        .saturating_add(clip_frames.saturating_mul(bytes_per_frame))
        .min(header.data_chunk.len());
    let payload = &header.data_chunk[start..end];
    Ok(build_wav_from_pcm_payload(
        header.channels,
        header.sample_rate,
        header.bits_per_sample.max(16),
        payload,
    ))
}

#[derive(Clone, Copy)]
struct VorbisDecodeAttempt {
    aotuv: bool,
    packet_format: ForcePacketFormat,
}

fn vorbis_decode_attempts() -> [VorbisDecodeAttempt; 6] {
    [
        VorbisDecodeAttempt {
            aotuv: false,
            packet_format: ForcePacketFormat::NoForce,
        },
        VorbisDecodeAttempt {
            aotuv: true,
            packet_format: ForcePacketFormat::NoForce,
        },
        VorbisDecodeAttempt {
            aotuv: false,
            packet_format: ForcePacketFormat::ForceModPackets,
        },
        VorbisDecodeAttempt {
            aotuv: true,
            packet_format: ForcePacketFormat::ForceModPackets,
        },
        VorbisDecodeAttempt {
            aotuv: false,
            packet_format: ForcePacketFormat::ForceNoModPackets,
        },
        VorbisDecodeAttempt {
            aotuv: true,
            packet_format: ForcePacketFormat::ForceNoModPackets,
        },
    ]
}

fn packet_format_name(format: ForcePacketFormat) -> &'static str {
    match format {
        ForcePacketFormat::NoForce => "auto",
        ForcePacketFormat::ForceModPackets => "mod",
        ForcePacketFormat::ForceNoModPackets => "no_mod",
    }
}

fn attempt_name(attempt: VorbisDecodeAttempt) -> String {
    format!(
        "{}+{}",
        if attempt.aotuv { "aotuv" } else { "default" },
        packet_format_name(attempt.packet_format)
    )
}

fn decode_wem_vorbis_with_codebooks<F>(
    wem: &[u8],
    attempt: VorbisDecodeAttempt,
    is_cancelled: &F,
) -> Result<Vec<u8>>
where
    F: Fn() -> bool + Sync,
{
    ensure_not_cancelled(is_cancelled)?;
    let codebooks = if attempt.aotuv {
        ww2ogg::CodebookLibrary::aotuv_codebooks()
    } else {
        ww2ogg::CodebookLibrary::default_codebooks()
    }
    .map_err(|e| anyhow!("load codebooks failed: {}", e))?;

    ensure_not_cancelled(is_cancelled)?;
    let input = Cursor::new(wem);
    let mut converter = ww2ogg::WwiseRiffVorbis::builder(input, codebooks)
        .force_packet_format(attempt.packet_format)
        .build()
        .map_err(|e| anyhow!("ww2ogg parse failed: {}", e))?;

    let mut ogg_bytes = Vec::<u8>::new();
    ensure_not_cancelled(is_cancelled)?;
    converter
        .generate_ogg(&mut ogg_bytes)
        .map_err(|e| anyhow!("ww2ogg convert failed: {}", e))?;

    ww2ogg::validate(&ogg_bytes).map_err(|e| anyhow!("ww2ogg validate failed: {}", e))?;
    Ok(ogg_bytes)
}

fn decode_wem_vorbis_preview_with_codebooks<F>(
    wem: &[u8],
    attempt: VorbisDecodeAttempt,
    clip_seconds: u32,
    is_cancelled: &F,
) -> Result<Vec<u8>>
where
    F: Fn() -> bool + Sync,
{
    ensure_not_cancelled(is_cancelled)?;
    let header = parse_wem_header(wem)?;
    let codebooks = if attempt.aotuv {
        ww2ogg::CodebookLibrary::aotuv_codebooks()
    } else {
        ww2ogg::CodebookLibrary::default_codebooks()
    }
    .map_err(|e| anyhow!("load codebooks failed: {}", e))?;

    ensure_not_cancelled(is_cancelled)?;
    let input = Cursor::new(wem);
    let mut converter = ww2ogg::WwiseRiffVorbis::builder(input, codebooks)
        .force_packet_format(attempt.packet_format)
        .build()
        .map_err(|e| anyhow!("ww2ogg parse failed: {}", e))?;

    let estimated_total_seconds = if header.avg_bytes_per_sec > 0 {
        header.data_chunk.len() as f64 / header.avg_bytes_per_sec as f64
    } else {
        0.0
    };
    let clip_seconds_f = clip_seconds as f64;
    let start_seconds = if estimated_total_seconds > clip_seconds_f {
        (estimated_total_seconds - clip_seconds_f) / 2.0
    } else {
        0.0
    };

    let mut ogg_bytes = Vec::<u8>::new();
    ensure_not_cancelled(is_cancelled)?;
    converter
        .generate_ogg_window(&mut ogg_bytes, start_seconds, clip_seconds_f)
        .map_err(|e| anyhow!("ww2ogg window convert failed: {}", e))?;

    ww2ogg::validate(&ogg_bytes).map_err(|e| anyhow!("ww2ogg validate failed: {}", e))?;
    Ok(ogg_bytes)
}

pub(crate) fn decode_wem_vorbis_to_ogg(wem: &[u8]) -> Result<Vec<u8>> {
    decode_wem_vorbis_to_ogg_with_cancel(wem, &|| false)
}

pub(crate) fn decode_wem_vorbis_to_ogg_with_cancel<F>(
    wem: &[u8],
    is_cancelled: &F,
) -> Result<Vec<u8>>
where
    F: Fn() -> bool + Sync,
{
    ensure_rayon_pool_initialized();
    ensure_not_cancelled(is_cancelled)?;
    let attempts = vorbis_decode_attempts();
    ensure_not_cancelled(is_cancelled)?;
    let results: Vec<(VorbisDecodeAttempt, Result<Vec<u8>>)> = attempts
        .par_iter()
        .map(|attempt| {
            (
                *attempt,
                decode_wem_vorbis_with_codebooks(wem, *attempt, is_cancelled),
            )
        })
        .collect();

    if let Some((_, Ok(ogg))) = results.iter().find(|(_, r)| r.is_ok()) {
        return Ok(ogg.clone());
    }

    let mut errs = Vec::new();
    for (attempt, r) in &results {
        if let Err(e) = r {
            errs.push(format!("{}={}", attempt_name(*attempt), e));
        }
    }

    Err(anyhow!(
        "failed to decode Wwise Vorbis WEM with built-in pipeline: {}",
        errs.join(" | ")
    ))
}

pub(crate) fn decode_wem_vorbis_to_wav(wem: &[u8]) -> Result<Vec<u8>> {
    decode_wem_vorbis_to_wav_with_cancel(wem, &|| false)
}

pub(crate) fn decode_wem_vorbis_to_wav_with_cancel<F>(
    wem: &[u8],
    is_cancelled: &F,
) -> Result<Vec<u8>>
where
    F: Fn() -> bool + Sync,
{
    let ogg = decode_wem_vorbis_to_ogg_with_cancel(wem, is_cancelled)?;
    decode_ogg_bytes_to_wav(&ogg)
}

pub(crate) fn decode_wem_to_wav(wem: &[u8]) -> Result<Vec<u8>> {
    decode_wem_to_wav_with_cancel(wem, &|| false)
}

pub(crate) fn decode_wem_to_wav_with_cancel<F>(wem: &[u8], is_cancelled: &F) -> Result<Vec<u8>>
where
    F: Fn() -> bool + Sync,
{
    ensure_rayon_pool_initialized();
    ensure_not_cancelled(is_cancelled)?;
    let header = parse_wem_header(wem)?;
    match header.codec {
        WwiseCodec::Pcm => Ok(build_wav_from_pcm_bytes(&header)),
        WwiseCodec::Vorbis => decode_wem_vorbis_to_wav_with_cancel(wem, is_cancelled),
        WwiseCodec::Unsupported(format) => Err(anyhow!(
            "unsupported wem codec format=0x{:04x}; built-in decoder supports PCM (0x0001/0xFFFE) and Wwise Vorbis (0xFFFF)",
            format
        )),
    }
}

pub(crate) fn decode_wem_preview_to_ogg_with_cancel<F>(
    wem: &[u8],
    clip_seconds: u32,
    is_cancelled: &F,
) -> Result<Vec<u8>>
where
    F: Fn() -> bool + Sync,
{
    ensure_rayon_pool_initialized();
    ensure_not_cancelled(is_cancelled)?;
    let header = parse_wem_header(wem)?;
    match header.codec {
        WwiseCodec::Pcm => Err(anyhow!(
            "pcm wem preview cannot be converted to ogg; use wav fallback instead"
        )),
        WwiseCodec::Vorbis => {
            let attempts = vorbis_decode_attempts();
            let results: Vec<(VorbisDecodeAttempt, Result<Vec<u8>>)> = attempts
                .par_iter()
                .map(|attempt| {
                    (
                        *attempt,
                        decode_wem_vorbis_preview_with_codebooks(
                            wem,
                            *attempt,
                            clip_seconds,
                            is_cancelled,
                        ),
                    )
                })
                .collect();
            if let Some((_, Ok(ogg))) = results.iter().find(|(_, r)| r.is_ok()) {
                return Ok(ogg.clone());
            }
            let mut errs = Vec::new();
            for (attempt, r) in &results {
                if let Err(e) = r {
                    errs.push(format!("{}={}", attempt_name(*attempt), e));
                }
            }
            Err(anyhow!(
                "failed to decode WEM preview with built-in pipeline: {}",
                errs.join(" | ")
            ))
        }
        WwiseCodec::Unsupported(format) => Err(anyhow!(
            "unsupported wem codec format=0x{:04x}; built-in decoder supports PCM (0x0001/0xFFFE) and Wwise Vorbis (0xFFFF)",
            format
        )),
    }
}

pub(crate) fn decode_wem_preview_to_wav_with_cancel<F>(
    wem: &[u8],
    clip_seconds: u32,
    is_cancelled: &F,
) -> Result<Vec<u8>>
where
    F: Fn() -> bool + Sync,
{
    ensure_rayon_pool_initialized();
    ensure_not_cancelled(is_cancelled)?;
    let header = parse_wem_header(wem)?;
    match header.codec {
        WwiseCodec::Pcm => decode_wem_pcm_preview_to_wav(&header, clip_seconds),
        WwiseCodec::Vorbis => {
            let ogg = decode_wem_preview_to_ogg_with_cancel(wem, clip_seconds, is_cancelled)?;
            decode_ogg_bytes_to_wav(&ogg)
        }
        WwiseCodec::Unsupported(format) => Err(anyhow!(
            "unsupported wem codec format=0x{:04x}; built-in decoder supports PCM (0x0001/0xFFFE) and Wwise Vorbis (0xFFFF)",
            format
        )),
    }
}

pub(crate) struct WemStreamInfo {
    pub codec: WwiseCodec,
    pub channels: u16,
    pub sample_rate: u32,
    pub bits_per_sample: u16,
    pub total_samples: usize,
}

pub(crate) fn get_wem_stream_info(wem: &[u8]) -> Result<WemStreamInfo> {
    let header = parse_wem_header(wem)?;
    let bytes_per_sample = (header.bits_per_sample / 8).max(1) as usize;
    let frame_size = header.block_align as usize;
    let bytes_per_frame = if frame_size > 0 {
        frame_size
    } else {
        header.channels as usize * bytes_per_sample
    };
    let total_samples = if bytes_per_frame > 0 {
        header.data_chunk.len() / bytes_per_frame
    } else {
        0
    };
    Ok(WemStreamInfo {
        codec: header.codec,
        channels: header.channels,
        sample_rate: header.sample_rate,
        bits_per_sample: header.bits_per_sample,
        total_samples,
    })
}

pub(crate) fn decode_wem_pcm_stream<F, C>(
    wem: &[u8],
    chunk_duration_ms: u32,
    mut on_chunk: C,
    is_cancelled: &F,
) -> Result<(u16, u32, usize)>
where
    F: Fn() -> bool + Sync,
    C: FnMut(&[i16], usize, usize) -> Result<()>,
{
    ensure_not_cancelled(is_cancelled)?;
    let header = parse_wem_header(wem)?;
    if header.codec != WwiseCodec::Pcm {
        return Err(anyhow!("decode_wem_pcm_stream only supports PCM WEM"));
    }

    let bytes_per_sample = ((header.bits_per_sample / 8).max(1)) as usize;
    if bytes_per_sample != 2 {
        return Err(anyhow!(
            "PCM WEM with {} bits per sample not supported for streaming (expected 16-bit)",
            header.bits_per_sample
        ));
    }

    let frame_size = header.block_align as usize;
    let bytes_per_frame = if frame_size > 0 {
        frame_size
    } else {
        header.channels as usize * bytes_per_sample
    };

    if bytes_per_frame == 0 {
        return Err(anyhow!("invalid PCM WEM: zero frame size"));
    }

    let samples_per_frame = bytes_per_frame / bytes_per_sample;
    let sample_rate = header.sample_rate as usize;
    let chunk_frames = sample_rate.saturating_mul(chunk_duration_ms as usize / 1000);
    let chunk_bytes = chunk_frames.saturating_mul(bytes_per_frame);

    let data = &header.data_chunk;
    let total_frames = data.len() / bytes_per_frame;
    let mut offset = 0usize;
    let mut chunk_index = 0usize;

    while offset < data.len() {
        ensure_not_cancelled(is_cancelled)?;
        let end = (offset + chunk_bytes).min(data.len());
        let chunk_data = &data[offset..end];

        let samples_in_chunk = chunk_data.len() / bytes_per_sample;
        let mut pcm = Vec::<i16>::with_capacity(samples_in_chunk);
        for i in (0..chunk_data.len()).step_by(2) {
            if i + 1 < chunk_data.len() {
                pcm.push(i16::from_le_bytes([chunk_data[i], chunk_data[i + 1]]));
            }
        }

        if !pcm.is_empty() {
            on_chunk(&pcm, chunk_index, total_frames)?;
            chunk_index += 1;
        }

        offset = end;
    }

    Ok((header.channels, header.sample_rate, total_frames))
}

pub(crate) fn decode_wem_vorbis_stream<F, C>(
    wem: &[u8],
    chunk_duration_ms: u32,
    mut on_chunk: C,
    is_cancelled: &F,
) -> Result<(u16, u32, usize)>
where
    F: Fn() -> bool + Sync,
    C: FnMut(&[i16], usize, usize) -> Result<()>,
{
    ensure_not_cancelled(is_cancelled)?;
    let header = parse_wem_header(wem)?;
    if header.codec != WwiseCodec::Vorbis {
        return Err(anyhow!("decode_wem_vorbis_stream only supports Vorbis WEM"));
    }

    ensure_rayon_pool_initialized();

    let ogg_bytes = decode_wem_vorbis_to_ogg_with_cancel(wem, is_cancelled)?;

    ensure_not_cancelled(is_cancelled)?;
    let mut ogg = lewton::inside_ogg::OggStreamReader::new(Cursor::new(&ogg_bytes))
        .map_err(|e| anyhow!("ogg parse failed: {}", e))?;

    let channels = ogg.ident_hdr.audio_channels as u16;
    let sample_rate = ogg.ident_hdr.audio_sample_rate;

    let chunk_samples =
        (sample_rate as u64 * chunk_duration_ms as u64 / 1000 * channels as u64) as usize;
    let mut chunk_index = 0usize;
    let mut total_samples = 0usize;

    loop {
        ensure_not_cancelled(is_cancelled)?;
        let mut chunk_pcm = Vec::<i16>::new();

        while chunk_pcm.len() < chunk_samples {
            match ogg.read_dec_packet_itl() {
                Ok(Some(packet)) => {
                    let packet_len = packet.len();
                    chunk_pcm.extend(packet);
                    total_samples += packet_len;
                }
                Ok(None) => break,
                Err(e) => return Err(anyhow!("vorbis decode failed: {}", e)),
            }
        }

        if chunk_pcm.is_empty() {
            break;
        }

        on_chunk(&chunk_pcm, chunk_index, 0)?;
        chunk_index += 1;
    }

    let total_frames = total_samples / channels as usize;
    Ok((channels, sample_rate, total_frames))
}

pub(crate) fn decode_wem_stream<F, C>(
    wem: &[u8],
    chunk_duration_ms: u32,
    on_chunk: C,
    is_cancelled: &F,
) -> Result<(WwiseCodec, u16, u32, usize)>
where
    F: Fn() -> bool + Sync,
    C: FnMut(&[i16], usize, usize) -> Result<()>,
{
    ensure_not_cancelled(is_cancelled)?;
    let info = get_wem_stream_info(wem)?;

    match info.codec {
        WwiseCodec::Pcm => {
            let (ch, sr, frames) = decode_wem_pcm_stream(wem, chunk_duration_ms, on_chunk, is_cancelled)?;
            Ok((WwiseCodec::Pcm, ch, sr, frames))
        }
        WwiseCodec::Vorbis => {
            let (ch, sr, frames) = decode_wem_vorbis_stream(wem, chunk_duration_ms, on_chunk, is_cancelled)?;
            Ok((WwiseCodec::Vorbis, ch, sr, frames))
        }
        WwiseCodec::Unsupported(format) => Err(anyhow!(
            "unsupported wem codec format=0x{:04x}; built-in decoder supports PCM (0x0001/0xFFFE) and Wwise Vorbis (0xFFFF)",
            format
        )),
    }
}
