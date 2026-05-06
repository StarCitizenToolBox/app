use anyhow::{anyhow, Result};
use flutter_rust_bridge::frb;
use once_cell::sync::Lazy;
use rodio::{buffer::SamplesBuffer, Decoder, DeviceSinkBuilder, Player, Source};
use std::fs::File;
use std::io::BufReader;
use std::num::{NonZeroU16, NonZeroU32};
use std::panic::{catch_unwind, AssertUnwindSafe};
use std::path::PathBuf;
use std::sync::Mutex;
use std::time::Duration;

#[frb(dart_metadata=("freezed"))]
pub struct AudioPlaybackState {
    pub current_source_path: Option<String>,
    pub duration_ms: Option<u32>,
    pub position_ms: u32,
    pub is_playing: bool,
    pub is_paused: bool,
    pub volume: f64,
}

#[frb(dart_metadata=("freezed"))]
pub struct StreamingAudioConfig {
    pub sample_rate: i32,
    pub channels: i32,
    pub estimated_duration_ms: Option<i32>,
}

struct AudioRuntime {
    _device_sink: rodio::stream::MixerDeviceSink,
    player: Player,
    current_source_path: Option<String>,
    duration_ms: Option<u32>,
    base_offset_ms: u32,
    streaming_sample_offset: u64,
    last_relative_samples: u64,
    current_source_samples: u64,
    volume: f64,
    streaming_config: Option<StreamingAudioConfig>,
    streaming_buffer: Vec<i16>,
}

static AUDIO_RUNTIME: Lazy<Mutex<Option<AudioRuntime>>> = Lazy::new(|| Mutex::new(None));

fn lock_audio_runtime() -> std::sync::MutexGuard<'static, Option<AudioRuntime>> {
    AUDIO_RUNTIME
        .lock()
        .unwrap_or_else(|poison| poison.into_inner())
}

fn ensure_runtime() -> Result<()> {
    let mut guard = lock_audio_runtime();
    if guard.is_some() && !AUDIO_RUNTIME.is_poisoned() {
        return Ok(());
    }
    if AUDIO_RUNTIME.is_poisoned() {
        *guard = None;
    }

    let mut device_sink = DeviceSinkBuilder::open_default_sink()
        .map_err(|e| anyhow!("failed to open audio output device: {}", e))?;
    device_sink.log_on_drop(false);
    let player = Player::connect_new(device_sink.mixer());
    *guard = Some(AudioRuntime {
        _device_sink: device_sink,
        player,
        current_source_path: None,
        duration_ms: None,
        base_offset_ms: 0,
        streaming_sample_offset: 0,
        last_relative_samples: 0,
        current_source_samples: 0,
        volume: 1.0,
        streaming_config: None,
        streaming_buffer: Vec::new(),
    });
    Ok(())
}

fn build_snapshot(runtime: &mut AudioRuntime) -> AudioPlaybackState {
    let relative = runtime.player.get_pos().as_millis().min(u32::MAX as u128) as u32;
    let is_paused = runtime.player.is_paused();
    let is_playing = !runtime.player.empty() && !is_paused;

    let position = if let Some(config) = &runtime.streaming_config {
        let sr = config.sample_rate as u64;
        let ch = config.channels as u64;
        let relative_samples = (relative as u64 * sr / 1000) * ch;

        if is_playing && runtime.current_source_samples > 0 {
            let expected_end = runtime.current_source_samples;
            if relative_samples < runtime.last_relative_samples
                && runtime.last_relative_samples > expected_end / 2
            {
                runtime.streaming_sample_offset += runtime.current_source_samples;
            }
        }

        if is_playing {
            runtime.last_relative_samples = relative_samples;
        }

        let total_samples = runtime.streaming_sample_offset + relative_samples;
        (total_samples * 1000 / (sr * ch)) as u32
    } else {
        runtime.base_offset_ms.saturating_add(relative)
    };

    let position_ms = if runtime.streaming_config.is_some() {
        position
    } else {
        runtime
            .duration_ms
            .map(|total| position.min(total))
            .unwrap_or(position)
    };

    //    if runtime.streaming_config.is_some() {
    //        println!(
    //            "[build_snapshot] streaming: sample_offset={}, relative={}ms, position_ms={}, is_playing={}",
    //            runtime.streaming_sample_offset, relative, position_ms, is_playing
    //        );
    //    }

    AudioPlaybackState {
        current_source_path: runtime.current_source_path.clone(),
        duration_ms: runtime.duration_ms,
        position_ms,
        is_playing,
        is_paused,
        volume: runtime.volume,
    }
}

