use std::env;
use std::path::{Path, PathBuf};

use anyhow::{Result, anyhow};
use image::{ImageBuffer, Rgba};
use rust::model_render;

fn main() -> Result<()> {
    let args = env::args().collect::<Vec<_>>();
    if args.len() < 3 {
        eprintln!("Usage: render_glb_probe <input.glb> <output_dir> [width] [height]");
        std::process::exit(2);
    }
    let input = PathBuf::from(&args[1]);
    let output_dir = PathBuf::from(&args[2]);
    let width = args.get(3).and_then(|v| v.parse().ok()).unwrap_or(512);
    let height = args.get(4).and_then(|v| v.parse().ok()).unwrap_or(512);
    std::fs::create_dir_all(&output_dir)?;
    let glb = std::fs::read(&input)?;
    for (view_name, file_name, rotation) in [
        ("iso", "render.png", (0.25, 0.75, 0.0)),
        ("side", "render_side.png", (0.0, 1.5707964, 0.0)),
        ("top", "render_top.png", (-1.5707964, 0.0, 0.0)),
    ] {
        let path = output_dir.join(file_name);
        let count = render_view(&glb, width, height, rotation, &path)?;
        println!("png[{view_name}]={}", path.display());
        println!("non_background_pixels[{view_name}]={count}");
    }
    Ok(())
}

fn render_view(
    glb: &[u8],
    width: u32,
    height: u32,
    rotation: (f32, f32, f32),
    output: &Path,
) -> Result<usize> {
    let rgba = model_render::render_glb_to_rgba(glb, width, height, rotation)?;
    let image = ImageBuffer::<Rgba<u8>, Vec<u8>>::from_raw(width, height, rgba)
        .ok_or_else(|| anyhow!("render output dimensions do not match RGBA buffer"))?;
    let count = image
        .as_raw()
        .chunks_exact(4)
        .filter(|px| px[0] != 0x8B || px[1] != 0x98 || px[2] != 0x9E)
        .count();
    if count == 0 {
        return Err(anyhow!("rendered image is blank: {}", output.display()));
    }
    image.save(output)?;
    Ok(count)
}
