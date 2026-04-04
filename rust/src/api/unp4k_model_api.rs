use anyhow::Result;
use flutter_rust_bridge::frb;
use quick_xml::events::{BytesStart, Event};
use quick_xml::Reader;
use serde_json::json;
use std::collections::{HashMap, HashSet, VecDeque};
use std::fs;
use std::path::{Path, PathBuf};
use unp4k::CryXmlReader;
use walkdir::WalkDir;

use crate::model_convert::{self, ConvertOptions};

#[frb(dart_metadata=("freezed"))]
pub struct ModelConvertResult {
    pub success: bool,
    pub output_path: Option<String>,
    pub error_code: Option<String>,
    pub error_message: Option<String>,
    pub warnings: Vec<String>,
}

#[frb(dart_metadata=("freezed"))]
pub struct LocalBatchFileResult {
    pub model_path: String,
    pub output_path: Option<String>,
    pub has_geometry: bool,
    pub error_code: Option<String>,
    pub error_message: Option<String>,
    pub warnings: Vec<String>,
    pub source_mode: String,
    pub fallback_reason: Option<String>,
}

#[frb(dart_metadata=("freezed"))]
pub struct AssemblyGraphStats {
    pub nodes: i32,
    pub geometry_nodes: i32,
    pub object_containers: i32,
    pub roots: i32,
}

#[frb(dart_metadata=("freezed"))]
pub struct LocalBatchConvertResult {
    pub success: bool,
    pub merged_output_path: Option<String>,
    pub assembly_manifest_path: Option<String>,
    pub assembly_report_path: Option<String>,
    pub success_count: i32,
    pub empty_count: i32,
    pub failed_count: i32,
    pub warnings: Vec<String>,
    pub files: Vec<LocalBatchFileResult>,
    pub source_mode: String,
    pub assembly_graph_stats: AssemblyGraphStats,
    pub fallback_reason_by_file: Vec<String>,
    pub error_code: Option<String>,
    pub error_message: Option<String>,
}

#[frb(dart_metadata=("freezed"))]
pub struct ModelConvertOptions {
    pub embed_textures: bool,
    pub overwrite: bool,
    pub max_texture_size: Option<u32>,
}

#[derive(Debug, Clone)]
struct SemanticNode {
    id: String,
    source_path: String,
    kind: String,
}

#[derive(Debug, Clone)]
struct SemanticEdge {
    from: String,
    to: String,
    relation: String,
    anchor: Option<String>,
}

#[derive(Default)]
struct SemanticGraph {
    nodes: HashMap<String, SemanticNode>,
    edges: Vec<SemanticEdge>,
    object_containers: HashSet<String>,
    anchor_translations: HashMap<String, [f32; 3]>,
    anchor_rotations: HashMap<String, [f32; 4]>,
}

impl SemanticGraph {
    fn add_node(&mut self, key: String, source_path: String, kind: &str) {
        self.nodes.entry(key.clone()).or_insert(SemanticNode {
            id: key,
            source_path,
            kind: kind.to_string(),
        });
    }

    fn add_edge(&mut self, from: String, to: String, relation: &str, anchor: Option<String>) {
        self.edges.push(SemanticEdge {
            from,
            to,
            relation: relation.to_string(),
            anchor,
        });
    }

    fn stats(&self) -> AssemblyGraphStats {
        let mut indegree: HashMap<&str, usize> = self.nodes.keys().map(|k| (k.as_str(), 0)).collect();
        for edge in &self.edges {
            if let Some(v) = indegree.get_mut(edge.to.as_str()) {
                *v += 1;
            }
        }
        let roots = indegree.values().filter(|v| **v == 0).count() as i32;
        let geometry_nodes = self
            .nodes
            .values()
            .filter(|node| node.kind == "model")
            .count() as i32;
        AssemblyGraphStats {
            nodes: self.nodes.len() as i32,
            geometry_nodes,
            object_containers: self.object_containers.len() as i32,
            roots,
        }
    }
}

#[derive(Debug)]
struct XmlLink {
    target: String,
    anchor: Option<String>,
    is_object_container: bool,
    source_context_id: String,
}

#[derive(Debug, Clone)]
struct XmlContextNode {
    local_id: String,
    parent_local_id: Option<String>,
    tag_name: String,
    anchor: Option<String>,
    cumulative_translation: Option<[f32; 3]>,
    cumulative_rotation_xyzw: Option<[f32; 4]>,
}

#[derive(Default)]
struct XmlParseResult {
    contexts: Vec<XmlContextNode>,
    links: Vec<XmlLink>,
}

#[derive(Debug, Clone, Default)]
struct DependencyPackageSummary {
    package_root: PathBuf,
    copied_files: usize,
    missing_files: Vec<String>,
}

fn add_vec3_plain(a: [f32; 3], b: [f32; 3]) -> [f32; 3] {
    [a[0] + b[0], a[1] + b[1], a[2] + b[2]]
}

fn euler_deg_xyz_to_quat_xyz_w(euler_deg: [f32; 3]) -> [f32; 4] {
    let (x, y, z) = (
        euler_deg[0].to_radians(),
        euler_deg[1].to_radians(),
        euler_deg[2].to_radians(),
    );
    let (sx, cx) = (0.5 * x).sin_cos();
    let (sy, cy) = (0.5 * y).sin_cos();
    let (sz, cz) = (0.5 * z).sin_cos();

    let qw = cx * cy * cz + sx * sy * sz;
    let qx = sx * cy * cz - cx * sy * sz;
    let qy = cx * sy * cz + sx * cy * sz;
    let qz = cx * cy * sz - sx * sy * cz;
    [qx, qy, qz, qw]
}

