use regex::Regex;
use unp4k::CryXmlReader;

use super::MaterialData;

pub fn parse_mtl_bytes(bytes: &[u8]) -> MaterialData {
    if is_pbxml(bytes) {
        if let Ok(text) = parse_pbxml_to_xml(bytes) {
            return parse_mtl(&text);
        }
    }

    if CryXmlReader::is_cryxml(bytes) {
        if let Ok(text) = CryXmlReader::parse(bytes) {
            return parse_mtl(&text);
        }
    }

    parse_mtl(&String::from_utf8_lossy(bytes))
}

fn is_pbxml(bytes: &[u8]) -> bool {
    bytes.starts_with(b"pbxml\0")
}

fn parse_pbxml_to_xml(bytes: &[u8]) -> Result<String, String> {
    let mut cursor = PbxmlCursor::new(bytes);
    cursor.read_magic()?;
    let xml = cursor.read_element()?;
    if cursor.remaining() != 0 {
        return Err(format!(
            "trailing bytes after pbxml document: {}",
            cursor.remaining()
        ));
    }
    Ok(xml)
}

struct PbxmlCursor<'a> {
    bytes: &'a [u8],
    pos: usize,
}

const MAX_CRY_INT_BYTES: usize = (usize::BITS as usize + 6) / 7;

impl<'a> PbxmlCursor<'a> {
    fn new(bytes: &'a [u8]) -> Self {
        Self { bytes, pos: 0 }
    }

    fn remaining(&self) -> usize {
        self.bytes.len().saturating_sub(self.pos)
    }

    fn read_magic(&mut self) -> Result<(), String> {
        let magic = self.read_bytes(6)?;
        if magic != b"pbxml\0" {
            return Err("provided stream does not contain a pbxml file".to_string());
        }
        Ok(())
    }

    fn read_element(&mut self) -> Result<String, String> {
        let number_of_children = self.read_cry_int()?;
        let number_of_attributes = self.read_cry_int()?;
        let node_name = self.read_cstring()?;

        let mut xml = String::new();
        xml.push('<');
        xml.push_str(&node_name);

        for _ in 0..number_of_attributes {
            let key = self.read_cstring()?;
            let value = self.read_cstring()?;
            xml.push(' ');
            xml.push_str(&key);
            xml.push_str("=\"");
            xml.push_str(&escape_xml(&value));
            xml.push('"');
        }

        let node_text = self.read_cstring()?;
        if number_of_children == 0 && node_text.is_empty() {
            xml.push_str("/>");
            return Ok(xml);
        }

        xml.push('>');
        if !node_text.is_empty() {
            xml.push_str(&escape_xml(&node_text));
        }

        for child_index in 0..number_of_children {
            let expected_length = self.read_cry_int()?;
            let child_start = self.pos;
            xml.push_str(&self.read_element()?);
            if child_index + 1 != number_of_children {
                let expected_pos = child_start + expected_length;
                if self.pos != expected_pos {
                    return Err(format!(
                        "expected length does not match at child {child_index}: expected pos {expected_pos}, got {}",
                        self.pos
                    ));
                }
            } else if expected_length != 0 {
                return Err("last child node must not have an expectedLength".to_string());
            }
        }

        xml.push_str("</");
        xml.push_str(&node_name);
        xml.push('>');
        Ok(xml)
    }

    fn read_cry_int(&mut self) -> Result<usize, String> {
        let mut bytes_read = 1usize;
        let mut current = self.read_u8()?;
        let mut result = (current & 0x7F) as usize;
        while (current & 0x80) != 0 {
            if bytes_read >= MAX_CRY_INT_BYTES {
                return Err("pbxml integer exceeds usize range".to_string());
            }
            if result > (usize::MAX >> 7) {
                return Err("pbxml integer exceeds usize range".to_string());
            }
            current = self.read_u8()?;
            result = (result << 7) | ((current & 0x7F) as usize);
            bytes_read += 1;
        }
        Ok(result)
    }

    fn read_cstring(&mut self) -> Result<String, String> {
        let start = self.pos;
        while self.read_u8()? != 0 {}
        let end = self.pos - 1;
        Ok(String::from_utf8_lossy(&self.bytes[start..end]).into_owned())
    }

