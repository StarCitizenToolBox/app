use std::env;
use std::path::{Path, PathBuf};

use anyhow::{anyhow, Result};
use image::{ImageBuffer, Rgba};
use rust::model_render;
use serde::Deserialize;
use starbreaker_p4k::MappedP4k;

#[derive(Debug, Deserialize)]
struct LoadoutGeometryEntry {
    item_port_name: String,
    geometry_path: Option<String>,
    children: Option<Vec<LoadoutGeometryEntry>>,
}

fn main() -> Result<()> {
    let args = env::args().collect::<Vec<_>>();
    if args.len() < 5 {
        eprintln!(
            "Usage: loadout_export_probe <Data.p4k> <root.cga|root.cgf> <loadout_geometry.json> <output_dir> [width] [height]"
        );
        std::process::exit(2);
    }

    let p4k_path = &args[1];
    let root_model = &args[2];
    let manifest_path = PathBuf::from(&args[3]);
    let output_dir = PathBuf::from(&args[4]);
    let width = args.get(5).and_then(|v| v.parse().ok()).unwrap_or(512);
    let height = args.get(6).and_then(|v| v.parse().ok()).unwrap_or(512);
    let parts_dir = output_dir.join("_loadout_parts");
    std::fs::create_dir_all(&parts_dir)?;

    let manifest = std::fs::read_to_string(&manifest_path)?;
    let root_entry: LoadoutGeometryEntry = serde_json::from_str(&manifest)?;
    let p4k = MappedP4k::open(p4k_path)?;
    let opts = starbreaker_options();

    let root_glb_bytes = starbreaker_3d::api::export_geometry_glb(
        &p4k,
        &normalize_p4k_model_path(root_model),
        None,
        &opts,
    )
    .map_err(|e| anyhow!(e.to_string()))?;
    let root_glb = parts_dir.join("000_root.glb");
    std::fs::write(&root_glb, &root_glb_bytes)?;

    let mut converted = 1usize;
    let mut skipped = 0usize;
    let mut failed = 0usize;
    export_children(&p4k, &opts, &root_entry, &parts_dir, &mut converted, &mut skipped, &mut failed);

    println!("root_model={root_model}");
    println!("manifest={}", manifest_path.display());
    println!("converted={converted}");
    println!("skipped={skipped}");
    println!("failed={failed}");
    println!("root_glb={}", root_glb.display());
    println!("root_glb_bytes={}", root_glb_bytes.len());

    match render_all_views(&root_glb_bytes, width, height, &output_dir, "loadout_root") {
        Ok(renders) => {
            for (view_name, png_path, non_background) in renders {
                println!("png[{view_name}]={}", png_path.display());
                println!("non_background_pixels[{view_name}]={non_background}");
            }
        }
        Err(err) => println!("render_error={err}"),
    }

    Ok(())
}

fn export_children(
    p4k: &MappedP4k,
    opts: &starbreaker_3d::ExportOptions,
    entry: &LoadoutGeometryEntry,
    parts_dir: &Path,
    converted: &mut usize,
    skipped: &mut usize,
    failed: &mut usize,
) {
    if let Some(children) = entry.children.as_deref() {
        for child in children {
            if let Some(geometry_path) = child.geometry_path.as_deref() {
                let part_name = format!(
                    "{:03}_{}.glb",
                    *converted,
                    sanitize_file_component(&child.item_port_name)
                );
                match starbreaker_3d::api::export_geometry_glb(
                    p4k,
                    &normalize_p4k_model_path(geometry_path),
                    None,
                    opts,
                ) {
                    Ok(bytes) => {
                        if std::fs::write(parts_dir.join(part_name), bytes).is_ok() {
                            *converted += 1;
                        } else {
                            *failed += 1;
                        }
                    }
                    Err(err) => {
                        *failed += 1;
                        println!("part_failed port={} model={} error={err}", child.item_port_name, geometry_path);
                    }
                }
            } else {
                *skipped += 1;
            }
            export_children(p4k, opts, child, parts_dir, converted, skipped, failed);
        }
    }
}

fn starbreaker_options() -> starbreaker_3d::ExportOptions {
    starbreaker_3d::ExportOptions {
        kind: starbreaker_3d::ExportKind::Bundled,
        format: starbreaker_3d::ExportFormat::Glb,
        material_mode: starbreaker_3d::MaterialMode::Textures,
        include_attachments: false,
        include_interior: false,
        include_lights: false,
        include_nodraw: false,
        include_shields: false,
        lod_level: 0,
        texture_mip: 2,
        threads: 0,
        include_animations: false,
        apply_default_animation_pose: true,
        default_animation_tags: vec!["landing_gear_extend".to_string()],
        decomposed_package_subdir: None,
    }
}

fn normalize_p4k_model_path(path: &str) -> String {
    path.trim_start_matches(['\\', '/']).replace('/', "\\")
}

fn sanitize_file_component(value: &str) -> String {
    value
        .chars()
        .map(|ch| if ch.is_ascii_alphanumeric() || ch == '_' || ch == '-' { ch } else { '_' })
        .collect()
}

fn render_view(
    glb_bytes: &[u8],
    width: u32,
    height: u32,
    rotation: (f32, f32, f32),
    png_path: &Path,
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
    output_dir: &Path,
    stem: &str,
) -> Result<Vec<(&'static str, PathBuf, usize)>> {
    let renders = [
        ("iso", format!("{stem}.png"), (0.25, 0.75, 0.0)),
        ("side", format!("{stem}_side.png"), (0.10, 0.0, 0.0)),
        ("top", format!("{stem}_top.png"), (1.20, 0.0, 0.0)),
    ];
    let mut outputs = Vec::with_capacity(renders.len());
    for (view_name, file_name, rotation) in renders {
        let png_path = output_dir.join(file_name);
        let non_background = render_view(glb_bytes, width, height, rotation, &png_path)?;
        outputs.push((view_name, png_path, non_background));
    }
    Ok(outputs)
}

fn count_non_background_pixels(rgba: &[u8]) -> usize {
    if rgba.len() < 4 {
        return 0;
    }
    let bg = &rgba[0..4];
    rgba.chunks_exact(4).filter(|pixel| *pixel != bg).count()
}