fn quat_mul_xyzw(a: [f32; 4], b: [f32; 4]) -> [f32; 4] {
    let (ax, ay, az, aw) = (a[0], a[1], a[2], a[3]);
    let (bx, by, bz, bw) = (b[0], b[1], b[2], b[3]);
    [
        aw * bx + ax * bw + ay * bz - az * by,
        aw * by - ax * bz + ay * bw + az * bx,
        aw * bz + ax * by - ay * bx + az * bw,
        aw * bw - ax * bx - ay * by - az * bz,
    ]
}

fn rotate_vec3_by_quat_xyzw(v: [f32; 3], q: [f32; 4]) -> [f32; 3] {
    let qv = [v[0], v[1], v[2], 0.0];
    let q_conj = [-q[0], -q[1], -q[2], q[3]];
    let rotated = quat_mul_xyzw(quat_mul_xyzw(q, qv), q_conj);
    [rotated[0], rotated[1], rotated[2]]
}

fn parse_xyz_from_attrs(attrs: &HashMap<String, String>) -> Option<[f32; 3]> {
    let x = attrs.get("x")?.parse::<f32>().ok()?;
    let y = attrs.get("y")?.parse::<f32>().ok()?;
    let z = attrs.get("z")?.parse::<f32>().ok()?;
    Some([x, y, z])
}

impl From<Option<ModelConvertOptions>> for ConvertOptions {
    fn from(value: Option<ModelConvertOptions>) -> Self {
        if let Some(v) = value {
            ConvertOptions {
                embed_textures: v.embed_textures,
                overwrite: v.overwrite,
                max_texture_size: v.max_texture_size,
            }
        } else {
            ConvertOptions::default()
        }
    }
}

pub fn p4k_model_is_supported(file_path: String) -> bool {
    model_convert::is_supported_model(&file_path)
}

pub async fn p4k_model_convert_to_glb(
    p4k_path: String,
    model_path: String,
    output_dir: String,
    options: Option<ModelConvertOptions>,
) -> Result<ModelConvertResult> {
    let options: ConvertOptions = options.into();
    let result =
        model_convert::convert_from_p4k(&p4k_path, &model_path, &output_dir, options).await;
    match result {
        Ok(ok) => Ok(ModelConvertResult {
            success: true,
            output_path: Some(ok.output_path),
            error_code: None,
            error_message: None,
            warnings: ok.warnings,
        }),
        Err(e) => Ok(ModelConvertResult {
            success: false,
            output_path: None,
            error_code: Some(e.code().to_string()),
            error_message: Some(e.to_string()),
            warnings: vec![],
        }),
    }
}

