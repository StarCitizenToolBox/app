use std::path::Path;

use anyhow::{Result, anyhow};
use image::{DynamicImage, ImageFormat};

use super::DecodedTexture;

pub fn decode_texture(
    path: &str,
    data: &[u8],
    max_texture_size: Option<u32>,
) -> Result<DecodedTexture> {
    let ext = Path::new(path)
        .extension()
        .and_then(|s| s.to_str())
        .unwrap_or_default()
        .to_lowercase();

    let img = match ext.as_str() {
        "dds" => image::load_from_memory_with_format(data, ImageFormat::Dds),
        "png" => image::load_from_memory_with_format(data, ImageFormat::Png),
        "jpg" | "jpeg" => image::load_from_memory_with_format(data, ImageFormat::Jpeg),
        "tga" => image::load_from_memory_with_format(data, ImageFormat::Tga),
        "tif" | "tiff" => image::load_from_memory_with_format(data, ImageFormat::Tiff),
        _ => image::load_from_memory(data),
    }
    .map_err(|e| anyhow!("{e}"))?;

    decoded_texture_from_image(path, img, max_texture_size)
}

pub(crate) fn decoded_texture_from_image(
    path: &str,
    img: DynamicImage,
    max_texture_size: Option<u32>,
) -> Result<DecodedTexture> {
    let img = maybe_resize(img, max_texture_size)?;
    let rgba = img.to_rgba8();
    let (width, height) = rgba.dimensions();
    Ok(DecodedTexture {
        name: Path::new(path)
            .file_name()
            .and_then(|s| s.to_str())
            .unwrap_or("texture")
            .to_string(),
        uri: path.replace('/', "\\"),
        label: None,
        width,
        height,
        rgba8: rgba.into_raw(),
    })
}

fn maybe_resize(img: DynamicImage, max_texture_size: Option<u32>) -> Result<DynamicImage> {
    if let Some(max) = max_texture_size {
        let w = img.width();
        let h = img.height();
        if w > 8192 || h > 8192 {
            return Err(anyhow!("texture too large: {w}x{h}"));
        }
        if w > max || h > max {
            return Ok(img.resize(max, max, image::imageops::FilterType::Triangle));
        }
    }
    Ok(img)
}

#[cfg(test)]
mod tests {
    use image::codecs::png::PngEncoder;
    use image::{ColorType, ImageBuffer, ImageEncoder, Rgba};

    use super::decode_texture;

    fn encode_png(width: u32, height: u32, fill: [u8; 4]) -> Vec<u8> {
        let image = ImageBuffer::from_pixel(width, height, Rgba(fill));
        let mut out = Vec::new();
        let encoder = PngEncoder::new(&mut out);
        encoder
            .write_image(image.as_raw(), width, height, ColorType::Rgba8.into())
            .expect("encode png");
        out
    }

    #[test]
    fn decode_texture_parses_png_and_preserves_filename() {
        let png = encode_png(2, 2, [255, 0, 0, 255]);
        let tex = decode_texture("textures/ship_diff.png", &png, None).expect("decode png");
        assert_eq!(tex.name, "ship_diff.png");
        assert_eq!(tex.uri, "textures\\ship_diff.png");
        assert_eq!((tex.width, tex.height), (2, 2));
        assert_eq!(tex.rgba8.len(), 2 * 2 * 4);
    }

    #[test]
    fn decode_texture_resizes_when_over_max_texture_size() {
        let png = encode_png(8, 4, [0, 255, 0, 255]);
        let tex = decode_texture("textures/ship_diff.png", &png, Some(4)).expect("decode png");
        assert_eq!((tex.width, tex.height), (4, 2));
    }

    #[test]
    fn decode_texture_rejects_too_large_texture_when_limit_enabled() {
        let png = encode_png(9000, 1, [0, 0, 255, 255]);
        let err = decode_texture("textures/huge.png", &png, Some(4096))
            .expect_err("expected texture-too-large error");
        assert!(err.to_string().contains("texture too large: 9000x1"));
    }
}
