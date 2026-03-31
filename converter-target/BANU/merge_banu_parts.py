#!/usr/bin/env python3
import copy
import json
import struct
import xml.etree.ElementTree as ET
from pathlib import Path


INPUT_DIR = Path("converter-target/BANU/_assembled_parts")
OUTPUT_DIR = Path("converter-target/BANU/_assembled_complete")
OUTPUT_GLB = OUTPUT_DIR / "BANU_Defender_full_merged.glb"
REPORT_MD = OUTPUT_DIR / "assembly_report.md"
REPORT_JSON = OUTPUT_DIR / "assembly_manifest.json"
MESHSETUP_PATH = Path("converter-target/BANU/Defender/BANU_Defender.meshsetup")


def align4(n: int) -> int:
    return (n + 3) & ~3


def read_glb(path: Path):
    data = path.read_bytes()
    if len(data) < 20 or data[:4] != b"glTF":
        raise ValueError(f"{path} is not a GLB")
    _, _, total_length = struct.unpack_from("<4sII", data, 0)
    if total_length != len(data):
        raise ValueError(f"{path} has invalid length")

    offset = 12
    json_obj = None
    bin_chunk = b""
    while offset < len(data):
        chunk_len, chunk_type = struct.unpack_from("<II", data, offset)
        offset += 8
        chunk = data[offset : offset + chunk_len]
        offset += chunk_len
        if chunk_type == 0x4E4F534A:
            json_obj = json.loads(chunk.decode("utf-8").rstrip(" \t\r\n\0"))
        elif chunk_type == 0x004E4942:
            bin_chunk = bytes(chunk)
    if json_obj is None:
        raise ValueError(f"{path} missing JSON chunk")
    return json_obj, bin_chunk


def write_glb(path: Path, json_obj, bin_chunk: bytes):
    json_bytes = json.dumps(json_obj, separators=(",", ":"), ensure_ascii=True).encode("utf-8")
    json_pad = align4(len(json_bytes)) - len(json_bytes)
    json_bytes += b" " * json_pad

    bin_pad = align4(len(bin_chunk)) - len(bin_chunk)
    bin_bytes = bin_chunk + (b"\0" * bin_pad)

    total = 12 + 8 + len(json_bytes) + 8 + len(bin_bytes)
    out = bytearray()
    out += struct.pack("<4sII", b"glTF", 2, total)
    out += struct.pack("<II", len(json_bytes), 0x4E4F534A)
    out += json_bytes
    out += struct.pack("<II", len(bin_bytes), 0x004E4942)
    out += bin_bytes
    path.write_bytes(out)


def fix_sparse(sparse_obj, accessor_offset, buffer_view_offset):
    if not sparse_obj:
        return
    if "indices" in sparse_obj and sparse_obj["indices"].get("bufferView") is not None:
        sparse_obj["indices"]["bufferView"] += buffer_view_offset
    if "values" in sparse_obj and sparse_obj["values"].get("bufferView") is not None:
        sparse_obj["values"]["bufferView"] += buffer_view_offset


