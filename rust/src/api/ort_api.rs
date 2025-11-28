use anyhow::Result;
use once_cell::sync::Lazy;
use std::collections::HashMap;
use std::sync::Mutex;

use crate::ort_models::opus_mt::OpusMtModel;

/// 全局模型缓存
static MODEL_CACHE: Lazy<Mutex<HashMap<String, OpusMtModel>>> =
    Lazy::new(|| Mutex::new(HashMap::new()));

/// 加载 ONNX 翻译模型
///
/// # Arguments
/// * `model_path` - 模型文件夹路径
/// * `model_key` - 模型缓存键（用于标识模型，如 "zh-en"）
/// * `quantization_suffix` - 量化后缀（如 "_q4", "_q8"，空字符串表示使用默认模型）
/// * `use_xnnpack` - 是否使用 XNNPACK 加速
///
pub fn load_translation_model(
    model_path: String,
    model_key: String,
    quantization_suffix: String,
    use_xnnpack: bool,
) -> Result<()> {
    let model = OpusMtModel::new(&model_path, &quantization_suffix, use_xnnpack)?;

    let mut cache = MODEL_CACHE
        .lock()
        .map_err(|e| anyhow::anyhow!("Failed to lock model cache: {}", e))?;

    cache.insert(model_key, model);

    Ok(())
}

/// 翻译文本
///
/// # Arguments
/// * `model_key` - 模型缓存键（如 "zh-en"）
/// * `text` - 要翻译的文本
///
/// # Returns
/// * `Result<String>` - 翻译后的文本
pub fn translate_text(model_key: String, text: String) -> Result<String> {
    let cache = MODEL_CACHE
        .lock()
        .map_err(|e| anyhow::anyhow!("Failed to lock model cache: {}", e))?;

    let model = cache.get(&model_key).ok_or_else(|| {
        anyhow::anyhow!(
            "Model not found: {}. Please load the model first.",
            model_key
        )
    })?;

    model.translate(&text)
}

/// 批量翻译文本
///
/// # Arguments
/// * `model_key` - 模型缓存键（如 "zh-en"）
/// * `texts` - 要翻译的文本列表
///
/// # Returns
/// * `Result<Vec<String>>` - 翻译后的文本列表
pub fn translate_text_batch(model_key: String, texts: Vec<String>) -> Result<Vec<String>> {
    let cache = MODEL_CACHE
        .lock()
        .map_err(|e| anyhow::anyhow!("Failed to lock model cache: {}", e))?;

    let model = cache.get(&model_key).ok_or_else(|| {
        anyhow::anyhow!(
            "Model not found: {}. Please load the model first.",
            model_key
        )
    })?;

    model.translate_batch(&texts)
}

/// 卸载模型
///
/// # Arguments
/// * `model_key` - 模型缓存键（如 "zh-en"）
///
pub fn unload_translation_model(model_key: String) -> Result<()> {
    let mut cache = MODEL_CACHE
        .lock()
        .map_err(|e| anyhow::anyhow!("Failed to lock model cache: {}", e))?;

    cache.remove(&model_key);

    Ok(())
}

/// 清空所有已加载的模型
///
/// # Returns
pub fn clear_all_models() -> Result<()> {
    let mut cache = MODEL_CACHE
        .lock()
        .map_err(|e| anyhow::anyhow!("Failed to lock model cache: {}", e))?;

    cache.clear();

    Ok(())
}
