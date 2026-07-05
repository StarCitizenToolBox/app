use anyhow::Result;
use clap::{Parser, Subcommand};
use p4k_upgrader::{
    estimate_update_size, repair_existing, run_update, verify_existing, Config, ProgressEvent,
    ProgressReporter,
};
use std::path::PathBuf;
use std::sync::{Arc, Mutex};
use std::time::{Duration, Instant};

#[derive(Parser)]
#[command(name = "p4k-upgrader")]
#[command(author = "xkeyC")]
#[command(version)]
#[command(about = "Verify or update Star Citizen Data.p4k from a manifest")]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// Verify an existing P4K against a manifest.
    Verify {
        /// JSON config path. If omitted, defaults are used when --manifest is present.
        #[arg(short, long)]
        config: Option<PathBuf>,
        /// Local manifest path or manifest URL.
        #[arg(short, long)]
        manifest: Option<String>,
        /// P4K path to verify.
        #[arg(long)]
        p4k: Option<PathBuf>,
        /// Object/cache root.
        #[arg(long)]
        cache_dir: Option<PathBuf>,
    },
    /// Estimate how many object payloads must be downloaded.
    Estimate {
        /// JSON config path. If omitted, defaults are used when --manifest is present.
        #[arg(short, long)]
        config: Option<PathBuf>,
        /// Local manifest path or manifest URL.
        #[arg(short, long)]
        manifest: Option<String>,
        /// Current P4K path used to calculate delta.
        #[arg(long)]
        p4k: Option<PathBuf>,
        /// Object/cache root.
        #[arg(long)]
        cache_dir: Option<PathBuf>,
    },
    /// Download required objects, assemble P4K, verify, and optionally replace existing_p4k.
    Update {
        /// JSON config path. If omitted, defaults are used when --manifest is present.
        #[arg(short, long)]
        config: Option<PathBuf>,
        /// Local manifest path or manifest URL.
        #[arg(short, long)]
        manifest: Option<String>,
        /// Existing P4K path to update.
        #[arg(long)]
        p4k: Option<PathBuf>,
        /// Temporary output P4K path.
        #[arg(long)]
        output: Option<PathBuf>,
        /// Object/cache root.
        #[arg(long)]
        cache_dir: Option<PathBuf>,
        /// Mirror object base URL. Can be passed more than once.
        #[arg(long = "mirror-base")]
        mirror_bases: Vec<String>,
        /// Official object base URL. Can be passed more than once.
        #[arg(long = "official-base")]
        official_bases: Vec<String>,
        /// Keep assembled output instead of replacing the existing P4K.
        #[arg(long)]
        no_replace: bool,
    },
    /// Repair a P4K by reusing recoverable payloads and restoring missing ones.
    Repair {
        /// JSON config path. If omitted, defaults are used when --manifest is present.
        #[arg(short, long)]
        config: Option<PathBuf>,
        /// Local manifest path or manifest URL.
        #[arg(short, long)]
        manifest: Option<String>,
        /// Existing P4K path to repair from.
        #[arg(long)]
        p4k: Option<PathBuf>,
        /// Repaired output P4K path.
        #[arg(long)]
        output: Option<PathBuf>,
        /// Object/cache root.
        #[arg(long)]
        cache_dir: Option<PathBuf>,
        /// Mirror object base URL. Can be passed more than once.
        #[arg(long = "mirror-base")]
        mirror_bases: Vec<String>,
        /// Official object base URL. Can be passed more than once.
        #[arg(long = "official-base")]
        official_bases: Vec<String>,
    },
}

