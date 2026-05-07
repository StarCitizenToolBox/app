use anyhow::{anyhow, Result};
use serde::Serialize;
use serde_json::{json, Value};
use std::collections::HashMap;
use std::fs;
use std::path::{Path, PathBuf};

const GLB_MAGIC: &[u8; 4] = b"glTF";
const CHUNK_JSON: u32 = 0x4E4F534A;
const CHUNK_BIN: u32 = 0x004E4942;

#[derive(Debug, Clone, Serialize, Default)]
pub struct GlbStats {
    pub path: String,
    pub nodes: usize,
    pub meshes: usize,
    pub materials: usize,
    pub accessors: usize,
    pub buffer_views: usize,
    pub binary_bytes: usize,
}

#[derive(Debug, Clone)]
pub struct MergeInput {
    pub path: PathBuf,
    pub anchor: Option<String>,
    pub anchor_path: Option<Vec<String>>,
    pub anchor_translation: Option<[f32; 3]>,
}

struct GlbData {
    json: Value,
    bin: Vec<u8>,
}

fn align4(n: usize) -> usize {
    (n + 3) & !3
}

fn get_array_mut<'a>(doc: &'a mut Value, key: &str) -> Result<&'a mut Vec<Value>> {
    if doc.get(key).is_none() {
        doc[key] = Value::Array(Vec::new());
    }
    doc.get_mut(key)
        .and_then(|v| v.as_array_mut())
        .ok_or_else(|| anyhow!("invalid glb json: '{key}' is not array"))
}

fn get_array_len(doc: &Value, key: &str) -> usize {
    doc.get(key)
        .and_then(|v| v.as_array())
        .map_or(0, |a| a.len())
}

fn find_node_by_name(doc: &Value, name: &str) -> Option<usize> {
    doc.get("nodes")?
        .as_array()?
        .iter()
        .position(|node| node.get("name").and_then(|v| v.as_str()) == Some(name))
}

fn find_node_by_path(doc: &Value, path: &[String]) -> Option<usize> {
    let first = path.first()?.as_str();
    let nodes = doc.get("nodes")?.as_array()?;
    nodes
        .iter()
        .enumerate()
        .filter(|(_, node)| node.get("name").and_then(|v| v.as_str()) == Some(first))
        .find_map(|(idx, _)| find_descendant_path(doc, idx, &path[1..]))
}

fn find_node_by_path_with_synthetic_root(doc: &Value, path: &[String]) -> Option<usize> {
    find_node_by_path(doc, path).or_else(|| {
        let first = path.first()?;
        let synthetic = format!("anchor::{first}");
        let synthetic_idx = find_node_by_name(doc, &synthetic)?;
        find_descendant_path(doc, synthetic_idx, &path[1..])
    })
}

fn ensure_descendant_node_path(
    doc: &mut Value,
    path: &[String],
    final_translation: Option<[f32; 3]>,
) -> Result<Option<usize>> {
    let Some(first) = path.first() else {
        return Ok(None);
    };
    let Some(mut current_idx) = find_node_by_name(doc, first) else {
        return Ok(None);
    };

    for (segment_idx, segment) in path.iter().enumerate().skip(1) {
        let existing_child = doc["nodes"][current_idx]
            .get("children")
            .and_then(|v| v.as_array())
            .and_then(|children| {
                children.iter().find_map(|child| {
                    let child_idx = child.as_u64()? as usize;
                    (doc["nodes"][child_idx]["name"].as_str() == Some(segment.as_str()))
                        .then_some(child_idx)
                })
            });
        if let Some(child_idx) = existing_child {
            current_idx = child_idx;
            continue;
        }

        let new_idx = get_array_len(doc, "nodes");
        let mut node = json!({
            "name": segment,
            "children": []
        });
        if segment_idx + 1 == path.len() {
            if let Some(translation) = final_translation {
                node["translation"] = json!([translation[0], translation[1], translation[2]]);
            }
        }
        get_array_mut(doc, "nodes")?.push(node);
        get_node_children_mut(doc, current_idx)?.push(Value::from(new_idx as u64));
        current_idx = new_idx;
    }

    Ok(Some(current_idx))
}

fn find_deepest_node_by_path(doc: &Value, path: &[String]) -> Option<usize> {
    let first = path.first()?.as_str();
    let nodes = doc.get("nodes")?.as_array()?;
    nodes
        .iter()
        .enumerate()
        .filter(|(_, node)| node.get("name").and_then(|v| v.as_str()) == Some(first))
        .map(|(idx, _)| deepest_descendant_path(doc, idx, &path[1..]))
        .max_by_key(|(_, depth)| *depth)
        .map(|(idx, _)| idx)
}

