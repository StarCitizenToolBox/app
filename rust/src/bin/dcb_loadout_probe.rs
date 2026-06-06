use std::env;
use std::path::PathBuf;

use anyhow::{anyhow, Result};
use serde::Serialize;
use starbreaker_datacore::loadout::{resolve_loadout_indexed, EntityIndex, LoadoutNode};
use starbreaker_datacore::OwnedDatabase;
use starbreaker_p4k::MappedP4k;

#[derive(Debug, Serialize)]
struct LoadoutGeometryEntry {
    item_port_name: String,
    entity_class_name: String,
    geometry_path: Option<String>,
    material_path: Option<String>,
    helper_bone_name: Option<String>,
    no_rotation: bool,
    offset_position: [f32; 3],
    offset_rotation: [f32; 3],
    detach_direction: [f32; 3],
    port_flags: String,
    children: Vec<LoadoutGeometryEntry>,
}

fn main() -> Result<()> {
    let args = env::args().collect::<Vec<_>>();
    if args.len() < 3 {
        eprintln!("Usage: dcb_loadout_probe <Data.p4k> <entity-name> [output.json]");
        std::process::exit(2);
    }

    let p4k_path = &args[1];
    let entity_name = &args[2];
    let output_path = args.get(3).map(PathBuf::from);

    let p4k = MappedP4k::open(p4k_path)?;
    let dcb_bytes = starbreaker_3d::api::read_datacore_from_p4k(&p4k)
        .map_err(|e| anyhow!("failed to extract Game2.dcb/Game.dcb from P4K: {e}"))?;
    println!("dcb_bytes={}", dcb_bytes.len());

    let owned = OwnedDatabase::from_vec(dcb_bytes)?;
    let db = owned.as_database()?;
    println!("records={}", db.records().len());

    let index = EntityIndex::new(&db);
    let record = index
        .find_record(entity_name)
        .or_else(|| starbreaker_3d::api::find_entity_record(&db, entity_name))
        .ok_or_else(|| anyhow!("no EntityClassDefinition record matches '{entity_name}'"))?;
    let record_name = db.resolve_string2(record.name_offset);
    println!("selected_record={record_name}");

    let tree = resolve_loadout_indexed(&index, record);
    let manifest = loadout_entry(&tree.root);
    println!("root_children={}", manifest.children.len());

    if let Some(output_path) = output_path {
        if let Some(parent) = output_path.parent() {
            std::fs::create_dir_all(parent)?;
        }
        std::fs::write(&output_path, serde_json::to_string_pretty(&manifest)?)?;
        println!("loadout_geometry_manifest={}", output_path.display());
    }

    Ok(())
}

fn loadout_entry(node: &LoadoutNode) -> LoadoutGeometryEntry {
    LoadoutGeometryEntry {
        item_port_name: node.item_port_name.clone(),
        entity_class_name: node.entity_name.clone(),
        geometry_path: node.geometry_path.clone(),
        material_path: node.material_path.clone(),
        helper_bone_name: node.helper_bone_name.clone(),
        no_rotation: node.no_rotation,
        offset_position: node.offset_position,
        offset_rotation: node.offset_rotation,
        detach_direction: node.detach_direction,
        port_flags: node.port_flags.clone(),
        children: node.children.iter().map(loadout_entry).collect(),
    }
}
