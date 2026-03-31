use anyhow::{anyhow, Result};
use std::collections::HashMap;

use super::{
    cryengine::{
        cgf::{gltf_trs_from_row_major_matrix, parse_cgf_headers, read_u32_le, CHUNK_TYPE_BASE_746, CHUNK_TYPE_DATA_STREAM, CHUNK_TYPE_MESH},
        chunks::mesh::parse_mesh_chunk_746,
        chunks::node::parse_cgf_node_chunks,
    },
    SceneData,
};

const FILE_SIGNATURE_CRCH: &[u8; 4] = b"CrCh";
const FILE_VERSION_746: u32 = 0x746;

pub fn parse_static_scene(data: &[u8]) -> Result<SceneData> {
    if data.len() < 16 {
        return Err(anyhow!("unsupported binary format: header is too short"));
    }

    let signature = &data[0..4];
    if signature != FILE_SIGNATURE_CRCH {
        return Err(anyhow!(
            "unsupported file signature: expected CrCh, got {:?}",
            signature
        ));
    }

    let headers = parse_cgf_headers(data)?;
    let file_version = read_u32_le(data, 4)?;

    let mesh_headers = headers
        .iter()
        .filter(|h| h.chunk_type_raw == CHUNK_TYPE_MESH)
        .copied()
        .collect::<Vec<_>>();
    if mesh_headers.is_empty() {
        return Err(anyhow!("unsupported chunk set: mesh chunk is missing"));
    }
    let mesh_headers_by_id = mesh_headers
        .iter()
        .map(|header| (header.id, *header))
        .collect::<HashMap<_, _>>();

    let mut warnings = Vec::new();
    let nodes = match parse_cgf_node_chunks(data, &headers) {
        Ok(nodes) => nodes,
        Err(err) => {
            warnings.push(format!(
                "best-effort parse: node chunk parsing failed: {err}"
            ));
            Vec::new()
        }
    };
    if file_version != FILE_VERSION_746 {
        warnings.push(format!(
            "best-effort parse for CrCh version 0x{file_version:X} (validated baseline is 0x{FILE_VERSION_746:X})"
        ));
    }
    let mut meshes = Vec::new();
    for node in &nodes {
        let Some(mesh_header) = mesh_headers_by_id.get(&node.object_node_id).copied() else {
            continue;
        };
        match parse_mesh_chunk_746(data, &headers, mesh_header, &mut warnings) {
            Ok(mut mesh) => {
                let name = if node.name.is_empty() {
                    format!("mesh_{}", mesh_header.id)
                } else {
                    node.name.clone()
                };
                let (translation, rotation, scale) =
                    gltf_trs_from_row_major_matrix(node.local_matrix);
                mesh.name = Some(name.clone());
                mesh.node_name = Some(name);
                mesh.node_translation = Some(translation);
                mesh.node_rotation = Some(rotation);
                mesh.node_scale = Some(scale);
                mesh.node_matrix = None;
                meshes.push(mesh);
            }
            Err(err) => warnings.push(format!(
                "skip mesh chunk id {} at offset {}: {}",
                mesh_header.id, mesh_header.offset, err
            )),
        }
    }

    if meshes.is_empty() {
        for mesh_header in mesh_headers {
            match parse_mesh_chunk_746(data, &headers, mesh_header, &mut warnings) {
                Ok(mesh) => meshes.push(mesh),
                Err(err) => warnings.push(format!(
                    "skip mesh chunk id {} at offset {}: {}",
                    mesh_header.id, mesh_header.offset, err
                )),
            }
        }
    }

    if meshes.is_empty() {
        return Err(anyhow!("no exportable mesh found"));
    }

    Ok(SceneData { meshes, warnings })
}
#[cfg(test)]
mod tests {
    use super::{parse_static_scene, CHUNK_TYPE_BASE_746, CHUNK_TYPE_DATA_STREAM, CHUNK_TYPE_MESH};

    fn push_i32(out: &mut Vec<u8>, v: i32) {
        out.extend_from_slice(&v.to_le_bytes());
    }

    fn push_u32(out: &mut Vec<u8>, v: u32) {
        out.extend_from_slice(&v.to_le_bytes());
    }

    fn push_f32(out: &mut Vec<u8>, v: f32) {
        out.extend_from_slice(&v.to_le_bytes());
    }