fn find_descendant_path(doc: &Value, node_index: usize, remaining: &[String]) -> Option<usize> {
    if remaining.is_empty() {
        return Some(node_index);
    }
    let target = remaining[0].as_str();
    let nodes = doc.get("nodes")?.as_array()?;
    let node = nodes.get(node_index)?;
    let children = node.get("children").and_then(|v| v.as_array())?;
    for child in children.iter().filter_map(|v| v.as_u64()) {
        let child_index = child as usize;
        let child_node = nodes.get(child_index)?;
        if child_node.get("name").and_then(|v| v.as_str()) == Some(target) {
            if let Some(found) = find_descendant_path(doc, child_index, &remaining[1..]) {
                return Some(found);
            }
        }
        if let Some(found) = find_descendant_path(doc, child_index, remaining) {
            return Some(found);
        }
    }
    None
}

fn deepest_descendant_path(doc: &Value, node_index: usize, remaining: &[String]) -> (usize, usize) {
    if remaining.is_empty() {
        return (node_index, 0);
    }
    let target = remaining[0].as_str();
    let Some(nodes) = doc.get("nodes").and_then(|v| v.as_array()) else {
        return (node_index, 0);
    };
    let Some(node) = nodes.get(node_index) else {
        return (node_index, 0);
    };
    let Some(children) = node.get("children").and_then(|v| v.as_array()) else {
        return (node_index, 0);
    };

    let mut best = (node_index, 0usize);
    for child in children.iter().filter_map(|v| v.as_u64()) {
        let child_index = child as usize;
        let Some(child_node) = nodes.get(child_index) else {
            continue;
        };
        if child_node.get("name").and_then(|v| v.as_str()) == Some(target) {
            let (idx, depth) = deepest_descendant_path(doc, child_index, &remaining[1..]);
            let candidate = (idx, depth + 1);
            if candidate.1 > best.1 {
                best = candidate;
            }
        }
        let candidate = deepest_descendant_path(doc, child_index, remaining);
        if candidate.1 > best.1 {
            best = candidate;
        }
    }
    best
}

fn get_node_children_mut(doc: &mut Value, node_index: usize) -> Result<&mut Vec<Value>> {
    let nodes = doc
        .get_mut("nodes")
        .and_then(|v| v.as_array_mut())
        .ok_or_else(|| anyhow!("invalid glb json: nodes is not array"))?;
    let node = nodes
        .get_mut(node_index)
        .ok_or_else(|| anyhow!("invalid node index {node_index}"))?;
    if node.get("children").is_none() {
        node["children"] = Value::Array(Vec::new());
    }
    node.get_mut("children")
        .and_then(|v| v.as_array_mut())
        .ok_or_else(|| anyhow!("invalid node children"))
}

fn read_u32_le(data: &[u8], offset: usize) -> Result<u32> {
    let bytes: [u8; 4] = data
        .get(offset..offset + 4)
        .ok_or_else(|| anyhow!("unexpected EOF"))?
        .try_into()
        .map_err(|_| anyhow!("unexpected EOF"))?;
    Ok(u32::from_le_bytes(bytes))
}

fn parse_glb(path: &Path) -> Result<GlbData> {
    let data = fs::read(path)?;
    if data.len() < 20 || data.get(0..4) != Some(GLB_MAGIC) {
        return Err(anyhow!("invalid glb: {}", path.display()));
    }
    let total_len = read_u32_le(&data, 8)? as usize;
    if total_len != data.len() {
        return Err(anyhow!(
            "invalid glb total length for {}: header={}, actual={}",
            path.display(),
            total_len,
            data.len()
        ));
    }

    let mut cursor = 12usize;
    let mut json_doc: Option<Value> = None;
    let mut bin = Vec::<u8>::new();
    while cursor + 8 <= data.len() {
        let chunk_len = read_u32_le(&data, cursor)? as usize;
        let chunk_type = read_u32_le(&data, cursor + 4)?;
        cursor += 8;
        let end = cursor
            .checked_add(chunk_len)
            .ok_or_else(|| anyhow!("invalid chunk size"))?;
        let chunk = data
            .get(cursor..end)
            .ok_or_else(|| anyhow!("truncated glb chunk"))?;
        cursor = end;

        match chunk_type {
            CHUNK_JSON => {
                let text = String::from_utf8_lossy(chunk)
                    .trim_end_matches('\0')
                    .trim_end()
                    .to_string();
                json_doc = Some(serde_json::from_str(&text)?);
            }
            CHUNK_BIN => bin = chunk.to_vec(),
            _ => {}
        }
    }

    let json = json_doc.ok_or_else(|| anyhow!("missing JSON chunk"))?;
    Ok(GlbData { json, bin })
}

fn write_glb(path: &Path, doc: &Value, bin: &[u8]) -> Result<()> {
    let mut json_bytes = serde_json::to_vec(doc)?;
    while json_bytes.len() % 4 != 0 {
        json_bytes.push(b' ');
    }
    let mut bin_bytes = bin.to_vec();
    while bin_bytes.len() % 4 != 0 {
        bin_bytes.push(0);
    }

    let total_len = 12 + 8 + json_bytes.len() + 8 + bin_bytes.len();
    let mut out = Vec::with_capacity(total_len);
    out.extend_from_slice(GLB_MAGIC);
    out.extend_from_slice(&(2u32).to_le_bytes());
    out.extend_from_slice(&(total_len as u32).to_le_bytes());
    out.extend_from_slice(&(json_bytes.len() as u32).to_le_bytes());
    out.extend_from_slice(&CHUNK_JSON.to_le_bytes());
    out.extend_from_slice(&json_bytes);
    out.extend_from_slice(&(bin_bytes.len() as u32).to_le_bytes());
    out.extend_from_slice(&CHUNK_BIN.to_le_bytes());
    out.extend_from_slice(&bin_bytes);
    fs::write(path, out)?;
    Ok(())
}