def merge_parts(parts):
    merged = {
        "asset": {"version": "2.0", "generator": "BANU merge script"},
        "scenes": [{"name": "MergedScene", "nodes": []}],
        "scene": 0,
        "nodes": [],
        "meshes": [],
        "materials": [],
        "accessors": [],
        "bufferViews": [],
        "buffers": [],
    }
    merged_bin = bytearray()
    merged_extensions = set()

    if any("images" in p["json"] for p in parts):
        merged["images"] = []
    if any("textures" in p["json"] for p in parts):
        merged["textures"] = []
    if any("samplers" in p["json"] for p in parts):
        merged["samplers"] = []

    for part in parts:
        j = part["json"]
        b = part["bin"]
        base = {
            "node": len(merged["nodes"]),
            "mesh": len(merged["meshes"]),
            "material": len(merged["materials"]),
            "accessor": len(merged["accessors"]),
            "bufferView": len(merged["bufferViews"]),
            "image": len(merged.get("images", [])),
            "texture": len(merged.get("textures", [])),
            "sampler": len(merged.get("samplers", [])),
            "byteOffset": len(merged_bin),
        }

        for e in j.get("extensionsUsed", []):
            merged_extensions.add(e)

        for m in j.get("materials", []):
            merged["materials"].append(copy.deepcopy(m))
        for s in j.get("samplers", []):
            merged["samplers"].append(copy.deepcopy(s))
        for img in j.get("images", []):
            img2 = copy.deepcopy(img)
            if img2.get("bufferView") is not None:
                img2["bufferView"] += base["bufferView"]
            merged["images"].append(img2)
        for tex in j.get("textures", []):
            tex2 = copy.deepcopy(tex)
            if tex2.get("source") is not None:
                tex2["source"] += base["image"]
            if tex2.get("sampler") is not None:
                tex2["sampler"] += base["sampler"]
            merged["textures"].append(tex2)

        for bv in j.get("bufferViews", []):
            bv2 = copy.deepcopy(bv)
            old_off = bv2.get("byteOffset", 0)
            bv2["byteOffset"] = base["byteOffset"] + old_off
            bv2["buffer"] = 0
            merged["bufferViews"].append(bv2)

        for acc in j.get("accessors", []):
            acc2 = copy.deepcopy(acc)
            if acc2.get("bufferView") is not None:
                acc2["bufferView"] += base["bufferView"]
            fix_sparse(acc2.get("sparse"), base["accessor"], base["bufferView"])
            merged["accessors"].append(acc2)

        for mesh in j.get("meshes", []):
            mesh2 = copy.deepcopy(mesh)
            for prim in mesh2.get("primitives", []):
                if prim.get("indices") is not None:
                    prim["indices"] += base["accessor"]
                if prim.get("material") is not None:
                    prim["material"] += base["material"]
                attrs = prim.get("attributes", {})
                for k, v in list(attrs.items()):
                    attrs[k] = v + base["accessor"]
                for tgt in prim.get("targets", []):
                    for k, v in list(tgt.items()):
                        tgt[k] = v + base["accessor"]
            merged["meshes"].append(mesh2)

        for node in j.get("nodes", []):
            node2 = copy.deepcopy(node)
            if node2.get("mesh") is not None:
                node2["mesh"] += base["mesh"]
            if node2.get("children"):
                node2["children"] = [c + base["node"] for c in node2["children"]]
            if node2.get("skin") is not None:
                # No skin remapping in this merge, drop to keep output valid.
                node2.pop("skin", None)
            merged["nodes"].append(node2)

        scene_index = j.get("scene", 0)
        roots = []
        if j.get("scenes") and scene_index < len(j["scenes"]):
            roots = j["scenes"][scene_index].get("nodes", [])
        if not roots and j.get("nodes"):
            roots = list(range(len(j["nodes"])))
        merged["scenes"][0]["nodes"].extend([r + base["node"] for r in roots])

        merged_bin.extend(b)
        while len(merged_bin) % 4 != 0:
            merged_bin.append(0)

    if merged_extensions:
        merged["extensionsUsed"] = sorted(merged_extensions)
    merged["buffers"] = [{"byteLength": len(merged_bin)}]
    return merged, bytes(merged_bin)


def collect_part_stats():
    stats = []
    for glb in sorted(INPUT_DIR.glob("*.glb")):
        j, b = read_glb(glb)
        item = {
            "file": glb.name,
            "path": str(glb),
            "meshes": len(j.get("meshes", [])),
            "nodes": len(j.get("nodes", [])),
            "materials": len(j.get("materials", [])),
            "accessors": len(j.get("accessors", [])),
            "bufferViews": len(j.get("bufferViews", [])),
            "binBytes": len(b),
        }
        stats.append(item)
    return stats