pub async fn p4k_model_convert_local_batch_and_merge(
    asset_root: String,
    output_dir: String,
    options: Option<ModelConvertOptions>,
) -> Result<LocalBatchConvertResult> {
    let options: ConvertOptions = options.into();
    let asset_root_path = PathBuf::from(&asset_root);
    let output_root_path = PathBuf::from(&output_dir);

    if !asset_root_path.exists() {
        return Ok(LocalBatchConvertResult {
            success: false,
            merged_output_path: None,
            assembly_manifest_path: None,
            assembly_report_path: None,
            success_count: 0,
            empty_count: 0,
            failed_count: 0,
            warnings: vec![],
            files: vec![],
            source_mode: "batch".to_string(),
            assembly_graph_stats: AssemblyGraphStats {
                nodes: 0,
                geometry_nodes: 0,
                object_containers: 0,
                roots: 0,
            },
            fallback_reason_by_file: vec![],
            error_code: Some("ERR_IO".to_string()),
            error_message: Some(format!(
                "asset_root does not exist: {}",
                asset_root_path.display()
            )),
        });
    }

    fs::create_dir_all(&output_root_path)?;
    let part_output_dir = output_root_path.join("_parts");
    fs::create_dir_all(&part_output_dir)?;

    let candidates = collect_batch_model_candidates(&asset_root_path)?;
    if candidates.is_empty() {
        return Ok(LocalBatchConvertResult {
            success: false,
            merged_output_path: None,
            assembly_manifest_path: None,
            assembly_report_path: None,
            success_count: 0,
            empty_count: 0,
            failed_count: 0,
            warnings: vec![],
            files: vec![],
            source_mode: "batch".to_string(),
            assembly_graph_stats: AssemblyGraphStats {
                nodes: 0,
                geometry_nodes: 0,
                object_containers: 0,
                roots: 0,
            },
            fallback_reason_by_file: vec![],
            error_code: Some("ERR_IO".to_string()),
            error_message: Some("no supported model files found under asset_root".to_string()),
        });
    }
    let local_index = build_local_index(&asset_root_path)?;
    let semantic_graph = build_semantic_graph(&candidates, &asset_root_path, &local_index)?;

    let mut files = Vec::with_capacity(candidates.len());
    let mut warnings = Vec::new();
    let mut fallback_reason_by_file = Vec::new();
    let mut merge_inputs = Vec::<crate::model_convert::glb_merge::MergeInput>::new();
    let mut success_count = 0i32;
    let mut empty_count = 0i32;
    let mut failed_count = 0i32;

    for model_path in &candidates {
        let model_path_string = model_path.to_string_lossy().to_string();
        let model_display = to_display_path(model_path, &asset_root_path);
        match model_convert::convert_from_fs(
            &model_path_string,
            &asset_root,
            &part_output_dir.to_string_lossy(),
            options.clone(),
        )
        .await
        {
            Ok(ok) => {
                success_count += 1;
                warnings.extend(ok.warnings.clone());
                let output_path = PathBuf::from(&ok.output_path);
                let model_key = normalize_key(&model_path_string);
                let anchor = model_anchor_for_key(&semantic_graph, &model_key);
                merge_inputs.push(crate::model_convert::glb_merge::MergeInput {
                    path: output_path.clone(),
                    anchor,
                });
                files.push(LocalBatchFileResult {
                    model_path: model_display,
                    output_path: Some(output_path.to_string_lossy().to_string()),
                    has_geometry: true,
                    error_code: None,
                    error_message: None,
                    warnings: ok.warnings,
                    source_mode: ok.source_mode,
                    fallback_reason: ok.fallback_reason,
                });
            }
            Err(err) => {
                if is_empty_geometry_error(&err) {
                    empty_count += 1;
                    fallback_reason_by_file.push(format!("{model_display}: {}", err));
                    files.push(LocalBatchFileResult {
                        model_path: model_display,
                        output_path: None,
                        has_geometry: false,
                        error_code: Some(err.code().to_string()),
                        error_message: Some(err.to_string()),
                        warnings: vec![],
                        source_mode: "batch".to_string(),
                        fallback_reason: Some("empty_geometry".to_string()),
                    });
                } else {
                    failed_count += 1;
                    fallback_reason_by_file.push(format!("{model_display}: {}", err));
                    files.push(LocalBatchFileResult {
                        model_path: model_display,
                        output_path: None,
                        has_geometry: false,
                        error_code: Some(err.code().to_string()),
                        error_message: Some(err.to_string()),
                        warnings: vec![],
                        source_mode: "batch".to_string(),
                        fallback_reason: None,
                    });
                }
            }
        }
    }

    let merged_output_path = output_root_path.join("merged_scene.glb");
    let merge_stats = if merge_inputs.is_empty() {
        None
    } else {
        let mut anchors = semantic_graph
            .nodes
            .values()
            .filter(|n| n.kind == "anchor")
            .map(|n| n.source_path.clone())
            .collect::<Vec<_>>();
        anchors.push("root".to_string());
        anchors.sort();
        anchors.dedup();

        Some(crate::model_convert::glb_merge::merge_glbs_with_attachments_and_transforms(
            &merge_inputs,
            &anchors,
            &semantic_graph.anchor_translations,
            &semantic_graph.anchor_rotations,
            &merged_output_path,
        )?)
    };
    let exported_model_paths = files
        .iter()
        .filter(|f| f.output_path.is_some() && f.has_geometry)
        .map(|f| f.model_path.clone())
        .collect::<Vec<_>>();
    let dependency_package_summary = if exported_model_paths.is_empty() {
        None
    } else {
        Some(export_dependency_package(
            &semantic_graph,
            &exported_model_paths,
            &asset_root_path,
            &local_index,
            &output_root_path,
        )?)
    };

    let assembly_manifest_path = output_root_path.join("assembly_manifest.json");
    let assembly_report_path = output_root_path.join("assembly_report.json");
    let manifest_json = json!({
        "asset_root": asset_root_path.to_string_lossy(),
        "output_dir": output_root_path.to_string_lossy(),
        "success_count": success_count,
        "empty_count": empty_count,
        "failed_count": failed_count,
        "files": files.iter().map(|f| {
            json!({
                "model_path": f.model_path,
                "output_path": f.output_path,
                "has_geometry": f.has_geometry,
                "error_code": f.error_code,
                "error_message": f.error_message,
                "source_mode": f.source_mode,
                "fallback_reason": f.fallback_reason,
                "dependency_chain": f.output_path.as_ref().and_then(|_| {
                    let abs_model = asset_root_path.join(&f.model_path);
                    Some(collect_dependency_chain(&semantic_graph, &abs_model.to_string_lossy()))
                }),
            })
        }).collect::<Vec<_>>(),
        "assembly_nodes": semantic_graph.nodes.values().map(|n| {
            json!({
                "id": n.id,
                "kind": n.kind,
                "source_path": n.source_path,
            })
        }).collect::<Vec<_>>(),
        "assembly_edges": semantic_graph.edges.iter().map(|e| {
            json!({
                "from": e.from,
                "to": e.to,
                "relation": e.relation,
                "anchor": e.anchor,
            })
        }).collect::<Vec<_>>(),
        "anchor_transforms": semantic_graph.nodes.values()
            .filter(|n| n.kind == "anchor")
            .map(|n| {
                let key = normalize_key(&n.source_path);
                json!({
                    "anchor": n.source_path,
                    "translation": semantic_graph.anchor_translations.get(&key),
                    "rotation_xyzw": semantic_graph.anchor_rotations.get(&key),
                })
            })
            .collect::<Vec<_>>(),
        "dependency_package": dependency_package_summary.as_ref().map(|s| json!({
            "package_root": s.package_root.to_string_lossy().to_string(),
            "copied_files": s.copied_files,
            "missing_files": s.missing_files,
        })),
    });
    let report_json = json!({
        "merge_output": if merge_stats.is_some() { Some(merged_output_path.to_string_lossy().to_string()) } else { None },
        "merge_stats": merge_stats.as_ref().map(|m| json!({
            "nodes": m.nodes,
            "meshes": m.meshes,
            "materials": m.materials,
            "accessors": m.accessors,
            "buffer_views": m.buffer_views,
            "binary_bytes": m.binary_bytes,
        })),
        "warnings": warnings.clone(),
        "fallback_reason_by_file": fallback_reason_by_file.clone(),
        "semantic_stats": {
            "node_count": semantic_graph.nodes.len(),
            "edge_count": semantic_graph.edges.len(),
            "object_container_count": semantic_graph.object_containers.len(),
            "model_node_count": semantic_graph.nodes.values().filter(|n| n.kind == "model").count(),
            "material_node_count": semantic_graph.nodes.values().filter(|n| n.kind == "material").count(),
            "texture_node_count": semantic_graph.nodes.values().filter(|n| n.kind == "texture").count(),
            "xml_node_count": semantic_graph.nodes.values().filter(|n| n.kind == "xml").count(),
            "xml_context_node_count": semantic_graph.nodes.values().filter(|n| n.kind == "xml_context").count(),
            "anchor_node_count": semantic_graph.nodes.values().filter(|n| n.kind == "anchor").count(),
        },
        "dependency_package": dependency_package_summary.as_ref().map(|s| json!({
            "package_root": s.package_root.to_string_lossy().to_string(),
            "copied_files": s.copied_files,
            "missing_files_count": s.missing_files.len(),
        })),
    });
    fs::write(
        &assembly_manifest_path,
        serde_json::to_vec_pretty(&manifest_json)?,
    )?;
    fs::write(
        &assembly_report_path,
        serde_json::to_vec_pretty(&report_json)?,
    )?;

    let success = merge_stats.is_some();
    let graph_stats = semantic_graph.stats();

    Ok(LocalBatchConvertResult {
        success,
        merged_output_path: merge_stats.map(|_| merged_output_path.to_string_lossy().to_string()),
        assembly_manifest_path: Some(assembly_manifest_path.to_string_lossy().to_string()),
        assembly_report_path: Some(assembly_report_path.to_string_lossy().to_string()),
        success_count,
        empty_count,
        failed_count,
        warnings: warnings.clone(),
        files,
        source_mode: "batch".to_string(),
        assembly_graph_stats: graph_stats,
        fallback_reason_by_file: fallback_reason_by_file.clone(),
        error_code: if success {
            None
        } else {
            Some("ERR_MODEL_PARSE_FAILED".to_string())
        },
        error_message: if success {
            None
        } else {
            Some("no GLB outputs generated from candidate models".to_string())
        },
    })
}

