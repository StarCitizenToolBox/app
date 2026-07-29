use std::fs::File;

use asar::{AsarReader, AsarWriter};
use tokio::fs;
use walkdir::WalkDir;

const RSI_LAUNCHER_MAIN_JS_PREFIXES: [&str; 3] = [
    "app/launcher/static/js/index.",
    "app/launcher/static/js/main.",
    "app/static/js/main.",
];
const RSI_LAUNCHER_MAIN_JS_SUFFIX: &str = ".js";

fn rsi_launcher_main_js_priority(path: &str) -> Option<usize> {
    let normalized_path = path.replace('\\', "/");
    RSI_LAUNCHER_MAIN_JS_PREFIXES.iter().position(|prefix| {
        normalized_path.starts_with(prefix)
            && normalized_path.ends_with(RSI_LAUNCHER_MAIN_JS_SUFFIX)
    })
}

fn select_rsi_launcher_main_js_path(paths: &[String]) -> Option<&str> {
    paths
        .iter()
        .filter_map(|path| {
            rsi_launcher_main_js_priority(path).map(|priority| {
                let normalized_path = path.replace('\\', "/");
                (path.as_str(), priority, normalized_path)
            })
        })
        .min_by(|left, right| left.1.cmp(&right.1).then_with(|| left.2.cmp(&right.2)))
        .map(|(path, _, _)| path)
}

pub struct RsiLauncherAsarData {
    pub asar_path: String,
    pub main_js_path: String,
    pub main_js_content: Vec<u8>,
}

impl RsiLauncherAsarData {
    pub async fn write_main_js(&self, content: Vec<u8>) -> anyhow::Result<()> {
        println!("[RsiLauncherAsarData] write_main_js");
        let mut asar_writer = AsarWriter::new();
        let asar_mem_file = fs::read(self.asar_path.clone()).await?;
        let asar = AsarReader::new(&asar_mem_file, None)?;
        let symlink_path = format!("{}.unpacked", self.asar_path);
        asar.files().iter().for_each(|v| {
            let (path, file) = v;
            let path_string = path.clone().into_os_string().into_string().unwrap();
            if path_string == self.main_js_path {
                asar_writer.write_file(path, &content, true).unwrap();
            } else {
                // check file exists in symlink_dir
                let file_path = format!("{}/{}", symlink_path, path_string);
                if std::fs::metadata(&file_path).is_ok() {
                    println!("[RsiLauncherAsarData] skip file: {}", path_string);
                } else {
                    println!("[RsiLauncherAsarData] write_file: {}", path_string);
                    asar_writer.write_file(path, file.data(), true).unwrap();
                }
            }
        });
        // check if symlink_dir exists
        if fs::metadata(&symlink_path).await.is_ok() {
            // loop symlink_dir
            for entry in WalkDir::new(symlink_path.clone())
                .follow_links(true)
                .into_iter()
                .filter_map(|e| e.ok())
            {
                let f_path = entry.path();
                if f_path.is_file() {
                    let relative_path = f_path.strip_prefix(&symlink_path)?;
                    let relative_path_str = relative_path.to_str().unwrap();
                    asar_writer.write_file(relative_path, &fs::read(f_path).await?, true)?;
                    // asar_writer.write_symlink(relative_path_str, f_path)?;
                    println!(
                        "[RsiLauncherAsarData] write symlink file: {} -> {}",
                        relative_path_str,
                        f_path.to_str().unwrap_or("??")
                    );
                }
            }
        }

        // rm old asar
        fs::remove_file(&self.asar_path).await?;
        // write new asar
        asar_writer.finalize(File::create(&self.asar_path)?)?;
        Ok(())
    }
}

pub async fn get_rsi_launcher_asar_data(asar_path: &str) -> anyhow::Result<RsiLauncherAsarData> {
    let asar_mem_file = fs::read(asar_path).await?;
    let asar = AsarReader::new(&asar_mem_file, None)?;
    let paths = asar
        .files()
        .keys()
        .map(|path| path.to_string_lossy().into_owned())
        .collect::<Vec<_>>();
    let main_js_path = select_rsi_launcher_main_js_path(&paths)
        .unwrap_or_default()
        .to_string();
    let main_js_content = asar
        .files()
        .iter()
        .find(|(path, _)| path.to_string_lossy() == main_js_path)
        .map(|(_, file)| file.data().to_vec())
        .unwrap_or_default();
    Ok(RsiLauncherAsarData {
        asar_path: asar_path.to_string(),
        main_js_path,
        main_js_content,
    })
}

#[cfg(test)]
mod tests {
    use super::select_rsi_launcher_main_js_path;

    #[test]
    fn selects_launcher_index_before_legacy_main_bundles() {
        let paths = vec![
            "app/overlay/static/js/index.1e614767.js".to_string(),
            "app/launcher/static/js/main.f3ea829e.js".to_string(),
            "app/launcher/static/js/index.deadbeef.js".to_string(),
            "app/loader/static/js/index.65760705.js".to_string(),
            "app/static/js/main.legacy123.js".to_string(),
        ];

        assert_eq!(
            select_rsi_launcher_main_js_path(&paths),
            Some("app/launcher/static/js/index.deadbeef.js")
        );
    }

    #[test]
    fn preserves_both_historical_main_layouts() {
        let launcher_main = vec!["app/launcher/static/js/main.f3ea829e.js".to_string()];
        let legacy_main = vec!["app/static/js/main.legacy123.js".to_string()];

        assert_eq!(
            select_rsi_launcher_main_js_path(&launcher_main),
            Some("app/launcher/static/js/main.f3ea829e.js")
        );
        assert_eq!(
            select_rsi_launcher_main_js_path(&legacy_main),
            Some("app/static/js/main.legacy123.js")
        );
    }

    #[test]
    fn rejects_unrelated_index_bundles() {
        let paths = vec![
            "app/guide-system/static/js/index.ad6b74a0.js".to_string(),
            "app/loader/static/js/index.65760705.js".to_string(),
            "app/overlay/static/js/index.1e614767.js".to_string(),
            "lib/main.js".to_string(),
        ];

        assert_eq!(select_rsi_launcher_main_js_path(&paths), None);
    }
}