def analyze_hardpoints(part_stats):
    hardpoints = []
    if MESHSETUP_PATH.exists():
        root = ET.parse(MESHSETUP_PATH).getroot()
        for node in root.iter("MSNode"):
            joint = node.attrib.get("Joint", "")
            if joint.startswith("hardpoint_"):
                hardpoints.append(joint)

    part_names = [Path(p["file"]).stem for p in part_stats]
    mappings = []
    for hp in sorted(set(hardpoints)):
        token = hp.replace("hardpoint_", "").lower().replace("-", "_")
        words = [w for w in token.split("_") if w]
        best_name = None
        best_score = 0
        for name in part_names:
            lname = name.lower().replace("-", "_")
            score = sum(1 for w in words if w in lname)
            if score > best_score:
                best_score = score
                best_name = name
        mappings.append(
            {
                "hardpoint": hp,
                "guessPart": best_name if best_score > 0 else None,
                "score": best_score,
            }
        )
    return mappings


def main():
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    part_stats = collect_part_stats()
    valid_names = {p["file"] for p in part_stats if p["meshes"] > 0 and p["nodes"] > 0}

    parts = []
    for glb in sorted(INPUT_DIR.glob("*.glb")):
        if glb.name not in valid_names:
            continue
        j, b = read_glb(glb)
        parts.append({"name": glb.name, "json": j, "bin": b})

    merged_json, merged_bin = merge_parts(parts)
    write_glb(OUTPUT_GLB, merged_json, merged_bin)

    hardpoint_map = analyze_hardpoints(part_stats)
    manifest = {
        "inputDir": str(INPUT_DIR),
        "outputGlb": str(OUTPUT_GLB),
        "totalParts": len(part_stats),
        "mergedParts": [p["name"] for p in parts],
        "skippedParts": [p["file"] for p in part_stats if p["file"] not in valid_names],
        "partStats": part_stats,
        "hardpointGuessMap": hardpoint_map,
        "mergedSummary": {
            "nodes": len(merged_json.get("nodes", [])),
            "meshes": len(merged_json.get("meshes", [])),
            "materials": len(merged_json.get("materials", [])),
            "accessors": len(merged_json.get("accessors", [])),
            "bufferViews": len(merged_json.get("bufferViews", [])),
            "bufferBytes": len(merged_bin),
        },
    }
    REPORT_JSON.write_text(json.dumps(manifest, indent=2, ensure_ascii=True), encoding="utf-8")

    md = []
    md.append("# BANU Defender Assembly Report")
    md.append("")
    md.append(f"- Input dir: `{INPUT_DIR}`")
    md.append(f"- Output merged GLB: `{OUTPUT_GLB}`")
    md.append(f"- Total converted parts: `{len(part_stats)}`")
    md.append(f"- Merged parts (has geometry): `{len(parts)}`")
    md.append("")
    md.append("## Merged Summary")
    ms = manifest["mergedSummary"]
    md.append(f"- nodes: `{ms['nodes']}`")
    md.append(f"- meshes: `{ms['meshes']}`")
    md.append(f"- materials: `{ms['materials']}`")
    md.append(f"- accessors: `{ms['accessors']}`")
    md.append(f"- bufferViews: `{ms['bufferViews']}`")
    md.append(f"- buffer bytes: `{ms['bufferBytes']}`")
    md.append("")
    md.append("## Included Parts")
    for name in manifest["mergedParts"]:
        md.append(f"- {name}")
    md.append("")
    md.append("## Skipped Parts (No Mesh Output)")
    for name in manifest["skippedParts"]:
        md.append(f"- {name}")
    md.append("")
    md.append("## Hardpoint Guess Mapping (Top Guess)")
    for item in hardpoint_map:
        if item["guessPart"]:
            md.append(f"- {item['hardpoint']} -> {item['guessPart']} (score={item['score']})")
        else:
            md.append(f"- {item['hardpoint']} -> (no candidate)")
    REPORT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")

    print(f"Wrote: {OUTPUT_GLB}")
    print(f"Wrote: {REPORT_MD}")
    print(f"Wrote: {REPORT_JSON}")


if __name__ == "__main__":
    main()