fn with_runtime_mut<F, T>(f: F) -> Result<T>
where
    F: FnOnce(&mut AudioRuntime) -> Result<T>,
{
    ensure_runtime()?;
    let mut guard = lock_audio_runtime();
    let runtime = guard
        .as_mut()
        .ok_or_else(|| anyhow!("audio runtime not initialized"))?;
    f(runtime)
}

enum AudioSource {
    Decoder(Decoder<BufReader<File>>),
    Ogg(SamplesBuffer),
}

impl Iterator for AudioSource {
    type Item = rodio::Sample;

    fn next(&mut self) -> Option<Self::Item> {
        match self {
            AudioSource::Decoder(source) => source.next(),
            AudioSource::Ogg(source) => source.next(),
        }
    }
}

impl Source for AudioSource {
    fn current_span_len(&self) -> Option<usize> {
        match self {
            AudioSource::Decoder(source) => source.current_span_len(),
            AudioSource::Ogg(source) => source.current_span_len(),
        }
    }

    fn channels(&self) -> rodio::ChannelCount {
        match self {
            AudioSource::Decoder(source) => source.channels(),
            AudioSource::Ogg(source) => source.channels(),
        }
    }

    fn sample_rate(&self) -> rodio::SampleRate {
        match self {
            AudioSource::Decoder(source) => source.sample_rate(),
            AudioSource::Ogg(source) => source.sample_rate(),
        }
    }

    fn total_duration(&self) -> Option<Duration> {
        match self {
            AudioSource::Decoder(source) => source.total_duration(),
            AudioSource::Ogg(source) => source.total_duration(),
        }
    }

    fn try_seek(&mut self, pos: Duration) -> Result<(), rodio::source::SeekError> {
        match self {
            AudioSource::Decoder(source) => source.try_seek(pos),
            AudioSource::Ogg(source) => source.try_seek(pos),
        }
    }
}

fn load_decoder(path: &str) -> Result<(Decoder<BufReader<File>>, Option<u32>)> {
    let file = File::open(PathBuf::from(path))
        .map_err(|e| anyhow!("failed to open audio file {}: {}", path, e))?;
    let decoder = catch_unwind(AssertUnwindSafe(|| Decoder::try_from(BufReader::new(file))))
        .map_err(|_| anyhow!("audio decoder panicked while opening {}", path))?
        .map_err(|e| anyhow!("failed to decode audio file {}: {}", path, e))?;
    let duration_ms = decoder
        .total_duration()
        .map(|d| d.as_millis().min(u32::MAX as u128) as u32);
    Ok((decoder, duration_ms))
}

