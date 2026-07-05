use std::env;
use std::fs;
use std::path::{Path, PathBuf};

fn main() {
    println!("cargo:rustc-check-cfg=cfg(has_closed_p4k_upgrader)");
    println!("cargo:rerun-if-env-changed=P4K_UPGRADER_FORCE_STUB");
    println!("cargo:rerun-if-env-changed=P4K_UPGRADER_IMPL_PATH");

    if force_stub() {
        return;
    }

    let Some(impl_dir) = implementation_dir() else {
        return;
    };

    copy_closed_sources(&impl_dir);
    println!("cargo:rerun-if-changed={}", impl_dir.display());
    println!("cargo:rustc-cfg=has_closed_p4k_upgrader");
}

fn force_stub() -> bool {
    env::var("P4K_UPGRADER_FORCE_STUB")
        .map(|value| {
            let value = value.trim();
            value == "1"
                || value.eq_ignore_ascii_case("true")
                || value.eq_ignore_ascii_case("yes")
                || value.eq_ignore_ascii_case("on")
        })
        .unwrap_or(false)
}

fn implementation_dir() -> Option<PathBuf> {
    let candidate = env::var_os("P4K_UPGRADER_IMPL_PATH")
        .map(PathBuf::from)
        .unwrap_or_else(default_sibling_path);
    let candidate = candidate.canonicalize().unwrap_or(candidate);
    if is_closed_module(&candidate) {
        Some(candidate)
    } else {
        None
    }
}

fn default_sibling_path() -> PathBuf {
    let manifest_dir = PathBuf::from(env::var_os("CARGO_MANIFEST_DIR").unwrap());
    manifest_dir
        .parent()
        .and_then(Path::parent)
        .and_then(Path::parent)
        .map(|root| root.join("p4k_upgrader"))
        .unwrap_or_else(|| PathBuf::from(r"P:\StarCitizen\p4k_upgrader"))
}

fn is_closed_module(path: &Path) -> bool {
    path.join("Cargo.toml").is_file() && path.join("src").join("lib.rs").is_file()
}

fn copy_closed_sources(impl_dir: &Path) {
    let out_dir = PathBuf::from(env::var_os("OUT_DIR").unwrap());
    let dst_dir = out_dir.join("p4k_upgrader_closed").join("src");
    if dst_dir.exists() {
        fs::remove_dir_all(&dst_dir).expect("remove stale p4k_upgrader closed source copy");
    }
    copy_dir(&impl_dir.join("src"), &dst_dir);

    let lib_path = dst_dir.join("lib.rs");
    let lib = fs::read_to_string(&lib_path).expect("read p4k_upgrader closed lib.rs");
    let lib = lib.replacen("//!", "//", 1);
    fs::write(lib_path, lib).expect("write p4k_upgrader closed lib.rs shim");
}

fn copy_dir(src: &Path, dst: &Path) {
    fs::create_dir_all(dst).expect("create p4k_upgrader closed source copy dir");
    for entry in fs::read_dir(src).expect("read p4k_upgrader closed source dir") {
        let entry = entry.expect("read p4k_upgrader closed source entry");
        let source = entry.path();
        let destination = dst.join(entry.file_name());
        let file_type = entry
            .file_type()
            .expect("read p4k_upgrader closed source entry type");
        if file_type.is_dir() {
            copy_dir(&source, &destination);
        } else if file_type.is_file() {
            fs::copy(&source, &destination).expect("copy p4k_upgrader closed source file");
        }
    }
}
