// Public facade for the Star Citizen P4K updater.
//
// Community builds compile this crate as an API-compatible stub that returns a
// clear unavailable error. Official/local builds can place the closed
// implementation at `P:\StarCitizen\p4k_upgrader` or set
// `P4K_UPGRADER_IMPL_PATH`; `build.rs` then includes that implementation at
// compile time without storing it in this repository.

#[cfg(has_closed_p4k_upgrader)]
include!(concat!(env!("OUT_DIR"), "/p4k_upgrader_closed/src/lib.rs"));

#[cfg(not(has_closed_p4k_upgrader))]
pub mod archive;
#[cfg(not(has_closed_p4k_upgrader))]
pub mod cache;
#[cfg(not(has_closed_p4k_upgrader))]
pub mod config;
#[cfg(not(has_closed_p4k_upgrader))]
pub mod error;
#[cfg(not(has_closed_p4k_upgrader))]
pub mod manifest;
#[cfg(not(has_closed_p4k_upgrader))]
pub mod pipeline;

#[cfg(not(has_closed_p4k_upgrader))]
pub use archive::{
    assemble_p4k, parse_p4k, repair_p4k, select_p4k_entries_requiring_cache, update_p4k_in_place,
    verify_p4k_against_manifest, verify_p4k_cig_structure, verify_p4k_cig_structure_with_progress,
    P4kRecord,
};
#[cfg(not(has_closed_p4k_upgrader))]
pub use config::{
    cancel_update, pause_update, reset_update_control, resume_update, set_download_thread_limit,
    Config, ProgressEvent, ProgressReporter,
};
#[cfg(not(has_closed_p4k_upgrader))]
pub use error::{Error, Result};
#[cfg(not(has_closed_p4k_upgrader))]
pub use manifest::{cache_manifest, clear_manifest_memory_cache, Manifest, ManifestEntry};
#[cfg(not(has_closed_p4k_upgrader))]
pub use pipeline::{
    estimate_update_size, is_repair_update_mode, repair_existing, replace_existing_p4k,
    run_repair_update, run_update, verify_existing,
};
