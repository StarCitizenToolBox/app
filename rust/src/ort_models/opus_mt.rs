use anyhow::{anyhow, Context, Result};
use ndarray::{Array2, ArrayD};
use ort::{
    execution_providers::XNNPACKExecutionProvider, session::builder::GraphOptimizationLevel,
    session::Session, value::Value,
};
use std::path::Path;
use std::sync::Mutex;
use tokenizers::Tokenizer;

/// Opus-MT 翻译模型的推理结构
pub struct OpusMtModel {
    encoder_session: Mutex<Session>,
    decoder_session: Mutex<Session>,
    tokenizer: Tokenizer,
    config: ModelConfig,
}

/// 模型配置
#[derive(Debug, Clone)]
pub struct ModelConfig {
    pub max_length: usize,
    pub num_beams: usize,
    pub decoder_start_token_id: i64,
    pub eos_token_id: i64,
    pub pad_token_id: i64,
}

impl Default for ModelConfig {
    fn default() -> Self {
        Self {
            max_length: 512,
            num_beams: 1,
            decoder_start_token_id: 0,
            eos_token_id: 0,
            pad_token_id: 0,
        }
    }
}

impl OpusMtModel {
    /// 从模型路径创建新的 OpusMT 模型实例
    ///
    /// # Arguments
    /// * `model_path` - 模型文件夹路径（应包含 onnx 子文件夹）
    /// * `quantization_suffix` - 量化后缀，如 "_q4", "_q8"，为空字符串则使用默认模型
    ///
    /// # Returns
    /// * `Result<Self>` - 成功返回模型实例，失败返回错误
    pub fn new<P: AsRef<Path>>(model_path: P, quantization_suffix: &str) -> Result<Self> {
        let model_path = model_path.as_ref();

        // onnx-community 标准：模型在 onnx 子文件夹中
        let onnx_dir = model_path.join("onnx");

        // 加载 tokenizer（在根目录）
        let tokenizer_path = model_path.join("tokenizer.json");

        // 动态加载并修复 tokenizer
        let tokenizer =
            Self::load_tokenizer(&tokenizer_path).context("Failed to load tokenizer")?;

        // 构建模型文件名
        let encoder_filename = if quantization_suffix.is_empty() {
            "encoder_model.onnx".to_string()
        } else {
            format!("encoder_model{}.onnx", quantization_suffix)
        };

        let decoder_filename = if quantization_suffix.is_empty() {
            "decoder_model.onnx".to_string()
        } else {
            format!("decoder_model{}.onnx", quantization_suffix)
        };

        // 加载 encoder 模型（在 onnx 子目录）
        let encoder_path = onnx_dir.join(&encoder_filename);
        if !encoder_path.exists() {
            return Err(anyhow!(
                "Encoder model not found: {}",
                encoder_path.display()
            ));
        }

        let encoder_session = Session::builder()
            .context("Failed to create encoder session builder")?
            .with_optimization_level(GraphOptimizationLevel::Level3)
            .context("Failed to set optimization level")?
            .with_intra_threads(4)
            .context("Failed to set intra threads")?
            .with_execution_providers([XNNPACKExecutionProvider::default().build()])
            .context("Failed to register XNNPACK execution provider")?
            .commit_from_file(&encoder_path)
            .context(format!(
                "Failed to load encoder model: {}",
                encoder_filename
            ))?;

        // 加载 decoder 模型（在 onnx 子目录）
        let decoder_path = onnx_dir.join(&decoder_filename);
        if !decoder_path.exists() {
            return Err(anyhow!(
                "Decoder model not found: {}",
                decoder_path.display()
            ));
        }

        let decoder_session = Session::builder()
            .context("Failed to create decoder session builder")?
            .with_optimization_level(GraphOptimizationLevel::Level3)
            .context("Failed to set optimization level")?
            .with_intra_threads(4)
            .context("Failed to set intra threads")?
            .with_execution_providers([XNNPACKExecutionProvider::default().build()])
            .context("Failed to register XNNPACK execution provider")?
            .commit_from_file(&decoder_path)
            .context(format!(
                "Failed to load decoder model: {}",
                decoder_filename
            ))?;

        // 加载配置（如果存在，在根目录）
        let config = Self::load_config(model_path)?;

        Ok(Self {
            encoder_session: Mutex::new(encoder_session),
            decoder_session: Mutex::new(decoder_session),
            tokenizer,
            config,
        })
    }

