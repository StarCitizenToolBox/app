use anyhow::{Result, anyhow};
use flutter_rust_bridge::frb;
use image::{DynamicImage, ImageFormat, RgbaImage};
use image_dds::{ddsfile::Dds, image_from_dds};
use rayon::prelude::*;
use serde::Serialize;
use std::collections::HashMap;
use std::io::Cursor;
use std::path::PathBuf;
use std::sync::atomic::{AtomicU64, Ordering};
use std::sync::{Arc, Mutex};
pub use unp4k::dataforge::DataForge;
use unp4k::{CryXmlReader, P4kEntry, P4kFile};

use crate::frb_generated::StreamSink;

/// P4K 文件项信息
#[frb(dart_metadata=("freezed"))]
pub struct P4kFileItem {
    /// 文件名/路径
    pub name: String,
    /// 是否为目录
    pub is_directory: bool,
    /// 文件大小（字节）
    pub size: u64,
    /// 压缩后大小（字节）
    pub compressed_size: u64,
    /// 文件修改时间（毫秒时间戳）
    pub date_modified: i64,
}

/// 将 DOS 日期时间转换为毫秒时间戳
fn dos_datetime_to_millis(date: u16, time: u16) -> i64 {
    let year = ((date >> 9) & 0x7F) as i32 + 1980;
    let month = ((date >> 5) & 0x0F) as u32;
    let day = (date & 0x1F) as u32;
    let hour = ((time >> 11) & 0x1F) as u32;
    let minute = ((time >> 5) & 0x3F) as u32;
    let second = ((time & 0x1F) * 2) as u32;

    let days_since_epoch = {
        let mut days = 0i64;
        for y in 1970..year {
            days += if (y % 4 == 0 && y % 100 != 0) || (y % 400 == 0) {
                366
            } else {
                365
            };
        }
        let days_in_months = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
        if month >= 1 && month <= 12 {
            days += days_in_months[(month - 1) as usize] as i64;
            if month > 2 && ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)) {
                days += 1;
            }
        }
        days += (day as i64) - 1;
        days
    };

    (days_since_epoch * 86400 + (hour as i64) * 3600 + (minute as i64) * 60 + (second as i64))
        * 1000
}

// 全局 P4K 读取器实例（用于保持状态）
static GLOBAL_P4K_READER: once_cell::sync::Lazy<Arc<Mutex<Option<P4kFile>>>> =
    once_cell::sync::Lazy::new(|| Arc::new(Mutex::new(None)));

static GLOBAL_P4K_FILES: once_cell::sync::Lazy<Arc<Mutex<HashMap<String, P4kEntry>>>> =
    once_cell::sync::Lazy::new(|| Arc::new(Mutex::new(HashMap::new())));

// 全局 DataForge 实例（用于 DCB 文件解析）
static GLOBAL_DCB_READER: once_cell::sync::Lazy<Arc<Mutex<Option<DataForge>>>> =
    once_cell::sync::Lazy::new(|| Arc::new(Mutex::new(None)));

// 模型拼装用 DCB 缓存。按 P4K 路径懒加载 Game2.dcb/Game.dcb，避免每次预览重复解析。
static GLOBAL_MODEL_DCB_CACHE: once_cell::sync::Lazy<Arc<Mutex<HashMap<String, Arc<DataForge>>>>> =
    once_cell::sync::Lazy::new(|| Arc::new(Mutex::new(HashMap::new())));

static GLOBAL_WEM_DECODE_REQUEST_ID: AtomicU64 = AtomicU64::new(0);

#[frb(dart_metadata=("freezed"))]
pub struct WemDecodeProgress {
    pub progress: f64,
    pub waveform: Option<Vec<f64>>,
    pub duration_ms: Option<i32>,
    pub is_complete: bool,
    pub error: Option<String>,
    pub pcm_chunk: Option<Vec<i16>>,
    pub sample_rate: Option<i32>,
    pub channels: Option<i32>,
    pub chunk_index: i32,
}

/// DDS 转 PNG 调试信息
#[frb(dart_metadata=("freezed"))]
#[derive(Debug, Clone, Serialize, Default)]
pub struct DdsPngDebug {
    pub requested_path: String,
    pub base_path: String,
    pub part_count: usize,
    pub reconstructed: bool,
    pub decode_mode: String,
    pub width: u32,
    pub height: u32,
}

/// 打开 P4K 文件（仅打开，不读取文件列表）
pub async fn p4k_open(p4k_path: String) -> Result<()> {
    let path = PathBuf::from(&p4k_path);
    if !path.exists() {
        return Err(anyhow!("P4K file not found: {}", p4k_path));
    }

    // 在后台线程执行阻塞操作
    let reader = tokio::task::spawn_blocking(move || {
        let reader = P4kFile::open(&path)?;
        Ok::<_, anyhow::Error>(reader)
    })
    .await??;

    *GLOBAL_P4K_READER.lock().unwrap() = Some(reader);
    // 清空之前的文件列表缓存
    GLOBAL_P4K_FILES.lock().unwrap().clear();

    Ok(())
}

fn model_dcb_cache_key(p4k_path: &str) -> String {
    std::fs::canonicalize(p4k_path)
        .unwrap_or_else(|_| PathBuf::from(p4k_path))
        .to_string_lossy()
        .replace('/', "\\")
        .to_ascii_lowercase()
}

pub async fn p4k_get_or_load_model_dcb(p4k_path: String) -> Result<Arc<DataForge>> {
    let cache_key = model_dcb_cache_key(&p4k_path);
    {
        let cache = GLOBAL_MODEL_DCB_CACHE.lock().unwrap();
        if let Some(df) = cache.get(&cache_key) {
            return Ok(df.clone());
        }
    }

    let df = tokio::task::spawn_blocking(move || {
        let mut p4k = P4kFile::open(&p4k_path)
            .map_err(|e| anyhow!("failed to open P4K for DCB cache: {e}"))?;
        let dcb_bytes = p4k
            .extract("Data\\Game2.dcb")
            .or_else(|_| p4k.extract("Data/Game2.dcb"))
            .or_else(|_| p4k.extract("Data\\Game.dcb"))
            .or_else(|_| p4k.extract("Data/Game.dcb"))
            .map_err(|e| anyhow!("failed to extract Game2.dcb/Game.dcb from P4K: {e}"))?;
        DataForge::parse(&dcb_bytes).map_err(|e| anyhow!("failed to parse model DCB: {e}"))
    })
    .await??;
    let df = Arc::new(df);

    let mut cache = GLOBAL_MODEL_DCB_CACHE.lock().unwrap();
    Ok(cache.entry(cache_key).or_insert_with(|| df.clone()).clone())
}

pub fn p4k_clear_model_dcb_cache() {
    GLOBAL_MODEL_DCB_CACHE.lock().unwrap().clear();
}

/// 确保文件列表已加载（内部使用）
fn ensure_files_loaded() -> Result<usize> {
    let mut files = GLOBAL_P4K_FILES.lock().unwrap();
    if !files.is_empty() {
        return Ok(files.len());
    }

    let reader = GLOBAL_P4K_READER.lock().unwrap();
    if reader.is_none() {
        return Err(anyhow!("P4K reader not initialized"));
    }

    let entries = reader.as_ref().unwrap().entries();
    for entry in entries {
        let name = normalize_p4k_path(&entry.name);
        files.insert(name, entry.clone());
    }

    Ok(files.len())
}

/// 获取文件数量（会触发文件列表加载）
pub async fn p4k_get_file_count() -> Result<usize> {
    tokio::task::spawn_blocking(|| ensure_files_loaded()).await?
}

/// 获取所有文件列表
pub async fn p4k_get_all_files() -> Result<Vec<P4kFileItem>> {
    tokio::task::spawn_blocking(|| {
        ensure_files_loaded()?;
        let files = GLOBAL_P4K_FILES.lock().unwrap();
        let mut result = Vec::with_capacity(files.len());

        for (name, entry) in files.iter() {
            result.push(P4kFileItem {
                name: name.clone(),
                is_directory: false,
                size: entry.uncompressed_size,
                compressed_size: entry.compressed_size,
                date_modified: dos_datetime_to_millis(entry.mod_date, entry.mod_time),
            });
        }

        Ok(result)
    })
    .await?
}

/// 提取文件到内存
pub async fn p4k_extract_to_memory(file_path: String) -> Result<Vec<u8>> {
    // 确保文件列表已加载
    tokio::task::spawn_blocking(|| ensure_files_loaded()).await??;
    // 获取文件 entry 的克隆
    let entry = p4k_get_entry(file_path).await?;

    // 在后台线程执行阻塞的提取操作
    let data = tokio::task::spawn_blocking(move || {
        let mut reader = GLOBAL_P4K_READER.lock().unwrap();
        if reader.is_none() {
            return Err(anyhow!("P4K reader not initialized"));
        }
        let data = reader.as_mut().unwrap().extract_entry(&entry)?;
        if (entry.name.to_lowercase().ends_with(".xml")
            || entry.name.to_lowercase().ends_with(".mtl"))
            && CryXmlReader::is_cryxml(&data)
        {
            let cry_xml_string = CryXmlReader::parse(&data)?;
            return Ok(cry_xml_string.into_bytes());
        }
        Ok::<_, anyhow::Error>(data)
    })
    .await??;

    Ok(data)
}

