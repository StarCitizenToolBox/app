use std::fs::File;

use asar::{AsarReader, AsarWriter};
use tokio::fs;

pub struct RsiLauncherAsarData {
    pub asar_path: String,
    pub main_js_path: String,
    pub main_js_content: Vec<u8>,
}

impl RsiLauncherAsarData {
    pub async fn write_main_js(&self, content: Vec<u8>) -> anyhow::Result<()> {
        let mut asar_writer = AsarWriter::new();
        let asar_mem_file = fs::read(self.asar_path.clone()).await?;
        let asar = AsarReader::new(&asar_mem_file, None)?;
        asar.files().iter().for_each(|v| {
            let (path, file) = v;
            let path_string = path.clone().into_os_string().into_string().unwrap();
            if path_string == self.main_js_path {
                asar_writer.write_file(path, &content, true).unwrap();
            } else {
                asar_writer.write_file(path, file.data(), true).unwrap();
            }
        });
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
        let path_string = path.clone().into_os_string().into_string().unwrap();
        if path_string.starts_with("app\\static\\js\\main.") && path_string.ends_with(".js") {
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