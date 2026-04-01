#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub(crate) enum WwiseCodec {
    Pcm,
    Vorbis,
    Unsupported(u16),
}

#[derive(Debug, Clone)]
pub(crate) struct WwiseHeader {
    pub codec: WwiseCodec,
    pub channels: u16,
    pub sample_rate: u32,
    pub avg_bytes_per_sec: u32,
    pub block_align: u16,
    pub bits_per_sample: u16,
    pub data_chunk: Vec<u8>,
}