fn build_preview_candidates(normalized_path: &str) -> Vec<String> {
    let mut candidates = vec![normalized_path.to_string()];
    if normalized_path.ends_with(".dds") {
        for level in 0..=15 {
            candidates.push(format!("{}.{}", normalized_path, level));
        }
    } else if let Some(idx) = normalized_path.find(".dds.") {
        // 点击 .dds.x 时，也把基础 .dds 放到候选集前面，方便获取头部并做拼接解码
        let base = format!("{}{}", &normalized_path[..idx], ".dds");
        candidates.insert(0, base);
    }
    candidates
}

fn dds_base_path(normalized_path: &str) -> Option<String> {
    if normalized_path.ends_with(".dds") {
        return Some(normalized_path.to_string());
    }
    normalized_path
        .find(".dds.")
        .map(|idx| format!("{}{}", &normalized_path[..idx], ".dds"))
}

fn collect_dds_parts(
    files: &HashMap<String, P4kEntry>,
    base_path: &str,
    max_parts: usize,
) -> Vec<(usize, P4kEntry)> {
    let prefix = format!("{base_path}.");
    let mut parts = Vec::new();
    for (name, entry) in files {
        if let Some(suffix) = name.strip_prefix(&prefix) {
            if let Ok(idx) = suffix.parse::<usize>() {
                if idx <= max_parts {
                    parts.push((idx, entry.clone()));
                }
            }
        }
    }
    parts.sort_by_key(|(idx, _)| *idx);
    parts
}

fn decode_image_for_preview(path: &str, data: &[u8]) -> Result<DynamicImage> {
    let lower = path.to_lowercase();
    if lower.ends_with(".dds") || lower.contains(".dds.") {
        return decode_dds_image(data);
    }

    let ext = PathBuf::from(path)
        .extension()
        .and_then(|s| s.to_str())
        .unwrap_or_default()
        .to_lowercase();
    let decoded = match ext.as_str() {
        "png" => image::load_from_memory_with_format(data, ImageFormat::Png),
        "jpg" | "jpeg" => image::load_from_memory_with_format(data, ImageFormat::Jpeg),
        "bmp" => image::load_from_memory_with_format(data, ImageFormat::Bmp),
        "gif" => image::load_from_memory_with_format(data, ImageFormat::Gif),
        "webp" => image::load_from_memory_with_format(data, ImageFormat::WebP),
        "tga" => image::load_from_memory_with_format(data, ImageFormat::Tga),
        "tif" | "tiff" => image::load_from_memory_with_format(data, ImageFormat::Tiff),
        _ => image::load_from_memory(data),
    };
    decoded.map_err(|e| anyhow!("decode image failed: {}", e))
}

fn decode_uncompressed_dds(data: &[u8]) -> Result<DynamicImage> {
    if data.len() < 128 || !has_dds_signature(data) {
        return Err(anyhow!("DDS signature not found or header too small"));
    }

    let height = le_u32(data, 12).ok_or_else(|| anyhow!("missing height"))?;
    let width = le_u32(data, 16).ok_or_else(|| anyhow!("missing width"))?;
    if width == 0 || height == 0 {
        return Err(anyhow!("invalid dds size {}x{}", width, height));
    }

    // DDS_PIXELFORMAT
    let fourcc = le_u32(data, 84).ok_or_else(|| anyhow!("missing fourcc"))?;
    let rgb_bit_count = le_u32(data, 88).ok_or_else(|| anyhow!("missing rgb bit count"))?;
    let r_mask = le_u32(data, 92).ok_or_else(|| anyhow!("missing r mask"))?;
    let g_mask = le_u32(data, 96).ok_or_else(|| anyhow!("missing g mask"))?;
    let b_mask = le_u32(data, 100).ok_or_else(|| anyhow!("missing b mask"))?;
    let a_mask = le_u32(data, 104).ok_or_else(|| anyhow!("missing a mask"))?;

    if fourcc != 0 {
        return Err(anyhow!("compressed/dx10 dds (fourcc={:#x})", fourcc));
    }
    if rgb_bit_count != 32 && rgb_bit_count != 24 {
        return Err(anyhow!("unsupported rgb bit count {}", rgb_bit_count));
    }

    let pixel_bytes = (rgb_bit_count / 8) as usize;
    let min_row_stride = (width as usize)
        .checked_mul(pixel_bytes)
        .ok_or_else(|| anyhow!("row stride overflow"))?;
    let mut row_stride = min_row_stride;
    let pitch = le_u32(data, 20).unwrap_or(0) as usize;
    if pitch >= min_row_stride {
        row_stride = pitch;
    }

    let data_offset = 128usize;
    let required_len = data_offset
        .checked_add(
            row_stride
                .checked_mul(height as usize)
                .ok_or_else(|| anyhow!("image size overflow"))?,
        )
        .ok_or_else(|| anyhow!("image size overflow"))?;
    if data.len() < required_len {
        return Err(anyhow!(
            "dds data too short: expected at least {}, got {}",
            required_len,
            data.len()
        ));
    }

    let mut rgba = Vec::with_capacity(
        (width as usize)
            .checked_mul(height as usize)
            .and_then(|v| v.checked_mul(4))
            .ok_or_else(|| anyhow!("rgba buffer overflow"))?,
    );

    for y in 0..height as usize {
        let row_start = data_offset + y * row_stride;
        for x in 0..width as usize {
            let p = row_start + x * pixel_bytes;
            let raw = if pixel_bytes == 4 {
                u32::from_le_bytes([data[p], data[p + 1], data[p + 2], data[p + 3]])
            } else {
                (data[p] as u32) | ((data[p + 1] as u32) << 8) | ((data[p + 2] as u32) << 16)
            };
            rgba.push(extract_masked_component(raw, r_mask, 0));
            rgba.push(extract_masked_component(raw, g_mask, 0));
            rgba.push(extract_masked_component(raw, b_mask, 0));
            // 无 alpha 掩码时默认不透明
            rgba.push(extract_masked_component(raw, a_mask, 255));
        }
    }

    let img = RgbaImage::from_raw(width, height, rgba)
        .ok_or_else(|| anyhow!("failed to build rgba image"))?;
    Ok(DynamicImage::ImageRgba8(img))
}

fn extract_masked_component(raw: u32, mask: u32, fallback: u8) -> u8 {
    if mask == 0 {
        return fallback;
    }
    let shift = mask.trailing_zeros();
    let max = mask >> shift;
    if max == 0 {
        return fallback;
    }
    let value = (raw & mask) >> shift;
    ((value * 255 + (max / 2)) / max) as u8
}

fn has_dds_signature(data: &[u8]) -> bool {
    data.len() >= 4 && &data[0..4] == b"DDS "
}

fn le_u32(data: &[u8], offset: usize) -> Option<u32> {
    if data.len() < offset + 4 {
        return None;
    }
    Some(u32::from_le_bytes([
        data[offset],
        data[offset + 1],
        data[offset + 2],
        data[offset + 3],
    ]))
}

fn dds_block_bytes(fourcc: &[u8]) -> Option<usize> {
    match fourcc {
        b"DXT1" | b"BC4U" | b"BC4S" | b"ATI1" => Some(8),
        b"DXT3" | b"DXT5" | b"BC5U" | b"BC5S" | b"ATI2" | b"BC7 " | b"BC6H" => Some(16),
        _ => None,
    }
}

fn compute_dds_mip_sizes(
    width: u32,
    height: u32,
    mip_count: u32,
    block_bytes: usize,
) -> Vec<usize> {
    let mut sizes = Vec::new();
    let mut w = width.max(1);
    let mut h = height.max(1);
    let count = mip_count.max(1);
    for _ in 0..count {
        let bw = w.div_ceil(4).max(1);
        let bh = h.div_ceil(4).max(1);
        sizes.push((bw as usize) * (bh as usize) * block_bytes);
        w = (w / 2).max(1);
        h = (h / 2).max(1);
    }
    sizes
}

fn dds_block_bytes_dxgi(format: u32) -> Option<usize> {
    match format {
        70..=72 => Some(8),
        73..=78 | 82..=84 | 94..=99 => Some(16),
        79..=81 => Some(8),
        _ => None,
    }
}