    fn read_u8(&mut self) -> Result<u8, String> {
        let byte = self
            .bytes
            .get(self.pos)
            .copied()
            .ok_or_else(|| "unexpected end of pbxml stream".to_string())?;
        self.pos += 1;
        Ok(byte)
    }

    fn read_bytes(&mut self, len: usize) -> Result<&'a [u8], String> {
        let end = self
            .pos
            .checked_add(len)
            .ok_or_else(|| "pbxml cursor overflow".to_string())?;
        let slice = self
            .bytes
            .get(self.pos..end)
            .ok_or_else(|| "unexpected end of pbxml stream".to_string())?;
        self.pos = end;
        Ok(slice)
    }
}

fn escape_xml(value: &str) -> String {
    let mut out = String::with_capacity(value.len());
    for ch in value.chars() {
        match ch {
            '&' => out.push_str("&amp;"),
            '<' => out.push_str("&lt;"),
            '>' => out.push_str("&gt;"),
            '"' => out.push_str("&quot;"),
            '\'' => out.push_str("&apos;"),
            _ => out.push(ch),
        }
    }
    out
}

pub fn parse_mtl(text: &str) -> MaterialData {
    let mut root = parse_material_block(text);
    root.sub_materials = parse_sub_materials(text);
    root
}

fn parse_sub_materials(text: &str) -> Vec<MaterialData> {
    let sub_section = Regex::new(r"(?is)<SubMaterials\b[^>]*>(.*?)</SubMaterials>")
        .ok()
        .and_then(|re| re.captures(text))
        .and_then(|cap| cap.get(1).map(|m| m.as_str().to_string()));

    let Some(sub_section) = sub_section else {
        return Vec::new();
    };

    let mut out = Vec::new();
    let Ok(material_re) = Regex::new(r"(?is)<Material\b[^>]*>.*?</Material>") else {
        return out;
    };

    for mat_cap in material_re.captures_iter(&sub_section) {
        if let Some(block) = mat_cap.get(0).map(|m| m.as_str()) {
            out.push(parse_material_block(block));
        }
    }

    out
}

