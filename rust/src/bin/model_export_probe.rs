use std::env;
use std::path::PathBuf;

use anyhow::{anyhow, Result};
use image::{ImageBuffer, Rgba};
use rust::model_convert::{convert_from_p4k_to_bytes, ConvertOptions};
use rust::model_render;

#[tokio::main(flavor = "multi_thread")]
async fn main() -> Result<()> {
    let args = env::args().collect::<Vec<_>>();
    if args.len() < 4 {
        eprintln!(
            "Usage: model_export_probe <Data.p4k> <model.cga|model.cgf> <output_dir> [width] [height]\n       model_export_probe --glb <input.glb> <output_dir> [width] [height]"
        );
        std::process::exit(2);
    }

    if args[1] == "--glb" {
        return render_existing_glb(&args).await;
    }

    let p4k_path = &args[1];
    let model_path = &args[2];
    let output_dir = PathBuf::from(&args[3]);
    let width = args.get(4).and_then(|v| v.parse().ok()).unwrap_or(512);
    let height = args.get(5).and_then(|v| v.parse().ok()).unwrap_or(512);
    std::fs::create_dir_all(&output_dir)?;

    let result = convert_from_p4k_to_bytes(
        p4k_path,
        model_path,
        ConvertOptions {
            embed_textures: true,
            overwrite: true,
            max_texture_size: Some(2048),
        },
    )
    .await?;

    let stem = std::path::Path::new(model_path)
        .file_stem()
        .and_then(|stem| stem.to_str())
        .unwrap_or("model");
    let glb_path = output_dir.join(format!("{stem}.glb"));
    std::fs::write(&glb_path, &result.glb_bytes)?;

    let renders = [
        ("iso", format!("{stem}.png"), (0.25, 0.75, 0.0)),
        ("side", format!("{stem}_side.png"), (0.10, 0.0, 0.0)),
        ("top", format!("{stem}_top.png"), (1.20, 0.0, 0.0)),
    ];
    let mut render_outputs = Vec::with_capacity(renders.len());
    for (view_name, file_name, rotation) in renders {
        let png_path = output_dir.join(file_name);
        let non_background = render_view(&result.glb_bytes, width, height, rotation, &png_path)?;
        render_outputs.push((view_name, png_path, non_background));
    }

    println!("model_path={model_path}");
    println!("source_mode={}", result.source_mode);
    println!("glb={}", glb_path.display());
    println!("glb_bytes={}", result.glb_bytes.len());
    for (view_name, png_path, non_background) in render_outputs {
        println!("png[{view_name}]={}", png_path.display());
        println!("non_background_pixels[{view_name}]={non_background}");
    }
    for warning in result.warnings {
        println!("warning={warning}");
    }

    Ok(())
}

async fn render_existing_glb(args: &[String]) -> Result<()> {
    let glb_path = PathBuf::from(&args[2]);
    let output_dir = PathBuf::from(&args[3]);
    let width = args.get(4).and_then(|v| v.parse().ok()).unwrap_or(512);
    let height = args.get(5).and_then(|v| v.parse().ok()).unwrap_or(512);
    std::fs::create_dir_all(&output_dir)?;

    let glb_bytes = std::fs::read(&glb_path)?;
    let stem = glb_path
        .file_stem()
        .and_then(|stem| stem.to_str())
        .unwrap_or("model");
    let outputs = render_all_views(&glb_bytes, width, height, &output_dir, stem)?;

    println!("model_path={}", glb_path.display());
    println!("source_mode=glb_file");
    println!("glb={}", glb_path.display());
    println!("glb_bytes={}", glb_bytes.len());
    for (view_name, png_path, non_background) in outputs {
        println!("png[{view_name}]={}", png_path.display());
        println!("non_background_pixels[{view_name}]={non_background}");
    }

    Ok(())
}

fn render_view(
    glb_bytes: &[u8],
    width: u32,
    height: u32,
    rotation: (f32, f32, f32),
    png_path: &std::path::Path,
) -> Result<usize> {
    let rgba = model_render::render_glb_to_rgba(glb_bytes, width, height, rotation)?;
    let image = ImageBuffer::<Rgba<u8>, Vec<u8>>::from_raw(width, height, rgba)
        .ok_or_else(|| anyhow!("render output dimensions do not match RGBA buffer"))?;
    let non_background = count_non_background_pixels(image.as_raw());
    if non_background == 0 {
        return Err(anyhow!("rendered image is blank: {}", png_path.display()));
    }
    image.save(png_path)?;
    Ok(non_background)
}

fn render_all_views(
    glb_bytes: &[u8],
    width: u32,
    height: u32,
    output_dir: &std::path::Path,
    stem: &str,
) -> Result<Vec<(&'static str, PathBuf, usize)>> {
    let renders = [
        ("iso", format!("{stem}.png"), (0.25, 0.75, 0.0)),
        ("side", format!("{stem}_side.png"), (0.10, 0.0, 0.0)),
        ("top", format!("{stem}_top.png"), (1.20, 0.0, 0.0)),
    ];
    let mut render_outputs = Vec::with_capacity(renders.len());
    for (view_name, file_name, rotation) in renders {
        let png_path = output_dir.join(file_name);
        let non_background = render_view(glb_bytes, width, height, rotation, &png_path)?;
        render_outputs.push((view_name, png_path, non_background));
    }
    Ok(render_outputs)
}

fn count_non_background_pixels(rgba: &[u8]) -> usize {
    if rgba.len() < 4 {
        return 0;
    }
    let bg = &rgba[0..4];
    rgba.chunks_exact(4).filter(|pixel| *pixel != bg).count()
}