fn build_local_index(asset_root: &Path) -> Result<HashMap<String, String>> {
    let mut index = HashMap::new();
    for entry in WalkDir::new(asset_root).into_iter().filter_map(|e| e.ok()) {
        if !entry.file_type().is_file() {
            continue;
        }
        let path = entry.path();
        let abs = path.to_string_lossy().replace('/', "\\");
        let abs_key = normalize_key(&abs);
        index.insert(abs_key, abs.clone());
        if let Ok(rel) = path.strip_prefix(asset_root) {
            let rel_str = rel.to_string_lossy().replace('/', "\\");
            index.insert(normalize_key(&rel_str), abs.clone());
            index.insert(normalize_key(&format!("\\{rel_str}")), abs);
        }
    }
    Ok(index)
}

fn normalize_path(path: &str) -> String {
    path.trim().replace('/', "\\")
}

fn normalize_key(path: &str) -> String {
    normalize_path(path).to_ascii_lowercase()
}

fn ext_of(path: &str) -> String {
    Path::new(path)
        .extension()
        .and_then(|s| s.to_str())
        .unwrap_or_default()
        .to_ascii_lowercase()
}

fn classify_kind(path: &str) -> &'static str {
    match ext_of(path).as_str() {
        "cga" | "cgf" | "chr" | "skin" => "model",
        "mtl" => "material",
        "dds" | "png" | "jpg" | "jpeg" | "tga" | "tif" | "tiff" | "bmp" => "texture",
        "xml" | "cdf" | "chrparams" => "xml",
        "socpak" => "object_container",
        _ => "asset",
    }
}

fn sidecar_candidates_for_model(path: &str) -> Vec<String> {
    let mut out = Vec::new();
    let normalized = normalize_path(path);
    let stem = match normalized.rfind('.') {
        Some(dot) if dot > 0 => normalized[..dot].to_string(),
        _ => normalized.clone(),
    };
    for ext in [
        ".mtl",
        ".chrparams",
        ".cdf",
        ".xml",
        ".skin",
        ".chr",
        ".cgf",
        ".cga",
    ] {
        out.push(format!("{stem}{ext}"));
    }
    out
}

fn find_path_case_insensitive(index: &HashMap<String, String>, candidate: &str) -> Option<String> {
    let key = normalize_key(candidate);
    if let Some(hit) = index.get(&key) {
        return Some(hit.clone());
    }
    let with_leading = if !candidate.starts_with('\\') {
        format!("\\{}", normalize_path(candidate))
    } else {
        normalize_path(candidate)
    };
    index.get(&normalize_key(&with_leading)).cloned()
}