    /// 动态加载 tokenizer，自动修复常见问题
    fn load_tokenizer(tokenizer_path: &Path) -> Result<Tokenizer> {
        use std::fs;

        // 读取原始文件
        let content =
            fs::read_to_string(tokenizer_path).context("Failed to read tokenizer.json")?;

        // 解析为 JSON
        let mut json: serde_json::Value =
            serde_json::from_str(&content).context("Failed to parse tokenizer.json")?;

        let mut needs_fix = false;

        // 修复 normalizer 中的问题
        if let Some(obj) = json.as_object_mut() {
            if let Some(normalizer) = obj.get("normalizer") {
                let mut should_remove_normalizer = false;

                if normalizer.is_null() {
                    // normalizer 是 null，需要移除
                    should_remove_normalizer = true;
                } else if let Some(norm_obj) = normalizer.as_object() {
                    // 检查是否是有问题的 Precompiled 类型
                    if let Some(type_val) = norm_obj.get("type") {
                        if type_val.as_str() == Some("Precompiled") {
                            // 检查 precompiled_charsmap 字段
                            if let Some(precompiled) = norm_obj.get("precompiled_charsmap") {
                                if precompiled.is_null() {
                                    // precompiled_charsmap 是 null，移除整个 normalizer
                                    should_remove_normalizer = true;
                                }
                            } else {
                                // 缺少 precompiled_charsmap 字段，移除整个 normalizer
                                should_remove_normalizer = true;
                            }
                        }
                    }
                }

                if should_remove_normalizer {
                    obj.remove("normalizer");
                    needs_fix = true;
                }
            }
        }

        // 从修复后的 JSON 字符串加载 tokenizer
        let json_str = if needs_fix {
            serde_json::to_string(&json).context("Failed to serialize fixed tokenizer")?
        } else {
            content
        };

        // 从字节数组加载 tokenizer
        Tokenizer::from_bytes(json_str.as_bytes())
            .map_err(|e| anyhow!("Failed to load tokenizer: {}", e))
    }

    /// 从配置文件加载模型配置
    fn load_config(model_path: &Path) -> Result<ModelConfig> {
        let config_path = model_path.join("config.json");

        if config_path.exists() {
            let config_str =
                std::fs::read_to_string(config_path).context("Failed to read config.json")?;
            let config_json: serde_json::Value =
                serde_json::from_str(&config_str).context("Failed to parse config.json")?;

            Ok(ModelConfig {
                max_length: config_json["max_length"].as_u64().unwrap_or(512) as usize,
                num_beams: config_json["num_beams"].as_u64().unwrap_or(1) as usize,
                decoder_start_token_id: config_json["decoder_start_token_id"].as_i64().unwrap_or(0),
                eos_token_id: config_json["eos_token_id"].as_i64().unwrap_or(0),
                pad_token_id: config_json["pad_token_id"].as_i64().unwrap_or(0),
            })
        } else {
            Ok(ModelConfig::default())
        }
    }

    /// 翻译文本
    ///
    /// # Arguments
    /// * `text` - 要翻译的文本
    ///
    /// # Returns
    /// * `Result<String>` - 翻译后的文本
    pub fn translate(&self, text: &str) -> Result<String> {
        // 1. Tokenize 输入文本
        let encoding = self
            .tokenizer
            .encode(text, true)
            .map_err(|e| anyhow!("Failed to encode text: {}", e))?;

        let input_ids = encoding.get_ids();
        let attention_mask = encoding.get_attention_mask();

        // 2. 准备 encoder 输入
        let batch_size = 1;
        let seq_len = input_ids.len();

        let input_ids_array: Array2<i64> = Array2::from_shape_vec(
            (batch_size, seq_len),
            input_ids.iter().map(|&id| id as i64).collect(),
        )
        .context("Failed to create input_ids array")?;

        let attention_mask_array: Array2<i64> = Array2::from_shape_vec(
            (batch_size, seq_len),
            attention_mask.iter().map(|&mask| mask as i64).collect(),
        )
        .context("Failed to create attention_mask array")?;

        // 3. 运行 encoder
        let input_ids_value = Value::from_array((
            input_ids_array.shape().to_vec(),
            input_ids_array.into_raw_vec_and_offset().0,
        ))
        .context("Failed to create input_ids value")?;
        let attention_mask_value = Value::from_array((
            attention_mask_array.shape().to_vec(),
            attention_mask_array.clone().into_raw_vec_and_offset().0,
        ))
        .context("Failed to create attention_mask value")?;

        let encoder_inputs = ort::inputs![
            "input_ids" => input_ids_value,
            "attention_mask" => attention_mask_value,
        ];

        let mut encoder_session = self
            .encoder_session
            .lock()
            .map_err(|e| anyhow!("Failed to lock encoder session: {}", e))?;
        let encoder_outputs = encoder_session
            .run(encoder_inputs)
            .context("Failed to run encoder")?;

        let encoder_hidden_states = encoder_outputs["last_hidden_state"]
            .try_extract_tensor::<f32>()
            .context("Failed to extract encoder hidden states")?;

        // 将 tensor 转换为 ArrayD
        let (shape, data) = encoder_hidden_states;
        let shape_vec: Vec<usize> = shape.iter().map(|&x| x as usize).collect();
        let encoder_array = ArrayD::from_shape_vec(shape_vec, data.to_vec())
            .context("Failed to create encoder array")?;

        // 4. 贪婪解码生成输出
        let output_ids = self.greedy_decode(encoder_array, &attention_mask_array)?;

        // 5. Decode 输出 token IDs
        let output_tokens: Vec<u32> = output_ids.iter().map(|&id| id as u32).collect();
        let decoded = self
            .tokenizer
            .decode(&output_tokens, true)
            .map_err(|e| anyhow!("Failed to decode output: {}", e))?;

        Ok(decoded)
    }