fn load_ogg_source(path: &str) -> Result<(AudioSource, Option<u32>)> {
    let file = File::open(PathBuf::from(path))
        .map_err(|e| anyhow!("failed to open audio file {}: {}", path, e))?;
    let mut ogg = lewton::inside_ogg::OggStreamReader::new(BufReader::new(file))
        .map_err(|e| anyhow!("failed to decode ogg audio file {}: {}", path, e))?;

    let channels = NonZeroU16::new(ogg.ident_hdr.audio_channels as u16)
        .ok_or_else(|| anyhow!("invalid ogg channel count for {}", path))?;
    let sample_rate = NonZeroU32::new(ogg.ident_hdr.audio_sample_rate)
        .ok_or_else(|| anyhow!("invalid ogg sample rate for {}", path))?;

    let mut samples = Vec::<f32>::new();
    loop {
        match ogg.read_dec_packet_itl() {
            Ok(Some(packet)) => {
                samples.extend(
                    packet
                        .into_iter()
                        .map(|s| (s as f32 / 32768.0).clamp(-1.0, 1.0)),
                );
            }
            Ok(None) => break,
            Err(e) => return Err(anyhow!("failed to decode ogg audio file {}: {}", path, e)),
        }
    }

    if samples.is_empty() {
        return Err(anyhow!("decoded ogg audio is empty: {}", path));
    }

    let duration_ms = ((samples.len() as u128 * 1000)
        / (channels.get() as u128 * sample_rate.get() as u128))
        .min(u32::MAX as u128) as u32;

    Ok((
        AudioSource::Ogg(SamplesBuffer::new(channels, sample_rate, samples)),
        Some(duration_ms),
    ))
}

fn load_audio_source(path: &str) -> Result<(AudioSource, Option<u32>)> {
    let lower = path.to_lowercase();
    match load_decoder(path) {
        Ok((decoder, duration_ms)) => Ok((AudioSource::Decoder(decoder), duration_ms)),
        Err(decoder_err) if lower.ends_with(".ogg") => match load_ogg_source(path) {
            Ok((source, duration_ms)) => Ok((source, duration_ms)),
            Err(ogg_err) => Err(anyhow!(
                "failed to decode audio file {}: {}; ogg fallback failed: {}",
                path,
                decoder_err,
                ogg_err
            )),
        },
        Err(err) => Err(err),
    }
}

/// Stop and forget the currently loaded source.
pub fn audio_stop() -> Result<AudioPlaybackState> {
    with_runtime_mut(|runtime| {
        runtime.player.stop();
        runtime.current_source_path = None;
        runtime.duration_ms = None;
        runtime.base_offset_ms = 0;
        runtime.streaming_sample_offset = 0;
        runtime.last_relative_samples = 0;
        runtime.current_source_samples = 0;
        runtime.streaming_config = None;
        runtime.streaming_buffer.clear();
        Ok(build_snapshot(runtime))
    })
}

/// Load a file into the player and start playback at the requested position.
pub fn audio_play_file(path: String, position_ms: u32) -> Result<AudioPlaybackState> {
    let (source, duration_ms) = load_audio_source(&path)?;
    let start_ms = duration_ms
        .map(|total| position_ms.min(total))
        .unwrap_or(position_ms);

    with_runtime_mut(|runtime| {
        runtime.player.stop();
        runtime.player.set_volume(runtime.volume as f32);

        let start = Duration::from_millis(start_ms as u64);
        if start.is_zero() {
            runtime.player.append(source);
        } else {
            runtime.player.append(source.skip_duration(start));
        }
        runtime.player.play();
        runtime.current_source_path = Some(path);
        runtime.duration_ms = duration_ms;
        runtime.base_offset_ms = start_ms;
        Ok(build_snapshot(runtime))
    })
}

/// Resume playback of the current source.
pub fn audio_resume() -> Result<AudioPlaybackState> {
    with_runtime_mut(|runtime| {
        runtime.player.play();
        Ok(build_snapshot(runtime))
    })
}

/// Pause playback.
pub fn audio_pause() -> Result<AudioPlaybackState> {
    with_runtime_mut(|runtime| {
        runtime.player.pause();
        Ok(build_snapshot(runtime))
    })
}