fn resolve_reference_path(
    current_file: &str,
    raw_ref: &str,
    index: &HashMap<String, String>,
) -> Option<String> {
    let raw = normalize_path(raw_ref);
    if raw.is_empty() {
        return None;
    }
    if let Some(hit) = find_path_case_insensitive(index, &raw) {
        return Some(hit);
    }
    let current_dir = Path::new(current_file)
        .parent()
        .map(|p| p.to_string_lossy().replace('/', "\\"))
        .unwrap_or_default();
    if !current_dir.is_empty() {
        let joined = format!("{current_dir}\\{raw}");
        if let Some(hit) = find_path_case_insensitive(index, &joined) {
            return Some(hit);
        }
    }
    let file_name = Path::new(&raw).file_name()?.to_str()?.to_ascii_lowercase();
    index.values().find_map(|path| {
        let name = Path::new(path).file_name()?.to_str()?.to_ascii_lowercase();
        (name == file_name).then(|| path.clone())
    })
}

fn decode_possible_xml(bytes: &[u8]) -> String {
    if CryXmlReader::is_cryxml(bytes) {
        if let Ok(text) = CryXmlReader::parse(bytes) {
            return text;
        }
    }
    String::from_utf8_lossy(bytes).into_owned()
}

fn looks_like_asset_path(value: &str) -> bool {
    let lower = value.to_ascii_lowercase();
    [
        ".cga", ".cgf", ".chr", ".skin", ".mtl", ".xml", ".cdf", ".chrparams", ".socpak",
        ".dds", ".png", ".jpg", ".jpeg", ".tga", ".tif", ".tiff", ".bmp",
    ]
    .iter()
    .any(|ext| lower.ends_with(ext))
}

fn parse_xml_link_node(
    reader: &Reader<&[u8]>,
    element: &BytesStart<'_>,
    inherited_anchor: Option<&str>,
    source_context_id: String,
    out: &mut Vec<XmlLink>,
) -> (Option<String>, Option<[f32; 3]>, Option<[f32; 3]>) {
    let tag_name = String::from_utf8_lossy(element.name().as_ref()).to_ascii_lowercase();
    let mut anchor: Option<String> = None;
    let mut refs: Vec<String> = Vec::new();
    let mut is_object_container = tag_name.contains("objectcontainer");
    let mut attrs_map = HashMap::<String, String>::new();

    for attr in element.attributes().flatten() {
        let key = String::from_utf8_lossy(attr.key.as_ref()).to_ascii_lowercase();
        let value = attr
            .decode_and_unescape_value(reader.decoder())
            .map(|v| normalize_path(&v))
            .unwrap_or_default();
        attrs_map.insert(key.clone(), value.clone());
        if value.is_empty() {
            continue;
        }

        if matches!(
            key.as_str(),
            "bonename" | "bone" | "joint" | "socket" | "hardpoint" | "tag" | "tags"
        ) && anchor.is_none()
        {
            anchor = Some(value.clone());
        }
        if key == "filename" && value.to_ascii_lowercase().ends_with(".socpak") {
            is_object_container = true;
        }
        let key_is_ref = matches!(
            key.as_str(),
            "path"
                | "file"
                | "filename"
                | "geometry"
                | "material"
                | "model"
                | "characterdefinition"
                | "source"
        );
        if key_is_ref || looks_like_asset_path(&value) {
            refs.push(value);
        }
    }
    let effective_anchor = anchor.or_else(|| inherited_anchor.map(|v| v.to_string()));

    for target in refs {
        out.push(XmlLink {
            target,
            anchor: effective_anchor.clone(),
            is_object_container,
            source_context_id: source_context_id.clone(),
        });
    }
    let translation = if tag_name.ends_with("position") || tag_name.contains("position") {
        parse_xyz_from_attrs(&attrs_map)
    } else {
        None
    };
    let rotation_deg = if tag_name.ends_with("rotation") || tag_name.contains("rotation") {
        parse_xyz_from_attrs(&attrs_map)
    } else {
        None
    };
    (effective_anchor, translation, rotation_deg)
}

