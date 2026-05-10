use std::collections::HashSet;

use anyhow::Result;
use regex::Regex;
use serde::Serialize;

#[derive(Debug, Clone, Serialize, Default)]
pub struct AssemblyModelRef {
    pub model_ref: String,
    pub material_override: Option<String>,
    pub anchor: String,
}

#[derive(Debug, Clone, Serialize, Default)]
pub struct ObjectContainerRef {
    pub file_name: String,
    pub bone_name: String,
    pub offset_position: Option<[f32; 3]>,
    pub offset_rotation: Option<[f32; 3]>,
}

#[derive(Debug, Clone, Serialize, Default)]
pub struct AssemblyGraph {
    pub models: Vec<AssemblyModelRef>,
    pub object_containers: Vec<ObjectContainerRef>,
    pub anchors: Vec<String>,
}

pub fn parse_banu_assembly_graph(xml_text: &str) -> Result<AssemblyGraph> {
    // Capture tagged geometry nodes with optional material override.
    // Keep this focused and non-greedy; full XML parsing is intentionally avoided here.
    let geometry_re = Regex::new(
        r#"(?is)<SGeometryNodeParams\b([^>]*)>.*?<Geometry\s+path="([^"]+\.(?:cga|cgf))"[^>]*/>.*?(?:<Material\s+path="([^"]+\.mtl)"[^>]*/>)?.*?</SGeometryNodeParams>"#,
    )?;
    let tags_re = Regex::new(r#"(?i)\bTags="([^"]*)""#)?;
    let plain_geometry_re = Regex::new(r#"(?i)<Geometry\s+path="([^"]+\.(?:cga|cgf))""#)?;
    let container_block_re = Regex::new(
        r#"(?is)<SVehicleObjectContainerParams\b[^>]*fileName="([^"]+\.socpak)"[^>]*boneName="([^"]*)"[^>]*>(.*?)</SVehicleObjectContainerParams>"#,
    )?;
    let container_self_re = Regex::new(
        r#"(?i)<SVehicleObjectContainerParams\b[^>]*fileName="([^"]+\.socpak)"[^>]*boneName="([^"]*)"[^>]*/>"#,
    )?;
    let position_re =
        Regex::new(r#"(?is)<Position\b[^>]*x="([^"]+)"[^>]*y="([^"]+)"[^>]*z="([^"]+)""#)?;
    let rotation_re =
        Regex::new(r#"(?is)<Rotation\b[^>]*x="([^"]+)"[^>]*y="([^"]+)"[^>]*z="([^"]+)""#)?;

    let mut models = Vec::new();
    let mut object_containers = Vec::new();
    let mut anchors = HashSet::new();
    anchors.insert("root".to_string());

    for cap in geometry_re.captures_iter(xml_text) {
        let attrs = cap.get(1).map(|m| m.as_str()).unwrap_or_default();
        let tags = tags_re
            .captures(attrs)
            .and_then(|m| m.get(1))
            .map(|m| m.as_str().trim().to_string())
            .filter(|s| !s.is_empty())
            .unwrap_or_else(|| "root".to_string());
        let anchor = anchor_from_tags(&tags);
        let model_ref = cap
            .get(2)
            .map(|m| m.as_str().replace('/', "\\"))
            .unwrap_or_default();
        if model_ref.is_empty() {
            continue;
        }
        let material_override = cap
            .get(3)
            .map(|m| m.as_str().replace('/', "\\"))
            .filter(|s| !s.is_empty());
        anchors.insert(anchor.clone());
        models.push(AssemblyModelRef {
            model_ref,
            material_override,
            anchor,
        });
    }

    // Always include plain geometry hits; this avoids dropping models when tagged regex
    // misses nested/irregular node layouts.
    for cap in plain_geometry_re.captures_iter(xml_text) {
        let model_ref = cap
            .get(1)
            .map(|m| m.as_str().replace('/', "\\"))
            .unwrap_or_default();
        if model_ref.is_empty() {
            continue;
        }
        models.push(AssemblyModelRef {
            model_ref,
            material_override: None,
            anchor: "root".to_string(),
        });
    }

    for cap in container_block_re.captures_iter(xml_text) {
        let file_name = cap
            .get(1)
            .map(|m| m.as_str().replace('/', "\\"))
            .unwrap_or_default();
        let bone_name = cap
            .get(2)
            .map(|m| m.as_str().trim().to_string())
            .filter(|s| !s.is_empty())
            .unwrap_or_else(|| "object_container".to_string());
        let body = cap.get(3).map(|m| m.as_str()).unwrap_or_default();
        if file_name.is_empty() {
            continue;
        }

        let offset_position = position_re.captures(body).and_then(|m| {
            Some([
                m.get(1)?.as_str().parse::<f32>().ok()?,
                m.get(2)?.as_str().parse::<f32>().ok()?,
                m.get(3)?.as_str().parse::<f32>().ok()?,
            ])
        });
        let offset_rotation = rotation_re.captures(body).and_then(|m| {
            Some([
                m.get(1)?.as_str().parse::<f32>().ok()?,
                m.get(2)?.as_str().parse::<f32>().ok()?,
                m.get(3)?.as_str().parse::<f32>().ok()?,
            ])
        });

        anchors.insert(bone_name.clone());
        object_containers.push(ObjectContainerRef {
            file_name,
            bone_name,
            offset_position,
            offset_rotation,
        });
    }

    for cap in container_self_re.captures_iter(xml_text) {
        let file_name = cap
            .get(1)
            .map(|m| m.as_str().replace('/', "\\"))
            .unwrap_or_default();
        let bone_name = cap
            .get(2)
            .map(|m| m.as_str().trim().to_string())
            .filter(|s| !s.is_empty())
            .unwrap_or_else(|| "object_container".to_string());
        if file_name.is_empty() {
            continue;
        }
        if object_containers
            .iter()
            .any(|c| c.file_name.eq_ignore_ascii_case(&file_name) && c.bone_name == bone_name)
        {
            continue;
        }
        anchors.insert(bone_name.clone());
        object_containers.push(ObjectContainerRef {
            file_name,
            bone_name,
            offset_position: None,
            offset_rotation: None,
        });
    }

    Ok(AssemblyGraph {
        models,
        object_containers,
        anchors: anchors.into_iter().collect(),
    })
}

fn anchor_from_tags(tags: &str) -> String {
    for token in tags.split_whitespace() {
        if token.to_ascii_lowercase().starts_with("hardpoint_") {
            return token.to_string();
        }
    }
    "root".to_string()
}

#[cfg(test)]
mod tests {
    use super::parse_banu_assembly_graph;

    #[test]
    fn parse_banu_assembly_graph_extracts_geometry_subgeometry_and_containers() {
        let xml = r#"
        <Root>
          <SGeometryNodeParams Tags="Paint_A">
            <Geometry path="Objects\Spaceships\Ships\BANU\Defender\Banu_Defender.cga" />
            <Material path="Objects/Spaceships/Ships/BANU/Defender/banu_defender_a.mtl" />
          </SGeometryNodeParams>
          <SGeometryNodeParams>
            <Geometry path="Objects\Spaceships\Ships\BANU\Defender\Banu_Defender.cga" />
          </SGeometryNodeParams>
          <SVehicleObjectContainerParams fileName="objectcontainers/ships/banu/defender/base_ext_lg.socpak" boneName="hardpoint_exterior_lighting">
            <Offset>
              <Rotation x="0" y="0" z="0" />
              <Position x="1.0" y="2.0" z="3.0" />
            </Offset>
          </SVehicleObjectContainerParams>
        </Root>
        "#;
        let graph = parse_banu_assembly_graph(xml).expect("graph");
        assert!(!graph.models.is_empty());
        assert_eq!(graph.object_containers.len(), 1);
        assert!(graph
            .models
            .iter()
            .any(|m| m.model_ref.eq_ignore_ascii_case(
                "Objects\\Spaceships\\Ships\\BANU\\Defender\\Banu_Defender.cga"
            )));
        assert!(graph
            .anchors
            .iter()
            .any(|a| a == "hardpoint_exterior_lighting"));
        let container = graph
            .object_containers
            .iter()
            .find(|c| c.bone_name == "hardpoint_exterior_lighting")
            .expect("container");
        assert_eq!(container.offset_position, Some([1.0, 2.0, 3.0]));
        assert_eq!(container.offset_rotation, Some([0.0, 0.0, 0.0]));
    }
}