fn dds_payload_layout(base_dds: &[u8]) -> Option<(usize, Option<usize>)> {
    if !has_dds_signature(base_dds) || base_dds.len() < 128 {
        return None;
    }
    let width = le_u32(base_dds, 16)?;
    let height = le_u32(base_dds, 12)?;
    let mip_count = le_u32(base_dds, 28).unwrap_or(1);
    let fourcc = base_dds.get(84..88)?;
    if fourcc == b"DX10" {
        if base_dds.len() < 148 {
            return None;
        }
        let dxgi_format = le_u32(base_dds, 128)?;
        let expected_total = dds_block_bytes_dxgi(dxgi_format).map(|block_bytes| {
            compute_dds_mip_sizes(width, height, mip_count, block_bytes)
                .into_iter()
                .sum::<usize>()
        });
        return Some((148, expected_total));
    }
    let expected_total = dds_block_bytes(fourcc).map(|block_bytes| {
        compute_dds_mip_sizes(width, height, mip_count, block_bytes)
            .into_iter()
            .sum::<usize>()
    });
    Some((128, expected_total))
}

fn reconstruct_dds_stream(base_dds: &[u8], dds_parts: &[(usize, Vec<u8>)]) -> Option<Vec<u8>> {
    if !has_dds_signature(base_dds) || base_dds.len() < 128 {
        return None;
    }

    let (header_size, expected_total) = dds_payload_layout(base_dds)?;
    let header = &base_dds[..header_size];
    let tail = &base_dds[header_size..];

    let mut sorted_parts = dds_parts.to_vec();
    // Star Citizen 资源中 .dds.N 常见为 N 越大 mip 越大，这里按降序拼接。
    sorted_parts.sort_by(|a, b| b.0.cmp(&a.0));

    let mut data = Vec::new();
    for (_, chunk) in sorted_parts {
        data.extend_from_slice(&chunk);
    }
    data.extend_from_slice(tail);

    if let Some(expected_total) = expected_total {
        if data.len() < expected_total {
            return None;
        }
        if data.len() > expected_total {
            data.truncate(expected_total);
        }
    }

    let mut merged = Vec::with_capacity(header_size + data.len());
    merged.extend_from_slice(header);
    merged.extend_from_slice(&data);
    Some(merged)
}

/// 提取并解码图片为 PNG（用于 UI 预览）
/// 对 .dds 会自动尝试 .dds.0 ~ .dds.15 的层级文件
pub async fn p4k_preview_image_png(file_path: String) -> Result<Vec<u8>> {
    let normalized_path = normalize_p4k_path(&file_path);
    tokio::task::spawn_blocking(move || {
        ensure_files_loaded()?;
        let is_dds_request = normalized_path.contains(".dds");
        let candidates = build_preview_candidates(&normalized_path);

        let (entries, dds_parts) = {
            let files = GLOBAL_P4K_FILES.lock().unwrap();
            let mut matched = Vec::new();
            for candidate in candidates {
                if let Some(entry) = files.get(&candidate) {
                    matched.push(entry.clone());
                }
            }
            let parts = if let Some(base) = dds_base_path(&normalized_path) {
                collect_dds_parts(&files, &base, 64)
            } else {
                Vec::new()
            };
            (matched, parts)
        };

        if entries.is_empty() {
            return Err(anyhow!("File not found: {}", file_path));
        }

        let mut reader_guard = GLOBAL_P4K_READER.lock().unwrap();
        let reader = reader_guard
            .as_mut()
            .ok_or_else(|| anyhow!("P4K reader not initialized"))?;

        // 缓存基础 dds 头（Star Citizen 的 .dds 常见为仅头部，数据在 .dds.x）
        let mut base_dds_header: Option<Vec<u8>> = None;
        let mut extracted_dds_chunks: Vec<(String, Vec<u8>)> = Vec::new();
        let mut last_error = String::new();
        for entry in entries {
            let raw = reader.extract_entry(&entry)?;
            let lower_name = entry.name.to_lowercase();
            extracted_dds_chunks.push((entry.name.clone(), raw.clone()));

            if lower_name.ends_with(".dds") && base_dds_header.is_none() {
                base_dds_header = Some(raw.clone());
            }

            // DDS 请求优先走重组逻辑，避免基础 .dds（仅头+尾mip）被“错误但可解码”地提前返回
            if !is_dds_request {
                match decode_image_for_preview(&entry.name, &raw) {
                    Ok(img) => {
                        let mut cursor = Cursor::new(Vec::new());
                        img.write_to(&mut cursor, ImageFormat::Png)
                            .map_err(|e| anyhow!("encode png failed: {}", e))?;
                        return Ok(cursor.into_inner());
                    }
                    Err(err) => {
                        last_error = err.to_string();
                    }
                }
            }
        }

        // 回退：尝试“头 + 所有 .dds.N 分片拼接”解码
        if let Some(header) = &base_dds_header {
            if !dds_parts.is_empty() {
                let mut extracted_parts: Vec<(usize, Vec<u8>)> = Vec::new();
                for (idx, part_entry) in &dds_parts {
                    if let Ok(bytes) = reader.extract_entry(part_entry) {
                        extracted_parts.push((*idx, bytes));
                    }
                }

                if let Some(reconstructed) = reconstruct_dds_stream(header, &extracted_parts) {
                    if let Ok(img) = decode_image_for_preview(&file_path, &reconstructed) {
                        let mut cursor = Cursor::new(Vec::new());
                        img.write_to(&mut cursor, ImageFormat::Png)
                            .map_err(|e| anyhow!("encode png failed: {}", e))?;
                        return Ok(cursor.into_inner());
                    }
                }
            }
        }

        // 回退：若基础 .dds 本身不带 DDS 签名，则在所有分片中找真实 DDS 头，再拼接其余分片
        if let Some((header_idx, (_, header_chunk))) = extracted_dds_chunks
            .iter()
            .enumerate()
            .find(|(_, (_, chunk))| has_dds_signature(chunk))
        {
            let mut merged = Vec::new();
            merged.extend_from_slice(header_chunk);

            for (idx, (_, chunk)) in extracted_dds_chunks.iter().enumerate() {
                if idx == header_idx {
                    continue;
                }
                // 跳过其他也带 DDS 头的块，避免把第二个独立 DDS 拼进去
                if has_dds_signature(chunk) {
                    continue;
                }
                merged.extend_from_slice(chunk);
            }

            if let Ok(img) = decode_image_for_preview(&file_path, &merged) {
                let mut cursor = Cursor::new(Vec::new());
                img.write_to(&mut cursor, ImageFormat::Png)
                    .map_err(|e| anyhow!("encode png failed: {}", e))?;
                return Ok(cursor.into_inner());
            }
        }

        // 最后兜底：DDS 重组均失败时，再尝试逐个直接解码
        if is_dds_request {
            for (name, raw) in &extracted_dds_chunks {
                if let Ok(img) = decode_image_for_preview(name, raw) {
                    let mut cursor = Cursor::new(Vec::new());
                    img.write_to(&mut cursor, ImageFormat::Png)
                        .map_err(|e| anyhow!("encode png failed: {}", e))?;
                    return Ok(cursor.into_inner());
                }
            }
        }

        Err(anyhow!(
            "Failed to decode preview image from {}: {}",
            file_path,
            if last_error.is_empty() {
                "unknown error"
            } else {
                &last_error
            }
        ))
    })
    .await?
}

fn decode_dds_image(data: &[u8]) -> Result<DynamicImage> {
    // 首先尝试 image crate 原生 DDS 支持
    if let Ok(img) = image::load_from_memory_with_format(data, ImageFormat::Dds) {
        return Ok(img);
    }

    // 尝试使用 image_dds 库解码
    let mut cursor = Cursor::new(data);
    if let Ok(dds) = Dds::read(&mut cursor) {
        if let Ok(rgba) = image_from_dds(&dds, 0) {
            return Ok(DynamicImage::ImageRgba8(rgba));
        }
    }

    // 回退到自定义未压缩 DDS 解码（支持 X8R8G8B8, A8R8G8B8, R8G8B8 等格式）
    decode_uncompressed_dds(data)
}

fn collect_dds_part_paths(
    index: &HashMap<String, String>,
    base_path: &str,
    max_parts: usize,
) -> Vec<(usize, String)> {
    let mut out = Vec::new();
    let prefix = format!("{}.", normalize_p4k_path(base_path));
    for (key, real) in index {
        if let Some(suffix) = key.strip_prefix(&prefix) {
            if let Ok(idx) = suffix.parse::<usize>() {
                if idx <= max_parts {
                    out.push((idx, real.clone()));
                }
            }
        }
    }
    out.sort_by_key(|(idx, _)| *idx);
    out
}