pub fn inspect_glb(path: &Path) -> Result<GlbStats> {
    let parsed = parse_glb(path)?;
    Ok(GlbStats {
        path: path.to_string_lossy().to_string(),
        nodes: get_array_len(&parsed.json, "nodes"),
        meshes: get_array_len(&parsed.json, "meshes"),
        materials: get_array_len(&parsed.json, "materials"),
        accessors: get_array_len(&parsed.json, "accessors"),
        buffer_views: get_array_len(&parsed.json, "bufferViews"),
        binary_bytes: parsed.bin.len(),
    })
}

fn remap_index_field(v: &mut Value, key: &str, delta: usize) {
    if let Some(x) = v.get_mut(key).and_then(|y| y.as_u64()) {
        v[key] = Value::from((x as usize + delta) as u64);
    }
}

pub fn merge_glbs(inputs: &[PathBuf], output_path: &Path) -> Result<GlbStats> {
    let adapted = inputs
        .iter()
        .cloned()
        .map(|path| MergeInput {
            path,
            anchor: None,
            anchor_path: None,
            anchor_translation: None,
        })
        .collect::<Vec<_>>();
    merge_glbs_with_attachments(&adapted, &["root".to_string()], output_path)
}

pub fn merge_glbs_with_attachments(
    inputs: &[MergeInput],
    anchors: &[String],
    output_path: &Path,
) -> Result<GlbStats> {
    merge_glbs_with_attachments_and_transforms(
        inputs,
        anchors,
        &HashMap::new(),
        &HashMap::new(),
        output_path,
    )
}

