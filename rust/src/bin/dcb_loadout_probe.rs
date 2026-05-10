use std::collections::HashMap;
use std::env;
use std::path::PathBuf;

use anyhow::{anyhow, Result};
use regex::Regex;
use serde::Serialize;
use unp4k::{dataforge::DataForge, dataforge::DataForgeGuid, P4kFile};

#[derive(Debug, Serialize)]
struct LoadoutGeometryEntry {
    item_port_name: String,
    item_port_flags: Option<String>,
    attach_anchor: String,
    attach_path: Vec<String>,
    attach_translation: Option<[f32; 3]>,
    entity_class_name: Option<String>,
    entity_class_reference: Option<String>,
    record_index: Option<usize>,
    record_name: Option<String>,
    record_path: Option<String>,
    geometry_path: Option<String>,
    material_path: Option<String>,
    nested_loadout: Option<String>,
}

#[derive(Debug, Clone)]
struct AttachmentInfo {
    helper: Option<String>,
    translation: Option<[f32; 3]>,
    flags: Option<String>,
}

fn main() -> Result<()> {
    let args = env::args().collect::<Vec<_>>();
    if args.len() < 3 {
        eprintln!("Usage: dcb_loadout_probe <Data.p4k> <entity-name> [output.xml]");
        std::process::exit(2);
    }

    let p4k_path = &args[1];
    let entity_name = args[2].to_lowercase();
    let output_path = args.get(3).map(PathBuf::from);

    let mut p4k = P4kFile::open(p4k_path)?;
    let dcb_bytes = p4k
        .extract("Data\\Game2.dcb")
        .or_else(|_| p4k.extract("Data/Game2.dcb"))
        .or_else(|_| p4k.extract("Data\\Game.dcb"))
        .map_err(|e| anyhow!("failed to extract Game2.dcb/Game.dcb from P4K: {e}"))?;
    println!("dcb_bytes={}", dcb_bytes.len());

    let df = DataForge::parse(&dcb_bytes)?;
    println!("dcb_version={}", df.header.file_version);
    println!("records={}", df.record_count());

    let mut matches = df
        .path_to_record()
        .iter()
        .filter(|(path, _)| path.to_lowercase().contains(&entity_name))
        .collect::<Vec<_>>();
    matches.sort_by(|a, b| a.0.len().cmp(&b.0.len()).then_with(|| a.0.cmp(b.0)));

    println!("matches={}", matches.len());
    for (path, index) in matches.iter().take(40) {
        let record = &df.record_definitions()[**index];
        let struct_name = df
            .get_struct_name(record.struct_index as usize)
            .unwrap_or_else(|_| "<unknown>".to_string());
        println!("match index={} struct={} path={}", index, struct_name, path);
    }

    let exact_entity_leaf = format!("/{}.xml", args[2].to_lowercase());
    let (path, index) = matches
        .iter()
        .find(|(path, index)| {
            let record = &df.record_definitions()[**index];
            df.get_struct_name(record.struct_index as usize)
                .map(|name| name == "EntityClassDefinition")
                .unwrap_or(false)
                && path
                    .replace('\\', "/")
                    .to_lowercase()
                    .ends_with(&exact_entity_leaf)
        })
        .or_else(|| {
            matches.iter().find(|(_, index)| {
                let record = &df.record_definitions()[**index];
                df.get_struct_name(record.struct_index as usize)
                    .map(|name| name == "EntityClassDefinition")
                    .unwrap_or(false)
            })
        })
        .or_else(|| matches.first())
        .ok_or_else(|| anyhow!("no DataForge records match '{}'", args[2]))?;

    let xml = df.record_to_xml_by_index(**index, true)?;
    println!("selected_index={}", index);
    println!("selected_path={}", path);
    println!("selected_xml_bytes={}", xml.len());
    println!(
        "contains_loadout={}",
        xml.contains("SEntityComponentDefaultLoadoutParams")
    );
    println!(
        "contains_geometry={}",
        xml.contains("SGeometryResourceParams")
    );
    let attachment_infos = parse_attachment_implementations(&df, &xml)?;

    if let Some((loadout_struct, loadout_variant)) = find_default_loadout_pointer(&xml)? {
        let loadout_xml = df.struct_instance_to_xml(&loadout_struct, loadout_variant, true)?;
        let entry_count = loadout_xml.matches("<SItemPortLoadoutEntry").count();
        let entity_class_name_count = loadout_xml.matches("entityClassName=").count();
        let entity_class_reference_count = loadout_xml.matches("entityClassReference=").count();
        println!("loadout_struct={loadout_struct}");
        println!("loadout_variant={loadout_variant:04X}");
        println!("loadout_xml_bytes={}", loadout_xml.len());
        println!("loadout_entries={entry_count}");
        println!("loadout_entityClassName_attrs={entity_class_name_count}");
        println!("loadout_entityClassReference_attrs={entity_class_reference_count}");
        let geometry_entries = resolve_loadout_geometry(&df, &loadout_xml, &attachment_infos)?;
        let with_records = geometry_entries
            .iter()
            .filter(|entry| entry.record_index.is_some())
            .count();
        let with_geometry = geometry_entries
            .iter()
            .filter(|entry| entry.geometry_path.is_some())
            .count();
        println!("loadout_resolved_records={with_records}");
        println!("loadout_resolved_geometry={with_geometry}");

        if let Some(output_path) = output_path.as_ref() {
            let loadout_output = output_path.with_file_name(format!(
                "{}_loadout.xml",
                output_path
                    .file_stem()
                    .and_then(|name| name.to_str())
                    .unwrap_or("loadout")
            ));
            std::fs::write(&loadout_output, loadout_xml)?;
            println!("loadout_xml={}", loadout_output.display());

            let manifest_output = output_path.with_file_name(format!(
                "{}_loadout_geometry.json",
                output_path
                    .file_stem()
                    .and_then(|name| name.to_str())
                    .unwrap_or("loadout")
            ));
            std::fs::write(
                &manifest_output,
                serde_json::to_string_pretty(&geometry_entries)?,
            )?;
            println!("loadout_geometry_manifest={}", manifest_output.display());
        }
    }

    if let Some(output_path) = output_path {
        if let Some(parent) = output_path.parent() {
            std::fs::create_dir_all(parent)?;
        }
        std::fs::write(&output_path, xml)?;
        println!("xml={}", output_path.display());
    }

    Ok(())
}