/// 提取 DDS 文件并转换为 PNG，返回 PNG 字节和调试信息
pub async fn p4k_extract_dds_as_png(file_path: String) -> Result<(Vec<u8>, DdsPngDebug)> {
    let requested = normalize_slashes(&file_path);
    let base_path = dds_base_path(&requested).unwrap_or_else(|| requested.clone());

    let files = GLOBAL_P4K_FILES.lock().unwrap().clone();
    let mut index = HashMap::<String, String>::with_capacity(files.len());
    for (name, entry) in files {
        index.insert(normalize_p4k_path(&name), entry.name);
    }

    let base_real = index
        .get(&normalize_p4k_path(&base_path))
        .cloned()
        .ok_or_else(|| anyhow!("DDS base entry not found: {}", base_path))?;
    let base_bytes = p4k_extract_to_memory(base_real.clone()).await?;

    let part_paths = collect_dds_part_paths(&index, &base_path, 64);
    let mut part_bytes = Vec::<(usize, Vec<u8>)>::new();
    for (idx, real) in &part_paths {
        if let Ok(bytes) = p4k_extract_to_memory(real.clone()).await {
            part_bytes.push((*idx, bytes));
        }
    }

    let reconstructed = reconstruct_dds_stream(&base_bytes, &part_bytes);
    let (decoded, decode_mode) = if let Some(bytes) = reconstructed.as_ref() {
        match decode_dds_image(bytes) {
            Ok(img) => (img, "reconstructed".to_string()),
            Err(_recon_err) => match decode_dds_image(&base_bytes) {
                Ok(img) => (img, "base".to_string()),
                Err(base_err) => {
                    return Err(anyhow!(
                        "dds decode failed (part_count={}, reconstructed=true): base_error={}",
                        part_bytes.len(),
                        base_err
                    ));
                }
            },
        }
    } else {
        let img = decode_dds_image(&base_bytes).map_err(|e| {
            anyhow!(
                "dds decode failed (part_count={}, reconstructed=false): {}",
                part_bytes.len(),
                e
            )
        })?;
        (img, "base".to_string())
    };

    let mut out = Cursor::new(Vec::new());
    decoded
        .write_to(&mut out, ImageFormat::Png)
        .map_err(|e| anyhow!("encode png failed: {e}"))?;

    let debug = DdsPngDebug {
        requested_path: requested,
        base_path: base_real,
        part_count: part_bytes.len(),
        reconstructed: reconstructed.is_some() && decode_mode == "reconstructed",
        decode_mode,
        width: decoded.width(),
        height: decoded.height(),
    };
    Ok((out.into_inner(), debug))
}

/// DDS 分片信息
#[frb(dart_metadata=("freezed"))]
pub struct DdsPartInfo {
    pub index: usize,
    pub path: String,
}

/// DDS 调试信息
#[frb(dart_metadata=("freezed"))]
pub struct DdsDebugInfo {
    pub requested_path: String,
    pub base_path: String,
    pub base_key: String,
    pub base_real: Option<String>,
    pub part_count: usize,
    pub parts: Vec<DdsPartInfo>,
}

/// 调试 DDS 分片信息
pub async fn p4k_debug_dds_parts(file_path: String) -> Result<DdsDebugInfo> {
    let requested = normalize_slashes(&file_path);
    let base_path = dds_base_path(&requested).unwrap_or_else(|| requested.clone());
    let files = GLOBAL_P4K_FILES.lock().unwrap().clone();
    let mut index = HashMap::<String, String>::with_capacity(files.len());
    for (name, entry) in files {
        index.insert(normalize_p4k_path(&name), entry.name);
    }
    let base_key = normalize_p4k_path(&base_path);
    let base_real = index.get(&base_key).cloned();
    let parts = collect_dds_part_paths(&index, &base_path, 64);
    Ok(DdsDebugInfo {
        requested_path: requested,
        base_path,
        base_key,
        base_real,
        part_count: parts.len(),
        parts: parts
            .into_iter()
            .map(|(i, p)| DdsPartInfo { index: i, path: p })
            .collect(),
    })
}

#[cfg(test)]
mod tests {
    use super::{decode_image_for_preview, has_dds_signature, reconstruct_dds_stream};
    use crate::audio::wwise::decode_wem_vorbis_to_ogg;
    use anyhow::{Result, anyhow};
    use image::ImageFormat;
    use std::fs;
    use std::io::Cursor;
    use std::path::PathBuf;

    fn read_file(path: &PathBuf) -> Result<Vec<u8>> {
        fs::read(path).map_err(|e| anyhow!("read {} failed: {}", path.display(), e))
    }

    #[test]
    fn convert_dds_target_sample_to_png() -> Result<()> {
        let base_name = "poster_advert_1_hammerhead_9x16_a_diff.dds";
        let target_dir = PathBuf::from("../dds_target");
        let base_path = target_dir.join(base_name);
        if !base_path.exists() {
            return Err(anyhow!("sample not found: {}", base_path.display()));
        }

        let base_dds = read_file(&base_path)?;
        let mut parts = Vec::<(usize, Vec<u8>)>::new();
        for idx in 1..=64 {
            let part_path = target_dir.join(format!("{base_name}.{idx}"));
            if !part_path.exists() {
                continue;
            }
            parts.push((idx, read_file(&part_path)?));
        }
        if parts.is_empty() {
            return Err(anyhow!("no dds parts found for {}", base_name));
        }

        let reconstructed = reconstruct_dds_stream(&base_dds, &parts)
            .ok_or_else(|| anyhow!("reconstruct_dds_stream returned None"))?;
        let img = decode_image_for_preview(base_name, &reconstructed)?;

        let mut cursor = Cursor::new(Vec::new());
        img.write_to(&mut cursor, ImageFormat::Png)?;
        let out_path = target_dir.join("poster_advert_1_hammerhead_9x16_a_diff.test.png");
        fs::write(&out_path, cursor.into_inner())
            .map_err(|e| anyhow!("write {} failed: {}", out_path.display(), e))?;
        println!("wrote {}", out_path.display());
        Ok(())
    }

    #[test]
    fn decode_uncompressed_bgra_dds_fallback() -> Result<()> {
        let mut dds = vec![0u8; 128];
        dds[0..4].copy_from_slice(b"DDS ");
        dds[4..8].copy_from_slice(&124u32.to_le_bytes());
        dds[8..12].copy_from_slice(&0x00021007u32.to_le_bytes());
        dds[12..16].copy_from_slice(&2u32.to_le_bytes()); // height
        dds[16..20].copy_from_slice(&2u32.to_le_bytes()); // width
        dds[20..24].copy_from_slice(&8u32.to_le_bytes()); // pitch
        dds[28..32].copy_from_slice(&1u32.to_le_bytes()); // mip count
        dds[76..80].copy_from_slice(&32u32.to_le_bytes()); // pf size
        dds[80..84].copy_from_slice(&0x41u32.to_le_bytes()); // rgb + alpha
        dds[84..88].copy_from_slice(&0u32.to_le_bytes()); // fourcc
        dds[88..92].copy_from_slice(&32u32.to_le_bytes()); // bpp
        dds[92..96].copy_from_slice(&0x00FF0000u32.to_le_bytes()); // r mask
        dds[96..100].copy_from_slice(&0x0000FF00u32.to_le_bytes()); // g mask
        dds[100..104].copy_from_slice(&0x000000FFu32.to_le_bytes()); // b mask
        dds[104..108].copy_from_slice(&0xFF000000u32.to_le_bytes()); // a mask
        dds[108..112].copy_from_slice(&0x1000u32.to_le_bytes()); // caps

        // 2x2 BGRA pixels: red, green, blue, white (all opaque)
        dds.extend_from_slice(&[0x00, 0x00, 0xFF, 0xFF]);
        dds.extend_from_slice(&[0x00, 0xFF, 0x00, 0xFF]);
        dds.extend_from_slice(&[0xFF, 0x00, 0x00, 0xFF]);
        dds.extend_from_slice(&[0xFF, 0xFF, 0xFF, 0xFF]);

        let img = decode_image_for_preview("fallback.dds", &dds)?;
        let rgba = img.to_rgba8();
        if rgba.width() != 2 || rgba.height() != 2 {
            return Err(anyhow!(
                "unexpected output size {}x{}",
                rgba.width(),
                rgba.height()
            ));
        }
        if rgba.get_pixel(0, 0).0 != [255, 0, 0, 255] {
            return Err(anyhow!(
                "unexpected first pixel {:?}",
                rgba.get_pixel(0, 0).0
            ));
        }
        Ok(())
    }