    fn build_datastream_chunk(
        stream_type: u32,
        num_elements: u32,
        bytes_per_element: u16,
        payload: &[u8],
    ) -> Vec<u8> {
        let mut out = Vec::new();
        out.extend_from_slice(&0u32.to_le_bytes()); // flags2
        out.extend_from_slice(&stream_type.to_le_bytes());
        out.extend_from_slice(&num_elements.to_le_bytes());
        out.extend_from_slice(&bytes_per_element.to_le_bytes());
        out.extend_from_slice(&0u16.to_le_bytes()); // star citizen flag
        out.extend_from_slice(&0u32.to_le_bytes()); // reserved
        out.extend_from_slice(&0u32.to_le_bytes()); // reserved
        out.extend_from_slice(payload);
        out
    }

    fn build_mesh_chunk(
        num_vertices: i32,
        num_indices: i32,
        subset_count: u32,
        subset_chunk_id: i32,
        mesh_id_vertices: i32,
        mesh_id_normals: i32,
        mesh_id_uvs: i32,
        mesh_id_indices: i32,
    ) -> Vec<u8> {
        let mut out = Vec::new();
        push_i32(&mut out, 0); // flags1
        push_i32(&mut out, 0); // flags2
        push_i32(&mut out, num_vertices);
        push_i32(&mut out, num_indices);
        push_u32(&mut out, subset_count);
        push_i32(&mut out, subset_chunk_id);
        push_i32(&mut out, -1); // verts anim
        push_i32(&mut out, mesh_id_vertices);
        push_i32(&mut out, mesh_id_normals);
        push_i32(&mut out, mesh_id_uvs);
        push_i32(&mut out, -1); // colors
        push_i32(&mut out, -1); // colors2
        push_i32(&mut out, mesh_id_indices);
        push_i32(&mut out, -1); // tangents
        push_i32(&mut out, -1); // sh coeffs
        push_i32(&mut out, -1); // shape deformation
        push_i32(&mut out, -1); // bone map
        push_i32(&mut out, -1); // face map
        push_i32(&mut out, -1); // vert mats
        push_i32(&mut out, -1); // qtangents
        push_i32(&mut out, -1); // skin
        push_i32(&mut out, -1); // dummy2
        push_i32(&mut out, -1); // verts uvs
        for _ in 0..4 {
            push_i32(&mut out, -1); // physics data
        }
        // min/max bounds
        push_f32(&mut out, 0.0);
        push_f32(&mut out, 0.0);
        push_f32(&mut out, 0.0);
        push_f32(&mut out, 1.0);
        push_f32(&mut out, 1.0);
        push_f32(&mut out, 0.0);
        out
    }

    fn build_mesh_chunk_802(
        num_vertices: i32,
        num_indices: i32,
        subset_count: u32,
        subset_chunk_id: i32,
        mesh_id_vertices: i32,
        mesh_id_normals: i32,
        mesh_id_uvs: i32,
        mesh_id_indices: i32,
        mesh_id_verts_uvs: i32,
    ) -> Vec<u8> {
        fn push_stream_ref(out: &mut Vec<u8>, id: i32) {
            push_i32(out, id);
            for _ in 0..7 {
                push_i32(out, 0);
            }
        }

        let mut out = Vec::new();
        push_i32(&mut out, 0); // flags1
        push_i32(&mut out, 0); // flags2
        push_i32(&mut out, num_vertices);
        push_i32(&mut out, num_indices);
        push_u32(&mut out, subset_count);
        push_i32(&mut out, subset_chunk_id);
        push_i32(&mut out, -1); // verts anim
        push_stream_ref(&mut out, mesh_id_vertices);
        push_stream_ref(&mut out, mesh_id_normals);
        push_stream_ref(&mut out, mesh_id_uvs);
        push_stream_ref(&mut out, -1); // colors
        push_stream_ref(&mut out, -1); // colors2
        push_stream_ref(&mut out, mesh_id_indices);
        push_stream_ref(&mut out, -1); // tangents
        push_stream_ref(&mut out, -1); // sh coeffs
        push_stream_ref(&mut out, -1); // shape deformation
        push_stream_ref(&mut out, -1); // bone map
        push_stream_ref(&mut out, -1); // face map
        push_stream_ref(&mut out, -1); // vert mats
        push_stream_ref(&mut out, -1); // qtangents
        push_stream_ref(&mut out, -1); // skin
        push_stream_ref(&mut out, -1); // dummy2
        push_stream_ref(&mut out, mesh_id_verts_uvs);
        for _ in 0..4 {
            push_i32(&mut out, -1); // physics data
        }
        push_f32(&mut out, 0.0);
        push_f32(&mut out, 0.0);
        push_f32(&mut out, 0.0);
        push_f32(&mut out, 1.0);
        push_f32(&mut out, 1.0);
        push_f32(&mut out, 0.0);
        out
    }

