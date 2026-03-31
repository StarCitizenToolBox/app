use anyhow::{anyhow, Result};

use crate::model_convert::cryengine::cgf::{
    chunk_slice, read_i32_chunk, read_u32_chunk, skip_chunk_bytes, CgfChunkHeader,
};
use crate::model_convert::cryengine::chunks::datastream::{
    parse_indices_stream, parse_normals_stream, parse_positions_stream, parse_uv_stream,
    parse_verts_uv_stream, STREAM_INDICES,
};
use crate::model_convert::cryengine::chunks::mesh_subsets::parse_mesh_subsets_chunk;
use crate::model_convert::{SceneMesh, ScenePrimitive};

#[derive(Debug, Clone, Copy)]
struct MeshChunkRefs {
    num_vertices: usize,
    num_indices: usize,
    num_vert_subsets: u32,
    mesh_subsets_id: i32,
    vertices_id: i32,
    normals_id: i32,
    uvs_id: i32,
    indices_id: i32,
    verts_uvs_id: i32,
}

pub(crate) fn parse_mesh_chunk_746(
    data: &[u8],
    headers: &[CgfChunkHeader],
    mesh_header: CgfChunkHeader,
    warnings: &mut Vec<String>,
) -> Result<SceneMesh> {
    let chunk = chunk_slice(data, mesh_header)?;
    let refs = parse_mesh_refs(chunk, mesh_header.version)?;

    if refs.num_vertices == 0 || refs.num_indices == 0 {
        return Err(anyhow!("unsupported mesh format: empty geometry"));
    }

    let verts_uv_fallback = if refs.verts_uvs_id >= 0 {
        parse_verts_uv_stream(data, headers, refs.verts_uvs_id, refs.num_vertices).ok()
    } else {
        None
    };

    let positions = match parse_positions_stream(data, headers, refs.vertices_id, refs.num_vertices)
    {
        Ok(v) => v,
        Err(err) => {
            if let Some((positions, _)) = &verts_uv_fallback {
                warnings.push(format!(
                    "mesh chunk id {} vertices stream parse failed (chunk id {}): {}; fallback to VERTSUVS chunk {}",
                    mesh_header.id, refs.vertices_id, err, refs.verts_uvs_id
                ));
                positions.clone()
            } else {
                return Err(err);
            }
        }
    };
    let indices = parse_indices_stream(
        data,
        headers,
        refs.indices_id,
        STREAM_INDICES,
        refs.num_indices,
    )?;
    let normals = match parse_normals_stream(data, headers, refs.normals_id, refs.num_vertices) {
        Ok(v) => v,
        Err(err) => {
            warnings.push(format!(
                "mesh chunk id {} normals stream parse failed (chunk id {}): {}; generated from geometry",
                mesh_header.id, refs.normals_id, err
            ));
            build_normals_from_geometry(&positions, &indices)
        }
    };
    let uvs = match parse_uv_stream(data, headers, refs.uvs_id, refs.num_vertices) {
        Ok(v) => v,
        Err(err) => {
            if let Some((_, uvs)) = &verts_uv_fallback {
                warnings.push(format!(
                    "mesh chunk id {} uv stream parse failed (chunk id {}): {}; fallback to VERTSUVS chunk {}",
                    mesh_header.id, refs.uvs_id, err, refs.verts_uvs_id
                ));
                uvs.clone()
            } else {
                warnings.push(format!(
                    "mesh chunk id {} uv stream parse failed (chunk id {}): {}; fallback to zero UVs",
                    mesh_header.id, refs.uvs_id, err
                ));
                vec![[0.0, 0.0]; refs.num_vertices]
            }
        }
    };

    let primitives = if refs.mesh_subsets_id >= 0 {
        match parse_mesh_subsets_chunk(
            data,
            headers,
            refs.mesh_subsets_id,
            refs.num_vert_subsets as usize,
            refs.num_indices,
            refs.num_vertices,
        ) {
            Ok(parsed) if !parsed.is_empty() => parsed,
            Ok(_) => {
                warnings.push(format!(
                    "mesh chunk id {} has empty subsets chunk {}; fallback to full-index primitive",
                    mesh_header.id, refs.mesh_subsets_id
                ));
                vec![fallback_single_primitive(
                    refs.num_indices,
                    refs.num_vertices,
                )]
            }
            Err(err) => {
                warnings.push(format!(
                    "mesh chunk id {} failed to parse subsets chunk {} (mesh v0x{:X}): {}; fallback to full-index primitive",
                    mesh_header.id, refs.mesh_subsets_id, mesh_header.version, err
                ));
                vec![fallback_single_primitive(
                    refs.num_indices,
                    refs.num_vertices,
                )]
            }
        }
    } else {
        vec![fallback_single_primitive(
            refs.num_indices,
            refs.num_vertices,
        )]
    };

    Ok(SceneMesh {
        positions,
        normals,
        uvs,
        joints: None,
        weights: None,
        indices,
        index_accessor_source: None,
        primitives,
        name: None,
        node_name: None,
        node_translation: None,
        node_rotation: None,
        node_scale: None,
        node_matrix: None,
    })
}