    #[test]
    fn convert_all_dds_target_files_to_png() -> Result<()> {
        let target_dir = PathBuf::from("../dds_target");
        if !target_dir.exists() {
            return Err(anyhow!("dds_target not found: {}", target_dir.display()));
        }

        let mut dds_targets = Vec::new();
        for entry in fs::read_dir(&target_dir)? {
            let entry = entry?;
            let path = entry.path();
            if !path.is_file() {
                continue;
            }
            let name = path
                .file_name()
                .and_then(|s| s.to_str())
                .ok_or_else(|| anyhow!("invalid utf-8 path: {}", path.display()))?
                .to_string();
            let lower = name.to_lowercase();
            if lower.ends_with(".dds") || lower.contains(".dds.") {
                dds_targets.push(name);
            }
        }
        dds_targets.sort();

        if dds_targets.is_empty() {
            return Err(anyhow!(
                "no .dds/.dds.N files found in {}",
                target_dir.display()
            ));
        }

        let mut success = 0usize;
        let mut failed = Vec::new();

        for target_name in dds_targets {
            let lower_target = target_name.to_lowercase();
            let base_name = if let Some(idx) = lower_target.find(".dds.") {
                format!("{}{}", &target_name[..idx], ".dds")
            } else {
                target_name.clone()
            };
            let base_path = target_dir.join(&base_name);
            if !base_path.exists() {
                println!("[SKIP] {} (base missing: {})", target_name, base_name);
                continue;
            }
            let base_dds = read_file(&base_path)?;

            let mut parts = Vec::<(usize, Vec<u8>)>::new();
            for idx in 1..=64 {
                let part_path = target_dir.join(format!("{base_name}.{idx}"));
                if part_path.exists() {
                    parts.push((idx, read_file(&part_path)?));
                }
            }

            let mut decoded = None;

            if !parts.is_empty() {
                if let Some(reconstructed) = reconstruct_dds_stream(&base_dds, &parts) {
                    if let Ok(img) = decode_image_for_preview(&base_name, &reconstructed) {
                        decoded = Some(img);
                    }
                }
            }

            if decoded.is_none() {
                // fallback: find any chunk with DDS signature then append non-signature chunks
                let mut chunks = Vec::<Vec<u8>>::new();
                chunks.push(base_dds.clone());
                for (_, p) in &parts {
                    chunks.push(p.clone());
                }
                if let Some((header_idx, header_chunk)) = chunks
                    .iter()
                    .enumerate()
                    .find(|(_, c)| has_dds_signature(c))
                {
                    let mut merged = Vec::new();
                    merged.extend_from_slice(header_chunk);
                    for (idx, chunk) in chunks.iter().enumerate() {
                        if idx == header_idx || has_dds_signature(chunk) {
                            continue;
                        }
                        merged.extend_from_slice(chunk);
                    }
                    if let Ok(img) = decode_image_for_preview(&base_name, &merged) {
                        decoded = Some(img);
                    }
                }
            }

            if decoded.is_none() {
                if let Ok(img) = decode_image_for_preview(&base_name, &base_dds) {
                    decoded = Some(img);
                }
            }

            match decoded {
                Some(img) => {
                    let mut cursor = Cursor::new(Vec::new());
                    img.write_to(&mut cursor, ImageFormat::Png)?;
                    let output_name = format!("{target_name}.test.png");
                    let out_path = target_dir.join(output_name);
                    fs::write(&out_path, cursor.into_inner())?;
                    println!("[OK] {} -> {}", target_name, out_path.display());
                    success += 1;
                }
                None => {
                    println!("[FAIL] {}", target_name);
                    failed.push(target_name);
                }
            }
        }

        println!("summary: success={}, failed={}", success, failed.len());
        if !failed.is_empty() {
            return Err(anyhow!("failed files: {}", failed.join(", ")));
        }
        Ok(())
    }

    #[test]
    fn decode_all_live_wem_to_ogg_if_present() -> Result<()> {
        let root = PathBuf::from(r"C:\WINDOWS\TEMP\SCToolbox_unp4kc\LIVE");
        if !root.exists() {
            println!("[SKIP] live wem folder not found: {}", root.display());
            return Ok(());
        }

        let mut wem_files = Vec::<PathBuf>::new();
        for entry in walkdir::WalkDir::new(&root).into_iter().flatten() {
            if !entry.file_type().is_file() {
                continue;
            }
            let p = entry.path();
            let lower = p.to_string_lossy().to_lowercase();
            if lower.ends_with(".wem") {
                wem_files.push(p.to_path_buf());
            }
        }
        wem_files.sort();
        if wem_files.is_empty() {
            println!("[SKIP] no .wem in {}", root.display());
            return Ok(());
        }

        let mut failed = Vec::<String>::new();
        for p in wem_files {
            let wem = fs::read(&p)?;
            match decode_wem_vorbis_to_ogg(&wem) {
                Ok(ogg) => {
                    if ogg.len() <= 4 || !ogg.starts_with(b"OggS") {
                        failed.push(format!("{} -> ogg too small", p.display()));
                    }
                }
                Err(e) => failed.push(format!("{} -> {}", p.display(), e)),
            }
        }

        if !failed.is_empty() {
            return Err(anyhow!("wem decode failed:\n{}", failed.join("\n")));
        }
        Ok(())
    }
}

async fn p4k_get_entry(file_path: String) -> Result<P4kEntry> {
    // 确保文件列表已加载
    tokio::task::spawn_blocking(|| ensure_files_loaded()).await??;

    // 规范化路径，P4K 查找大小写不敏感
    let normalized_path = normalize_p4k_path(&file_path);

    // 获取文件 entry 的克隆
    let entry = {
        let files = GLOBAL_P4K_FILES.lock().unwrap();
        files
            .get(&normalized_path)
            .ok_or_else(|| anyhow!("File not found: {}", file_path))?
            .clone()
    };

    Ok(entry)
}

fn normalize_slashes(path: &str) -> String {
    path.replace('/', "\\")
}

fn normalize_p4k_path(path: &str) -> String {
    let mut normalized = path.replace('/', "\\");
    if !normalized.starts_with('\\') {
        normalized = format!("\\{}", normalized);
    }
    normalized.to_lowercase()
}

/// 提取文件到磁盘
pub async fn p4k_extract_to_disk(file_path: String, output_path: String) -> Result<()> {
    let entry = p4k_get_entry(file_path).await?;

    // 在后台线程执行阻塞的文件写入操作
    tokio::task::spawn_blocking(move || {
        let output = PathBuf::from(&output_path);
        // 创建父目录
        if let Some(parent) = output.parent() {
            std::fs::create_dir_all(parent)?;
        }

        let mut reader_guard = GLOBAL_P4K_READER.lock().unwrap();
        let reader = reader_guard
            .as_mut()
            .ok_or_else(|| anyhow!("P4K reader not initialized"))?;

        unp4k::p4k_utils::extract_single_file(reader, &entry, &output, true)?;
        Ok::<_, anyhow::Error>(())
    })
    .await??;

    Ok(())
}

/// 内置 WEM -> OGG 转换（用于预览播放，不依赖外部工具）
pub async fn p4k_decode_wem_to_ogg(input_path: String, output_path: String) -> Result<()> {
    tokio::task::spawn_blocking(move || {
        let request_id = GLOBAL_WEM_DECODE_REQUEST_ID.fetch_add(1, Ordering::SeqCst) + 1;
        let is_cancelled = || GLOBAL_WEM_DECODE_REQUEST_ID.load(Ordering::SeqCst) != request_id;

        let input = PathBuf::from(&input_path);
        if !input.exists() {
            return Err(anyhow!("input wem not found: {}", input_path));
        }

        let wem = std::fs::read(&input)?;
        let ogg = match crate::audio::wwise::decode_wem_to_ogg_with_cancel(&wem, &is_cancelled) {
            Ok(w) => w,
            Err(e) if e.to_string().contains("wem decode cancelled") => {
                return Err(anyhow!("wem decode interrupted by newer request"));
            }
            Err(e) => return Err(e),
        };

        let output = PathBuf::from(&output_path);
        if let Some(parent) = output.parent() {
            std::fs::create_dir_all(parent)?;
        }
        std::fs::write(output, ogg)?;
        Ok(())
    })
    .await?
}

/// 内置 WEM -> OGG 预览转换（估算中段并仅输出短片段）
pub async fn p4k_decode_wem_to_ogg_preview(
    input_path: String,
    output_path: String,
    clip_seconds: u32,
) -> Result<()> {
    tokio::task::spawn_blocking(move || {
        let request_id = GLOBAL_WEM_DECODE_REQUEST_ID.fetch_add(1, Ordering::SeqCst) + 1;
        let is_cancelled = || GLOBAL_WEM_DECODE_REQUEST_ID.load(Ordering::SeqCst) != request_id;

        let input = PathBuf::from(&input_path);
        if !input.exists() {
            return Err(anyhow!("input wem not found: {}", input_path));
        }

        let wem = std::fs::read(&input)?;
        let ogg = match crate::audio::wwise::decode_wem_preview_to_ogg_with_cancel(
            &wem,
            clip_seconds.max(1),
            &is_cancelled,
        ) {
            Ok(w) => w,
            Err(e) if e.to_string().contains("wem decode cancelled") => {
                return Err(anyhow!("wem decode interrupted by newer request"));
            }
            Err(e) => return Err(e),
        };

        let output = PathBuf::from(&output_path);
        if let Some(parent) = output.parent() {
            std::fs::create_dir_all(parent)?;
        }
        std::fs::write(output, ogg)?;
        Ok(())
    })
    .await?
}