    fn build_mesh_subset_chunk_with_header(subsets: &[(i32, i32, i32, i32, i32)]) -> Vec<u8> {
        let mut out = Vec::new();
        push_u32(&mut out, subsets.len() as u32);
        push_u32(&mut out, 0); // reserved
        for (first_index, num_indices, first_vertex, num_vertices, mat_id) in subsets {
            push_i32(&mut out, *first_index);
            push_i32(&mut out, *num_indices);
            push_i32(&mut out, *first_vertex);
            push_i32(&mut out, *num_vertices);
            push_i32(&mut out, *mat_id);
            push_i32(&mut out, 0); // padding
        }
        out
    }

    fn build_node_chunk(
        name: &str,
        object_node_id: i32,
        parent_node_id: i32,
        material_id: i32,
    ) -> Vec<u8> {
        let mut out = Vec::new();
        let mut name_bytes = [0u8; 64];
        let name_raw = name.as_bytes();
        let name_len = name_raw.len().min(63);
        name_bytes[..name_len].copy_from_slice(&name_raw[..name_len]);
        out.extend_from_slice(&name_bytes);
        out.extend_from_slice(&object_node_id.to_le_bytes());
        out.extend_from_slice(&parent_node_id.to_le_bytes());
        out.extend_from_slice(&0i32.to_le_bytes());
        out.extend_from_slice(&material_id.to_le_bytes());
        out.extend_from_slice(&0u32.to_le_bytes());
        for value in [
            1.0f32, 0.0, 0.0, 0.0, //
            0.0, 1.0, 0.0, 0.0, //
            0.0, 0.0, 1.0, 0.0, //
            0.0, 0.0, 0.0, 1.0,
        ] {
            out.extend_from_slice(&value.to_le_bytes());
        }
        out.extend_from_slice(&[0u8; 64]);
        out.extend_from_slice(&0u32.to_le_bytes());
        out.extend_from_slice(&0u32.to_le_bytes());
        out.extend_from_slice(&1.0f32.to_le_bytes());
        out.extend_from_slice(&0.0f32.to_le_bytes());
        out.extend_from_slice(&0.0f32.to_le_bytes());
        out.extend_from_slice(&0.0f32.to_le_bytes());
        out.extend_from_slice(&0u32.to_le_bytes());
        out.extend_from_slice(&0u32.to_le_bytes());
        out.extend_from_slice(&0u32.to_le_bytes());
        out.extend_from_slice(&0u32.to_le_bytes());
        out
    }

    fn half_bits(value: f32) -> u16 {
        if value == 0.0 {
            0
        } else if value == 1.0 {
            0x3C00
        } else {
            panic!("test helper half_bits only supports 0.0 or 1.0");
        }
    }

    fn encode_chunk_header(
        chunk_type: u32,
        version: u16,
        id: i32,
        size: u32,
        offset: u32,
        out: &mut Vec<u8>,
    ) {
        let low = (chunk_type - CHUNK_TYPE_BASE_746) as u16;
        out.extend_from_slice(&low.to_le_bytes());
        out.extend_from_slice(&version.to_le_bytes());
        out.extend_from_slice(&id.to_le_bytes());
        out.extend_from_slice(&size.to_le_bytes());
        out.extend_from_slice(&offset.to_le_bytes());
    }

