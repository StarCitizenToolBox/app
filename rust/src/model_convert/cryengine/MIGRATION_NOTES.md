# CryEngine Migration Baseline

This document maps the object-oriented C# converter architecture to the current Rust model_convert pipeline.

## C# Source (Cryengine-Converter-master)

- `CryEngineCore/Model.cs`
  - Reads file header, chunk table, and chunk payloads
- `CryEngineCore/Chunks/Chunk*.cs`
  - Versioned chunk readers by `ChunkType` + `Version`
- `CryEngine/CryEngine.cs`
  - Builds node graph, geometry binding, and material assignment
- `Renderers/Gltf/*`
  - Converts structured model graph into glTF

## Current Rust (model_convert)

- `cgf_parser.rs`
  - Directly parses CrCh chunk payloads into `SceneData`
- `ivo_parser.rs`
  - Directly parses #ivo skin streams and optional node layout into `SceneData`
- `mod.rs`
  - Orchestrates parse/fallback/material/assembly/merge
- `gltf_builder.rs`
  - Writes glTF from flat `SceneData`

## Gap To Close

1. Missing reusable chunk model layer (file header + chunk table + typed chunk payloads).
2. Parsing and graph-building are coupled (hard to debug and replace one part).
3. Versioned chunk behavior is scattered instead of centralized.

## Replacement Order

1. Add Rust `cryengine` core model layer.
2. Move IVO chunk reads onto core layer.
3. Move CrCh chunk reads onto core layer.
4. Keep a single adapter from core `Model` to `SceneData` for glTF export.
