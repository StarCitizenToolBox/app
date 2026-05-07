use std::env;
use std::path::{Path, PathBuf};

use anyhow::{Result, anyhow};
use image::{ImageBuffer, Rgba};
use rust::model_convert::glb_merge::{MergeInput, merge_glbs_with_attachments};
use rust::model_convert::{ConvertOptions, convert_from_p4k_to_bytes};
use rust::model_render;
use serde::Deserialize;

#[derive(Debug, Deserialize)]
struct LoadoutGeometryEntry {
    item_port_name: String,
    item_port_flags: Option<String>,
    attach_anchor: Option<String>,
    attach_path: Option<Vec<String>>,
    attach_translation: Option<[f32; 3]>,
    geometry_path: Option<String>,
}

#[tokio::main(flavor = "multi_thread")]
async fn main() -> Result<()> {
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
    let entries: Vec<LoadoutGeometryEntry> = serde_json::from_str(&manifest)?;

    let options = ConvertOptions {
        embed_textures: true,
        overwrite: true,
        max_texture_size: Some(1024),
    };

    let mut inputs = Vec::<MergeInput>::new();
    let mut anchors = vec!["root".to_string()];
    let mut converted = 0usize;
    let mut skipped = 0usize;
    let mut failed = 0usize;

    let root_bytes = convert_from_p4k_to_bytes(p4k_path, root_model, options.clone()).await?;
    let root_glb = parts_dir.join("000_root.glb");
    std::fs::write(&root_glb, root_bytes.glb_bytes)?;
    inputs.push(MergeInput {
        path: root_glb,
        anchor: None,
        anchor_path: None,
        anchor_translation: None,
    });
    converted += 1;

    for (index, entry) in entries.iter().enumerate() {
        let Some(geometry_path) = entry.geometry_path.as_deref() else {
            skipped += 1;
            continue;
        };
        if entry
            .item_port_flags
            .as_deref()
            .is_some_and(has_invisible_flag)
        {
            skipped += 1;
            continue;
        }
        if !is_exterior_preview_entry(entry) {
            println!(
                "part_skipped_internal index={} port={} model={}",
                index, entry.item_port_name, geometry_path
            );
            skipped += 1;
            continue;
        }
        let anchor = entry
            .attach_anchor
            .as_deref()
            .filter(|value| !value.is_empty())
            .unwrap_or(&entry.item_port_name);
        if anchor.is_empty() {
            skipped += 1;
            continue;
        }
        let model_path = normalize_p4k_model_path(geometry_path);
        match convert_from_p4k_to_bytes(p4k_path, &model_path, options.clone()).await {
            Ok(result) => {
                let part_path = parts_dir.join(format!(
                    "{:03}_{}_{}.glb",
                    index + 1,
                    sanitize_file_component(anchor),
                    sanitize_file_component(
                        Path::new(geometry_path)
                            .file_stem()
                            .and_then(|stem| stem.to_str())
                            .unwrap_or("part")
                    )
                ));
                std::fs::write(&part_path, result.glb_bytes)?;
                anchors.push(anchor.to_string());
                inputs.push(MergeInput {
                    path: part_path,
                    anchor: Some(anchor.to_string()),
                    anchor_path: entry.attach_path.clone(),
                    anchor_translation: entry.attach_translation,
                });
                converted += 1;
            }
            Err(err) => {
                failed += 1;
                println!(
                    "part_failed index={} anchor={} model={} error={}",
                    index, entry.item_port_name, model_path, err
                );
            }
        }
    }

    let merged_glb = output_dir.join("BANU_Defender_loadout.glb");
    let stats = merge_glbs_with_attachments(&inputs, &anchors, &merged_glb)?;
    let glb_bytes = std::fs::read(&merged_glb)?;

    println!("root_model={root_model}");
    println!("manifest={}", manifest_path.display());
    println!("converted={converted}");
    println!("skipped={skipped}");
    println!("failed={failed}");
    println!("merged_glb={}", merged_glb.display());
    println!("merged_glb_bytes={}", glb_bytes.len());
    println!("merged_nodes={}", stats.nodes);
    println!("merged_meshes={}", stats.meshes);
    println!("merged_materials={}", stats.materials);
    match render_all_views(
        &glb_bytes,
        width,
        height,
        &output_dir,
        "BANU_Defender_loadout",
    ) {
        Ok(renders) => {
            for (view_name, png_path, non_background) in renders {
                println!("png[{view_name}]={}", png_path.display());
                println!("non_background_pixels[{view_name}]={non_background}");
            }
        }
        Err(err) => {
            println!("render_error={err}");
        }
    }

    Ok(())
}

fn normalize_p4k_model_path(path: &str) -> String {
    let normalized = path.replace('/', "\\");
    if normalized.to_ascii_lowercase().starts_with("data\\") {
        normalized
    } else {
        format!("Data\\{normalized}")
    }
}

fn sanitize_file_component(value: &str) -> String {
    value
        .chars()
        .map(|ch| {
            if ch.is_ascii_alphanumeric() || ch == '_' || ch == '-' {
                ch
            } else {
                '_'
            }
        })
        .collect()
}

fn has_invisible_flag(flags: &str) -> bool {
    flags
        .split_whitespace()
        .any(|flag| flag.eq_ignore_ascii_case("invisible"))
}

fn is_exterior_preview_entry(entry: &LoadoutGeometryEntry) -> bool {
    let port = entry.item_port_name.to_ascii_lowercase();
    let model = entry
        .geometry_path
        .as_deref()
        .unwrap_or_default()
        .to_ascii_lowercase();
    port.contains("weapon")
        || port.contains("gun")
        || port.contains("thruster")
        || port.contains("missile")
        || port.contains("mount")
        || port.contains("countermeasure")
        || model.contains("\\weapons\\")
        || model.contains("/weapons/")
        || model.contains("\\weapon_mounts\\")
        || model.contains("/weapon_mounts/")
        || model.contains("\\ammo\\missiles\\")
        || model.contains("/ammo/missiles/")
        || model.contains("\\missile_racks\\")
        || model.contains("/missile_racks/")
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
