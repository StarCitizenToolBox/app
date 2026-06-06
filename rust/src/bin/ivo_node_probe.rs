use std::env;

use anyhow::{anyhow, Result};
use starbreaker_p4k::MappedP4k;

fn main() -> Result<()> {
    let args = env::args().collect::<Vec<_>>();
    if args.len() < 3 {
        eprintln!("Usage: ivo_node_probe <Data.p4k> <model.cga|model.cgf|model.skin>");
        std::process::exit(2);
    }

    let p4k_path = &args[1];
    let model_path = normalize_p4k_model_path(&args[2]);
    let p4k = MappedP4k::open(p4k_path)?;
    let data = p4k.read_file(&model_path)?;

    println!("model={model_path}");
    println!("bytes={}", data.len());
    let (nodes, material_indices) = starbreaker_3d::nmc::parse_nmc_full(&data)
        .ok_or_else(|| anyhow!("missing or unsupported NMC_Full chunk"))?;
    println!("nodes={}", nodes.len());
    println!("material_indices={:?}", material_indices);
    for (index, node) in nodes.iter().enumerate() {
        println!(
            "node[{index}] parent={:?} geometry_type={} name={:?}",
            node.parent_index, node.geometry_type, node.name
        );
    }

    Ok(())
}

fn normalize_p4k_model_path(path: &str) -> String {
    let normalized = path.trim_start_matches(['\\', '/']).replace('/', "\\");
    if normalized.to_ascii_lowercase().starts_with("data\\") {
        normalized
    } else {
        format!("Data\\{normalized}")
    }
}
