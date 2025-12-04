use anyhow::{anyhow, Result};
use flutter_rust_bridge::frb;
use std::collections::HashMap;
use std::path::PathBuf;
use std::sync::{Arc, Mutex};
use unp4k::{P4kEntry, P4kFile};

/// P4K 文件项信息
#[frb(dart_metadata=("freezed"))]
pub struct P4kFileItem {
    /// 文件名/路径
    pub name: String,
    /// 是否为目录
    pub is_directory: bool,
    /// 文件大小（字节）
    pub size: u64,
    /// 压缩后大小（字节）
    pub compressed_size: u64,
}

// 全局 P4K 读取器实例（用于保持状态）
static GLOBAL_P4K_READER: once_cell::sync::Lazy<Arc<Mutex<Option<P4kFile>>>> =
    once_cell::sync::Lazy::new(|| Arc::new(Mutex::new(None)));

static GLOBAL_P4K_FILES: once_cell::sync::Lazy<Arc<Mutex<HashMap<String, P4kEntry>>>> =
    once_cell::sync::Lazy::new(|| Arc::new(Mutex::new(HashMap::new())));

/// 打开 P4K 文件
pub async fn p4k_open(p4k_path: String) -> Result<usize> {
    let path = PathBuf::from(&p4k_path);
    if !path.exists() {
        return Err(anyhow!("P4K file not found: {}", p4k_path));
    }

    // 在后台线程执行阻塞操作
    let (reader, file_count, files_map) = tokio::task::spawn_blocking(move || {
        let reader = P4kFile::open(&path)?;
        let entries = reader.entries();
        let file_count = entries.len();

        let mut files_map = HashMap::new();
        for entry in entries {
            // 将路径转换为 Windows 风格，以 \ 开头
            let name = if entry.name.starts_with("\\") {
                entry.name.clone()
            } else {
                format!("\\{}", entry.name.replace("/", "\\"))
            };
            files_map.insert(name, entry.clone());
        }

        Ok::<_, anyhow::Error>((reader, file_count, files_map))
    })
    .await??;

    *GLOBAL_P4K_READER.lock().unwrap() = Some(reader);
    *GLOBAL_P4K_FILES.lock().unwrap() = files_map;

    Ok(file_count)
}

/// 获取所有文件列表
pub async fn p4k_get_all_files() -> Result<Vec<P4kFileItem>> {
    let files = GLOBAL_P4K_FILES.lock().unwrap();
    let mut result = Vec::with_capacity(files.len());

    for (name, entry) in files.iter() {
        result.push(P4kFileItem {
            name: name.clone(),
            is_directory: false,
            size: entry.uncompressed_size,
            compressed_size: entry.compressed_size,
        });
    }

    Ok(result)
}

/// 获取指定目录下的文件列表
pub async fn p4k_get_files_in_directory(directory: String) -> Result<Vec<P4kFileItem>> {
    let files = GLOBAL_P4K_FILES.lock().unwrap();
    let mut result = Vec::new();
    let mut dirs = std::collections::HashSet::new();

    // 确保目录路径以 \ 开头和结尾
    let dir_path = if !directory.starts_with("\\") {
        format!("\\{}", directory)
    } else {
        directory.clone()
    };
    let dir_path = if !dir_path.ends_with("\\") {
        format!("{}\\", dir_path)
    } else {
        dir_path
    };

    for (name, entry) in files.iter() {
        if name.starts_with(&dir_path) {
            let relative = &name[dir_path.len()..];
            if let Some(slash_pos) = relative.find("\\") {
                // 这是一个子目录
                let subdir = &relative[..slash_pos];
                if !dirs.contains(subdir) {
                    dirs.insert(subdir.to_string());
                    result.push(P4kFileItem {
                        name: format!("{}{}\\", dir_path, subdir),
                        is_directory: true,
                        size: 0,
                        compressed_size: 0,
                    });
                }
            } else {
                // 这是一个文件
                result.push(P4kFileItem {
                    name: name.clone(),
                    is_directory: false,
                    size: entry.uncompressed_size,
                    compressed_size: entry.compressed_size,
                });
            }
        }
    }

    // 按目录优先，然后按名称排序
    result.sort_by(|a, b| {
        if a.is_directory && !b.is_directory {
            std::cmp::Ordering::Less
        } else if !a.is_directory && b.is_directory {
            std::cmp::Ordering::Greater
        } else {
            a.name.cmp(&b.name)
        }
    });

    Ok(result)
}

/// 提取文件到内存
pub async fn p4k_extract_to_memory(file_path: String) -> Result<Vec<u8>> {
    // 规范化路径
    let normalized_path = if file_path.starts_with("\\") {
        file_path.clone()
    } else {
        format!("\\{}", file_path)
    };

    // 获取文件 entry 的克隆
    let entry = {
        let files = GLOBAL_P4K_FILES.lock().unwrap();
        files
            .get(&normalized_path)
            .ok_or_else(|| anyhow!("File not found: {}", file_path))?
            .clone()
    };

    // 在后台线程执行阻塞的提取操作
    let data = tokio::task::spawn_blocking(move || {
        let mut reader = GLOBAL_P4K_READER.lock().unwrap();
        if reader.is_none() {
            return Err(anyhow!("P4K reader not initialized"));
        }
        let data = reader.as_mut().unwrap().extract_entry(&entry)?;
        Ok::<_, anyhow::Error>(data)
    })
    .await??;

    Ok(data)
}

/// 提取文件到磁盘
pub async fn p4k_extract_to_disk(file_path: String, output_path: String) -> Result<()> {
    let data = p4k_extract_to_memory(file_path).await?;
    
    // 在后台线程执行阻塞的文件写入操作
    tokio::task::spawn_blocking(move || {
        let output = PathBuf::from(&output_path);

        // 创建父目录
        if let Some(parent) = output.parent() {
            std::fs::create_dir_all(parent)?;
        }

        std::fs::write(output, data)?;
        Ok::<_, anyhow::Error>(())
    })
    .await??;

    Ok(())
}

/// 关闭 P4K 读取器
pub async fn p4k_close() -> Result<()> {
    *GLOBAL_P4K_READER.lock().unwrap() = None;
    GLOBAL_P4K_FILES.lock().unwrap().clear();
    Ok(())
}