    fn build_crch_file(file_version: u32, chunks: Vec<(u32, u16, i32, Vec<u8>)>) -> Vec<u8> {
        let mut file = Vec::new();
        file.extend_from_slice(b"CrCh");
        file.extend_from_slice(&file_version.to_le_bytes());
        file.extend_from_slice(&(chunks.len() as u32).to_le_bytes());
        file.extend_from_slice(&16u32.to_le_bytes());

        let table_start = file.len();
        file.resize(table_start + chunks.len() * 16, 0u8);

        let mut offset = (table_start + chunks.len() * 16) as u32;
        let mut headers = Vec::new();
        for (chunk_type, version, id, payload) in &chunks {
            encode_chunk_header(
                *chunk_type,
                *version,
                *id,
                payload.len() as u32,
                offset,
                &mut headers,
            );
            offset += payload.len() as u32;
        }
        file[table_start..table_start + headers.len()].copy_from_slice(&headers);

        for (_, _, _, payload) in chunks {
            file.extend_from_slice(&payload);
        }
        file
    }

    fn build_minimal_746_triangle() -> Vec<u8> {
        let vertices_payload = [
            0.0f32, 0.0, 0.0, //
            1.0, 0.0, 0.0, //
            0.0, 1.0, 0.0,
        ]
        .into_iter()
        .flat_map(|v| v.to_le_bytes())
        .collect::<Vec<_>>();
        let normals_payload = [
            0.0f32, 0.0, 1.0, //
            0.0, 0.0, 1.0, //
            0.0, 0.0, 1.0,
        ]
        .into_iter()
        .flat_map(|v| v.to_le_bytes())
        .collect::<Vec<_>>();
        let uvs_payload = [
            0.0f32, 0.0, //
            1.0, 0.0, //
            0.0, 1.0,
        ]
        .into_iter()
        .flat_map(|v| v.to_le_bytes())
        .collect::<Vec<_>>();
        let indices_payload = vec![0u8, 0, 1, 0, 2, 0];

        let mesh = build_mesh_chunk(3, 3, 0, -1, 2, 3, 4, 5);
        let ds_vertices = build_datastream_chunk(0, 3, 12, &vertices_payload);
        let ds_normals = build_datastream_chunk(1, 3, 12, &normals_payload);
        let ds_uvs = build_datastream_chunk(2, 3, 8, &uvs_payload);
        let ds_indices = build_datastream_chunk(5, 3, 2, &indices_payload);

        let mut file = Vec::new();
        file.extend_from_slice(b"CrCh");
        file.extend_from_slice(&0x746u32.to_le_bytes());
        file.extend_from_slice(&5u32.to_le_bytes()); // num chunks
        file.extend_from_slice(&16u32.to_le_bytes()); // chunk table offset

        let table_start = file.len();
        file.resize(table_start + 5 * 16, 0u8);

        let mut offset = (table_start + 5 * 16) as u32;
        let mesh_offset = offset;
        offset += mesh.len() as u32;
        let v_offset = offset;
        offset += ds_vertices.len() as u32;
        let n_offset = offset;
        offset += ds_normals.len() as u32;
        let uv_offset = offset;
        offset += ds_uvs.len() as u32;
        let i_offset = offset;

        {
            let mut headers = Vec::new();
            encode_chunk_header(
                CHUNK_TYPE_MESH,
                0x0800,
                1,
                mesh.len() as u32,
                mesh_offset,
                &mut headers,
            );
            encode_chunk_header(
                CHUNK_TYPE_DATA_STREAM,
                0x0800,
                2,
                ds_vertices.len() as u32,
                v_offset,
                &mut headers,
            );
            encode_chunk_header(
                CHUNK_TYPE_DATA_STREAM,
                0x0800,
                3,
                ds_normals.len() as u32,
                n_offset,
                &mut headers,
            );
            encode_chunk_header(
                CHUNK_TYPE_DATA_STREAM,
                0x0800,
                4,
                ds_uvs.len() as u32,
                uv_offset,
                &mut headers,
            );
            encode_chunk_header(
                CHUNK_TYPE_DATA_STREAM,
                0x0800,
                5,
                ds_indices.len() as u32,
                i_offset,
                &mut headers,
            );
            file[table_start..table_start + headers.len()].copy_from_slice(&headers);
        }

        file.extend_from_slice(&mesh);
        file.extend_from_slice(&ds_vertices);
        file.extend_from_slice(&ds_normals);
        file.extend_from_slice(&ds_uvs);
        file.extend_from_slice(&ds_indices);
        file
    }