pub fn merge_glbs_with_attachments_and_transforms(
    inputs: &[MergeInput],
    anchors: &[String],
    anchor_translations: &HashMap<String, [f32; 3]>,
    anchor_rotations: &HashMap<String, [f32; 4]>,
    output_path: &Path,
) -> Result<GlbStats> {
    if inputs.is_empty() {
        return Err(anyhow!("no glb inputs to merge"));
    }

    let mut anchor_list = if anchors.is_empty() {
        vec!["root".to_string()]
    } else {
        anchors.to_vec()
    };
    anchor_list.sort();
    anchor_list.dedup();

    let mut merged = json!({
        "asset": { "version": "2.0", "generator": "starcitizen_box-rust-merge" },
        "scene": 0,
        "scenes": [ { "name": "MergedScene", "nodes": [] } ],
        "nodes": [],
        "meshes": [],
        "skins": [],
        "animations": [],
        "cameras": [],
        "materials": [],
        "accessors": [],
        "bufferViews": [],
        "buffers": []
    });

    let mut merged_bin = Vec::<u8>::new();
    let mut extensions_used: Vec<String> = Vec::new();
    let mut anchor_to_node = std::collections::HashMap::<String, usize>::new();

    for anchor in anchor_list {
        let idx = get_array_len(&merged, "nodes");
        let label = if anchor.is_empty() { "root" } else { &anchor };
        let mut node = json!({
            "name": format!("anchor::{label}"),
            "children": []
        });
        if let Some(translation) = anchor_translations.get(label) {
            node["translation"] = json!([translation[0], translation[1], translation[2]]);
        }
        if let Some(rotation) = anchor_rotations.get(label) {
            node["rotation"] = json!([rotation[0], rotation[1], rotation[2], rotation[3]]);
        }
        get_array_mut(&mut merged, "nodes")?.push(node);
        merged["scenes"][0]["nodes"]
            .as_array_mut()
            .ok_or_else(|| anyhow!("invalid merged scene nodes"))?
            .push(Value::from(idx as u64));
        anchor_to_node.insert(anchor, idx);
    }

    for input in inputs {
        let mut part = parse_glb(&input.path)?;
        let fallback_anchor = "root".to_string();
        let selected_anchor = input
            .anchor
            .as_ref()
            .filter(|s| !s.is_empty())
            .unwrap_or(&fallback_anchor);
        let existing_anchor_idx = if selected_anchor == "root" {
            None
        } else {
            input
                .anchor_path
                .as_deref()
                .and_then(|path| find_node_by_path_with_synthetic_root(&merged, path))
                .or_else(|| {
                    if input.anchor_translation.is_some() {
                        input.anchor_path.as_deref().and_then(|path| {
                            ensure_descendant_node_path(&mut merged, path, input.anchor_translation)
                                .ok()
                                .flatten()
                        })
                    } else {
                        None
                    }
                })
                .or_else(|| {
                    input
                        .anchor_path
                        .as_deref()
                        .and_then(|path| find_deepest_node_by_path(&merged, path))
                })
                .or_else(|| find_node_by_name(&merged, selected_anchor))
        };

        let node_base = get_array_len(&merged, "nodes");
        let mesh_base = get_array_len(&merged, "meshes");
        let skin_base = get_array_len(&merged, "skins");
        let camera_base = get_array_len(&merged, "cameras");
        let material_base = get_array_len(&merged, "materials");
        let accessor_base = get_array_len(&merged, "accessors");
        let buffer_view_base = get_array_len(&merged, "bufferViews");
        let image_base = get_array_len(&merged, "images");
        let texture_base = get_array_len(&merged, "textures");
        let sampler_base = get_array_len(&merged, "samplers");
        let bin_offset = merged_bin.len();

        if let Some(ext) = part.json.get("extensionsUsed").and_then(|v| v.as_array()) {
            for item in ext.iter().filter_map(|x| x.as_str()) {
                if !extensions_used.iter().any(|s| s == item) {
                    extensions_used.push(item.to_string());
                }
            }
        }

        for key in ["samplers", "images", "textures", "materials"] {
            if part.json.get(key).is_some() && merged.get(key).is_none() {
                merged[key] = Value::Array(Vec::new());
            }
        }

        if let Some(arr) = part.json.get_mut("samplers").and_then(|v| v.as_array_mut()) {
            get_array_mut(&mut merged, "samplers")?.append(arr);
        }

        if let Some(arr) = part.json.get_mut("images").and_then(|v| v.as_array_mut()) {
            for img in arr.iter_mut() {
                remap_index_field(img, "bufferView", buffer_view_base);
            }
            get_array_mut(&mut merged, "images")?.append(arr);
        }

        if let Some(arr) = part.json.get_mut("textures").and_then(|v| v.as_array_mut()) {
            for tex in arr.iter_mut() {
                remap_index_field(tex, "source", image_base);
                remap_index_field(tex, "sampler", sampler_base);
            }
            get_array_mut(&mut merged, "textures")?.append(arr);
        }

        if let Some(arr) = part
            .json
            .get_mut("materials")
            .and_then(|v| v.as_array_mut())
        {
            get_array_mut(&mut merged, "materials")?.append(arr);
        }

        if let Some(arr) = part.json.get_mut("skins").and_then(|v| v.as_array_mut()) {
            for skin in arr.iter_mut() {
                if let Some(joints) = skin.get_mut("joints").and_then(|v| v.as_array_mut()) {
                    for joint in joints.iter_mut() {
                        if let Some(old) = joint.as_u64() {
                            *joint = Value::from((old as usize + node_base) as u64);
                        }
                    }
                }
                remap_index_field(skin, "inverseBindMatrices", accessor_base);
                remap_index_field(skin, "skeleton", node_base);
            }
            get_array_mut(&mut merged, "skins")?.append(arr);
        }

        if let Some(arr) = part
            .json
            .get_mut("animations")
            .and_then(|v| v.as_array_mut())
        {
            for animation in arr.iter_mut() {
                if let Some(samplers) = animation.get_mut("samplers").and_then(|v| v.as_array_mut())
                {
                    for sampler in samplers.iter_mut() {
                        remap_index_field(sampler, "input", accessor_base);
                        remap_index_field(sampler, "output", accessor_base);
                    }
                }
                if let Some(channels) = animation.get_mut("channels").and_then(|v| v.as_array_mut())
                {
                    for channel in channels.iter_mut() {
                        if let Some(target) =
                            channel.get_mut("target").and_then(|v| v.as_object_mut())
                        {
                            if let Some(old) = target.get("node").and_then(|v| v.as_u64()) {
                                target.insert(
                                    "node".to_string(),
                                    Value::from((old as usize + node_base) as u64),
                                );
                            }
                        }
                    }
                }
            }
            get_array_mut(&mut merged, "animations")?.append(arr);
        }

        if let Some(arr) = part.json.get_mut("cameras").and_then(|v| v.as_array_mut()) {
            get_array_mut(&mut merged, "cameras")?.append(arr);
        }

        if let Some(arr) = part
            .json
            .get_mut("bufferViews")
            .and_then(|v| v.as_array_mut())
        {
            for bv in arr.iter_mut() {
                bv["buffer"] = Value::from(0u64);
                let old_off = bv.get("byteOffset").and_then(|v| v.as_u64()).unwrap_or(0) as usize;
                bv["byteOffset"] = Value::from((old_off + bin_offset) as u64);
            }
            get_array_mut(&mut merged, "bufferViews")?.append(arr);
        }

        if let Some(arr) = part
            .json
            .get_mut("accessors")
            .and_then(|v| v.as_array_mut())
        {
            for acc in arr.iter_mut() {
                remap_index_field(acc, "bufferView", buffer_view_base);
                if let Some(sparse) = acc.get_mut("sparse").and_then(|v| v.as_object_mut()) {
                    if let Some(indices) = sparse.get_mut("indices").and_then(|v| v.as_object_mut())
                    {
                        if let Some(old) = indices.get("bufferView").and_then(|v| v.as_u64()) {
                            indices.insert(
                                "bufferView".to_string(),
                                Value::from((old as usize + buffer_view_base) as u64),
                            );
                        }
                    }
                    if let Some(values) = sparse.get_mut("values").and_then(|v| v.as_object_mut()) {
                        if let Some(old) = values.get("bufferView").and_then(|v| v.as_u64()) {
                            values.insert(
                                "bufferView".to_string(),
                                Value::from((old as usize + buffer_view_base) as u64),
                            );
                        }
                    }
                }
            }
            get_array_mut(&mut merged, "accessors")?.append(arr);
        }

        if let Some(arr) = part.json.get_mut("meshes").and_then(|v| v.as_array_mut()) {
            for mesh in arr.iter_mut() {
                if let Some(prims) = mesh.get_mut("primitives").and_then(|v| v.as_array_mut()) {
                    for prim in prims.iter_mut() {
                        remap_index_field(prim, "indices", accessor_base);
                        remap_index_field(prim, "material", material_base);
                        if let Some(attrs) =
                            prim.get_mut("attributes").and_then(|v| v.as_object_mut())
                        {
                            for (_, v) in attrs.iter_mut() {
                                if let Some(old) = v.as_u64() {
                                    *v = Value::from((old as usize + accessor_base) as u64);
                                }
                            }
                        }
                        if let Some(targets) =
                            prim.get_mut("targets").and_then(|v| v.as_array_mut())
                        {
                            for target in targets.iter_mut() {
                                if let Some(obj) = target.as_object_mut() {
                                    for (_, v) in obj.iter_mut() {
                                        if let Some(old) = v.as_u64() {
                                            *v = Value::from((old as usize + accessor_base) as u64);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            get_array_mut(&mut merged, "meshes")?.append(arr);
        }

        if let Some(arr) = part.json.get_mut("nodes").and_then(|v| v.as_array_mut()) {
            for node in arr.iter_mut() {
                remap_index_field(node, "mesh", mesh_base);
                remap_index_field(node, "skin", skin_base);
                remap_index_field(node, "camera", camera_base);
                if let Some(children) = node.get_mut("children").and_then(|v| v.as_array_mut()) {
                    for child in children.iter_mut() {
                        if let Some(old) = child.as_u64() {
                            *child = Value::from((old as usize + node_base) as u64);
                        }
                    }
                }
            }
            get_array_mut(&mut merged, "nodes")?.append(arr);
        }

        let roots = if let Some(scenes) = part.json.get("scenes").and_then(|v| v.as_array()) {
            let scene_idx = part.json.get("scene").and_then(|v| v.as_u64()).unwrap_or(0) as usize;
            scenes
                .get(scene_idx)
                .and_then(|s| s.get("nodes"))
                .and_then(|n| n.as_array())
                .cloned()
                .unwrap_or_default()
        } else {
            Vec::new()
        };
        let fallback_anchor_idx = *anchor_to_node
            .get(selected_anchor)
            .or_else(|| anchor_to_node.get("root"))
            .ok_or_else(|| anyhow!("missing anchor node"))?;
        let path_anchor_idx = input
            .anchor_path
            .as_deref()
            .and_then(|path| path.first())
            .and_then(|first| {
                anchor_to_node
                    .get(first)
                    .copied()
                    .or_else(|| find_node_by_name(&merged, &format!("anchor::{first}")))
            });
        let anchor_idx = existing_anchor_idx
            .or(path_anchor_idx)
            .unwrap_or(fallback_anchor_idx);
        let anchor_children = get_node_children_mut(&mut merged, anchor_idx)?;
        if roots.is_empty() {
            let node_count = get_array_len(&part.json, "nodes");
            for i in 0..node_count {
                anchor_children.push(Value::from((i + node_base) as u64));
            }
        } else {
            for node in roots {
                if let Some(old) = node.as_u64() {
                    anchor_children.push(Value::from((old as usize + node_base) as u64));
                }
            }
        }

        merged_bin.extend_from_slice(&part.bin);
        let padded = align4(merged_bin.len());
        if padded > merged_bin.len() {
            merged_bin.resize(padded, 0);
        }
        let _ = texture_base;
    }

    if !extensions_used.is_empty() {
        merged["extensionsUsed"] = Value::Array(
            extensions_used
                .into_iter()
                .map(Value::String)
                .collect::<Vec<_>>(),
        );
    }
    merged["buffers"] = Value::Array(vec![json!({ "byteLength": merged_bin.len() })]);

    write_glb(output_path, &merged, &merged_bin)?;
    inspect_glb(output_path)
}

#[cfg(test)]
mod tests {
    use super::*;
    use serde_json::json;
    use std::fs;
    use std::time::{SystemTime, UNIX_EPOCH};

    fn unique_path(name: &str) -> PathBuf {
        let mut path = std::env::temp_dir();
        let stamp = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .expect("time went backwards")
            .as_nanos();
        path.push(format!("{}_{}_{}.glb", name, std::process::id(), stamp));
        path
    }

    fn write_test_glb(path: &Path, node_name: &str) {
        let doc = json!({
            "asset": { "version": "2.0" },
            "scene": 0,
            "scenes": [{ "nodes": [0] }],
            "nodes": [{
                "name": node_name,
                "skin": 0,
                "camera": 0
            }],
            "skins": [{
                "joints": [0],
                "skeleton": 0,
                "inverseBindMatrices": 0
            }],
            "animations": [{
                "samplers": [{
                    "input": 0,
                    "output": 0
                }],
                "channels": [{
                    "sampler": 0,
                    "target": { "node": 0, "path": "translation" }
                }]
            }],
            "cameras": [{
                "type": "perspective",
                "perspective": { "yfov": 1.0, "znear": 0.1 }
            }],
            "accessors": [{
                "bufferView": 0,
                "componentType": 5126,
                "count": 1,
                "type": "MAT4"
            }],
            "bufferViews": [{
                "buffer": 0,
                "byteOffset": 0,
                "byteLength": 16
            }],
            "buffers": [{
                "byteLength": 16
            }]
        });
        write_glb(path, &doc, &[0u8; 16]).expect("write test glb");
    }

    fn write_node_only_glb(path: &Path, node_names: &[&str]) {
        let nodes = node_names
            .iter()
            .map(|name| json!({ "name": name }))
            .collect::<Vec<_>>();
        let scene_nodes = (0..node_names.len()).map(Value::from).collect::<Vec<_>>();
        let doc = json!({
            "asset": { "version": "2.0" },
            "scene": 0,
            "scenes": [{ "nodes": scene_nodes }],
            "nodes": nodes,
            "buffers": [{ "byteLength": 0 }]
        });
        write_glb(path, &doc, &[]).expect("write node-only test glb");
    }

    #[test]
    fn merge_glbs_preserves_skins_animations_and_cameras() {
        let input_a = unique_path("merge_a");
        let input_b = unique_path("merge_b");
        let output = unique_path("merge_out");

        write_test_glb(&input_a, "input_a");
        write_test_glb(&input_b, "input_b");

        let result =
            merge_glbs(&[input_a.clone(), input_b.clone()], &output).expect("merge should succeed");
        assert_eq!(result.nodes, 3);

        let merged = parse_glb(&output).expect("parse merged glb");
        let skins = merged.json["skins"].as_array().expect("skins array");
        let animations = merged.json["animations"]
            .as_array()
            .expect("animations array");
        let cameras = merged.json["cameras"].as_array().expect("cameras array");
        let nodes = merged.json["nodes"].as_array().expect("nodes array");

        assert_eq!(skins.len(), 2);
        assert_eq!(animations.len(), 2);
        assert_eq!(cameras.len(), 2);
        assert_eq!(nodes.len(), 3);

        assert_eq!(nodes[1]["skin"].as_u64(), Some(0));
        assert_eq!(nodes[1]["camera"].as_u64(), Some(0));
        assert_eq!(nodes[2]["skin"].as_u64(), Some(1));
        assert_eq!(nodes[2]["camera"].as_u64(), Some(1));

        assert_eq!(skins[0]["joints"][0].as_u64(), Some(1));
        assert_eq!(skins[0]["skeleton"].as_u64(), Some(1));
        assert_eq!(skins[1]["joints"][0].as_u64(), Some(2));
        assert_eq!(skins[1]["skeleton"].as_u64(), Some(2));

        assert_eq!(animations[0]["samplers"][0]["input"].as_u64(), Some(0));
        assert_eq!(animations[0]["samplers"][0]["output"].as_u64(), Some(0));
        assert_eq!(animations[1]["samplers"][0]["input"].as_u64(), Some(1));
        assert_eq!(animations[1]["samplers"][0]["output"].as_u64(), Some(1));

        let _ = fs::remove_file(input_a);
        let _ = fs::remove_file(input_b);
        let _ = fs::remove_file(output);
    }

    #[test]
    fn merge_glbs_attaches_to_existing_named_node_before_fallback_anchor() {
        let input_root = unique_path("merge_root_hardpoint");
        let input_child = unique_path("merge_child_hardpoint");
        let output = unique_path("merge_out_hardpoint");

        write_node_only_glb(&input_root, &["ship", "hardpoint_weapon_nose_left"]);
        write_node_only_glb(&input_child, &["weapon"]);

        let inputs = vec![
            MergeInput {
                path: input_root.clone(),
                anchor: None,
                anchor_path: None,
                anchor_translation: None,
            },
            MergeInput {
                path: input_child.clone(),
                anchor: Some("hardpoint_weapon_nose_left".to_string()),
                anchor_path: None,
                anchor_translation: None,
            },
        ];
        merge_glbs_with_attachments(
            &inputs,
            &["root".to_string(), "hardpoint_weapon_nose_left".to_string()],
            &output,
        )
        .expect("merge should succeed");

        let merged = parse_glb(&output).expect("parse merged glb");
        let nodes = merged.json["nodes"].as_array().expect("nodes array");
        let hardpoint_idx = nodes
            .iter()
            .position(|node| {
                node.get("name").and_then(|v| v.as_str()) == Some("hardpoint_weapon_nose_left")
            })
            .expect("hardpoint node");
        let weapon_idx = nodes
            .iter()
            .position(|node| node.get("name").and_then(|v| v.as_str()) == Some("weapon"))
            .expect("weapon node");
        let children = nodes[hardpoint_idx]["children"]
            .as_array()
            .expect("hardpoint children");
        assert!(children
            .iter()
            .any(|child| child.as_u64() == Some(weapon_idx as u64)));

        let _ = fs::remove_file(input_root);
        let _ = fs::remove_file(input_child);
        let _ = fs::remove_file(output);
    }

    #[test]
    fn merge_glbs_uses_anchor_path_to_disambiguate_duplicate_nodes() {
        let input_root = unique_path("merge_root_duplicate_path");
        let input_left = unique_path("merge_left_duplicate_path");
        let input_right = unique_path("merge_right_duplicate_path");
        let input_weapon = unique_path("merge_weapon_duplicate_path");
        let output = unique_path("merge_out_duplicate_path");

        write_node_only_glb(
            &input_root,
            &["ship", "hardpoint_weapon_left", "hardpoint_weapon_right"],
        );
        write_node_only_glb(&input_left, &["hardpoint_class_2"]);
        write_node_only_glb(&input_right, &["hardpoint_class_2"]);
        write_node_only_glb(&input_weapon, &["weapon"]);

        let inputs = vec![
            MergeInput {
                path: input_root.clone(),
                anchor: None,
                anchor_path: None,
                anchor_translation: None,
            },
            MergeInput {
                path: input_left.clone(),
                anchor: Some("hardpoint_weapon_left".to_string()),
                anchor_path: Some(vec!["hardpoint_weapon_left".to_string()]),
                anchor_translation: None,
            },
            MergeInput {
                path: input_right.clone(),
                anchor: Some("hardpoint_weapon_right".to_string()),
                anchor_path: Some(vec!["hardpoint_weapon_right".to_string()]),
                anchor_translation: None,
            },
            MergeInput {
                path: input_weapon.clone(),
                anchor: Some("hardpoint_class_2".to_string()),
                anchor_path: Some(vec![
                    "hardpoint_weapon_right".to_string(),
                    "hardpoint_class_2".to_string(),
                ]),
                anchor_translation: None,
            },
        ];
        merge_glbs_with_attachments(
            &inputs,
            &[
                "root".to_string(),
                "hardpoint_weapon_left".to_string(),
                "hardpoint_weapon_right".to_string(),
                "hardpoint_class_2".to_string(),
            ],
            &output,
        )
        .expect("merge should succeed");

        let merged = parse_glb(&output).expect("parse merged glb");
        let nodes = merged.json["nodes"].as_array().expect("nodes array");
        let right_hardpoint_idx = nodes
            .iter()
            .position(|node| {
                node.get("name").and_then(|v| v.as_str()) == Some("hardpoint_weapon_right")
            })
            .expect("right hardpoint");
        let right_class_idx = nodes[right_hardpoint_idx]["children"]
            .as_array()
            .expect("right children")
            .iter()
            .filter_map(|child| child.as_u64().map(|idx| idx as usize))
            .find(|idx| {
                nodes[*idx].get("name").and_then(|v| v.as_str()) == Some("hardpoint_class_2")
            })
            .expect("right class hardpoint");
        let weapon_idx = nodes
            .iter()
            .position(|node| node.get("name").and_then(|v| v.as_str()) == Some("weapon"))
            .expect("weapon node");
        let right_class_children = nodes[right_class_idx]["children"]
            .as_array()
            .expect("right class children");
        assert!(right_class_children
            .iter()
            .any(|child| child.as_u64() == Some(weapon_idx as u64)));

        let _ = fs::remove_file(input_root);
        let _ = fs::remove_file(input_left);
        let _ = fs::remove_file(input_right);
        let _ = fs::remove_file(input_weapon);
        let _ = fs::remove_file(output);
    }

    #[test]
    fn merge_glbs_falls_back_to_deepest_existing_anchor_path_node() {
        let input_root = unique_path("merge_root_deepest_path");
        let input_weapon = unique_path("merge_weapon_deepest_path");
        let output = unique_path("merge_out_deepest_path");

        write_node_only_glb(&input_root, &["ship", "hardpoint_weapon_right"]);
        write_node_only_glb(&input_weapon, &["weapon"]);

        let inputs = vec![
            MergeInput {
                path: input_root.clone(),
                anchor: None,
                anchor_path: None,
                anchor_translation: None,
            },
            MergeInput {
                path: input_weapon.clone(),
                anchor: Some("hardpoint_class_2".to_string()),
                anchor_path: Some(vec![
                    "hardpoint_weapon_right".to_string(),
                    "hardpoint_class_2".to_string(),
                ]),
                anchor_translation: None,
            },
        ];
        merge_glbs_with_attachments(
            &inputs,
            &[
                "root".to_string(),
                "hardpoint_weapon_right".to_string(),
                "hardpoint_class_2".to_string(),
            ],
            &output,
        )
        .expect("merge should succeed");

        let merged = parse_glb(&output).expect("parse merged glb");
        let nodes = merged.json["nodes"].as_array().expect("nodes array");
        let right_hardpoint_idx = nodes
            .iter()
            .position(|node| {
                node.get("name").and_then(|v| v.as_str()) == Some("hardpoint_weapon_right")
            })
            .expect("right hardpoint");
        let weapon_idx = nodes
            .iter()
            .position(|node| node.get("name").and_then(|v| v.as_str()) == Some("weapon"))
            .expect("weapon node");
        let children = nodes[right_hardpoint_idx]["children"]
            .as_array()
            .expect("right children");
        assert!(children
            .iter()
            .any(|child| child.as_u64() == Some(weapon_idx as u64)));

        let _ = fs::remove_file(input_root);
        let _ = fs::remove_file(input_weapon);
        let _ = fs::remove_file(output);
    }

    #[test]
    fn merge_glbs_falls_back_to_synthetic_parent_anchor_from_path() {
        let input_root = unique_path("merge_root_synthetic_parent");
        let input_weapon = unique_path("merge_weapon_synthetic_parent");
        let output = unique_path("merge_out_synthetic_parent");

        write_node_only_glb(&input_root, &["ship"]);
        write_node_only_glb(&input_weapon, &["weapon"]);

        let inputs = vec![
            MergeInput {
                path: input_root.clone(),
                anchor: None,
                anchor_path: None,
                anchor_translation: None,
            },
            MergeInput {
                path: input_weapon.clone(),
                anchor: Some("hardpoint_class_2".to_string()),
                anchor_path: Some(vec![
                    "hardpoint_weapon_wing_right".to_string(),
                    "hardpoint_class_2".to_string(),
                ]),
                anchor_translation: None,
            },
        ];
        merge_glbs_with_attachments(
            &inputs,
            &[
                "root".to_string(),
                "hardpoint_weapon_wing_right".to_string(),
                "hardpoint_class_2".to_string(),
            ],
            &output,
        )
        .expect("merge should succeed");

        let merged = parse_glb(&output).expect("parse merged glb");
        let nodes = merged.json["nodes"].as_array().expect("nodes array");
        let parent_anchor_idx = nodes
            .iter()
            .position(|node| {
                node.get("name").and_then(|v| v.as_str())
                    == Some("anchor::hardpoint_weapon_wing_right")
            })
            .expect("synthetic parent anchor");
        let weapon_idx = nodes
            .iter()
            .position(|node| node.get("name").and_then(|v| v.as_str()) == Some("weapon"))
            .expect("weapon node");
        let children = nodes[parent_anchor_idx]["children"]
            .as_array()
            .expect("parent anchor children");
        assert!(children
            .iter()
            .any(|child| child.as_u64() == Some(weapon_idx as u64)));

        let _ = fs::remove_file(input_root);
        let _ = fs::remove_file(input_weapon);
        let _ = fs::remove_file(output);
    }

    #[test]
    fn merge_glbs_searches_inside_synthetic_parent_anchor_path() {
        let input_root = unique_path("merge_root_synthetic_path");
        let input_rack = unique_path("merge_rack_synthetic_path");
        let input_missile = unique_path("merge_missile_synthetic_path");
        let output = unique_path("merge_out_synthetic_path");

        write_node_only_glb(&input_root, &["ship"]);
        write_node_only_glb(&input_rack, &["missile_01_attach"]);
        write_node_only_glb(&input_missile, &["missile"]);

        let inputs = vec![
            MergeInput {
                path: input_root.clone(),
                anchor: None,
                anchor_path: None,
                anchor_translation: None,
            },
            MergeInput {
                path: input_rack.clone(),
                anchor: Some("hardpoint_missile_rack_outer".to_string()),
                anchor_path: Some(vec!["hardpoint_missile_rack_outer".to_string()]),
                anchor_translation: None,
            },
            MergeInput {
                path: input_missile.clone(),
                anchor: Some("missile_01_attach".to_string()),
                anchor_path: Some(vec![
                    "hardpoint_missile_rack_outer".to_string(),
                    "missile_01_attach".to_string(),
                ]),
                anchor_translation: None,
            },
        ];
        merge_glbs_with_attachments(
            &inputs,
            &[
                "root".to_string(),
                "hardpoint_missile_rack_outer".to_string(),
                "missile_01_attach".to_string(),
            ],
            &output,
        )
        .expect("merge should succeed");

        let merged = parse_glb(&output).expect("parse merged glb");
        let nodes = merged.json["nodes"].as_array().expect("nodes array");
        let attach_idx = nodes
            .iter()
            .position(|node| node.get("name").and_then(|v| v.as_str()) == Some("missile_01_attach"))
            .expect("missile attach");
        let missile_idx = nodes
            .iter()
            .position(|node| node.get("name").and_then(|v| v.as_str()) == Some("missile"))
            .expect("missile node");
        let children = nodes[attach_idx]["children"]
            .as_array()
            .expect("attach children");
        assert!(children
            .iter()
            .any(|child| child.as_u64() == Some(missile_idx as u64)));

        let _ = fs::remove_file(input_root);
        let _ = fs::remove_file(input_rack);
        let _ = fs::remove_file(input_missile);
        let _ = fs::remove_file(output);
    }
}