fn main() -> Result<()> {
    match Cli::parse().command {
        Commands::Verify {
            config,
            manifest,
            p4k,
            cache_dir,
        } => {
            let mut config = load_config(config, manifest.is_none(), false)?;
            apply_common_overrides(&mut config, manifest, p4k, cache_dir);
            attach_cli_progress(&mut config);
            verify_existing(&config)?;
        }
        Commands::Estimate {
            config,
            manifest,
            p4k,
            cache_dir,
        } => {
            let mut config = load_config(config, manifest.is_none(), false)?;
            apply_common_overrides(&mut config, manifest, p4k, cache_dir);
            attach_cli_progress(&mut config);
            estimate_update_size(&config)?;
        }
        Commands::Update {
            config,
            manifest,
            p4k,
            output,
            cache_dir,
            mirror_bases,
            official_bases,
            no_replace,
        } => {
            let mut config = load_config(config, manifest.is_none(), true)?;
            apply_common_overrides(&mut config, manifest, p4k, cache_dir);
            if let Some(output) = output {
                config.output_p4k = output;
            }
            if !mirror_bases.is_empty() {
                config.mirror_bases = mirror_bases;
            }
            if !official_bases.is_empty() {
                config.official_bases = official_bases;
            }
            if no_replace {
                config.replace_existing_p4k = false;
            }
            attach_cli_progress(&mut config);
            run_update(&config)?;
        }
        Commands::Repair {
            config,
            manifest,
            p4k,
            output,
            cache_dir,
            mirror_bases,
            official_bases,
        } => {
            let mut config = load_config(config, manifest.is_none(), true)?;
            apply_common_overrides(&mut config, manifest, p4k, cache_dir);
            if let Some(output) = output {
                config.output_p4k = output;
            }
            if !mirror_bases.is_empty() {
                config.mirror_bases = mirror_bases;
            }
            if !official_bases.is_empty() {
                config.official_bases = official_bases;
            }
            config.replace_existing_p4k = false;
            attach_cli_progress(&mut config);
            repair_existing(&config)?;
        }
    }
    Ok(())
}

fn load_config(
    config_path: Option<PathBuf>,
    require_existing_or_template: bool,
    require_object_source: bool,
) -> Result<Config> {
    if let Some(path) = config_path {
        return Ok(Config::from_file(path, require_object_source)?);
    }
    let default_path = PathBuf::from("p4k_update_config.json");
    if default_path.exists() || require_existing_or_template {
        Ok(Config::from_file(default_path, require_object_source)?)
    } else {
        Ok(Config::default())
    }
}

#[derive(Debug)]
struct CliProgressState {
    last_print: Instant,
    last_key: String,
}

fn attach_cli_progress(config: &mut Config) {
    let state = Arc::new(Mutex::new(CliProgressState {
        last_print: Instant::now() - Duration::from_secs(10),
        last_key: String::new(),
    }));
    config.progress = ProgressReporter::new(move |event: ProgressEvent| {
        let now = Instant::now();
        let key = format!(
            "{}:{}:{}:{}:{}",
            event.phase, event.name, event.current, event.total, event.downloaded_bytes
        );
        let mut state = match state.lock() {
            Ok(state) => state,
            Err(_) => return,
        };
        let is_terminal = event.total > 1 && event.current >= event.total;
        if !is_terminal
            && key == state.last_key
            && now.duration_since(state.last_print) < Duration::from_secs(5)
        {
            return;
        }
        if !is_terminal && now.duration_since(state.last_print) < Duration::from_secs(2) {
            return;
        }
        state.last_print = now;
        state.last_key = key;
        println!(
            "[{}] {}/{} bytes={}/{} active={} threads={} {} {}",
            event.phase,
            event.current,
            event.total,
            event.downloaded_bytes,
            event.total_bytes,
            event.active_downloads,
            event.thread_limit,
            event.name,
            event.message
        );
    });
}

fn apply_common_overrides(
    config: &mut Config,
    manifest: Option<String>,
    p4k: Option<PathBuf>,
    cache_dir: Option<PathBuf>,
) {
    if let Some(manifest) = manifest {
        config.manifest_source = manifest;
    }
    if let Some(p4k) = p4k {
        config.existing_p4k = p4k;
    }
    if let Some(cache_dir) = cache_dir {
        config.cache_dir = cache_dir;
    }
}
