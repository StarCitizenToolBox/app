#!/usr/bin/env python3
import argparse
import json
import math
import struct
from pathlib import Path


CTYPE_SIZE = {
    5120: 1,  # BYTE
    5121: 1,  # UNSIGNED_BYTE
    5122: 2,  # SHORT
    5123: 2,  # UNSIGNED_SHORT
    5125: 4,  # UNSIGNED_INT
    5126: 4,  # FLOAT
}
NUM_COMP = {
    "SCALAR": 1,
    "VEC2": 2,
    "VEC3": 3,
    "VEC4": 4,
    "MAT2": 4,
    "MAT3": 9,
    "MAT4": 16,
}


def align4(n: int) -> int:
    return (n + 3) & ~3


def load_glb(path: Path):
    data = path.read_bytes()
    if data[:4] != b"glTF":
        raise ValueError("not a glb")
    _, _, total = struct.unpack_from("<4sII", data, 0)
    if total != len(data):
        raise ValueError("invalid glb length")
    off = 12
    gltf = None
    bin_chunk = b""
    while off < len(data):
        clen, ctype = struct.unpack_from("<II", data, off)
        off += 8
        chunk = data[off : off + clen]
        off += clen
        if ctype == 0x4E4F534A:
            gltf = json.loads(chunk.decode("utf-8").rstrip(" \t\r\n\0"))
        elif ctype == 0x004E4942:
            bin_chunk = bytes(chunk)
    if gltf is None:
        raise ValueError("missing json chunk")
    return gltf, bytearray(bin_chunk)


def save_glb(path: Path, gltf, bin_chunk: bytes):
    json_bytes = json.dumps(gltf, separators=(",", ":"), ensure_ascii=True).encode("utf-8")
    json_bytes += b" " * (align4(len(json_bytes)) - len(json_bytes))
    bin_bytes = bytes(bin_chunk)
    bin_bytes += b"\0" * (align4(len(bin_bytes)) - len(bin_bytes))
    total = 12 + 8 + len(json_bytes) + 8 + len(bin_bytes)
    out = bytearray()
    out += struct.pack("<4sII", b"glTF", 2, total)
    out += struct.pack("<II", len(json_bytes), 0x4E4F534A)
    out += json_bytes
    out += struct.pack("<II", len(bin_bytes), 0x004E4942)
    out += bin_bytes
    path.write_bytes(out)


def accessor_info(gltf, acc_idx):
    acc = gltf["accessors"][acc_idx]
    bv = gltf["bufferViews"][acc["bufferView"]]
    comp = acc["componentType"]
    ncomp = NUM_COMP[acc["type"]]
    item_size = CTYPE_SIZE[comp] * ncomp
    stride = bv.get("byteStride", item_size)
    base = bv.get("byteOffset", 0) + acc.get("byteOffset", 0)
    return acc, bv, comp, ncomp, stride, base


def read_positions(gltf, bin_chunk: bytearray, acc_idx):
    acc, _, comp, ncomp, stride, base = accessor_info(gltf, acc_idx)
    if comp != 5126 or ncomp != 3:
        return None
    out = []
    for i in range(acc["count"]):
        p = base + i * stride
        out.append(struct.unpack_from("<fff", bin_chunk, p))
    return out


def read_indices(gltf, bin_chunk: bytearray, acc_idx):
    acc, _, comp, ncomp, stride, base = accessor_info(gltf, acc_idx)
    if ncomp != 1:
        return None
    out = []
    for i in range(acc["count"]):
        p = base + i * stride
        if comp == 5125:
            out.append(struct.unpack_from("<I", bin_chunk, p)[0])
        elif comp == 5123:
            out.append(struct.unpack_from("<H", bin_chunk, p)[0])
        elif comp == 5121:
            out.append(struct.unpack_from("<B", bin_chunk, p)[0])
        else:
            return None
    return out


def write_normals(gltf, bin_chunk: bytearray, acc_idx, normals):
    acc, _, comp, ncomp, stride, base = accessor_info(gltf, acc_idx)
    if comp != 5126 or ncomp != 3 or len(normals) != acc["count"]:
        return False
    for i, n in enumerate(normals):
        p = base + i * stride
        struct.pack_into("<fff", bin_chunk, p, n[0], n[1], n[2])
    return True


def recompute_normals(gltf, bin_chunk: bytearray, flip=False):
    fixed_prims = 0
    skipped_prims = 0
    for mesh in gltf.get("meshes", []):
        for prim in mesh.get("primitives", []):
            mode = prim.get("mode", 4)
            attrs = prim.get("attributes", {})
            if mode != 4 or "POSITION" not in attrs or "NORMAL" not in attrs or "indices" not in prim:
                skipped_prims += 1
                continue
            pos = read_positions(gltf, bin_chunk, attrs["POSITION"])
            ind = read_indices(gltf, bin_chunk, prim["indices"])
            if not pos or not ind:
                skipped_prims += 1
                continue
            nsum = [[0.0, 0.0, 0.0] for _ in range(len(pos))]
            for t in range(0, len(ind) - 2, 3):
                i0, i1, i2 = ind[t], ind[t + 1], ind[t + 2]
                if i0 >= len(pos) or i1 >= len(pos) or i2 >= len(pos):
                    continue
                p0, p1, p2 = pos[i0], pos[i1], pos[i2]
                ux, uy, uz = p1[0] - p0[0], p1[1] - p0[1], p1[2] - p0[2]
                vx, vy, vz = p2[0] - p0[0], p2[1] - p0[1], p2[2] - p0[2]
                nx = uy * vz - uz * vy
                ny = uz * vx - ux * vz
                nz = ux * vy - uy * vx
                if flip:
                    nx, ny, nz = -nx, -ny, -nz
                nsum[i0][0] += nx
                nsum[i0][1] += ny
                nsum[i0][2] += nz
                nsum[i1][0] += nx
                nsum[i1][1] += ny
                nsum[i1][2] += nz
                nsum[i2][0] += nx
                nsum[i2][1] += ny
                nsum[i2][2] += nz

            normals = []
            for x, y, z in nsum:
                l = math.sqrt(x * x + y * y + z * z)
                if l > 1e-8:
                    normals.append((x / l, y / l, z / l))
                else:
                    normals.append((0.0, 1.0, 0.0))
            ok = write_normals(gltf, bin_chunk, attrs["NORMAL"], normals)
            if ok:
                fixed_prims += 1
            else:
                skipped_prims += 1
    return fixed_prims, skipped_prims


def force_double_sided(gltf):
    count = 0
    for m in gltf.get("materials", []):
        if m.get("doubleSided") is not True:
            m["doubleSided"] = True
            count += 1
    return count


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("input_glb")
    ap.add_argument("output_glb")
    ap.add_argument("--flip", action="store_true", help="flip recomputed normals")
    ap.add_argument("--double-sided", action="store_true", default=True)
    args = ap.parse_args()

    in_path = Path(args.input_glb)
    out_path = Path(args.output_glb)
    gltf, bin_chunk = load_glb(in_path)
    fixed, skipped = recompute_normals(gltf, bin_chunk, flip=args.flip)
    ds = force_double_sided(gltf) if args.double_sided else 0
    save_glb(out_path, gltf, bin_chunk)
    print(f"fixed_primitives={fixed}")
    print(f"skipped_primitives={skipped}")
    print(f"double_sided_set={ds}")
    print(f"wrote={out_path}")


if __name__ == "__main__":
    main()
