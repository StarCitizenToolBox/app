#[cfg(test)]
mod large_file_tests {
    use std::panic;
    use std::path::PathBuf;

    #[test]
    fn test_decode_large_wem_637814297() {
        let wem_path = PathBuf::from(
            r"C:\Users\xkeyc\AppData\Local\Temp\SCToolbox_unp4kc\LIVE\data\sounds\wwise\media\637814297.wem",
        );

        if !wem_path.exists() {
            eprintln!("Skipping test: WEM file not found at {:?}", wem_path);
            return;
        }

        println!("Reading WEM file: {:?}", wem_path);
        let wem_data = match std::fs::read(&wem_path) {
            Ok(data) => {
                println!("Successfully read {} bytes", data.len());
                data
            }
            Err(e) => {
                panic!("Failed to read WEM file: {}", e);
            }
        };

        println!("Attempting to decode WEM to WAV...");
        let result = panic::catch_unwind(|| crate::audio::wwise::decode_wem_to_wav(&wem_data));

        match result {
            Ok(Ok(wav_data)) => {
                println!("Successfully decoded to WAV: {} bytes", wav_data.len());
            }
            Ok(Err(e)) => {
                eprintln!("Decoding failed with error: {}", e);
            }
            Err(panic_info) => {
                eprintln!("!!! PANIC during decoding !!!");
                if let Some(s) = panic_info.downcast_ref::<&str>() {
                    eprintln!("Panic message: {}", s);
                } else if let Some(s) = panic_info.downcast_ref::<String>() {
                    eprintln!("Panic message: {}", s);
                } else {
                    eprintln!("Panic message: (unknown type)");
                }
                panic!("Test failed due to panic during WEM decoding");
            }
        }
    }

    #[test]
    fn test_decode_large_wem_streaming() {
        let wem_path = PathBuf::from(
            r"C:\Users\xkeyc\AppData\Local\Temp\SCToolbox_unp4kc\LIVE\data\sounds\wwise\media\637814297.wem",
        );

        if !wem_path.exists() {
            eprintln!("Skipping test: WEM file not found at {:?}", wem_path);
            return;
        }

        println!("Reading WEM file for streaming test: {:?}", wem_path);
        let wem_data = std::fs::read(&wem_path).expect("Failed to read WEM file");
        println!("File size: {} bytes", wem_data.len());

        println!("Attempting streaming decode...");
        let result = panic::catch_unwind(|| {
            let mut chunk_count = 0usize;
            let result = super::super::decode_wem_stream(
                &wem_data,
                1000,
                |_chunk, _index, _total| {
                    chunk_count += 1;
                    if chunk_count % 10 == 0 {
                        println!("Processed chunk {}", chunk_count);
                    }
                    Ok(())
                },
                &|| false,
            );
            (result, chunk_count)
        });

        match result {
            Ok((Ok((codec, channels, sample_rate, total_frames)), chunk_count)) => {
                println!("Streaming decode successful!");
                println!("  Codec: {:?}", codec);
                println!("  Channels: {}", channels);
                println!("  Sample rate: {}", sample_rate);
                println!("  Total frames: {}", total_frames);
                println!("  Total chunks: {}", chunk_count);
            }
            Ok((Err(e), _)) => {
                eprintln!("Streaming decode failed with error: {}", e);
            }
            Err(panic_info) => {
                eprintln!("!!! PANIC during streaming decode !!!");
                if let Some(s) = panic_info.downcast_ref::<&str>() {
                    eprintln!("Panic message: {}", s);
                } else if let Some(s) = panic_info.downcast_ref::<String>() {
                    eprintln!("Panic message: {}", s);
                }
                panic!("Test failed due to panic during streaming decode");
            }
        }
    }

    #[test]
    fn test_get_wem_stream_info() {
        let wem_path = PathBuf::from(
            r"C:\Users\xkeyc\AppData\Local\Temp\SCToolbox_unp4kc\LIVE\data\sounds\wwise\media\637814297.wem",
        );

        if !wem_path.exists() {
            eprintln!("Skipping test: WEM file not found at {:?}", wem_path);
            return;
        }

        println!("Reading WEM file for info test: {:?}", wem_path);
        let wem_data = std::fs::read(&wem_path).expect("Failed to read WEM file");

        let result = panic::catch_unwind(|| super::super::get_wem_stream_info(&wem_data));

        match result {
            Ok(Ok(info)) => {
                println!("WEM stream info:");
                println!("  Codec: {:?}", info.codec);
                println!("  Channels: {}", info.channels);
                println!("  Sample rate: {}", info.sample_rate);
                println!("  Bits per sample: {}", info.bits_per_sample);
                println!("  Total samples: {}", info.total_samples);
            }
            Ok(Err(e)) => {
                eprintln!("Failed to get stream info: {}", e);
            }
            Err(panic_info) => {
                eprintln!("!!! PANIC while getting stream info !!!");
                if let Some(s) = panic_info.downcast_ref::<&str>() {
                    eprintln!("Panic message: {}", s);
                } else if let Some(s) = panic_info.downcast_ref::<String>() {
                    eprintln!("Panic message: {}", s);
                }
                panic!("Test failed due to panic");
            }
        }
    }
}