/// 将 OGG 转为 WAV（导出时用于复用缓存）
pub async fn p4k_decode_ogg_to_wav(input_path: String, output_path: String) -> Result<()> {
    tokio::task::spawn_blocking(move || {
        let input = PathBuf::from(&input_path);
        if !input.exists() {
            return Err(anyhow!("input ogg not found: {}", input_path));
        }

        let ogg = std::fs::read(&input)?;
        let wav = crate::audio::wwise::decode_ogg_to_wav(&ogg)?;

        let output = PathBuf::from(&output_path);
        if let Some(parent) = output.parent() {
            std::fs::create_dir_all(parent)?;
        }
        std::fs::write(output, wav)?;
        Ok(())
    })
    .await?
}

/// 内置 WEM(PCM) -> WAV 转换（用于预览播放或导出兜底，不依赖外部工具）
pub async fn p4k_decode_wem_to_wav(input_path: String, output_path: String) -> Result<()> {
    tokio::task::spawn_blocking(move || {
        let request_id = GLOBAL_WEM_DECODE_REQUEST_ID.fetch_add(1, Ordering::SeqCst) + 1;
        let is_cancelled = || GLOBAL_WEM_DECODE_REQUEST_ID.load(Ordering::SeqCst) != request_id;

        let input = PathBuf::from(&input_path);
        if !input.exists() {
            return Err(anyhow!("input wem not found: {}", input_path));
        }

        let wem = std::fs::read(&input)?;
        let wav = match crate::audio::wwise::decode_wem_to_wav_with_cancel(&wem, &is_cancelled) {
            Ok(w) => w,
            Err(e) if e.to_string().contains("wem decode cancelled") => {
                return Err(anyhow!("wem decode interrupted by newer request"));
            }
            Err(e) => return Err(e),
        };

        let output = PathBuf::from(&output_path);
        if let Some(parent) = output.parent() {
            std::fs::create_dir_all(parent)?;
        }
        std::fs::write(output, wav)?;
        Ok(())
    })
    .await?
}

/// 内置 WEM -> WAV 预览转换（估算中段并仅输出短片段，导出兜底用）
pub async fn p4k_decode_wem_to_wav_preview(
    input_path: String,
    output_path: String,
    clip_seconds: u32,
) -> Result<()> {
    tokio::task::spawn_blocking(move || {
        let request_id = GLOBAL_WEM_DECODE_REQUEST_ID.fetch_add(1, Ordering::SeqCst) + 1;
        let is_cancelled = || GLOBAL_WEM_DECODE_REQUEST_ID.load(Ordering::SeqCst) != request_id;

        let input = PathBuf::from(&input_path);
        if !input.exists() {
            return Err(anyhow!("input wem not found: {}", input_path));
        }

        let wem = std::fs::read(&input)?;
        let wav = match crate::audio::wwise::decode_wem_preview_to_wav_with_cancel(
            &wem,
            clip_seconds.max(1),
            &is_cancelled,
        ) {
            Ok(w) => w,
            Err(e) if e.to_string().contains("wem decode cancelled") => {
                return Err(anyhow!("wem decode interrupted by newer request"));
            }
            Err(e) => return Err(e),
        };

        let output = PathBuf::from(&output_path);
        if let Some(parent) = output.parent() {
            std::fs::create_dir_all(parent)?;
        }
        std::fs::write(output, wav)?;
        Ok(())
    })
    .await?
}

/// 取消正在进行的 WEM 解码任务（通过提升全局请求 id）
pub fn p4k_cancel_wem_decode() {
    GLOBAL_WEM_DECODE_REQUEST_ID.fetch_add(1, Ordering::SeqCst);
}

/// 流式解码 WEM 到内存，返回进度和波形数据
/// 每2秒发送一次进度更新，支持流式播放
pub async fn p4k_decode_wem_to_wav_stream(
    input_path: String,
    stream_sink: StreamSink<WemDecodeProgress>,
) {
    let stream_sink = Arc::new(stream_sink);
    let input = input_path.clone();

    let sink = stream_sink.clone();
    let handle = tokio::task::spawn_blocking(move || {
        let request_id = GLOBAL_WEM_DECODE_REQUEST_ID.fetch_add(1, Ordering::SeqCst) + 1;
        let is_cancelled = || GLOBAL_WEM_DECODE_REQUEST_ID.load(Ordering::SeqCst) != request_id;

        let input_pb = PathBuf::from(&input);
        if !input_pb.exists() {
            let _ = sink.add(WemDecodeProgress {
                progress: 0.0,
                waveform: None,
                duration_ms: None,
                is_complete: true,
                error: Some(format!("input wem not found: {}", input)),
                pcm_chunk: None,
                sample_rate: None,
                channels: None,
                chunk_index: 0,
            });
            return;
        }

        let wem = match std::fs::read(&input_pb) {
            Ok(w) => w,
            Err(e) => {
                let _ = sink.add(WemDecodeProgress {
                    progress: 0.0,
                    waveform: None,
                    duration_ms: None,
                    is_complete: true,
                    error: Some(format!("read wem failed: {}", e)),
                    pcm_chunk: None,
                    sample_rate: None,
                    channels: None,
                    chunk_index: 0,
                });
                return;
            }
        };

        let info = match crate::audio::wwise::get_wem_stream_info(&wem) {
            Ok(i) => i,
            Err(e) => {
                let _ = sink.add(WemDecodeProgress {
                    progress: 0.0,
                    waveform: None,
                    duration_ms: None,
                    is_complete: true,
                    error: Some(format!("parse wem header failed: {}", e)),
                    pcm_chunk: None,
                    sample_rate: None,
                    channels: None,
                    chunk_index: 0,
                });
                return;
            }
        };

        let _ = sink.add(WemDecodeProgress {
            progress: 0.05,
            waveform: None,
            duration_ms: None,
            is_complete: false,
            error: None,
            pcm_chunk: None,
            sample_rate: Some(info.sample_rate as i32),
            channels: Some(info.channels as i32),
            chunk_index: 0,
        });

        let mut all_pcm: Vec<i16> = Vec::new();
        let mut waveform_samples: Vec<f64> = Vec::new();
        let sample_rate = info.sample_rate;
        let channels = info.channels;
        let total_frames = info.total_samples;

        let chunk_duration_ms = 2000u32;
        let sink_clone = sink.clone();

        let result = crate::audio::wwise::decode_wem_stream(
            &wem,
            chunk_duration_ms,
            |pcm_chunk: &[i16], chunk_index: usize, _total_frames: usize| {
                if is_cancelled() {
                    return Err(anyhow!("wem decode cancelled"));
                }

                all_pcm.extend_from_slice(pcm_chunk);

                let chunk_waveform = compute_waveform_from_pcm(pcm_chunk, 10);
                waveform_samples.extend(chunk_waveform);

                let frames_decoded = all_pcm.len() / channels as usize;
                let progress = if total_frames > 0 {
                    (frames_decoded as f64 / total_frames as f64).min(0.95)
                } else {
                    0.5
                };

                let _ = sink_clone.add(WemDecodeProgress {
                    progress,
                    waveform: None,
                    duration_ms: None,
                    is_complete: false,
                    error: None,
                    pcm_chunk: Some(pcm_chunk.to_vec()),
                    sample_rate: Some(sample_rate as i32),
                    channels: Some(channels as i32),
                    chunk_index: chunk_index as i32,
                });

                Ok(())
            },
            &is_cancelled,
        );

        let (codec, ch, sr, frames) = match result {
            Ok(r) => r,
            Err(e) => {
                let err_msg = if e.to_string().contains("wem decode cancelled") {
                    "wem decode interrupted by newer request".to_string()
                } else {
                    e.to_string()
                };
                let _ = sink.add(WemDecodeProgress {
                    progress: 0.0,
                    waveform: None,
                    duration_ms: None,
                    is_complete: true,
                    error: Some(err_msg),
                    pcm_chunk: None,
                    sample_rate: None,
                    channels: None,
                    chunk_index: 0,
                });
                return;
            }
        };

        let duration_ms = if sr > 0 && ch > 0 {
            ((frames as f64 / sr as f64) * 1000.0) as i32
        } else {
            0
        };

        let final_waveform = compute_waveform_from_pcm(&all_pcm, 160);

        let _ = sink.add(WemDecodeProgress {
            progress: 1.0,
            waveform: Some(final_waveform),
            duration_ms: Some(duration_ms),
            is_complete: true,
            error: None,
            pcm_chunk: None,
            sample_rate: Some(sr as i32),
            channels: Some(ch as i32),
            chunk_index: -1,
        });
    });

    let _ = handle.await;
}