fn parse_attachment_implementations(
    df: &DataForge,
    xml: &str,
) -> Result<HashMap<String, AttachmentInfo>> {
    let re = Regex::new(
        r#"<SItemPortDef\b[^>]*\bName="([^"]+)"[^>]*\bFlags="([^"]*)"[^>]*\bAttachmentImplementation="([^"]+)""#,
    )?;
    let helper_re = Regex::new(r#"<Helper\b[^>]*\bName="([^"]*)""#)?;
    let position_re = Regex::new(r#"<Position\b[^>]*\bx="([^"]+)"\s+y="([^"]+)"\s+z="([^"]+)""#)?;
    let mut infos = HashMap::new();
    for cap in re.captures_iter(xml) {
        let name = cap.get(1).map(|m| m.as_str()).unwrap_or_default();
        let flags = cap
            .get(2)
            .map(|m| m.as_str().to_string())
            .filter(|value| !value.is_empty());
        let pointer = cap.get(3).map(|m| m.as_str()).unwrap_or_default();
        let Some((struct_name, variant)) = parse_pointer_label(pointer) else {
            continue;
        };
        let impl_xml = df.struct_instance_to_xml(&struct_name, variant, false)?;
        let helper = helper_re
            .captures(&impl_xml)
            .and_then(|cap| cap.get(1))
            .map(|m| m.as_str().to_string())
            .filter(|value| !value.is_empty());
        let translation = position_re.captures(&impl_xml).and_then(|cap| {
            let x = cap.get(1)?.as_str().parse::<f32>().ok()?;
            let y = cap.get(2)?.as_str().parse::<f32>().ok()?;
            let z = cap.get(3)?.as_str().parse::<f32>().ok()?;
            if x == 0.0 && y == 0.0 && z == 0.0 {
                None
            } else {
                Some([-x, z, y])
            }
        });
        infos.insert(
            name.to_string(),
            AttachmentInfo {
                helper,
                translation,
                flags,
            },
        );
    }
    Ok(infos)
}

fn find_default_loadout_pointer(xml: &str) -> Result<Option<(String, u32)>> {
    let re = Regex::new(
        r#"SEntityComponentDefaultLoadoutParams\b[^>]*\bloadout="([^"]+)\[([0-9A-Fa-f]+)\]""#,
    )?;
    Ok(re.captures(xml).and_then(|cap| {
        let struct_name = cap.get(1)?.as_str().to_string();
        let variant = u32::from_str_radix(cap.get(2)?.as_str(), 16).ok()?;
        Some((struct_name, variant))
    }))
}

fn resolve_loadout_geometry(
    df: &DataForge,
    loadout_xml: &str,
    attachment_infos: &HashMap<String, AttachmentInfo>,
) -> Result<Vec<LoadoutGeometryEntry>> {
    resolve_loadout_geometry_inner(df, loadout_xml, attachment_infos, 0, None, &[])
}

fn resolve_loadout_geometry_inner(
    df: &DataForge,
    loadout_xml: &str,
    attachment_infos: &HashMap<String, AttachmentInfo>,
    depth: usize,
    fallback_anchor: Option<&str>,
    parent_path: &[String],
) -> Result<Vec<LoadoutGeometryEntry>> {
    let entry_re = Regex::new(r#"<SItemPortLoadoutEntryParams\b([^>]*)/?>"#)?;
    let attr_re = Regex::new(r#"([A-Za-z0-9_]+)="([^"]*)""#)?;
    let mut entries = Vec::new();
    if depth >= 4 {
        return Ok(entries);
    }

    for cap in entry_re.captures_iter(loadout_xml) {
        let attrs = cap.get(1).map(|m| m.as_str()).unwrap_or_default();
        let mut attr_map = std::collections::HashMap::new();
        for attr in attr_re.captures_iter(attrs) {
            attr_map.insert(
                attr.get(1).unwrap().as_str().to_string(),
                attr.get(2).unwrap().as_str().to_string(),
            );
        }

        let item_port_name = attr_map.get("itemPortName").cloned().unwrap_or_default();
        let attachment_info = (parent_path.is_empty())
            .then(|| attachment_infos.get(&item_port_name))
            .flatten();
        let helper_anchor = attachment_info
            .and_then(|info| info.helper.as_deref())
            .filter(|helper| !helper.is_empty());
        let attach_anchor = fallback_anchor
            .filter(|anchor| !anchor.is_empty())
            .or(helper_anchor)
            .unwrap_or(&item_port_name)
            .to_string();
        let mut attach_path = parent_path.to_vec();
        if attach_path.is_empty() {
            if let Some(helper) = helper_anchor.filter(|helper| *helper != item_port_name) {
                attach_path.push(helper.to_string());
            }
        }
        if !item_port_name.is_empty() {
            attach_path.push(item_port_name.clone());
        } else if !attach_anchor.is_empty() && attach_path.is_empty() {
            attach_path.push(attach_anchor.clone());
        }
        let attach_translation = attachment_info
            .filter(|_| helper_anchor.is_some_and(|helper| helper != item_port_name))
            .and_then(|info| info.translation);
        let class_name = attr_map
            .get("entityClassName")
            .filter(|value| !value.is_empty())
            .cloned();
        let class_ref = attr_map
            .get("entityClassReference")
            .filter(|value| !value.is_empty() && *value != "null")
            .cloned();
        let nested_loadout = attr_map
            .get("loadout")
            .filter(|value| !value.is_empty() && *value != "null")
            .cloned();

        let record_index = if let Some(class_name) = class_name.as_deref() {
            find_entity_record_by_class_name(df, class_name)?
        } else if let Some(class_ref) = class_ref.as_deref() {
            parse_guid(class_ref).and_then(|guid| df.record_index_by_guid(&guid))
        } else {
            None
        };

        let (record_name, record_path, geometry_path, material_path) =
            if let Some(record_index) = record_index {
                let record_name = df.get_record_name(record_index).ok();
                let record_path = df
                    .path_to_record()
                    .iter()
                    .find_map(|(path, index)| (*index == record_index).then(|| path.clone()));
                let record_xml = df.record_to_xml_by_index(record_index, false).ok();
                let geometry_path = record_xml.as_deref().and_then(extract_geometry_path);
                let material_path = record_xml.as_deref().and_then(extract_material_path);
                (record_name, record_path, geometry_path, material_path)
            } else {
                (None, None, None, None)
            };

        let has_geometry = geometry_path.is_some();
        entries.push(LoadoutGeometryEntry {
            item_port_name: item_port_name.clone(),
            item_port_flags: attachment_info.and_then(|info| info.flags.clone()),
            attach_anchor: attach_anchor.clone(),
            attach_path: attach_path.clone(),
            attach_translation,
            entity_class_name: class_name,
            entity_class_reference: class_ref,
            record_index,
            record_name,
            record_path,
            geometry_path,
            material_path,
            nested_loadout,
        });

        if let Some(nested_loadout) = attr_map
            .get("loadout")
            .filter(|value| !value.is_empty() && *value != "null")
        {
            if let Some((struct_name, variant)) = parse_pointer_label(nested_loadout) {
                let nested_xml = df.struct_instance_to_xml(&struct_name, variant, false)?;
                let nested_fallback = if has_geometry {
                    None
                } else {
                    Some(attach_anchor.as_str())
                };
                let nested_parent_path = if has_geometry {
                    attach_path.as_slice()
                } else {
                    parent_path
                };
                entries.extend(resolve_loadout_geometry_inner(
                    df,
                    &nested_xml,
                    attachment_infos,
                    depth + 1,
                    nested_fallback,
                    nested_parent_path,
                )?);
            }
        }
    }

    Ok(entries)
}

fn parse_pointer_label(value: &str) -> Option<(String, u32)> {
    let (struct_name, rest) = value.split_once('[')?;
    let variant = rest.strip_suffix(']')?;
    Some((
        struct_name.to_string(),
        u32::from_str_radix(variant, 16).ok()?,
    ))
}

fn find_entity_record_by_class_name(df: &DataForge, class_name: &str) -> Result<Option<usize>> {
    let wanted = class_name.to_ascii_lowercase();
    for (index, record) in df.record_definitions().iter().enumerate() {
        let struct_name = df
            .get_struct_name(record.struct_index as usize)
            .unwrap_or_default();
        if struct_name != "EntityClassDefinition" {
            continue;
        }
        let record_name = df.get_record_name(index).unwrap_or_default();
        let short_name = record_name
            .rsplit('.')
            .next()
            .unwrap_or(&record_name)
            .to_ascii_lowercase();
        if short_name == wanted || record_name.to_ascii_lowercase() == wanted {
            return Ok(Some(index));
        }
    }
    Ok(None)
}

fn extract_geometry_path(xml: &str) -> Option<String> {
    let re = Regex::new(r#"<Geometry\s+path="([^"]+\.(?:cga|cgf))""#).ok()?;
    re.captures(xml)
        .and_then(|cap| cap.get(1))
        .map(|m| m.as_str().replace('/', "\\"))
}

fn extract_material_path(xml: &str) -> Option<String> {
    let re = Regex::new(r#"<Material\s+path="([^"]+\.mtl)""#).ok()?;
    re.captures(xml)
        .and_then(|cap| cap.get(1))
        .map(|m| m.as_str().replace('/', "\\"))
}

fn parse_guid(value: &str) -> Option<DataForgeGuid> {
    let mut parts = value.split('-');
    let a = u32::from_str_radix(parts.next()?, 16).ok()?;
    let b = u16::from_str_radix(parts.next()?, 16).ok()?;
    let c = u16::from_str_radix(parts.next()?, 16).ok()?;
    let d = parts.next()?;
    let e = parts.next()?;
    if d.len() != 4 || e.len() != 12 {
        return None;
    }
    let mut bytes = [0u8; 16];
    bytes[0..4].copy_from_slice(&a.to_le_bytes());
    bytes[4..6].copy_from_slice(&b.to_le_bytes());
    bytes[6..8].copy_from_slice(&c.to_le_bytes());
    bytes[8] = u8::from_str_radix(&d[0..2], 16).ok()?;
    bytes[9] = u8::from_str_radix(&d[2..4], 16).ok()?;
    for i in 0..6 {
        bytes[10 + i] = u8::from_str_radix(&e[i * 2..i * 2 + 2], 16).ok()?;
    }
    Some(DataForgeGuid { bytes })
}
