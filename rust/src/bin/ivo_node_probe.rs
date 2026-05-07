use std::env;

use anyhow::{anyhow, Result};
use rust::model_convert::cryengine::{
    chunks::node_mesh_combo::parse_node_mesh_combo_chunk, ChunkType, ModelFile,
};
use unp4k::P4kFile;

fn main() -> Result<()> {
    let args = env::args().collect::<Vec<_>>();
    if args.len() < 3 {
        eprintln!("Usage: ivo_node_probe <Data.p4k> <model.cga|model.cgf>");
        std::process::exit(2);
    }

    let p4k_path = &args[1];
    let model_path = normalize_p4k_model_path(&args[2]);
    let mut p4k = P4kFile::open(p4k_path)?;
    let data = p4k.extract(&model_path)?;
    let model = ModelFile::parse(&data)?;
    println!("model={model_path}");
    println!(
        "signature={:?} version={} chunks={}",
        model.header.signature,
        model.header.version,
        model.chunks.len()
    );

    for (index, chunk) in model.chunks.iter().enumerate() {
        println!(
            "chunk[{index}] type={:?} raw=0x{:08X} version={} offset=0x{:X} size={:?}",
            chunk.chunk_type, chunk.chunk_type_raw, chunk.version, chunk.offset, chunk.size
        );
    }

    let combo = model
        .chunks
        .iter()
        .copied()
        .find(|chunk| chunk.chunk_type == ChunkType::NodeMeshCombo)
        .ok_or_else(|| anyhow!("missing NodeMeshCombo chunk"))?;
    let combo_index = model
        .chunks
        .iter()
        .position(|chunk| {
            chunk.offset == combo.offset && chunk.chunk_type_raw == combo.chunk_type_raw
        })
        .ok_or_else(|| anyhow!("missing NodeMeshCombo chunk index"))?;
    let (combo_start, combo_end) = model.chunk_data_bounds(&data, combo_index)?;
    let combo_bytes = &data[combo_start..combo_end];
    println!(
        "combo_bounds=0x{combo_start:X}..0x{combo_end:X} len={}",
        combo_bytes.len()
    );
    print_ascii_runs(combo_bytes);
    print_node_u16_candidates(combo_bytes);
    let parsed = parse_node_mesh_combo_chunk(&data, combo)?;
    println!(
        "combo nodes={} meshes={} unknown2={} subsets={} string_table_size={} unknown1={} unknown3={}",
        parsed.number_of_nodes,
        parsed.number_of_meshes,
        parsed.unknown2,
        parsed.number_of_mesh_subsets,
        parsed.string_table_size,
        parsed.unknown1,
        parsed.unknown3
    );
    for (index, node) in parsed.nodes.iter().enumerate() {
        println!(
            "node[{index}] parent={:?} mesh_chunk_id={} geometry_type={} name={:?}",
            node.parent_index,
            node.mesh_chunk_id,
            node.geometry_type,
            parsed
                .node_names
                .get(index)
                .map(String::as_str)
                .unwrap_or("")
        );
    }
    println!("unknown_indices={:?}", parsed.unknown_indices);
    println!("material_indices={:?}", parsed.material_indices);

    Ok(())
}

fn print_ascii_runs(bytes: &[u8]) {
    let mut i = 0usize;
    while i < bytes.len() {
        while i < bytes.len() && !is_ascii_name_byte(bytes[i]) {
            i += 1;
        }
        let start = i;
        while i < bytes.len() && is_ascii_name_byte(bytes[i]) {
            i += 1;
        }
        if i.saturating_sub(start) >= 4 {
            println!(
                "ascii_run offset=0x{start:X} len={} text={:?}",
                i - start,
                String::from_utf8_lossy(&bytes[start..i])
            );
        }
    }
}

fn print_node_u16_candidates(bytes: &[u8]) {
    let node_count = read_i32(bytes, 4).unwrap_or(0).max(0) as usize;
    if node_count == 0 {
        return;
    }
    let node_base = 32usize;
    let node_size = 216usize;
    for node_index in 0..node_count.min(8) {
        let start = node_base + node_index * node_size;
        let end = start + node_size;
        if end > bytes.len() {
            break;
        }
        let mut fields = Vec::new();
        for offset in (96..node_size).step_by(2) {
            let absolute = start + offset;
            let value = u16::from_le_bytes([bytes[absolute], bytes[absolute + 1]]);
            if value <= 32 || value == u16::MAX {
                fields.push(format!("{offset}:{value}"));
            }
        }
        println!("node_u16_candidates[{node_index}] {}", fields.join(" "));
        let selected = (136..=160)
            .step_by(2)
            .map(|offset| {
                let absolute = start + offset;
                let value = u16::from_le_bytes([bytes[absolute], bytes[absolute + 1]]);
                format!("{offset}:{value}")
            })
            .collect::<Vec<_>>();
        println!("node_u16_selected[{node_index}] {}", selected.join(" "));
    }
}

fn read_i32(bytes: &[u8], offset: usize) -> Option<i32> {
    Some(i32::from_le_bytes(
        bytes.get(offset..offset + 4)?.try_into().ok()?,
    ))
}

fn is_ascii_name_byte(byte: u8) -> bool {
    byte.is_ascii_alphanumeric() || matches!(byte, b'_' | b'-' | b'.' | b'/' | b'\\')
}

fn normalize_p4k_model_path(path: &str) -> String {
    let normalized = path.replace('/', "\\");
    if normalized.to_ascii_lowercase().starts_with("data\\") {
        normalized
    } else {
        format!("Data\\{normalized}")
    }
}