    #[test]
    fn parse_static_scene_reads_minimal_746_triangle() {
        let data = build_minimal_746_triangle();
        let scene = parse_static_scene(&data).expect("expected valid parse");
        assert_eq!(scene.meshes.len(), 1);
        let mesh = &scene.meshes[0];
        assert_eq!(mesh.positions.len(), 3);
        assert_eq!(mesh.normals.len(), 3);
        assert_eq!(mesh.uvs.len(), 3);
        assert_eq!(mesh.indices, vec![0, 1, 2]);
    }

    #[test]
    fn parse_static_scene_allows_non_746_as_best_effort() {
        let mut data = build_minimal_746_triangle();
        data[4..8].copy_from_slice(&0x745u32.to_le_bytes());
        let scene = parse_static_scene(&data).expect("best-effort parse should succeed");
        assert_eq!(scene.meshes.len(), 1);
        assert!(
            scene
                .warnings
                .iter()
                .any(|w| w.contains("best-effort parse")),
            "warnings: {:?}",
            scene.warnings
        );
    }

    #[test]
    fn parse_static_scene_rejects_invalid_signature() {
        let mut data = build_minimal_746_triangle();
        data[0..4].copy_from_slice(b"CryT");
        let err = parse_static_scene(&data).expect_err("expected unsupported signature");
        assert!(err.to_string().contains("unsupported file signature"));
    }

    #[test]
    fn parse_static_scene_reads_multiple_mesh_chunks() {
        let base = build_minimal_746_triangle();
        let scene = parse_static_scene(&base).expect("parse");
        assert_eq!(scene.meshes.len(), 1);

        let vertices_payload = [
            0.0f32, 0.0, 0.0, //
            1.0, 0.0, 0.0, //
            0.0, 1.0, 0.0,
        ]
        .into_iter()
        .flat_map(|v| v.to_le_bytes())
        .collect::<Vec<_>>();
        let normals_payload = [
            0.0f32, 0.0, 1.0, //
            0.0, 0.0, 1.0, //
            0.0, 0.0, 1.0,
        ]
        .into_iter()
        .flat_map(|v| v.to_le_bytes())
        .collect::<Vec<_>>();
        let uvs_payload = [
            0.0f32, 0.0, //
            1.0, 0.0, //
            0.0, 1.0,
        ]
        .into_iter()
        .flat_map(|v| v.to_le_bytes())
        .collect::<Vec<_>>();
        let indices_payload = vec![0u8, 0, 1, 0, 2, 0];

        let chunks = vec![
            (
                CHUNK_TYPE_MESH,
                0x0800,
                1,
                build_mesh_chunk(3, 3, 0, -1, 2, 3, 4, 5),
            ),
            (
                CHUNK_TYPE_DATA_STREAM,
                0x0800,
                2,
                build_datastream_chunk(0, 3, 12, &vertices_payload),
            ),
            (
                CHUNK_TYPE_DATA_STREAM,
                0x0800,
                3,
                build_datastream_chunk(1, 3, 12, &normals_payload),
            ),
            (
                CHUNK_TYPE_DATA_STREAM,
                0x0800,
                4,
                build_datastream_chunk(2, 3, 8, &uvs_payload),
            ),
            (
                CHUNK_TYPE_DATA_STREAM,
                0x0800,
                5,
                build_datastream_chunk(5, 3, 2, &indices_payload),
            ),
            (
                CHUNK_TYPE_MESH,
                0x0800,
                11,
                build_mesh_chunk(3, 3, 0, -1, 12, 13, 14, 15),
            ),
            (
                CHUNK_TYPE_DATA_STREAM,
                0x0800,
                12,
                build_datastream_chunk(0, 3, 12, &vertices_payload),
            ),
            (
                CHUNK_TYPE_DATA_STREAM,
                0x0800,
                13,
                build_datastream_chunk(1, 3, 12, &normals_payload),
            ),
            (
                CHUNK_TYPE_DATA_STREAM,
                0x0800,
                14,
                build_datastream_chunk(2, 3, 8, &uvs_payload),
            ),
            (
                CHUNK_TYPE_DATA_STREAM,
                0x0800,
                15,
                build_datastream_chunk(5, 3, 2, &indices_payload),
            ),
        ];
        let data = build_crch_file(0x746, chunks);
        let parsed = parse_static_scene(&data).expect("parse multi mesh");
        assert_eq!(parsed.meshes.len(), 2);
    }

