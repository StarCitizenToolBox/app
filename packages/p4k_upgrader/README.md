# p4k_upgrader

Rust package for verifying or updating Star Citizen `Data.p4k` from a launcher manifest.

This is a standalone implementation and does not depend on the deprecated `unp4k_rs` workspace.

The crate ports the behavior from `p4k_update_verify_toolkit`:

- reads local or HTTP manifest sources
- supports JSON manifests and binary `P4K-MANI` manifests
- caches payload objects by SHA256
- verifies CIG P4K structure and compressed payload SHA256
- assembles a sector-aligned CIG/ZIP64 P4K and optionally replaces the existing file

## Commands

Verify directly from a manifest file:

```powershell
cargo run -p p4k_upgrader -- verify --manifest .\manifest.raw --p4k E:\StarCitizen\LIVE\Data.p4k
```

Verify the current P4K:

```powershell
cargo run -p p4k_upgrader -- verify --config p4k_update_config.json
```

Estimate required downloads:

```powershell
cargo run -p p4k_upgrader -- estimate --config p4k_update_config.json
```

Download required objects, assemble, verify, and replace:

```powershell
cargo run -p p4k_upgrader -- update --config p4k_update_config.json
```

Update directly from a manifest and mirror:

```powershell
cargo run -p p4k_upgrader -- update --manifest .\manifest.raw --p4k E:\StarCitizen\LIVE\Data.p4k --mirror-base https://example.invalid/objects
```

`verify` and `estimate` only require `manifest_source`; `update` also requires at least one
`mirror_bases` or `official_bases` entry unless the manifest provides per-entry URLs.