fn parse_xml_links(xml_text: &str) -> XmlParseResult {
    let mut out = XmlParseResult::default();
    let mut reader = Reader::from_str(xml_text);
    reader.config_mut().trim_text(true);
    let mut buf = Vec::new();
    let mut stack: Vec<(
        String,
        Option<String>,
        Option<[f32; 3]>,
        Option<[f32; 4]>,
    )> = Vec::new();
    let mut seq = 0usize;

    loop {
        match reader.read_event_into(&mut buf) {
            Ok(Event::Start(e)) => {
                seq += 1;
                let local_id = format!("n{seq}");
                let parent_local_id = stack.last().map(|(id, _, _, _)| id.clone());
                let inherited_anchor = stack.last().and_then(|(_, a, _, _)| a.as_deref());
                let parent_translation = stack.last().and_then(|(_, _, t, _)| *t);
                let parent_rotation = stack.last().and_then(|(_, _, _, r)| *r);
                let (resolved_anchor, local_translation, local_rotation) = parse_xml_link_node(
                    &reader,
                    &e,
                    inherited_anchor,
                    local_id.clone(),
                    &mut out.links,
                );
                let local_rotation_q = local_rotation.map(euler_deg_xyz_to_quat_xyz_w);
                let cumulative_rotation_xyzw = match (parent_rotation, local_rotation_q) {
                    (Some(pr), Some(lr)) => Some(quat_mul_xyzw(pr, lr)),
                    (Some(pr), None) => Some(pr),
                    (None, Some(lr)) => Some(lr),
                    (None, None) => None,
                };
                let cumulative_translation = match (parent_translation, local_translation, parent_rotation)
                {
                    (Some(pt), Some(lt), Some(pr)) => {
                        Some(add_vec3_plain(pt, rotate_vec3_by_quat_xyzw(lt, pr)))
                    }
                    (Some(pt), Some(lt), None) => Some(add_vec3_plain(pt, lt)),
                    (Some(pt), None, _) => Some(pt),
                    (None, Some(lt), _) => Some(lt),
                    (None, None, _) => None,
                };
                out.contexts.push(XmlContextNode {
                    local_id: local_id.clone(),
                    parent_local_id,
                    tag_name: String::from_utf8_lossy(e.name().as_ref()).to_string(),
                    anchor: resolved_anchor.clone().or_else(|| inherited_anchor.map(|v| v.to_string())),
                    cumulative_translation,
                    cumulative_rotation_xyzw,
                });
                stack.push((
                    local_id,
                    resolved_anchor.or_else(|| inherited_anchor.map(|v| v.to_string())),
                    cumulative_translation,
                    cumulative_rotation_xyzw,
                ));
            }
            Ok(Event::Empty(e)) => {
                seq += 1;
                let local_id = format!("n{seq}");
                let parent_local_id = stack.last().map(|(id, _, _, _)| id.clone());
                let inherited_anchor = stack.last().and_then(|(_, a, _, _)| a.as_deref());
                let parent_translation = stack.last().and_then(|(_, _, t, _)| *t);
                let parent_rotation = stack.last().and_then(|(_, _, _, r)| *r);
                let (resolved_anchor, local_translation, local_rotation) = parse_xml_link_node(
                    &reader,
                    &e,
                    inherited_anchor,
                    local_id.clone(),
                    &mut out.links,
                );
                let local_rotation_q = local_rotation.map(euler_deg_xyz_to_quat_xyz_w);
                let cumulative_rotation_xyzw = match (parent_rotation, local_rotation_q) {
                    (Some(pr), Some(lr)) => Some(quat_mul_xyzw(pr, lr)),
                    (Some(pr), None) => Some(pr),
                    (None, Some(lr)) => Some(lr),
                    (None, None) => None,
                };
                let cumulative_translation = match (parent_translation, local_translation, parent_rotation)
                {
                    (Some(pt), Some(lt), Some(pr)) => {
                        Some(add_vec3_plain(pt, rotate_vec3_by_quat_xyzw(lt, pr)))
                    }
                    (Some(pt), Some(lt), None) => Some(add_vec3_plain(pt, lt)),
                    (Some(pt), None, _) => Some(pt),
                    (None, Some(lt), _) => Some(lt),
                    (None, None, _) => None,
                };
                out.contexts.push(XmlContextNode {
                    local_id,
                    parent_local_id,
                    tag_name: String::from_utf8_lossy(e.name().as_ref()).to_string(),
                    anchor: resolved_anchor.or_else(|| inherited_anchor.map(|v| v.to_string())),
                    cumulative_translation,
                    cumulative_rotation_xyzw,
                });
            }
            Ok(Event::End(_)) => {
                let _ = stack.pop();
            }
            Ok(Event::Eof) => break,
            Err(_) => break,
            _ => {}
        }
        buf.clear();
    }
    out
}

fn collect_material_texture_refs(bytes: &[u8]) -> Vec<String> {
    let mut refs = Vec::new();
    let material = crate::model_convert::material_parser::parse_mtl_bytes(bytes);
    let collect_from = |mat: &crate::model_convert::MaterialData, refs: &mut Vec<String>| {
        if let Some(v) = &mat.base_color {
            if !v.trim().is_empty() {
                refs.push(normalize_path(v));
            }
        }
        for v in &mat.base_color_candidates {
            refs.push(normalize_path(v));
        }
        if let Some(v) = &mat.normal {
            if !v.trim().is_empty() {
                refs.push(normalize_path(v));
            }
        }
        for v in &mat.normal_candidates {
            refs.push(normalize_path(v));
        }
        if let Some(v) = &mat.specular_texture {
            if !v.trim().is_empty() {
                refs.push(normalize_path(v));
            }
        }
        for v in &mat.specular_texture_candidates {
            refs.push(normalize_path(v));
        }
        if let Some(v) = &mat.occlusion {
            if !v.trim().is_empty() {
                refs.push(normalize_path(v));
            }
        }
        for v in &mat.occlusion_candidates {
            refs.push(normalize_path(v));
        }
        if let Some(v) = &mat.emissive {
            if !v.trim().is_empty() {
                refs.push(normalize_path(v));
            }
        }
        for v in &mat.emissive_candidates {
            refs.push(normalize_path(v));
        }
        if let Some(v) = &mat.opacity_texture {
            if !v.trim().is_empty() {
                refs.push(normalize_path(v));
            }
        }
        for v in &mat.opacity_texture_candidates {
            refs.push(normalize_path(v));
        }
    };
    collect_from(&material, &mut refs);
    for sub in &material.sub_materials {
        collect_from(sub, &mut refs);
    }
    refs.sort();
    refs.dedup();
    refs
}