    #[test]
    fn parse_static_scene_reads_subset_primitives_with_material_ids() {
        let vertices_payload = [
            0.0f32, 0.0, 0.0, //
            1.0, 0.0, 0.0, //
            0.0, 1.0, 0.0,
        ]
        .into_iter()
        .flat_map(|v| v.to_le_bytes())
        .collect::<Vec<_>>();
        let normals_payload = [
            0.0f32, 0.0, 1.0, //
            0.0, 0.0, 1.0, //
            0.0, 0.0, 1.0,
        ]
        .into_iter()
        .flat_map(|v| v.to_le_bytes())
        .collect::<Vec<_>>();
        let uvs_payload = [
            0.0f32, 0.0, //
            1.0, 0.0, //
            0.0, 1.0,
        ]
        .into_iter()
        .flat_map(|v| v.to_le_bytes())
        .collect::<Vec<_>>();
        let indices_payload = vec![0u8, 0, 1, 0, 2, 0];
        let subsets = build_mesh_subset_chunk_with_header(&[(0, 3, 0, 3, 5), (0, 3, 0, 3, 9)]);

        let chunks = vec![
            (
                CHUNK_TYPE_MESH,
                0x0900,
                1,
                build_mesh_chunk(3, 3, 2, 10, 2, 3, 4, 5),
            ),
            (CHUNK_TYPE_MESH, 0x0900, 11, vec![1, 2, 3]), // invalid mesh, should be skipped
            (CHUNK_TYPE_BASE_746 + 0x0001, 0x0900, 10, subsets),
            (
                CHUNK_TYPE_DATA_STREAM,
                0x0800,
                2,
                build_datastream_chunk(0, 3, 12, &vertices_payload),
            ),
            (
                CHUNK_TYPE_DATA_STREAM,
                0x0800,
                3,
                build_datastream_chunk(1, 3, 12, &normals_payload),
            ),
            (
                CHUNK_TYPE_DATA_STREAM,
                0x0800,
                4,
                build_datastream_chunk(2, 3, 8, &uvs_payload),
            ),
            (
                CHUNK_TYPE_DATA_STREAM,
                0x0800,
                5,
                build_datastream_chunk(5, 3, 2, &indices_payload),
            ),
        ];
        let data = build_crch_file(0x900, chunks);
        let scene = parse_static_scene(&data).expect("parse");
        assert_eq!(scene.meshes.len(), 1);
        assert_eq!(scene.meshes[0].primitives.len(), 2);
        assert_eq!(scene.meshes[0].primitives[0].material_id, 5);
        assert_eq!(scene.meshes[0].primitives[1].material_id, 9);
    }

    #[test]
    fn parse_static_scene_fallbacks_to_single_primitive_when_subset_missing() {
        let vertices_payload = [
            0.0f32, 0.0, 0.0, //
            1.0, 0.0, 0.0, //
            0.0, 1.0, 0.0,
        ]
        .into_iter()
        .flat_map(|v| v.to_le_bytes())
        .collect::<Vec<_>>();
        let normals_payload = [
            0.0f32, 0.0, 1.0, //
            0.0, 0.0, 1.0, //
            0.0, 0.0, 1.0,
        ]
        .into_iter()
        .flat_map(|v| v.to_le_bytes())
        .collect::<Vec<_>>();
        let uvs_payload = [
            0.0f32, 0.0, //
            1.0, 0.0, //
            0.0, 1.0,
        ]
        .into_iter()
        .flat_map(|v| v.to_le_bytes())
        .collect::<Vec<_>>();
        let indices_payload = vec![0u8, 0, 1, 0, 2, 0];

        let chunks = vec![
            (
                CHUNK_TYPE_MESH,
                0x0802,
                1,
                build_mesh_chunk_802(3, 3, 1, 99, 2, 3, 4, 5, -1),
            ),
            (
                CHUNK_TYPE_DATA_STREAM,
                0x0800,
                2,
                build_datastream_chunk(0, 3, 12, &vertices_payload),
            ),
            (
                CHUNK_TYPE_DATA_STREAM,
                0x0800,
                3,
                build_datastream_chunk(1, 3, 12, &normals_payload),
            ),
            (
                CHUNK_TYPE_DATA_STREAM,
                0x0800,
                4,
                build_datastream_chunk(2, 3, 8, &uvs_payload),
            ),
            (
                CHUNK_TYPE_DATA_STREAM,
                0x0800,
                5,
                build_datastream_chunk(5, 3, 2, &indices_payload),
            ),
        ];
        let data = build_crch_file(0x746, chunks);
        let scene = parse_static_scene(&data).expect("parse");
        assert_eq!(scene.meshes.len(), 1);
        assert_eq!(scene.meshes[0].primitives.len(), 1);
        assert_eq!(scene.meshes[0].primitives[0].material_id, -1);
        assert!(
            scene
                .warnings
                .iter()
                .any(|w| w.contains("fallback to full-index primitive")),
            "warnings: {:?}",
            scene.warnings
        );
    }