/// Seek the current source.
pub fn audio_seek(position_ms: u32) -> Result<AudioPlaybackState> {
    with_runtime_mut(|runtime| {
        let clamped_position_ms = runtime
            .duration_ms
            .map(|total| position_ms.min(total))
            .unwrap_or(position_ms);
        let can_seek_in_place = clamped_position_ms >= runtime.base_offset_ms;
        let relative_target_ms = clamped_position_ms.saturating_sub(runtime.base_offset_ms);
        let relative_target = Duration::from_millis(relative_target_ms as u64);

        // Preferred path: seek in-place for lower latency and less decoder churn.
        if can_seek_in_place && runtime.player.try_seek(relative_target).is_ok() {
            return Ok(build_snapshot(runtime));
        }

        // Fallback path: rebuild source and skip to target when decoder seek is unsupported.
        let path = runtime
            .current_source_path
            .clone()
            .ok_or_else(|| anyhow!("failed to seek audio: no audio source loaded"))?;
        let was_paused = runtime.player.is_paused();
        let (source, duration_ms) = load_audio_source(&path)
            .map_err(|e| anyhow!("failed to seek audio: fallback reload failed: {}", e))?;

        runtime.player.stop();
        runtime.player.set_volume(runtime.volume as f32);
        let position = Duration::from_millis(clamped_position_ms as u64);
        if position.is_zero() {
            runtime.player.append(source);
        } else {
            runtime.player.append(source.skip_duration(position));
        }
        if was_paused {
            runtime.player.pause();
        } else {
            runtime.player.play();
        }

        runtime.current_source_path = Some(path);
        runtime.duration_ms = duration_ms;
        runtime.base_offset_ms = clamped_position_ms;
        Ok(build_snapshot(runtime))
    })
}

/// Adjust the output volume.
pub fn audio_set_volume(volume: f64) -> Result<AudioPlaybackState> {
    with_runtime_mut(|runtime| {
        runtime.volume = volume.clamp(0.0, 3.0);
        runtime.player.set_volume(runtime.volume as f32);
        Ok(build_snapshot(runtime))
    })
}

/// Get the latest player snapshot.
pub fn audio_get_state() -> Result<AudioPlaybackState> {
    with_runtime_mut(|runtime| Ok(build_snapshot(runtime)))
}

/// Dispose the player and release all audio resources.
pub fn audio_dispose() -> Result<()> {
    let mut guard = lock_audio_runtime();
    if let Some(runtime) = guard.as_mut() {
        runtime.player.stop();
    }
    *guard = None;
    Ok(())
}

/// Start streaming playback with initial PCM chunk.
pub fn audio_start_stream(
    pcm_data: Vec<i16>,
    sample_rate: i32,
    channels: i32,
    source_path: String,
    duration_ms: i32,
    auto_play: bool,
) -> Result<AudioPlaybackState> {
    let sr = NonZeroU32::new(sample_rate as u32).ok_or_else(|| anyhow!("invalid sample rate"))?;
    let ch = NonZeroU16::new(channels as u16).ok_or_else(|| anyhow!("invalid channel count"))?;

    let source_samples = pcm_data.len() as u64;
    let samples: Vec<f32> = pcm_data.iter().map(|&s| s as f32 / 32768.0).collect();
    let buffer = SamplesBuffer::new(ch, sr, samples);

    with_runtime_mut(|runtime| {
        runtime.player.stop();
        runtime.player.set_volume(runtime.volume as f32);
        runtime.player.append(buffer);
        if auto_play {
            runtime.player.play();
        } else {
            runtime.player.pause();
        }
        runtime.current_source_path = Some(source_path);
        runtime.duration_ms = Some(duration_ms as u32);
        runtime.base_offset_ms = 0;
        runtime.streaming_sample_offset = 0;
        runtime.last_relative_samples = 0;
        runtime.current_source_samples = source_samples;
        runtime.streaming_config = Some(StreamingAudioConfig {
            sample_rate,
            channels,
            estimated_duration_ms: Some(duration_ms),
        });
        runtime.streaming_buffer = pcm_data;
        Ok(build_snapshot(runtime))
    })
}