fn parse_material_block(text: &str) -> MaterialData {
    let mut mat = MaterialData::default();

    let header_attrs = Regex::new(r#"(?is)<Material\b([^>]*)>"#)
        .ok()
        .and_then(|re| re.captures(text))
        .and_then(|cap| cap.get(1).map(|m| m.as_str().to_string()));
    let attr_re = Regex::new(r#"([A-Za-z0-9_:\-]+)\s*=\s*"([^"]+)""#).ok();
    if let (Some(header_attrs), Some(attr_re)) = (header_attrs, attr_re.as_ref()) {
        for attr in attr_re.captures_iter(&header_attrs) {
            let key = attr
                .get(1)
                .map(|m| m.as_str().to_lowercase())
                .unwrap_or_default();
            let value = attr
                .get(2)
                .map(|m| m.as_str().to_string())
                .unwrap_or_default();
            match key.as_str() {
                "name" => mat.name = Some(value),
                "diffuse" => mat.diffuse = parse_rgb3(&value),
                "specular" => mat.specular = parse_rgb3(&value),
                "emissive" => mat.emissive_color = parse_rgb3(&value),
                "glow" => mat.glow_amount = value.parse::<f32>().ok(),
                "opacity" => mat.opacity = value.parse::<f32>().ok(),
                "shininess" => mat.shininess = value.parse::<f32>().ok(),
                "alphatest" => mat.alpha_test = value.parse::<f32>().ok(),
                "mtlflags" => mat.material_flags = value.parse::<u32>().ok(),
                "shader" => mat.shader = Some(value),
                "stringgenmask" => mat.string_gen_mask = Some(value),
                "glowamount" => mat.glow_amount = value.parse::<f32>().ok(),
                _ => {}
            }
        }
    }

    mat.no_draw = matches!(mat.shader.as_deref(), Some("NoDraw"))
        || mat
            .material_flags
            .map(|flags| (flags & 0x0400) != 0)
            .unwrap_or(false);

    let tex_tag_re = Regex::new(r#"(?is)<Texture\b([^>]*)>"#).ok();
    if let (Some(tex_tag_re), Some(attr_re)) = (tex_tag_re, attr_re) {
        for cap in tex_tag_re.captures_iter(text) {
            let attrs = cap.get(1).map(|m| m.as_str()).unwrap_or_default();
            let mut map_name: Option<String> = None;
            let mut file_path: Option<String> = None;

            for attr in attr_re.captures_iter(attrs) {
                let key = attr
                    .get(1)
                    .map(|m| m.as_str().to_lowercase())
                    .unwrap_or_default();
                let value = attr
                    .get(2)
                    .map(|m| m.as_str().to_string())
                    .unwrap_or_default();
                if key == "map" {
                    map_name = Some(value);
                } else if key == "file" {
                    file_path = Some(value);
                }
            }

            let Some(file) = file_path else {
                continue;
            };
            if !looks_like_image(&file) {
                continue;
            }

            let map_key = normalize_map_name(&map_name.unwrap_or_default(), &file);
            apply_channel_texture(&mut mat, &map_key, file);
        }
    }

    mat
}

fn parse_rgb3(value: &str) -> Option<[f32; 3]> {
    let values = value
        .split(',')
        .map(|part| part.trim().parse::<f32>())
        .collect::<Result<Vec<_>, _>>()
        .ok()?;
    if values.len() != 3 {
        return None;
    }
    Some([values[0], values[1], values[2]])
}

fn looks_like_image(path: &str) -> bool {
    let lower = path.to_lowercase();
    lower.ends_with(".dds")
        || lower.ends_with(".png")
        || lower.ends_with(".tga")
        || lower.ends_with(".tif")
        || lower.ends_with(".tiff")
        || lower.ends_with(".jpg")
        || lower.ends_with(".jpeg")
        || lower.ends_with(".bmp")
}

fn normalize_map_name(map_name: &str, file: &str) -> String {
    let merged = format!("{} {}", map_name.to_lowercase(), file.to_lowercase());
    merged
}

fn apply_channel_texture(material: &mut MaterialData, map_key: &str, file: String) {
    if is_base_color(map_key) {
        material.base_color_candidates.push(file.clone());
        if material.base_color.is_none() {
            material.base_color = Some(file);
        }
        return;
    }

    if is_normal(map_key) {
        material.normal_candidates.push(file.clone());
        if material.normal.is_none() {
            material.normal = Some(file);
        }
        return;
    }

    if is_specular(map_key) {
        material.specular_texture_candidates.push(file.clone());
        if material.specular_texture.is_none() {
            material.specular_texture = Some(file);
        }
        return;
    }

    if is_occlusion(map_key) {
        material.occlusion_candidates.push(file.clone());
        if material.occlusion.is_none() {
            material.occlusion = Some(file);
        }
        return;
    }

    if is_emissive(map_key) {
        material.emissive_candidates.push(file.clone());
        if material.emissive.is_none() {
            material.emissive = Some(file);
        }
        return;
    }

    if is_opacity(map_key) {
        material.opacity_texture_candidates.push(file.clone());
        if material.opacity_texture.is_none() {
            material.opacity_texture = Some(file);
        }
        return;
    }

    // Conservative fallback keeps behavior usable when map labels are irregular.
    if material.base_color.is_none() {
        material.base_color = Some(file);
    }
}

fn is_base_color(key: &str) -> bool {
    key.contains("diff")
        || key.contains("albedo")
        || key.contains("basecolor")
        || key.contains("base_color")
        || key.contains("diffusemap")
        || key.contains("albedomap")
        || key.contains("basecolormap")
        || key.contains("colormap")
        || key.contains("texslot1")
        || key.contains("texslot9")
}

fn is_normal(key: &str) -> bool {
    key.contains("bump")
        || key.contains("normal")
        || key.contains("normalmap")
        || key.contains("bumpmap")
        || contains_token(key, "nrm")
        || contains_token(key, "ddn")
        || key.contains("texslot2")
}

fn is_occlusion(key: &str) -> bool {
    key.contains("occlusion")
        || key.contains("ambientocclusion")
        || key.contains("ambient_occlusion")
        || contains_token(key, "ao")
}

fn is_emissive(key: &str) -> bool {
    key.contains("emiss")
        || key.contains("emittance")
        || key.contains("glow")
        || key.contains("selfillum")
        || key.contains("self_illum")
}

fn is_specular(key: &str) -> bool {
    key.contains("specular")
        || key.contains("specgloss")
        || key.contains("texslot4")
        || key.contains("texslot10")
}

fn is_opacity(key: &str) -> bool {
    key.contains("opacity")
        || key.contains("alpha")
        || key.contains("transparency")
        || key.contains("transluc")
}

fn contains_token(haystack: &str, needle: &str) -> bool {
    haystack
        .split(|c: char| !c.is_ascii_alphanumeric())
        .any(|token| token.eq_ignore_ascii_case(needle))
}

#[cfg(test)]
mod tests {
    use super::{parse_mtl, parse_mtl_bytes, parse_pbxml_to_xml, MAX_CRY_INT_BYTES};
    use std::path::PathBuf;

    fn test_data_path(name: &str) -> PathBuf {
        let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
        manifest_dir
            .join("..")
            .join("Cryengine-Converter-master")
            .join("Cryengine-Converter-master")
            .join("CgfConverterIntegrationTests")
            .join("TestData")
            .join(name)
    }

    #[test]
    fn parse_mtl_extracts_multiple_channels_from_single_material() {
        let text = r#"
            <Material>
              <Texture Map="Diffuse" File="textures/ship_diff.dds" />
              <Texture Map="Bumpmap" File="textures/ship_norm.dds" />
              <Texture Map="Occlusion" File="textures/ship_ao.dds" />
              <Texture Map="Emittance" File="textures/ship_emit.dds" />
              <Texture Map="Opacity" File="textures/ship_alpha.dds" />
            </Material>
        "#;

        let result = parse_mtl(text);
        assert_eq!(result.base_color.as_deref(), Some("textures/ship_diff.dds"));
        assert_eq!(result.normal.as_deref(), Some("textures/ship_norm.dds"));
        assert_eq!(result.occlusion.as_deref(), Some("textures/ship_ao.dds"));
        assert_eq!(result.emissive.as_deref(), Some("textures/ship_emit.dds"));
        assert_eq!(
            result.opacity_texture.as_deref(),
            Some("textures/ship_alpha.dds")
        );
    }

    #[test]
    fn parse_mtl_extracts_sub_materials() {
        let text = r#"
            <Material>
              <SubMaterials>
                <Material Name="m0">
                  <Texture Map="TexSlot1" File="textures/a_diff.dds" />
                  <Texture Map="TexSlot2" File="textures/a_norm.dds" />
                </Material>
                <Material Name="m1">
                  <Texture Map="Diffuse" File="textures/b_diff.dds" />
                  <Texture Map="Opacity" File="textures/b_alpha.dds" />
                </Material>
              </SubMaterials>
            </Material>
        "#;

        let result = parse_mtl(text);
        assert_eq!(result.sub_materials.len(), 2);
        assert_eq!(
            result.sub_materials[0].base_color.as_deref(),
            Some("textures/a_diff.dds")
        );
        assert_eq!(
            result.sub_materials[0].normal.as_deref(),
            Some("textures/a_norm.dds")
        );
        assert_eq!(
            result.sub_materials[1].base_color.as_deref(),
            Some("textures/b_diff.dds")
        );
        assert_eq!(
            result.sub_materials[1].opacity_texture.as_deref(),
            Some("textures/b_alpha.dds")
        );
    }

    #[test]
    fn parse_mtl_falls_back_to_first_image_for_base_color() {
        let text = r#"
            <Material>
              <Texture Map="UnknownTag" File="textures/fallback.png" />
            </Material>
        "#;

        let result = parse_mtl(text);
        assert_eq!(result.base_color.as_deref(), Some("textures/fallback.png"));
    }

    #[test]
    fn parse_mtl_handles_basecolor_and_normal_aliases() {
        let text = r#"
            <Material>
              <Texture Map="BaseColor" File="textures/ship_basecolor.dds" />
              <Texture Map="NormalMap" File="textures/ship_normal.dds" />
              <Texture Map="AmbientOcclusion" File="textures/ship_ao.dds" />
              <Texture Map="Emissive" File="textures/ship_emit.dds" />
              <Texture Map="Transparency" File="textures/ship_opacity.dds" />
            </Material>
        "#;

        let result = parse_mtl(text);
        assert_eq!(
            result.base_color.as_deref(),
            Some("textures/ship_basecolor.dds")
        );
        assert_eq!(result.normal.as_deref(), Some("textures/ship_normal.dds"));
        assert_eq!(result.occlusion.as_deref(), Some("textures/ship_ao.dds"));
        assert_eq!(result.emissive.as_deref(), Some("textures/ship_emit.dds"));
        assert_eq!(
            result.opacity_texture.as_deref(),
            Some("textures/ship_opacity.dds")
        );
    }

    #[test]
    fn parse_mtl_handles_texslot9_as_base_color() {
        let text = r#"
            <Material>
              <Texture Map="TexSlot9" File="textures/ship_diff_slot9.dds" />
            </Material>
        "#;
        let result = parse_mtl(text);
        assert_eq!(
            result.base_color.as_deref(),
            Some("textures/ship_diff_slot9.dds")
        );
    }

    #[test]
    fn parse_mtl_handles_more_common_aliases_for_basecolor_and_normal() {
        let text = r#"
            <Material>
              <Texture Map="DiffuseMap" File="textures/ship_diffuse.dds" />
              <Texture Map="BumpMap" File="textures/ship_bump.dds" />
              <Texture Map="ship_nrm" File="textures/ship_nrm.dds" />
            </Material>
        "#;
        let result = parse_mtl(text);
        assert_eq!(
            result.base_color.as_deref(),
            Some("textures/ship_diffuse.dds")
        );
        assert_eq!(result.normal.as_deref(), Some("textures/ship_bump.dds"));
        assert_eq!(
            result.normal_candidates.last().map(String::as_str),
            Some("textures/ship_nrm.dds")
        );
    }

    #[test]
    fn parse_mtl_bytes_handles_cryxmlb_material_file() {
        let path = test_data_path("pbxml.mtl");
        if !path.exists() {
            eprintln!(
                "skip parse_mtl_bytes_handles_cryxmlb_material_file: missing fixture {path:?}"
            );
            return;
        }
        let bytes = std::fs::read(path).expect("read pbxml fixture");
        let result = parse_mtl_bytes(&bytes);
        assert_eq!(result.sub_materials.len(), 2);
        assert_eq!(result.material_flags, Some(524544));
        assert_eq!(
            result.sub_materials[0].name.as_deref(),
            Some("Check_Point_mat")
        );
    }

    #[test]
    fn parse_mtl_bytes_handles_binary_star_citizen_material_file() {
        let path = test_data_path("SC_mat.mtl");
        if !path.exists() {
            eprintln!(
                "skip parse_mtl_bytes_handles_binary_star_citizen_material_file: missing fixture {path:?}"
            );
            return;
        }
        let bytes = std::fs::read(path).expect("read SC fixture");
        let result = parse_mtl_bytes(&bytes);
        assert_eq!(result.sub_materials.len(), 2);
        assert_eq!(result.sub_materials[0].name.as_deref(), Some("proxy"));
        assert_eq!(
            result.sub_materials[1].name.as_deref(),
            Some("Anodized_01_A")
        );
    }

    #[test]
    fn parse_pbxml_rejects_overlong_integer_encoding() {
        let mut bytes = b"pbxml\0".to_vec();
        bytes.extend(std::iter::repeat(0x81u8).take(MAX_CRY_INT_BYTES + 1));
        bytes.push(0x00);

        let err = parse_pbxml_to_xml(&bytes).expect_err("expected overlong varint rejection");
        assert!(
            err.contains("exceeds usize range"),
            "unexpected error: {err}"
        );
    }
}
