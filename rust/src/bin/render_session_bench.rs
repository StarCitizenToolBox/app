use std::env;
use std::path::PathBuf;
use std::time::Instant;

use anyhow::{Result, anyhow};
use rust::model_render;

fn main() -> Result<()> {
    let args = env::args().collect::<Vec<_>>();
    if args.len() < 3 {
        eprintln!("Usage: render_session_bench <input.glb> <frames> [width] [height]");
        std::process::exit(2);
    }
    let input = PathBuf::from(&args[1]);
    let frames = args[2].parse::<usize>()?.max(1);
    let width = args.get(3).and_then(|v| v.parse().ok()).unwrap_or(768);
    let height = args.get(4).and_then(|v| v.parse().ok()).unwrap_or(768);

    let glb = std::fs::read(&input)?;
    let create_started = Instant::now();
    let (session_id, model_radius) = model_render::create_session(&glb, width, height, None)?;
    let create_elapsed = create_started.elapsed();
    let distance = model_radius * 3.0;

    let render_started = Instant::now();
    for frame in 0..frames {
        let yaw = frame as f32 * 0.04;
        let camera = [
            distance * yaw.cos(),
            model_radius * 0.4,
            distance * yaw.sin(),
        ];
        let (rgba, _, _) = model_render::render_session(&session_id, camera, [0.0, 0.0, 0.0])?;
        if rgba.is_empty() {
            return Err(anyhow!("empty frame"));
        }
    }
    let render_elapsed = render_started.elapsed();
    model_render::release_session(&session_id);

    let frame_ms = render_elapsed.as_secs_f64() * 1000.0 / frames as f64;
    println!(
        "session_create_ms={:.3}",
        create_elapsed.as_secs_f64() * 1000.0
    );
    println!("frames={frames}");
    println!(
        "render_total_ms={:.3}",
        render_elapsed.as_secs_f64() * 1000.0
    );
    println!("render_frame_ms={frame_ms:.3}");
    println!("render_fps={:.3}", 1000.0 / frame_ms);
    Ok(())
}
