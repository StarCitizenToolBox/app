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

struct AudioRuntime {
    _device_sink: rodio::stream::MixerDeviceSink,
    player: Player,
    current_source_path: Option<String>,
    duration_ms: Option<u32>,
    volume: f64,
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
        volume: 1.0,
    });
    Ok(())
}

fn build_snapshot(runtime: &AudioRuntime) -> AudioPlaybackState {
    let position = runtime.player.get_pos().as_millis().min(u32::MAX as u128) as u32;
    let is_paused = runtime.player.is_paused();
    let is_playing = !runtime.player.empty() && !is_paused;

    AudioPlaybackState {
        current_source_path: runtime.current_source_path.clone(),
        duration_ms: runtime.duration_ms,
        position_ms: runtime
            .duration_ms
            .map(|total| position.min(total))
            .unwrap_or(position),
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

fn with_runtime<F, T>(f: F) -> Result<T>
where
    F: FnOnce(&AudioRuntime) -> Result<T>,
{
    ensure_runtime()?;
    let guard = lock_audio_runtime();
    let runtime = guard
        .as_ref()
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

/// Stop and forget the currently loaded source.
pub fn audio_stop() -> Result<AudioPlaybackState> {
    with_runtime_mut(|runtime| {
        runtime.player.stop();
        runtime.current_source_path = None;
        runtime.duration_ms = None;
        Ok(build_snapshot(runtime))
    })
}

/// Load a file into the player and start playback at the requested position.
pub fn audio_play_file(path: String, position_ms: u32) -> Result<AudioPlaybackState> {
    let lower = path.to_lowercase();
    let decoded = load_decoder(&path);
    let (source, duration_ms) = match decoded {
        Ok((decoder, duration_ms)) => (AudioSource::Decoder(decoder), duration_ms),
        Err(decoder_err) if lower.ends_with(".ogg") => match load_ogg_source(&path) {
            Ok((source, duration_ms)) => (source, duration_ms),
            Err(ogg_err) => {
                return Err(anyhow!(
                    "failed to decode audio file {}: {}; ogg fallback failed: {}",
                    path,
                    decoder_err,
                    ogg_err
                ))
            }
        },
        Err(err) => return Err(err),
    };

    with_runtime_mut(|runtime| {
        runtime.player.stop();
        runtime.player.set_volume(runtime.volume as f32);

        let start = Duration::from_millis(position_ms as u64);
        if start.is_zero() {
            runtime.player.append(source);
        } else {
            runtime.player.append(source.skip_duration(start));
        }
        runtime.player.play();
        runtime.current_source_path = Some(path);
        runtime.duration_ms = duration_ms;
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
        let position = Duration::from_millis(position_ms as u64);
        runtime
            .player
            .try_seek(position)
            .map_err(|e| anyhow!("failed to seek audio: {}", e))?;
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
    with_runtime(|runtime| Ok(build_snapshot(runtime)))
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
