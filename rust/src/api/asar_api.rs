use std::fs::File;

use asar::{AsarReader, AsarWriter};
use tokio::fs;
use walkdir::WalkDir;

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
                    asar_writer.write_file(relative_path, &fs::read(f_path).await?, true, )?;
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
    let mut main_js_path = String::from("");
    let mut main_js_content: Vec<u8> = Vec::new();
    asar.files().iter().for_each(|v| {
        let (path, file) = v;
        let path_string = path.clone().into_os_string().into_string().unwrap().replace("\\", "/");
        if path_string.starts_with("app/static/js/main.") && path_string.ends_with(".js") {
            main_js_path = path_string;
            main_js_content = file.data().to_vec();
        }
    });
    Ok(RsiLauncherAsarData {
        asar_path: asar_path.to_string(),
        main_js_path,
        main_js_content,
    })
}