fn parse_mesh_refs(chunk: &[u8], version: u16) -> Result<MeshChunkRefs> {
    let mut cursor = 0usize;
    let _flags1 = read_i32_chunk(chunk, &mut cursor)?;
    let _flags2 = read_i32_chunk(chunk, &mut cursor)?;
    let num_vertices = read_i32_chunk(chunk, &mut cursor)? as usize;
    let num_indices = read_i32_chunk(chunk, &mut cursor)? as usize;
    let num_vert_subsets = read_u32_chunk(chunk, &mut cursor)?;
    let mesh_subsets_id = read_i32_chunk(chunk, &mut cursor)?;
    let _verts_anim_id = read_i32_chunk(chunk, &mut cursor)?;

    let (vertices_id, normals_id, uvs_id, indices_id, verts_uvs_id) = if version == 0x0802 {
        let vertices_id = read_i32_chunk(chunk, &mut cursor)?;
        skip_chunk_bytes(chunk, &mut cursor, 28)?;
        let normals_id = read_i32_chunk(chunk, &mut cursor)?;
        skip_chunk_bytes(chunk, &mut cursor, 28)?;
        let uvs_id = read_i32_chunk(chunk, &mut cursor)?;
        skip_chunk_bytes(chunk, &mut cursor, 28)?;
        skip_chunk_bytes(chunk, &mut cursor, 32)?;
        skip_chunk_bytes(chunk, &mut cursor, 32)?;
        let indices_id = read_i32_chunk(chunk, &mut cursor)?;
        skip_chunk_bytes(chunk, &mut cursor, 28)?;
        skip_chunk_bytes(chunk, &mut cursor, 32)?;
        skip_chunk_bytes(chunk, &mut cursor, 32)?;
        skip_chunk_bytes(chunk, &mut cursor, 32)?;
        skip_chunk_bytes(chunk, &mut cursor, 32)?;
        skip_chunk_bytes(chunk, &mut cursor, 32)?;
        skip_chunk_bytes(chunk, &mut cursor, 32)?;
        skip_chunk_bytes(chunk, &mut cursor, 32)?;
        skip_chunk_bytes(chunk, &mut cursor, 32)?;
        skip_chunk_bytes(chunk, &mut cursor, 32)?;
        let verts_uvs_id = read_i32_chunk(chunk, &mut cursor)?;
        skip_chunk_bytes(chunk, &mut cursor, 28)?;
        (vertices_id, normals_id, uvs_id, indices_id, verts_uvs_id)
    } else {
        let vertices_id = read_i32_chunk(chunk, &mut cursor)?;
        let normals_id = read_i32_chunk(chunk, &mut cursor)?;
        let uvs_id = read_i32_chunk(chunk, &mut cursor)?;
        let _colors_id = read_i32_chunk(chunk, &mut cursor)?;
        let _colors2_id = read_i32_chunk(chunk, &mut cursor)?;
        let indices_id = read_i32_chunk(chunk, &mut cursor)?;
        let _tangents_id = read_i32_chunk(chunk, &mut cursor)?;
        let _sh_coeffs_id = read_i32_chunk(chunk, &mut cursor)?;
        let _shape_deformation_id = read_i32_chunk(chunk, &mut cursor)?;
        let _bone_map_id = read_i32_chunk(chunk, &mut cursor)?;
        let _face_map_id = read_i32_chunk(chunk, &mut cursor)?;
        let _vert_mats_id = read_i32_chunk(chunk, &mut cursor)?;
        let _qtangents_id = read_i32_chunk(chunk, &mut cursor)?;
        let _skin_id = read_i32_chunk(chunk, &mut cursor)?;
        let _dummy2_id = read_i32_chunk(chunk, &mut cursor)?;
        let verts_uvs_id = read_i32_chunk(chunk, &mut cursor)?;
        (vertices_id, normals_id, uvs_id, indices_id, verts_uvs_id)
    };

    for _ in 0..4 {
        let _physics_data = read_i32_chunk(chunk, &mut cursor)?;
    }
    for _ in 0..6 {
        let _ = read_u32_chunk(chunk, &mut cursor)?;
    }

    Ok(MeshChunkRefs {
        num_vertices,
        num_indices,
        num_vert_subsets,
        mesh_subsets_id,
        vertices_id,
        normals_id,
        uvs_id,
        indices_id,
        verts_uvs_id,
    })
}


fn fallback_single_primitive(num_indices: usize, num_vertices: usize) -> ScenePrimitive {
    ScenePrimitive {
        first_index: 0,
        num_indices: num_indices as u32,
        first_vertex: 0,
        num_vertices: num_vertices as u32,
        material_id: -1,
    }
}

fn build_normals_from_geometry(positions: &[[f32; 3]], indices: &[u32]) -> Vec<[f32; 3]> {
    let mut normals = vec![[0.0f32, 0.0, 0.0]; positions.len()];
    for tri in indices.chunks_exact(3) {
        let i0 = tri[0] as usize;
        let i1 = tri[1] as usize;
        let i2 = tri[2] as usize;
        if i0 >= positions.len() || i1 >= positions.len() || i2 >= positions.len() {
            continue;
        }
        let p0 = positions[i0];
        let p1 = positions[i1];
        let p2 = positions[i2];

        let u = [p1[0] - p0[0], p1[1] - p0[1], p1[2] - p0[2]];
        let v = [p2[0] - p0[0], p2[1] - p0[1], p2[2] - p0[2]];
        let n = [
            u[1] * v[2] - u[2] * v[1],
            u[2] * v[0] - u[0] * v[2],
            u[0] * v[1] - u[1] * v[0],
        ];

        for &idx in &[i0, i1, i2] {
            normals[idx][0] += n[0];
            normals[idx][1] += n[1];
            normals[idx][2] += n[2];
        }
    }

    for n in &mut normals {
        let len2 = n[0] * n[0] + n[1] * n[1] + n[2] * n[2];
        if len2 > 1e-12 {
            let inv = len2.sqrt().recip();
            n[0] *= inv;
            n[1] *= inv;
            n[2] *= inv;
        } else {
            *n = [0.0, 0.0, 1.0];
        }
    }
    normals
}
