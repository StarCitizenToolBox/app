# p4k_upgrader

Open-source facade for the Star Citizen `Data.p4k` downloader/upgrader/repair
API used by StarCitizenToolBox.

## Open-source facade only

The crate included in this public repository is a mock/facade/stub only. It
keeps the public Rust API and CLI surface available for community builds, but
it intentionally does **not** contain the real P4K downloader, upgrader, repair,
or recovery implementation.

Implementation details for the real P4K update pipeline are closed-source for
security and abuse-prevention reasons. Community/open-source builds return an
unavailable/TODO-style error for P4K operations unless a local closed-source
module is present during an official build.

Official local builds may provide the closed implementation in either of these
ways:

- Set `P4K_UPGRADER_IMPL_PATH` to the local closed-source module directory.
- Place the closed-source module at the sibling location detected by `build.rs`
  (for example, `P:\StarCitizen\p4k_upgrader`).

Set `P4K_UPGRADER_FORCE_STUB=1` to force the community stub even when a local
closed-source implementation is present.

## Commands

The CLI surface is retained for API compatibility. In community/stub builds,
these commands fail with the unavailable error described above.

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