/// In-memory variant of `p4k_decode_wem_to_wav_stream` — accepts raw WEM bytes instead of a file path.
pub async fn p4k_decode_wem_bytes_to_wav_stream(
    wem_bytes: Vec<u8>,
    stream_sink: StreamSink<WemDecodeProgress>,
) {
    let stream_sink = Arc::new(stream_sink);

    let sink = stream_sink.clone();
    let handle = tokio::task::spawn_blocking(move || {
        let request_id = GLOBAL_WEM_DECODE_REQUEST_ID.fetch_add(1, Ordering::SeqCst) + 1;
        let is_cancelled = || GLOBAL_WEM_DECODE_REQUEST_ID.load(Ordering::SeqCst) != request_id;

        let wem = &wem_bytes;
        let info = match crate::audio::wwise::get_wem_stream_info(wem) {
            Ok(i) => i,
            Err(e) => {
                let _ = sink.add(WemDecodeProgress {
                    progress: 0.0,
                    waveform: None,
                    duration_ms: None,
                    is_complete: true,
                    error: Some(format!("parse wem header failed: {}", e)),
                    pcm_chunk: None,
                    sample_rate: None,
                    channels: None,
                    chunk_index: 0,
                });
                return;
            }
        };

        let _ = sink.add(WemDecodeProgress {
            progress: 0.05,
            waveform: None,
            duration_ms: None,
            is_complete: false,
            error: None,
            pcm_chunk: None,
            sample_rate: Some(info.sample_rate as i32),
            channels: Some(info.channels as i32),
            chunk_index: 0,
        });

        let mut all_pcm: Vec<i16> = Vec::new();
        let mut waveform_samples: Vec<f64> = Vec::new();
        let sample_rate = info.sample_rate;
        let channels = info.channels;
        let total_frames = info.total_samples;

        let chunk_duration_ms = 2000u32;
        let sink_clone = sink.clone();

        let result = crate::audio::wwise::decode_wem_stream(
            wem,
            chunk_duration_ms,
            |pcm_chunk: &[i16], chunk_index: usize, _total_frames: usize| {
                if is_cancelled() {
                    return Err(anyhow!("wem decode cancelled"));
                }

                all_pcm.extend_from_slice(pcm_chunk);

                let chunk_waveform = compute_waveform_from_pcm(pcm_chunk, 10);
                waveform_samples.extend(chunk_waveform);

                let frames_decoded = all_pcm.len() / channels as usize;
                let progress = if total_frames > 0 {
                    (frames_decoded as f64 / total_frames as f64).min(0.95)
                } else {
                    0.5
                };

                let _ = sink_clone.add(WemDecodeProgress {
                    progress,
                    waveform: None,
                    duration_ms: None,
                    is_complete: false,
                    error: None,
                    pcm_chunk: Some(pcm_chunk.to_vec()),
                    sample_rate: Some(sample_rate as i32),
                    channels: Some(channels as i32),
                    chunk_index: chunk_index as i32,
                });

                Ok(())
            },
            &is_cancelled,
        );

        let (_codec, ch, sr, frames) = match result {
            Ok(r) => r,
            Err(e) => {
                let err_msg = if e.to_string().contains("wem decode cancelled") {
                    "wem decode interrupted by newer request".to_string()
                } else {
                    e.to_string()
                };
                let _ = sink.add(WemDecodeProgress {
                    progress: 0.0,
                    waveform: None,
                    duration_ms: None,
                    is_complete: true,
                    error: Some(err_msg),
                    pcm_chunk: None,
                    sample_rate: None,
                    channels: None,
                    chunk_index: 0,
                });
                return;
            }
        };

        let duration_ms = if sr > 0 && ch > 0 {
            ((frames as f64 / sr as f64) * 1000.0) as i32
        } else {
            0
        };

        let final_waveform = compute_waveform_from_pcm(&all_pcm, 160);

        let _ = sink.add(WemDecodeProgress {
            progress: 1.0,
            waveform: Some(final_waveform),
            duration_ms: Some(duration_ms),
            is_complete: true,
            error: None,
            pcm_chunk: None,
            sample_rate: Some(sr as i32),
            channels: Some(ch as i32),
            chunk_index: -1,
        });
    });

    let _ = handle.await;
}

fn compute_waveform_from_pcm(pcm: &[i16], points: usize) -> Vec<f64> {
    if pcm.is_empty() || points == 0 {
        return vec![0.0; points.max(1)];
    }

    let bucket = (pcm.len() / points).max(1);
    let mut result = Vec::with_capacity(points);
    for i in (0..pcm.len()).step_by(bucket) {
        let end = (i + bucket).min(pcm.len());
        let mut peak = 0.0f64;
        for j in i..end {
            let sample = (pcm[j] as f64).abs() / 32768.0;
            if sample > peak {
                peak = sample;
            }
        }
        result.push(peak.clamp(0.0, 1.0));
    }

    while result.len() < points {
        result.push(0.0);
    }
    result.truncate(points);
    result
}