    #[test]
    fn parse_static_scene_reads_mesh_802_layout_stream_references() {
        let vertices_payload = [
            0.0f32, 0.0, 0.0, //
            1.0, 0.0, 0.0, //
            0.0, 1.0, 0.0,
        ]
        .into_iter()
        .flat_map(|v| v.to_le_bytes())
        .collect::<Vec<_>>();
        let normals_payload = [
            0.0f32, 0.0, 1.0, //
            0.0, 0.0, 1.0, //
            0.0, 0.0, 1.0,
        ]
        .into_iter()
        .flat_map(|v| v.to_le_bytes())
        .collect::<Vec<_>>();
        let uvs_payload = [
            0.0f32, 0.0, //
            1.0, 0.0, //
            0.0, 1.0,
        ]
        .into_iter()
        .flat_map(|v| v.to_le_bytes())
        .collect::<Vec<_>>();
        let indices_payload = vec![0u8, 0, 1, 0, 2, 0];

        let chunks = vec![
            (
                CHUNK_TYPE_MESH,
                0x0802,
                1,
                build_mesh_chunk_802(3, 3, 0, -1, 2, 3, 4, 5, -1),
            ),
            (
                CHUNK_TYPE_DATA_STREAM,
                0x0800,
                2,
                build_datastream_chunk(0, 3, 12, &vertices_payload),
            ),
            (
                CHUNK_TYPE_DATA_STREAM,
                0x0800,
                3,
                build_datastream_chunk(1, 3, 12, &normals_payload),
            ),
            (
                CHUNK_TYPE_DATA_STREAM,
                0x0800,
                4,
                build_datastream_chunk(2, 3, 8, &uvs_payload),
            ),
            (
                CHUNK_TYPE_DATA_STREAM,
                0x0800,
                5,
                build_datastream_chunk(5, 3, 2, &indices_payload),
            ),
        ];
        let data = build_crch_file(0x746, chunks);
        let scene = parse_static_scene(&data).expect("parse");
        assert_eq!(scene.meshes.len(), 1);
        assert_eq!(scene.meshes[0].positions.len(), 3);
        assert_eq!(scene.meshes[0].uvs.len(), 3);
    }