fn build_semantic_graph(
    roots: &[PathBuf],
    asset_root: &Path,
    index: &HashMap<String, String>,
) -> Result<SemanticGraph> {
    let mut graph = SemanticGraph::default();
    let mut visited: HashSet<String> = HashSet::new();
    let mut queue: VecDeque<String> = VecDeque::new();

    graph.add_node("anchor:root".to_string(), "root".to_string(), "anchor");
    for root in roots {
        let normalized = root.to_string_lossy().replace('/', "\\");
        let key = normalize_key(&normalized);
        graph.add_node(key.clone(), to_display_path(root, asset_root), "model");
        queue.push_back(normalized);
    }

    while let Some(current) = queue.pop_front() {
        let current_key = normalize_key(&current);
        if !visited.insert(current_key.clone()) {
            continue;
        }
        let current_kind = classify_kind(&current).to_string();
        if current_kind == "model" {
            for sidecar in sidecar_candidates_for_model(&current) {
                if let Some(hit) = find_path_case_insensitive(index, &sidecar) {
                    let target_key = normalize_key(&hit);
                    graph.add_node(
                        target_key.clone(),
                        to_display_path(Path::new(&hit), asset_root),
                        classify_kind(&hit),
                    );
                    graph.add_edge(current_key.clone(), target_key.clone(), "sidecar", None);
                    if !visited.contains(&target_key) {
                        queue.push_back(hit);
                    }
                }
            }
        }

        let bytes = match fs::read(&current) {
            Ok(v) => v,
            Err(_) => continue,
        };
        match ext_of(&current).as_str() {
            "xml" | "cdf" | "chrparams" | "socpak" => {
                let xml = decode_possible_xml(&bytes);
                let parsed = parse_xml_links(&xml);
                let mut context_global_ids = HashMap::<String, String>::new();
                for context in &parsed.contexts {
                    let global_id = format!("xmlctx:{current_key}:{}", context.local_id);
                    context_global_ids.insert(context.local_id.clone(), global_id.clone());
                    graph.add_node(
                        global_id.clone(),
                        format!(
                            "{}::{}",
                            to_display_path(Path::new(&current), asset_root),
                            context.tag_name
                        ),
                        "xml_context",
                    );
                    if let Some(parent_local) = &context.parent_local_id {
                        if let Some(parent_global) = context_global_ids.get(parent_local) {
                            graph.add_edge(
                                parent_global.clone(),
                                global_id.clone(),
                                "xml_child",
                                None,
                            );
                        } else {
                            graph.add_edge(
                                current_key.clone(),
                                global_id.clone(),
                                "xml_context_root",
                                None,
                            );
                        }
                    } else {
                        graph.add_edge(current_key.clone(), global_id.clone(), "xml_context_root", None);
                    }
                    if let Some(anchor) = &context.anchor {
                        let anchor_id = format!("anchor:{}", normalize_key(anchor));
                        graph.add_node(anchor_id.clone(), anchor.clone(), "anchor");
                        graph.add_edge(anchor_id, global_id.clone(), "context_attachment", None);
                        let anchor_key = normalize_key(anchor);
                        if let Some(t) = context.cumulative_translation {
                            graph.anchor_translations.entry(anchor_key.clone()).or_insert(t);
                        }
                        if let Some(rxyzw) = context.cumulative_rotation_xyzw {
                            graph.anchor_rotations.entry(anchor_key).or_insert(rxyzw);
                        }
                    }
                }

                for link in parsed.links {
                    if link.is_object_container {
                        graph.object_containers.insert(link.target.clone());
                    }
                    if let Some(target) = resolve_reference_path(&current, &link.target, index) {
                        let target_key = normalize_key(&target);
                        graph.add_node(
                            target_key.clone(),
                            to_display_path(Path::new(&target), asset_root),
                            classify_kind(&target),
                        );
                        let source_id = context_global_ids
                            .get(&link.source_context_id)
                            .cloned()
                            .unwrap_or_else(|| current_key.clone());
                        graph.add_edge(source_id, target_key.clone(), "xml_ref", link.anchor.clone());
                        if let Some(anchor) = link.anchor {
                            let anchor_id = format!("anchor:{}", normalize_key(&anchor));
                            graph.add_node(anchor_id.clone(), anchor, "anchor");
                            graph.add_edge(anchor_id, target_key.clone(), "attachment", None);
                        }
                        if !visited.contains(&target_key) {
                            queue.push_back(target);
                        }
                    }
                }
            }
            "mtl" => {
                for tex in collect_material_texture_refs(&bytes) {
                    let resolved = crate::model_convert::path_resolver::resolve_texture_path(
                        &current, &tex, index,
                    )
                    .or_else(|| resolve_reference_path(&current, &tex, index));
                    if let Some(target) = resolved {
                        let target_key = normalize_key(&target);
                        graph.add_node(
                            target_key.clone(),
                            to_display_path(Path::new(&target), asset_root),
                            classify_kind(&target),
                        );
                        graph.add_edge(
                            current_key.clone(),
                            target_key,
                            "material_texture",
                            None,
                        );
                    }
                }
            }
            _ => {}
        }
    }

    Ok(graph)
}

fn collect_dependency_chain(graph: &SemanticGraph, model_abs_path: &str) -> Vec<String> {
    let start = normalize_key(model_abs_path);
    let mut queue = VecDeque::new();
    let mut visited: HashSet<String> = HashSet::new();
    let mut out = Vec::new();
    queue.push_back(start.clone());
    visited.insert(start.clone());

    while let Some(current) = queue.pop_front() {
        for edge in graph.edges.iter().filter(|e| e.from == current) {
            if !visited.insert(edge.to.clone()) {
                continue;
            }
            if let Some(node) = graph.nodes.get(&edge.to) {
                if edge.to != start {
                    out.push(format!("{} ({})", node.source_path, node.kind));
                }
            }
            queue.push_back(edge.to.clone());
        }
    }

    out.sort();
    out.dedup();
    out
}