fn build_wav_from_pcm(channels: u16, sample_rate: u32, pcm: &[i16]) -> Result<Vec<u8>> {
    let mut payload = vec![0u8; pcm.len() * 2];
    for (i, sample) in pcm.iter().enumerate() {
        let b = sample.to_le_bytes();
        payload[i * 2] = b[0];
        payload[i * 2 + 1] = b[1];
    }

    let block_align = channels.saturating_mul(2);
    let avg_bytes_per_sec = sample_rate.saturating_mul(block_align as u32);

    let mut wav = Vec::<u8>::with_capacity(44 + payload.len());
    wav.extend_from_slice(b"RIFF");
    wav.extend_from_slice(&(36u32.saturating_add(payload.len() as u32)).to_le_bytes());
    wav.extend_from_slice(b"WAVE");
    wav.extend_from_slice(b"fmt ");
    wav.extend_from_slice(&16u32.to_le_bytes());
    wav.extend_from_slice(&1u16.to_le_bytes());
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

fn compute_waveform_from_wav(wav: &[u8]) -> Vec<f64> {
    let points = 160usize;
    if wav.len() < 44 {
        return vec![0.0; points];
    }

    if &wav[0..4] != b"RIFF" || &wav[8..12] != b"WAVE" {
        return vec![0.0; points];
    }

    let mut data_offset: Option<usize> = None;
    let mut data_length: Option<usize> = None;
    let mut channels: Option<u16> = None;
    let mut bits_per_sample: Option<u16> = None;
    let mut offset = 12;

    while offset + 8 <= wav.len() {
        let chunk_id = &wav[offset..offset + 4];
        let chunk_size = u32::from_le_bytes([
            wav[offset + 4],
            wav[offset + 5],
            wav[offset + 6],
            wav[offset + 7],
        ]) as usize;
        let chunk_data_start = offset + 8;

        if chunk_id == b"fmt " && chunk_size >= 16 {
            channels = Some(u16::from_le_bytes([
                wav[chunk_data_start + 2],
                wav[chunk_data_start + 3],
            ]));
            bits_per_sample = Some(u16::from_le_bytes([
                wav[chunk_data_start + 14],
                wav[chunk_data_start + 15],
            ]));
        } else if chunk_id == b"data" {
            data_offset = Some(chunk_data_start);
            data_length = Some(chunk_size);
        }

        offset = chunk_data_start + chunk_size + (chunk_size % 2);
    }

    let data_offset = match data_offset {
        Some(o) => o,
        None => return vec![0.0; points],
    };
    let data_length = match data_length {
        Some(l) => l,
        None => return vec![0.0; points],
    };
    let _channels = channels.unwrap_or(2);
    let bits = bits_per_sample.unwrap_or(16);

    let pcm_data = &wav[data_offset..data_offset + data_length.min(wav.len() - data_offset)];

    if bits == 16 {
        let sample_count = pcm_data.len() / 2;
        if sample_count == 0 {
            return vec![0.0; points];
        }
        let bucket = (sample_count / points).max(1);
        let mut result = Vec::with_capacity(points);
        for i in (0..sample_count).step_by(bucket) {
            let end = (i + bucket).min(sample_count);
            let mut peak = 0.0f64;
            for j in i..end {
                let sample = (i16::from_le_bytes([pcm_data[j * 2], pcm_data[j * 2 + 1]]) as f64)
                    .abs()
                    / 32768.0;
                if sample > peak {
                    peak = sample;
                }
            }
            result.push(peak.clamp(0.0, 1.0));
        }
        result
    } else {
        let bucket = (pcm_data.len() / points).max(1);
        let mut result = Vec::with_capacity(points);
        for i in (0..pcm_data.len()).step_by(bucket) {
            let end = (i + bucket).min(pcm_data.len());
            let mut peak = 0.0f64;
            for j in i..end {
                let sample = (pcm_data[j] as i32 - 128).abs() as f64 / 128.0;
                if sample > peak {
                    peak = sample;
                }
            }
            result.push(peak.clamp(0.0, 1.0));
        }
        result
    }
}

fn estimate_duration_from_wav(wav: &[u8]) -> i32 {
    if wav.len() < 44 {
        return 0;
    }

    if &wav[0..4] != b"RIFF" || &wav[8..12] != b"WAVE" {
        return 0;
    }

    let mut sample_rate: Option<u32> = None;
    let mut channels: Option<u16> = None;
    let mut bits_per_sample: Option<u16> = None;
    let mut data_length: Option<usize> = None;
    let mut offset = 12;

    while offset + 8 <= wav.len() {
        let chunk_id = &wav[offset..offset + 4];
        let chunk_size = u32::from_le_bytes([
            wav[offset + 4],
            wav[offset + 5],
            wav[offset + 6],
            wav[offset + 7],
        ]) as usize;
        let chunk_data_start = offset + 8;

        if chunk_id == b"fmt " && chunk_size >= 16 {
            channels = Some(u16::from_le_bytes([
                wav[chunk_data_start + 2],
                wav[chunk_data_start + 3],
            ]));
            sample_rate = Some(u32::from_le_bytes([
                wav[chunk_data_start + 4],
                wav[chunk_data_start + 5],
                wav[chunk_data_start + 6],
                wav[chunk_data_start + 7],
            ]));
            bits_per_sample = Some(u16::from_le_bytes([
                wav[chunk_data_start + 14],
                wav[chunk_data_start + 15],
            ]));
        } else if chunk_id == b"data" {
            data_length = Some(chunk_size);
        }

        offset = chunk_data_start + chunk_size + (chunk_size % 2);
    }

    let sample_rate = match sample_rate {
        Some(s) => s,
        None => return 0,
    };
    let channels = match channels {
        Some(c) => c,
        None => return 0,
    };
    let bits = match bits_per_sample {
        Some(b) => b,
        None => return 0,
    };
    let data_length = match data_length {
        Some(l) => l,
        None => return 0,
    };

    if sample_rate == 0 || channels == 0 || bits == 0 {
        return 0;
    }

    let bytes_per_second = sample_rate as f64 * channels as f64 * (bits as f64 / 8.0);
    if bytes_per_second <= 0.0 {
        return 0;
    }

    ((data_length as f64 / bytes_per_second) * 1000.0) as i32
}

/// 关闭 P4K 读取器
pub async fn p4k_close() -> Result<()> {
    *GLOBAL_P4K_READER.lock().unwrap() = None;
    GLOBAL_P4K_FILES.lock().unwrap().clear();
    p4k_clear_model_dcb_cache();
    Ok(())
}

// ==================== DataForge/DCB API ====================

/// DCB 记录项信息
#[frb(dart_metadata=("freezed"))]
pub struct DcbRecordItem {
    /// 记录路径
    pub path: String,
    /// 记录索引
    pub index: usize,
}

/// 检查数据是否为 DataForge/DCB 格式
pub fn dcb_is_dataforge(data: Vec<u8>) -> bool {
    DataForge::is_dataforge(&data)
}

/// 从内存数据打开 DCB 文件
pub async fn dcb_open(data: Vec<u8>) -> Result<()> {
    let df = tokio::task::spawn_blocking(move || {
        DataForge::parse(&data).map_err(|e| anyhow!("Failed to parse DataForge: {}", e))
    })
    .await??;

    *GLOBAL_DCB_READER.lock().unwrap() = Some(df);
    Ok(())
}

/// 获取 DCB 记录数量
pub fn dcb_get_record_count() -> Result<usize> {
    let reader = GLOBAL_DCB_READER.lock().unwrap();
    let df = reader
        .as_ref()
        .ok_or_else(|| anyhow!("DCB reader not initialized"))?;
    Ok(df.record_count())
}

/// 获取所有 DCB 记录路径列表
pub async fn dcb_get_record_list() -> Result<Vec<DcbRecordItem>> {
    tokio::task::spawn_blocking(|| {
        let reader = GLOBAL_DCB_READER.lock().unwrap();
        let df = reader
            .as_ref()
            .ok_or_else(|| anyhow!("DCB reader not initialized"))?;

        let path_to_record = df.path_to_record();
        let mut result: Vec<DcbRecordItem> = path_to_record
            .iter()
            .map(|(path, &index)| DcbRecordItem {
                path: path.clone(),
                index,
            })
            .collect();

        // 按路径排序
        result.sort_by(|a, b| a.path.cmp(&b.path));
        Ok(result)
    })
    .await?
}

/// 根据路径获取单条记录的 XML
pub async fn dcb_record_to_xml(path: String) -> Result<String> {
    tokio::task::spawn_blocking(move || {
        let reader = GLOBAL_DCB_READER.lock().unwrap();
        let df = reader
            .as_ref()
            .ok_or_else(|| anyhow!("DCB reader not initialized"))?;

        df.record_to_xml(&path, true)
            .map_err(|e| anyhow!("Failed to convert record to XML: {}", e))
    })
    .await?
}

/// 根据索引获取单条记录的 XML
pub async fn dcb_record_to_xml_by_index(index: usize) -> Result<String> {
    tokio::task::spawn_blocking(move || {
        let reader = GLOBAL_DCB_READER.lock().unwrap();
        let df = reader
            .as_ref()
            .ok_or_else(|| anyhow!("DCB reader not initialized"))?;

        df.record_to_xml_by_index(index, true)
            .map_err(|e| anyhow!("Failed to convert record to XML: {}", e))
    })
    .await?
}

/// 全文搜索 DCB 记录
/// 返回匹配的记录路径和预览摘要
#[frb(dart_metadata=("freezed"))]
pub struct DcbSearchResult {
    /// 记录路径
    pub path: String,
    /// 记录索引
    pub index: usize,
    /// 匹配的行内容和行号列表
    pub matches: Vec<DcbSearchMatch>,
}

#[frb(dart_metadata=("freezed"))]
pub struct DcbSearchMatch {
    /// 行号（从1开始）
    pub line_number: usize,
    /// 匹配行的内容（带上下文）
    pub line_content: String,
}

/// 全文搜索 DCB 记录
pub async fn dcb_search_all(query: String) -> Result<Vec<DcbSearchResult>> {
    tokio::task::spawn_blocking(move || {
        let reader = GLOBAL_DCB_READER.lock().unwrap();
        let df = reader
            .as_ref()
            .ok_or_else(|| anyhow!("DCB reader not initialized"))?;

        let query_lower = query.to_lowercase();

        // 收集所有记录路径和索引
        let records: Vec<(String, usize)> = df
            .path_to_record()
            .iter()
            .map(|(path, &index)| (path.clone(), index))
            .collect();

        // 使用 rayon 并发搜索
        let mut results: Vec<DcbSearchResult> = records
            .par_iter()
            .filter_map(|(path, index)| {
                // 先检查路径是否匹配
                let path_matches = path.to_lowercase().contains(&query_lower);

                // 尝试获取 XML 并搜索内容
                if let Ok(xml) = df.record_to_xml_by_index(*index, true) {
                    let mut matches = Vec::new();

                    for (line_num, line) in xml.lines().enumerate() {
                        if line.to_lowercase().contains(&query_lower) {
                            let line_content = if line.len() > 200 {
                                format!("{}...", &line[..200])
                            } else {
                                line.to_string()
                            };
                            matches.push(DcbSearchMatch {
                                line_number: line_num + 1,
                                line_content,
                            });

                            // 每条记录最多保留 5 个匹配
                            if matches.len() >= 5 {
                                break;
                            }
                        }
                    }

                    if path_matches || !matches.is_empty() {
                        return Some(DcbSearchResult {
                            path: path.clone(),
                            index: *index,
                            matches,
                        });
                    }
                }
                None
            })
            .collect();

        // 按路径排序以保持结果稳定性
        results.sort_by(|a, b| a.path.cmp(&b.path));

        Ok(results)
    })
    .await?
}

/// 导出 DCB 到磁盘
/// merge: true = 合并为单个 XML，false = 分离为多个 XML 文件
pub async fn dcb_export_to_disk(output_path: String, dcb_path: String, merge: bool) -> Result<()> {
    let output = PathBuf::from(&output_path);
    let dcb = PathBuf::from(&dcb_path);

    tokio::task::spawn_blocking(move || {
        let reader = GLOBAL_DCB_READER.lock().unwrap();
        let df = reader
            .as_ref()
            .ok_or_else(|| anyhow!("DCB reader not initialized"))?;

        if merge {
            unp4k::dataforge::export_merged(&df, &dcb, Some(&output))?;
        } else {
            unp4k::dataforge::export_separate(&df, &dcb, Some(&output))?;
        }

        Ok(())
    })
    .await?
}

/// 关闭 DCB 读取器
pub async fn dcb_close() -> Result<()> {
    *GLOBAL_DCB_READER.lock().unwrap() = None;
    Ok(())
}
