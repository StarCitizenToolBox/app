mod decoder;
mod parser;
mod types;

use anyhow::Result;

pub(crate) fn decode_wem_to_wav(wem: &[u8]) -> Result<Vec<u8>> {
    decoder::decode_wem_to_wav(wem)
}

pub(crate) fn decode_wem_to_wav_with_cancel<F>(wem: &[u8], is_cancelled: &F) -> Result<Vec<u8>>
where
    F: Fn() -> bool + Sync,
{
    decoder::decode_wem_to_wav_with_cancel(wem, is_cancelled)
}

pub(crate) fn decode_wem_to_ogg(wem: &[u8]) -> Result<Vec<u8>> {
    decoder::decode_wem_vorbis_to_ogg(wem)
}

pub(crate) fn decode_wem_to_ogg_with_cancel<F>(wem: &[u8], is_cancelled: &F) -> Result<Vec<u8>>
where
    F: Fn() -> bool + Sync,
{
    decoder::decode_wem_vorbis_to_ogg_with_cancel(wem, is_cancelled)
}

pub(crate) fn decode_wem_preview_to_wav_with_cancel<F>(
    wem: &[u8],
    clip_seconds: u32,
    is_cancelled: &F,
) -> Result<Vec<u8>>
where
    F: Fn() -> bool + Sync,
{
    decoder::decode_wem_preview_to_wav_with_cancel(wem, clip_seconds, is_cancelled)
}

pub(crate) fn decode_wem_preview_to_ogg_with_cancel<F>(
    wem: &[u8],
    clip_seconds: u32,
    is_cancelled: &F,
) -> Result<Vec<u8>>
where
    F: Fn() -> bool + Sync,
{
    decoder::decode_wem_preview_to_ogg_with_cancel(wem, clip_seconds, is_cancelled)
}

pub(crate) fn decode_ogg_to_wav(ogg_bytes: &[u8]) -> Result<Vec<u8>> {
    decoder::decode_ogg_bytes_to_wav(ogg_bytes)
}

#[cfg(test)]
pub(crate) fn decode_wem_vorbis_to_ogg(wem: &[u8]) -> Result<Vec<u8>> {
    decoder::decode_wem_vorbis_to_ogg(wem)
}

#[cfg(test)]
pub(crate) fn decode_wem_vorbis_to_wav(wem: &[u8]) -> Result<Vec<u8>> {
    decoder::decode_wem_vorbis_to_wav(wem)
}