fn collect_dependency_keys_for_model(graph: &SemanticGraph, model_abs_path: &str) -> HashSet<String> {
    let start = normalize_key(model_abs_path);
    let mut queue = VecDeque::new();
    let mut visited: HashSet<String> = HashSet::new();
    queue.push_back(start.clone());
    visited.insert(start);
    while let Some(current) = queue.pop_front() {
        for edge in graph.edges.iter().filter(|e| e.from == current) {
            if visited.insert(edge.to.clone()) {
                queue.push_back(edge.to.clone());
            }
        }
    }
    visited
}

fn export_dependency_package(
    graph: &SemanticGraph,
    model_paths: &[String],
    asset_root: &Path,
    index: &HashMap<String, String>,
    output_root: &Path,
) -> Result<DependencyPackageSummary> {
    let package_root = output_root.join("_dependency_package");
    let package_assets_root = package_root.join("assets");
    fs::create_dir_all(&package_assets_root)?;

    let mut all_keys = HashSet::<String>::new();
    for model in model_paths {
        let abs_model = asset_root.join(model);
        let abs_str = abs_model.to_string_lossy().replace('/', "\\");
        all_keys.extend(collect_dependency_keys_for_model(graph, &abs_str));
    }

    let mut copied_files = 0usize;
    let mut missing_files = Vec::<String>::new();
    let mut copied_manifest = Vec::<serde_json::Value>::new();
    let mut keys = all_keys.into_iter().collect::<Vec<_>>();
    keys.sort();
    for key in keys {
        // `index` only contains real files discovered from `asset_root`.
        // Graph-only nodes (e.g. xml_context / anchor) are intentionally skipped
        // so they are not reported as missing files in dependency manifests.
        let Some(abs) = index.get(&key).cloned() else {
            continue;
        };
        let source = PathBuf::from(&abs);
        if !source.exists() || !source.is_file() {
            if let Some(node) = graph.nodes.get(&key) {
                missing_files.push(node.source_path.clone());
            } else {
                missing_files.push(abs.clone());
            }
            continue;
        }

        let rel = source
            .strip_prefix(asset_root)
            .map(|p| p.to_path_buf())
            .unwrap_or_else(|_| {
                let file_name = source
                    .file_name()
                    .map(|v| v.to_owned())
                    .unwrap_or_else(|| "unknown.bin".into());
                PathBuf::from("_external").join(file_name)
            });
        let target = package_assets_root.join(&rel);
        if let Some(parent) = target.parent() {
            fs::create_dir_all(parent)?;
        }
        fs::copy(&source, &target)?;
        copied_files += 1;
        copied_manifest.push(json!({
            "source": source.to_string_lossy().to_string(),
            "relative_path": rel.to_string_lossy().replace('/', "\\"),
        }));
    }

    let package_manifest = json!({
        "package_root": package_root.to_string_lossy(),
        "asset_root": asset_root.to_string_lossy(),
        "copied_files": copied_files,
        "missing_files": missing_files,
        "files": copied_manifest,
    });
    fs::write(
        package_root.join("package_manifest.json"),
        serde_json::to_vec_pretty(&package_manifest)?,
    )?;

    Ok(DependencyPackageSummary {
        package_root,
        copied_files,
        missing_files,
    })
}

fn model_anchor_for_key(graph: &SemanticGraph, model_key: &str) -> Option<String> {
    if let Some(anchor) = graph
        .edges
        .iter()
        .find(|e| e.to == model_key && e.relation == "xml_ref" && e.anchor.is_some())
        .and_then(|e| e.anchor.clone())
    {
        return Some(normalize_key(&anchor));
    }

    for edge in graph
        .edges
        .iter()
        .filter(|e| e.to == model_key && (e.relation == "attachment" || e.relation == "xml_ref"))
    {
        if edge.from.starts_with("anchor:") {
            return Some(edge.from.trim_start_matches("anchor:").to_string());
        }
    }
    None
}

fn collect_batch_model_candidates(asset_root: &Path) -> Result<Vec<PathBuf>> {
    let mut out = Vec::new();
    for entry in WalkDir::new(asset_root).into_iter().filter_map(|e| e.ok()) {
        if !entry.file_type().is_file() {
            continue;
        }
        let path = entry.path();
        let ext = path
            .extension()
            .and_then(|s| s.to_str())
            .unwrap_or_default()
            .to_ascii_lowercase();
        if !matches!(ext.as_str(), "cga" | "cgf" | "chr" | "skin") {
            continue;
        }
        out.push(path.to_path_buf());
    }
    out.sort();
    out.dedup();
    Ok(out)
}

fn to_display_path(path: &Path, root: &Path) -> String {
    path.strip_prefix(root)
        .map(|p| p.to_string_lossy().replace('/', "\\"))
        .unwrap_or_else(|_| path.to_string_lossy().to_string())
}

fn is_empty_geometry_error(err: &crate::model_convert::ModelConvertError) -> bool {
    match err {
        crate::model_convert::ModelConvertError::ModelParseFailed(msg) => {
            let lower = msg.to_ascii_lowercase();
            lower.contains("no meshes") || lower.contains("no mesh")
        }
        _ => false,
    }
}