    /// 贪婪解码
    fn greedy_decode(
        &self,
        encoder_hidden_states: ArrayD<f32>,
        encoder_attention_mask: &Array2<i64>,
    ) -> Result<Vec<i64>> {
        let batch_size = 1;
        let mut generated_ids = vec![self.config.decoder_start_token_id];

        for _ in 0..self.config.max_length {
            // 准备 decoder 输入
            let decoder_input_len = generated_ids.len();
            let decoder_input_ids: Array2<i64> =
                Array2::from_shape_vec((batch_size, decoder_input_len), generated_ids.clone())
                    .context("Failed to create decoder input_ids")?;

            // 创建 ORT Value
            let decoder_input_value = Value::from_array((
                decoder_input_ids.shape().to_vec(),
                decoder_input_ids.into_raw_vec_and_offset().0,
            ))
            .context("Failed to create decoder input value")?;
            let encoder_hidden_value = Value::from_array((
                encoder_hidden_states.shape().to_vec(),
                encoder_hidden_states.clone().into_raw_vec_and_offset().0,
            ))
            .context("Failed to create encoder hidden value")?;
            let encoder_mask_value = Value::from_array((
                encoder_attention_mask.shape().to_vec(),
                encoder_attention_mask.clone().into_raw_vec_and_offset().0,
            ))
            .context("Failed to create encoder mask value")?;

            // 运行 decoder
            let decoder_inputs = ort::inputs![
                "input_ids" => decoder_input_value,
                "encoder_hidden_states" => encoder_hidden_value,
                "encoder_attention_mask" => encoder_mask_value,
            ];

            let mut decoder_session = self
                .decoder_session
                .lock()
                .map_err(|e| anyhow!("Failed to lock decoder session: {}", e))?;
            let decoder_outputs = decoder_session
                .run(decoder_inputs)
                .context("Failed to run decoder")?;

            // 获取 logits
            let logits_tensor = decoder_outputs["logits"]
                .try_extract_tensor::<f32>()
                .context("Failed to extract logits")?;

            let (logits_shape, logits_data) = logits_tensor;
            let vocab_size = logits_shape[2] as usize;

            // 获取最后一个 token 的 logits
            let last_token_idx = decoder_input_len - 1;
            let last_logits_start = last_token_idx * vocab_size;
            let last_logits_end = last_logits_start + vocab_size;

            let last_logits_slice = &logits_data[last_logits_start..last_logits_end];

            // 找到最大概率的 token
            let next_token_id = last_logits_slice
                .iter()
                .enumerate()
                .max_by(|(_, a), (_, b)| a.partial_cmp(b).unwrap())
                .map(|(idx, _)| idx as i64)
                .context("Failed to find max token")?;

            // 检查是否到达结束 token
            if next_token_id == self.config.eos_token_id {
                break;
            }

            generated_ids.push(next_token_id);
        }

        Ok(generated_ids)
    }

    /// 批量翻译文本
    ///
    /// # Arguments
    /// * `texts` - 要翻译的文本列表
    ///
    /// # Returns
    /// * `Result<Vec<String>>` - 翻译后的文本列表
    pub fn translate_batch(&self, texts: &[String]) -> Result<Vec<String>> {
        texts.iter().map(|text| self.translate(text)).collect()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_translation() {
        let model = OpusMtModel::new(
            "C:\\Users\\xkeyc\\Downloads\\onnx_models\\opus-mt-zh-en",
            "_q4f16",
        )
        .unwrap();
        let result = model.translate("你好世界").unwrap();
        println!("Translation: {}", result);
    }
}