    #[test]
    fn parse_static_scene_fallbacks_to_verts_uv_stream_for_missing_vertex_and_uv_streams() {
        let mut verts_uv_payload = Vec::new();
        for (x, y, z, u, v) in [
            (0.0f32, 0.0f32, 0.0f32, 0.0f32, 0.0f32),
            (1.0f32, 0.0f32, 0.0f32, 1.0f32, 0.0f32),
            (0.0f32, 1.0f32, 0.0f32, 0.0f32, 1.0f32),
        ] {
            verts_uv_payload.extend_from_slice(&x.to_le_bytes());
            verts_uv_payload.extend_from_slice(&y.to_le_bytes());
            verts_uv_payload.extend_from_slice(&z.to_le_bytes());
            verts_uv_payload.extend_from_slice(&0u32.to_le_bytes()); // color
            verts_uv_payload.extend_from_slice(&half_bits(u).to_le_bytes());
            verts_uv_payload.extend_from_slice(&half_bits(v).to_le_bytes());
        }

        let normals_payload = [
            0.0f32, 0.0, 1.0, //
            0.0, 0.0, 1.0, //
            0.0, 0.0, 1.0,
        ]
        .into_iter()
        .flat_map(|v| v.to_le_bytes())
        .collect::<Vec<_>>();
        let indices_payload = vec![0u8, 0, 1, 0, 2, 0];

        let mut mesh = build_mesh_chunk(3, 3, 0, -1, -1, 3, -1, 5);
        // patch verts_uvs_id (index 22, 4 bytes per i32 after header fields)
        let verts_uv_offset = 4 * 22;
        mesh[verts_uv_offset..verts_uv_offset + 4].copy_from_slice(&6i32.to_le_bytes());
        let chunks = vec![
            (CHUNK_TYPE_MESH, 0x0800, 1, mesh),
            (
                CHUNK_TYPE_DATA_STREAM,
                0x0800,
                3,
                build_datastream_chunk(1, 3, 12, &normals_payload),
            ),
            (
                CHUNK_TYPE_DATA_STREAM,
                0x0800,
                5,
                build_datastream_chunk(5, 3, 2, &indices_payload),
            ),
            (
                CHUNK_TYPE_DATA_STREAM,
                0x0800,
                6,
                build_datastream_chunk(15, 3, 20, &verts_uv_payload),
            ),
        ];
        let data = build_crch_file(0x746, chunks);
        let scene = parse_static_scene(&data).expect("parse");
        assert_eq!(scene.meshes.len(), 1);
        assert_eq!(scene.meshes[0].positions.len(), 3);
        assert_eq!(scene.meshes[0].uvs.len(), 3);
        assert!(
            scene
                .warnings
                .iter()
                .any(|w| w.contains("fallback to VERTSUVS chunk")),
            "warnings: {:?}",
            scene.warnings
        );
    }

    #[test]
    fn parse_static_scene_attaches_node_names_and_identity_matrices() {
        let vertices_payload = [
            0.0f32, 0.0, 0.0, //
            1.0, 0.0, 0.0, //
            0.0, 1.0, 0.0,
        ]
        .into_iter()
        .flat_map(|v| v.to_le_bytes())
        .collect::<Vec<_>>();
        let normals_payload = [
            0.0f32, 0.0, 1.0, //
            0.0, 0.0, 1.0, //
            0.0, 0.0, 1.0,
        ]
        .into_iter()
        .flat_map(|v| v.to_le_bytes())
        .collect::<Vec<_>>();
        let uvs_payload = [
            0.0f32, 0.0, //
            1.0, 0.0, //
            0.0, 1.0,
        ]
        .into_iter()
        .flat_map(|v| v.to_le_bytes())
        .collect::<Vec<_>>();
        let indices_payload = vec![0u8, 0, 1, 0, 2, 0];

        let chunks = vec![
            (
                CHUNK_TYPE_MESH,
                0x0800,
                10,
                build_mesh_chunk(3, 3, 0, -1, 2, 3, 4, 5),
            ),
            (
                0xCCCC_000B,
                0x0823,
                1,
                build_node_chunk("cargo_hull", 10, -1, 0),
            ),
            (
                CHUNK_TYPE_DATA_STREAM,
                0x0800,
                2,
                build_datastream_chunk(0, 3, 12, &vertices_payload),
            ),
            (
                CHUNK_TYPE_DATA_STREAM,
                0x0800,
                3,
                build_datastream_chunk(1, 3, 12, &normals_payload),
            ),
            (
                CHUNK_TYPE_DATA_STREAM,
                0x0800,
                4,
                build_datastream_chunk(2, 3, 8, &uvs_payload),
            ),
            (
                CHUNK_TYPE_DATA_STREAM,
                0x0800,
                5,
                build_datastream_chunk(5, 3, 2, &indices_payload),
            ),
        ];
        let data = build_crch_file(0x746, chunks);
        let scene = parse_static_scene(&data).expect("parse");
        assert_eq!(scene.meshes.len(), 1);
        assert_eq!(scene.meshes[0].name.as_deref(), Some("cargo_hull"));
        assert_eq!(scene.meshes[0].node_name.as_deref(), Some("cargo_hull"));
        assert_eq!(scene.meshes[0].node_translation, Some([0.0, 0.0, 0.0]));
        assert_eq!(scene.meshes[0].node_rotation, Some([0.0, 0.0, 0.0, 1.0]));
        assert_eq!(scene.meshes[0].node_scale, Some([1.0, 1.0, 1.0]));
        assert_eq!(scene.meshes[0].node_matrix, None);
    }
}
