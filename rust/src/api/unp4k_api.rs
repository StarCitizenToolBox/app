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
    /// 文件修改时间（毫秒时间戳）
    pub date_modified: i64,
}

/// 将 DOS 日期时间转换为毫秒时间戳
fn dos_datetime_to_millis(date: u16, time: u16) -> i64 {
    let year = ((date >> 9) & 0x7F) as i32 + 1980;
    let month = ((date >> 5) & 0x0F) as u32;
    let day = (date & 0x1F) as u32;
    let hour = ((time >> 11) & 0x1F) as u32;
    let minute = ((time >> 5) & 0x3F) as u32;
    let second = ((time & 0x1F) * 2) as u32;

    let days_since_epoch = {
        let mut days = 0i64;
        for y in 1970..year {
            days += if (y % 4 == 0 && y % 100 != 0) || (y % 400 == 0) { 366 } else { 365 };
        }
        let days_in_months = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
        if month >= 1 && month <= 12 {
            days += days_in_months[(month - 1) as usize] as i64;
            if month > 2 && ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)) {
                days += 1;
            }
        }
        days += (day as i64) - 1;
        days
    };

    (days_since_epoch * 86400 + (hour as i64) * 3600 + (minute as i64) * 60 + (second as i64)) * 1000
}

// 全局 P4K 读取器实例（用于保持状态）
static GLOBAL_P4K_READER: once_cell::sync::Lazy<Arc<Mutex<Option<P4kFile>>>> =
    once_cell::sync::Lazy::new(|| Arc::new(Mutex::new(None)));

static GLOBAL_P4K_FILES: once_cell::sync::Lazy<Arc<Mutex<HashMap<String, P4kEntry>>>> =
    once_cell::sync::Lazy::new(|| Arc::new(Mutex::new(HashMap::new())));

/// 打开 P4K 文件（仅打开，不读取文件列表）
pub async fn p4k_open(p4k_path: String) -> Result<()> {
    let path = PathBuf::from(&p4k_path);
    if !path.exists() {
        return Err(anyhow!("P4K file not found: {}", p4k_path));
    }

    // 在后台线程执行阻塞操作
    let reader = tokio::task::spawn_blocking(move || {
        let reader = P4kFile::open(&path)?;
        Ok::<_, anyhow::Error>(reader)
    })
    .await??;

    *GLOBAL_P4K_READER.lock().unwrap() = Some(reader);
    // 清空之前的文件列表缓存
    GLOBAL_P4K_FILES.lock().unwrap().clear();

    Ok(())
}

/// 确保文件列表已加载（内部使用）
fn ensure_files_loaded() -> Result<usize> {
    let mut files = GLOBAL_P4K_FILES.lock().unwrap();
    if !files.is_empty() {
        return Ok(files.len());
    }

    let reader = GLOBAL_P4K_READER.lock().unwrap();
    if reader.is_none() {
        return Err(anyhow!("P4K reader not initialized"));
    }

    let entries = reader.as_ref().unwrap().entries();
    for entry in entries {
        let name = if entry.name.starts_with("\\") {
            entry.name.clone()
        } else {
            format!("\\{}", entry.name.replace("/", "\\"))
        };
        files.insert(name, entry.clone());
    }

    Ok(files.len())
}

/// 获取文件数量（会触发文件列表加载）
pub async fn p4k_get_file_count() -> Result<usize> {
    tokio::task::spawn_blocking(|| ensure_files_loaded()).await?
}

/// 获取所有文件列表
pub async fn p4k_get_all_files() -> Result<Vec<P4kFileItem>> {
    tokio::task::spawn_blocking(|| {
        ensure_files_loaded()?;
        let files = GLOBAL_P4K_FILES.lock().unwrap();
        let mut result = Vec::with_capacity(files.len());

        for (name, entry) in files.iter() {
            result.push(P4kFileItem {
                name: name.clone(),
                is_directory: false,
                size: entry.uncompressed_size,
                compressed_size: entry.compressed_size,
                date_modified: dos_datetime_to_millis(entry.mod_date, entry.mod_time),
            });
        }

        Ok(result)
    })
    .await?
}

/// 提取文件到内存
pub async fn p4k_extract_to_memory(file_path: String) -> Result<Vec<u8>> {
    // 确保文件列表已加载
    tokio::task::spawn_blocking(|| ensure_files_loaded()).await??;

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