/// Append PCM chunk to currently playing stream.
pub fn audio_append_stream(pcm_data: Vec<i16>) -> Result<AudioPlaybackState> {
    with_runtime_mut(|runtime| {
        let config = runtime
            .streaming_config
            .as_ref()
            .ok_or_else(|| anyhow!("no streaming audio in progress"))?;

        let sr = NonZeroU32::new(config.sample_rate as u32).unwrap();
        let ch = NonZeroU16::new(config.channels as u16).unwrap();

        let source_samples = pcm_data.len() as u64;
        let samples: Vec<f32> = pcm_data.iter().map(|&s| s as f32 / 32768.0).collect();
        let buffer = SamplesBuffer::new(ch, sr, samples);

        runtime.player.append(buffer);
        runtime.current_source_samples = source_samples;
        runtime.streaming_buffer.extend(pcm_data);
        Ok(build_snapshot(runtime))
    })
}

/// Stop streaming and clear streaming config.
pub fn audio_stop_stream() -> Result<AudioPlaybackState> {
    with_runtime_mut(|runtime| {
        runtime.player.stop();
        runtime.current_source_path = None;
        runtime.duration_ms = None;
        runtime.base_offset_ms = 0;
        runtime.streaming_sample_offset = 0;
        runtime.last_relative_samples = 0;
        runtime.current_source_samples = 0;
        runtime.streaming_config = None;
        runtime.streaming_buffer.clear();
        Ok(build_snapshot(runtime))
    })
}

/// Seek during streaming playback. Can only seek to already buffered position.
pub fn audio_seek_stream(position_ms: u32) -> Result<AudioPlaybackState> {
    with_runtime_mut(|runtime| {
        let config = runtime
            .streaming_config
            .as_ref()
            .ok_or_else(|| anyhow!("no streaming audio in progress"))?;

        let sr = config.sample_rate as u64;
        let ch = config.channels as u64;
        let buffered_samples = runtime.streaming_buffer.len() as u64;
        let buffered_duration_ms = (buffered_samples * 1000 / (sr * ch)) as u32;

        println!(
            "[audio_seek_stream] position_ms={}, sample_rate={}, channels={}, buffered_samples={}, buffered_duration_ms={}",
            position_ms, sr, ch, buffered_samples, buffered_duration_ms
        );

        if position_ms > buffered_duration_ms {
            println!(
                "[audio_seek_stream] seek failed: position {}ms > buffered {}ms",
                position_ms, buffered_duration_ms
            );
            return Err(anyhow!(
                "seek position {}ms exceeds buffered duration {}ms",
                position_ms,
                buffered_duration_ms
            ));
        }

        let sample_offset = (position_ms as u64 * sr / 1000 * ch) as usize;
        let remaining_samples = buffered_samples - sample_offset as u64;
        println!(
            "[audio_seek_stream] sample_offset={}, remaining_samples={}",
            sample_offset, remaining_samples
        );

        let was_paused = runtime.player.is_paused();

        let sr_nz = NonZeroU32::new(sr as u32).unwrap();
        let ch_nz = NonZeroU16::new(ch as u16).unwrap();

        let samples_f32: Vec<f32> = runtime.streaming_buffer[sample_offset..]
            .iter()
            .map(|&s| s as f32 / 32768.0)
            .collect();
        let buffer = SamplesBuffer::new(ch_nz, sr_nz, samples_f32);

        runtime.player.stop();
        runtime.player.set_volume(runtime.volume as f32);
        runtime.player.append(buffer);

        if was_paused {
            runtime.player.pause();
        } else {
            runtime.player.play();
        }

        runtime.streaming_sample_offset = sample_offset as u64;
        runtime.last_relative_samples = 0;
        runtime.current_source_samples = remaining_samples;

        let snapshot = build_snapshot(runtime);
        println!(
            "[audio_seek_stream] seek success, returning position_ms={}, sample_offset={}, is_playing={}",
            snapshot.position_ms, sample_offset, snapshot.is_playing
        );
        Ok(snapshot)
    })
}
