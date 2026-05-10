import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:starcitizen_doctor/common/rust/rust_audio_player.dart';
import 'package:starcitizen_doctor/common/rust/api/unp4k_api.dart' as unp4k_api;
import 'package:starcitizen_doctor/common/rust/api/audio_api.dart' as audio_api;

import 'waveform_painter.dart';

final Map<String, List<double>> audioWaveformCache = <String, List<double>>{};

double _audioLastVolume = 1.0;
bool _audioAutoPlay = true;

class AudioTempWidget extends HookWidget {
  final Uint8List bytes;
  final String sourcePath;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const AudioTempWidget(
    this.bytes,
    this.sourcePath, {
    super.key,
    this.onPrevious,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final player = useMemoized(() => RustAudioPlayer());
    final duration = useState(Duration.zero);
    final position = useState(Duration.zero);
    final isPlaying = useState(false);
    final isPaused = useState(false);
    final waveform = useState<List<double>>([]);
    final dragMs = useState<double?>(null);
    final dragVolume = useState<double?>(null);
    final volume = useState(_audioLastVolume.clamp(0.0, 3.0));
    final estimatedDuration = useState(Duration.zero);
    final playablePath = useState<String?>(null);
    final errorMessage = useState<String?>(null);
    final isDecoding = useState(true);
    final decodeProgress = useState(0.0);
    final autoPlay = useState(_audioAutoPlay);
    final prepareTokenRef = useRef<int>(0);
    final pollTimerRef = useRef<Timer?>(null);
    final seekRequestRef = useRef<int>(0);
    final streamStarted = useRef<bool>(false);
    final isDecodeComplete = useState(false);
    final isSeeking = useRef<bool>(false);
    final lastPositionRef = useRef<int>(0);
    final overlayKeyRef = useRef<GlobalKey<_PreviewModeOverlayState>>(
      GlobalKey(),
    );
    final pendingSwitchToFull = useRef<bool>(false);
    final pcmBufferChunksRef = useRef<List<Int16List>>(<Int16List>[]);
    final pcmBufferSamplesRef = useRef<int>(0);
    final pcmBufferTruncatedRef = useRef<bool>(false);
    final streamSampleRateRef = useRef<int?>(null);
    final streamChannelsRef = useRef<int?>(null);
    final streamDurationMsRef = useRef<int>(0);
    const maxRestartPcmBufferSeconds = 120;

    void syncPlayerState(AudioPlaybackState state) {
      if (state.durationMs != null) {
        duration.value = Duration(milliseconds: state.durationMs!);
      }
      if (!isSeeking.value && dragMs.value == null) {
        position.value = Duration(milliseconds: state.positionMs);
        lastPositionRef.value = state.positionMs;
      }
      isPlaying.value = state.isPlaying;
      isPaused.value = state.isPaused;
      volume.value = state.volume;
    }

    Future<void> refreshPlayerState() async {
      if (isSeeking.value || dragMs.value != null) return;
      try {
        final state = await audio_api.audioGetState();
        if (state.durationMs != null) {
          duration.value = Duration(milliseconds: state.durationMs!);
        }
        if (!isSeeking.value && dragMs.value == null) {
          position.value = Duration(milliseconds: state.positionMs);
          lastPositionRef.value = state.positionMs;
        }
        isPlaying.value = state.isPlaying;
        isPaused.value = state.isPaused;
      } catch (_) {}
    }

    useEffect(() {
      var disposed = false;
      final currentToken = ++prepareTokenRef.value;
      pollTimerRef.value?.cancel();
      streamStarted.value = false;
      pendingSwitchToFull.value = false;
      isSeeking.value = false;
      dragMs.value = null;
      lastPositionRef.value = 0;
      position.value = Duration.zero;
      duration.value = Duration.zero;
      estimatedDuration.value = Duration.zero;
      playablePath.value = null;
      isDecoding.value = true;
      isDecodeComplete.value = false;
      errorMessage.value = null;
      decodeProgress.value = 0.0;
      waveform.value = <double>[];
      streamSampleRateRef.value = null;
      streamChannelsRef.value = null;
      streamDurationMsRef.value = 0;
      pcmBufferChunksRef.value = <Int16List>[];
      pcmBufferSamplesRef.value = 0;
      pcmBufferTruncatedRef.value = false;

      () async {
        try {
          await player.stop();
        } catch (_) {}
      }();

      pollTimerRef.value = Timer.periodic(const Duration(milliseconds: 200), (
        _,
      ) async {
        if (disposed) return;
        try {
          await refreshPlayerState();
        } catch (e) {
          if (disposed || prepareTokenRef.value != currentToken) return;
          errorMessage.value = _friendlyAudioError(e);
        }
      });

      () async {
        try {
          if (disposed) return;
          await unp4k_api.p4KCancelWemDecode();
          isDecoding.value = true;
          isDecodeComplete.value = false;
          errorMessage.value = null;
          decodeProgress.value = 0.0;

          int? sampleRate;
          int? channels;
          int totalDurationMs = 0;
          final waveformSamples = <double>[];
          DateTime lastWaveformUpdate = DateTime.now();

          final stream = unp4k_api.p4KDecodeWemBytesToWavStream(
            wemBytes: bytes,
          );

          await for (final progress in stream) {
            if (disposed || prepareTokenRef.value != currentToken) return;

            decodeProgress.value = progress.progress;

            if (progress.error != null) {
              errorMessage.value = progress.error;
              isDecoding.value = false;
              return;
            }

            if (progress.sampleRate != null) {
              sampleRate = progress.sampleRate;
              streamSampleRateRef.value = progress.sampleRate;
            }
            if (progress.channels != null) {
              channels = progress.channels;
              streamChannelsRef.value = progress.channels;
            }

            if (progress.pcmChunk != null &&
                progress.pcmChunk!.isNotEmpty &&
                sampleRate != null &&
                channels != null) {
              final pcmData = Int16List.fromList(progress.pcmChunk!);
              final chunkDurationMs =
                  ((pcmData.length / channels) * 1000) ~/ sampleRate;
              totalDurationMs += chunkDurationMs;
              streamDurationMsRef.value = totalDurationMs;
              if (!pcmBufferTruncatedRef.value) {
                final maxBufferSamples =
                    sampleRate * channels * maxRestartPcmBufferSeconds;
                final nextSampleCount =
                    pcmBufferSamplesRef.value + pcmData.length;
                if (nextSampleCount <= maxBufferSamples) {
                  pcmBufferChunksRef.value.add(pcmData);
                  pcmBufferSamplesRef.value = nextSampleCount;
                } else {
                  pcmBufferChunksRef.value = <Int16List>[];
                  pcmBufferSamplesRef.value = 0;
                  pcmBufferTruncatedRef.value = true;
                }
              }

              final chunkWaveform = _computeWaveformFromPcm(pcmData, 10);
              waveformSamples.addAll(chunkWaveform);

              final now = DateTime.now();
              if (now.difference(lastWaveformUpdate).inMilliseconds >= 100) {
                lastWaveformUpdate = now;
                waveform.value = _finalizeWaveform(waveformSamples, 160);
              }

              if (!streamStarted.value) {
                streamStarted.value = true;
                isDecoding.value = false;
                playablePath.value = sourcePath;
                try {
                  await audio_api.audioStopStream();
                  final state = await audio_api.audioStartStream(
                    pcmData: pcmData,
                    sampleRate: sampleRate,
                    channels: channels,
                    sourcePath: sourcePath,
                    durationMs: totalDurationMs,
                    autoPlay: autoPlay.value,
                  );
                  if (!disposed && prepareTokenRef.value == currentToken) {
                    duration.value = Duration(milliseconds: totalDurationMs);
                    estimatedDuration.value = Duration(
                      milliseconds: totalDurationMs,
                    );
                    isPlaying.value = state.isPlaying;
                    isPaused.value = state.isPaused;
                  }
                } catch (e) {
                  if (!disposed && prepareTokenRef.value == currentToken) {
                    errorMessage.value = _friendlyAudioError(e);
                  }
                }
              } else {
                try {
                  await audio_api.audioAppendStream(pcmData: pcmData);
                  if (!disposed && prepareTokenRef.value == currentToken) {
                    duration.value = Duration(milliseconds: totalDurationMs);
                    estimatedDuration.value = Duration(
                      milliseconds: totalDurationMs,
                    );
                  }
                } catch (e) {
                  if (!disposed && prepareTokenRef.value == currentToken) {
                    errorMessage.value = _friendlyAudioError(e);
                  }
                }
              }
            }

            if (progress.isComplete) {
              if (progress.waveform != null) {
                final wf = progress.waveform!.toList();
                audioWaveformCache[sourcePath] = wf;
                waveform.value = wf;
              } else if (waveformSamples.isNotEmpty) {
                final finalWaveform = _finalizeWaveform(waveformSamples, 160);
                audioWaveformCache[sourcePath] = finalWaveform;
                waveform.value = finalWaveform;
              }

              if (progress.durationMs != null) {
                streamDurationMsRef.value = progress.durationMs!;
                estimatedDuration.value = Duration(
                  milliseconds: progress.durationMs!,
                );
                duration.value = Duration(milliseconds: progress.durationMs!);
              }

              playablePath.value = sourcePath;
              isDecoding.value = false;

              try {
                final state = await audio_api.audioGetState();
                if (!disposed && prepareTokenRef.value == currentToken) {
                  syncPlayerState(state);
                }
              } catch (e) {
                if (!disposed && prepareTokenRef.value == currentToken) {
                  errorMessage.value = _friendlyAudioError(e);
                }
              }

              if (streamStarted.value &&
                  !disposed &&
                  prepareTokenRef.value == currentToken) {
                final overlayState = overlayKeyRef.value.currentState;
                if (overlayState != null) {
                  pendingSwitchToFull.value = true;
                  overlayState.startExitAnimation();
                } else {
                  pendingSwitchToFull.value = false;
                  isDecodeComplete.value = true;
                }
              } else {
                isDecodeComplete.value = true;
              }
            }
          }
        } catch (e) {
          if (disposed) return;
          if (prepareTokenRef.value != currentToken) return;
          errorMessage.value = _friendlyAudioError(e);
          isDecoding.value = false;
        }
      }();

      return () {
        disposed = true;
        pollTimerRef.value?.cancel();
        final releasedToken = currentToken;
        Future.microtask(() async {
          if (prepareTokenRef.value != releasedToken) return;
          try {
            await unp4k_api.p4KCancelWemDecode();
          } catch (_) {}
          try {
            await audio_api.audioStopStream();
          } catch (_) {}
          try {
            await player.dispose();
          } catch (_) {}
        });
      };
    }, [sourcePath]);

    useEffect(() {
      final v = volume.value.clamp(0.0, 3.0);
      _audioLastVolume = v;
      unawaited(player.setVolume(v));
      return null;
    }, [volume.value]);

    useEffect(() {
      _audioAutoPlay = autoPlay.value;
      return null;
    }, [autoPlay.value]);

    if (isDecoding.value && playablePath.value == null) {
      return _buildDecodingIndicator(context, decodeProgress.value);
    }
    if (playablePath.value == null) {
      if (errorMessage.value != null) {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF5A1E1E),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFB94A4A)),
                ),
                child: Text(
                  "音频解码失败：${errorMessage.value}",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        );
      }
      return const Center(child: Text("音频预览失败：未找到可播放文件"));
    }

    final showDecodeOverlay = !isDecodeComplete.value && streamStarted.value;

    final displayDuration = duration.value > estimatedDuration.value
        ? duration.value
        : estimatedDuration.value;
    final totalMs = displayDuration.inMilliseconds;
    final int currentMs = position.value.inMilliseconds.clamp(
      0,
      totalMs > 0 ? totalMs : 0,
    );
    final effectiveMs = dragMs.value ?? currentMs.toDouble();
    final progress = totalMs > 0
        ? (effectiveMs / totalMs).clamp(0.0, 1.0)
        : 0.0;
    final effectiveVolume = (dragVolume.value ?? volume.value).clamp(0.0, 3.0);

    bool isMissingStreamError(Object error) {
      return error.toString().contains('no streaming audio in progress');
    }

    Int16List flattenBufferedPcm() {
      final chunks = pcmBufferChunksRef.value;
      final sampleCount = pcmBufferSamplesRef.value;
      final out = Int16List(sampleCount);
      var offset = 0;
      for (final chunk in chunks) {
        out.setRange(offset, offset + chunk.length, chunk);
        offset += chunk.length;
      }
      return out;
    }

    Future<AudioPlaybackState?> restartStreamFromBufferedPcm(
      int targetMs, {
      required bool autoPlayStream,
    }) async {
      final sampleRate = streamSampleRateRef.value;
      final channels = streamChannelsRef.value;
      if (sampleRate == null ||
          channels == null ||
          sampleRate <= 0 ||
          channels <= 0 ||
          pcmBufferTruncatedRef.value ||
          pcmBufferSamplesRef.value == 0) {
        return null;
      }

      final bufferedDurationMs =
          (pcmBufferSamplesRef.value * 1000) ~/ (sampleRate * channels);
      final knownDurationMs = math.max(
        streamDurationMsRef.value,
        math.max(totalMs, bufferedDurationMs),
      );
      final clampedTargetMs = targetMs.clamp(0, knownDurationMs).toInt();

      var state = await audio_api.audioStartStream(
        pcmData: flattenBufferedPcm(),
        sampleRate: sampleRate,
        channels: channels,
        sourcePath: sourcePath,
        durationMs: knownDurationMs,
        autoPlay: autoPlayStream,
      );
      streamStarted.value = true;

      if (clampedTargetMs > 0) {
        state = await audio_api.audioSeekStream(positionMs: clampedTargetMs);
        if (autoPlayStream && state.isPaused) {
          state = await audio_api.audioResume();
        }
      }

      playablePath.value = sourcePath;
      duration.value = Duration(milliseconds: knownDurationMs);
      estimatedDuration.value = Duration(milliseconds: knownDurationMs);
      return state;
    }

    Future<void> seekToPosition(
      int targetMs, {
      required bool resumeIfPlaying,
    }) async {
      final requestId = ++seekRequestRef.value;
      final int clampedTargetMs = targetMs.clamp(0, totalMs).toInt();
      final previousPosition = position.value;
      position.value = Duration(milliseconds: clampedTargetMs);
      dragMs.value = null;
      isSeeking.value = true;

      try {
        try {
          final state = await audio_api.audioSeekStream(
            positionMs: clampedTargetMs,
          );
          if (requestId != seekRequestRef.value) return;
          syncPlayerState(state);
          position.value = Duration(milliseconds: clampedTargetMs);
          lastPositionRef.value = clampedTargetMs;
        } catch (streamErr) {
          final errMsg = streamErr.toString();
          if (isMissingStreamError(streamErr)) {
            final state = await restartStreamFromBufferedPcm(
              clampedTargetMs,
              autoPlayStream: resumeIfPlaying,
            );
            if (state == null) {
              errorMessage.value = "音频流已失效，请重新打开该音频。";
              position.value = previousPosition;
              return;
            }
            if (requestId != seekRequestRef.value) return;
            syncPlayerState(state);
            position.value = Duration(milliseconds: clampedTargetMs);
            lastPositionRef.value = clampedTargetMs;
          } else if (errMsg.contains('exceeds buffered duration')) {
            final match = RegExp(
              r'buffered duration (\d+)ms',
            ).firstMatch(errMsg);
            final bufferedMs = match != null
                ? int.tryParse(match.group(1) ?? '0') ?? 0
                : 0;
            final bufferedSec = (bufferedMs / 1000).toStringAsFixed(1);
            errorMessage.value = "只能跳转到已缓冲区域（当前已缓冲 ${bufferedSec}s）";
          } else {
            rethrow;
          }
        }
      } catch (e) {
        if (requestId != seekRequestRef.value) return;
        position.value = previousPosition;
        errorMessage.value = e.toString();
      } finally {
        if (requestId == seekRequestRef.value) {
          isSeeking.value = false;
        }
      }
    }

    Future<void> togglePlay() async {
      if (isPlaying.value) {
        try {
          final state = await audio_api.audioPause();
          syncPlayerState(state);
        } catch (_) {
          try {
            final state = await player.pause();
            syncPlayerState(state);
          } catch (_) {}
        }
        return;
      }

      bool shouldReplay = false;
      if (totalMs > 0 && currentMs >= totalMs - 500) {
        shouldReplay = true;
      }

      try {
        if (isPaused.value && !shouldReplay) {
          try {
            var state = await audio_api.audioResume();
            if (!state.isPlaying && state.currentSourcePath == null) {
              final restarted = await restartStreamFromBufferedPcm(
                currentMs,
                autoPlayStream: true,
              );
              if (restarted != null) {
                state = restarted;
              }
            }
            syncPlayerState(state);
          } catch (_) {
            var state = await player.resume();
            if (!state.isPlaying && state.currentSourcePath == null) {
              final restarted = await restartStreamFromBufferedPcm(
                currentMs,
                autoPlayStream: true,
              );
              if (restarted != null) {
                state = restarted;
              }
            }
            syncPlayerState(state);
          }
        } else {
          final seekMs = shouldReplay ? 0 : currentMs;
          try {
            final state = await audio_api.audioSeekStream(positionMs: seekMs);
            syncPlayerState(state);
            if (state.isPaused) {
              final resumed = await audio_api.audioResume();
              syncPlayerState(resumed);
            }
          } catch (e) {
            if (!isMissingStreamError(e)) {
              rethrow;
            }
            final state = await restartStreamFromBufferedPcm(
              seekMs,
              autoPlayStream: true,
            );
            if (state == null) {
              errorMessage.value = "音频流已失效，请重新打开该音频。";
              return;
            }
            syncPlayerState(state);
          }
        }
      } catch (e) {
        errorMessage.value = e.toString();
      }
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (errorMessage.value != null) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF5A1E1E),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFB94A4A)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    FluentIcons.error_badge,
                    size: 18,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "音频预览失败：${errorMessage.value}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Button(
                    onPressed: () => errorMessage.value = null,
                    child: const Text("关闭"),
                  ),
                ],
              ),
            ),
          ],
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth <= 0
                    ? 1.0
                    : constraints.maxWidth;
                Offset? localOffsetFromGlobal(Offset globalPosition) {
                  final renderObject = context.findRenderObject();
                  if (renderObject is! RenderBox || !renderObject.hasSize) {
                    return null;
                  }
                  return renderObject.globalToLocal(globalPosition);
                }

                double dxToRatio(double dx) => (dx / width).clamp(0.0, 1.0);

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (details) async {
                    if (totalMs <= 0) return;
                    final localPosition = localOffsetFromGlobal(
                      details.globalPosition,
                    );
                    if (localPosition == null) return;
                    final ratio = dxToRatio(localPosition.dx);
                    final target = (ratio * totalMs).round();
                    await seekToPosition(
                      target,
                      resumeIfPlaying: isPlaying.value,
                    );
                  },
                  onHorizontalDragStart: (details) {
                    if (totalMs <= 0) return;
                    final localPosition = localOffsetFromGlobal(
                      details.globalPosition,
                    );
                    if (localPosition == null) return;
                    dragMs.value = (dxToRatio(localPosition.dx) * totalMs)
                        .toDouble();
                  },
                  onHorizontalDragUpdate: (details) {
                    if (totalMs <= 0) return;
                    final localPosition = localOffsetFromGlobal(
                      details.globalPosition,
                    );
                    if (localPosition == null) return;
                    final ratio = dxToRatio(localPosition.dx);
                    dragMs.value = ratio * totalMs;
                  },
                  onHorizontalDragEnd: (_) async {
                    if (totalMs <= 0 || dragMs.value == null) return;
                    final target = dragMs.value!.round();
                    await seekToPosition(
                      target,
                      resumeIfPlaying: isPlaying.value,
                    );
                  },
                  onHorizontalDragCancel: () {
                    dragMs.value = null;
                  },
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF1B2434),
                              Color(0xFF111A27),
                              Color(0xFF0E1622),
                            ],
                          ),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: .12),
                          ),
                        ),
                        child: CustomPaint(
                          size: Size.infinite,
                          painter: WaveformPainter(
                            samples: waveform.value,
                            progress: progress,
                            totalMs: totalMs,
                          ),
                        ),
                      ),
                      if (showDecodeOverlay)
                        Positioned.fill(
                          child: _PreviewModeOverlay(
                            key: overlayKeyRef.value,
                            onComplete: () {
                              if (pendingSwitchToFull.value) {
                                pendingSwitchToFull.value = false;
                                isDecodeComplete.value = true;
                              }
                            },
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                _fmtDuration(Duration(milliseconds: effectiveMs.round())),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: .85),
                ),
              ),
              const Spacer(),
              Text(
                _fmtDuration(displayDuration),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: .7),
                ),
              ),
            ],
          ),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onPrevious != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: onPrevious,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: .25),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          FluentIcons.previous,
                          size: 14,
                          color: Colors.white.withValues(alpha: .8),
                        ),
                      ),
                    ),
                  ),
                GestureDetector(
                  onTap: togglePlay,
                  child: Container(
                    width: 43,
                    height: 43,
                    decoration: BoxDecoration(
                      color: FluentTheme.of(
                        context,
                      ).accentColor.withValues(alpha: .22),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: .35),
                        width: 1.6,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      isPlaying.value ? FluentIcons.pause : FluentIcons.play,
                      size: 20,
                      color: Colors.white.withValues(alpha: .96),
                    ),
                  ),
                ),
                if (onNext != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: GestureDetector(
                      onTap: onNext,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: .25),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          FluentIcons.next,
                          size: 14,
                          color: Colors.white.withValues(alpha: .8),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  effectiveVolume <= 0.001
                      ? FluentIcons.volume_disabled
                      : (effectiveVolume < 1.0
                            ? FluentIcons.volume1
                            : FluentIcons.volume3),
                  size: 14,
                ),
                onPressed: () async {
                  final target = effectiveVolume <= 0.001 ? 1.0 : 0.0;
                  volume.value = target;
                  final state = await player.setVolume(target);
                  syncPlayerState(state);
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth <= 0
                        ? 1.0
                        : constraints.maxWidth;
                    Offset? localOffsetFromGlobal(Offset globalPosition) {
                      final renderObject = context.findRenderObject();
                      if (renderObject is! RenderBox || !renderObject.hasSize) {
                        return null;
                      }
                      return renderObject.globalToLocal(globalPosition);
                    }

                    double dxToRatio(double dx) => (dx / width).clamp(0.0, 1.0);

                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapUp: (details) async {
                        final localPosition = localOffsetFromGlobal(
                          details.globalPosition,
                        );
                        if (localPosition == null) return;
                        final ratio = dxToRatio(localPosition.dx);
                        final v = ratio * 3.0;
                        dragVolume.value = v;
                        volume.value = v;
                        final state = await player.setVolume(v);
                        syncPlayerState(state);
                        dragVolume.value = null;
                      },
                      onHorizontalDragStart: (details) {
                        final localPosition = localOffsetFromGlobal(
                          details.globalPosition,
                        );
                        if (localPosition == null) return;
                        final v = dxToRatio(localPosition.dx) * 3.0;
                        dragVolume.value = v;
                        volume.value = v;
                        unawaited(player.setVolume(v));
                      },
                      onHorizontalDragUpdate: (details) {
                        final localPosition = localOffsetFromGlobal(
                          details.globalPosition,
                        );
                        if (localPosition == null) return;
                        final ratio = dxToRatio(localPosition.dx);
                        final v = ratio * 3.0;
                        dragVolume.value = v;
                        volume.value = v;
                        unawaited(player.setVolume(v));
                      },
                      onHorizontalDragEnd: (_) {
                        if (dragVolume.value == null) return;
                        final v = dragVolume.value!.clamp(0.0, 3.0);
                        volume.value = v;
                        unawaited(player.setVolume(v));
                        dragVolume.value = null;
                      },
                      onHorizontalDragCancel: () {
                        dragVolume.value = null;
                      },
                      child: Container(
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: width * (effectiveVolume / 3.0),
                            decoration: BoxDecoration(
                              color: FluentTheme.of(
                                context,
                              ).accentColor.defaultBrushFor(Brightness.dark),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Text("${(effectiveVolume * 100).round()}%"),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Checkbox(
                checked: autoPlay.value,
                onChanged: (v) => autoPlay.value = v ?? false,
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () => autoPlay.value = !autoPlay.value,
                child: Text(
                  "切换音乐时自动播放",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: .7),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDecodingIndicator(BuildContext context, double progress) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 32,
            height: 32,
            child: ProgressRing(strokeWidth: 3),
          ),
        ],
      ),
    );
  }

  String _friendlyAudioError(Object error) {
    final raw = error.toString();
    final unsupported = RegExp(
      r"unsupported wem codec format=0x([0-9a-fA-F]+)",
    );
    final match = unsupported.firstMatch(raw);
    if (match != null) {
      final codec = match.group(1)?.toLowerCase() ?? "unknown";
      return "当前 WEM 编码不受内置解码支持（format=0x$codec）。\n"
          "当前版本支持 PCM (0x0001) 和 Wwise Vorbis (0xFFFF) 的 WEM 预览。";
    }
    return raw;
  }

  String _fmtDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final h = d.inHours;
    if (h > 0) return "$h:$m:$s";
    return "$m:$s";
  }

  static List<double> _computeWaveformFromPcm(Int16List pcm, int points) {
    if (pcm.isEmpty || points == 0) return List.filled(points.clamp(1, 1), 0.0);
    final bucket = math.max(1, pcm.length ~/ points);
    final out = <double>[];
    for (int i = 0; i < pcm.length; i += bucket) {
      final end = math.min(pcm.length, i + bucket);
      double peak = 0;
      for (int j = i; j < end; j++) {
        final v = pcm[j].abs() / 32768.0;
        if (v > peak) peak = v;
      }
      out.add(peak.clamp(0.0, 1.0));
    }
    return out;
  }

  static List<double> _finalizeWaveform(
    List<double> samples,
    int targetPoints,
  ) {
    if (samples.isEmpty) return List.filled(targetPoints, 0.0);
    if (samples.length == targetPoints) return samples;
    if (samples.length < targetPoints) {
      return [...samples, ...List.filled(targetPoints - samples.length, 0.0)];
    }
    final bucket = (samples.length / targetPoints).ceil();
    final out = <double>[];
    for (int i = 0; i < samples.length; i += bucket) {
      final end = math.min(samples.length, i + bucket);
      double maxVal = 0;
      for (int j = i; j < end; j++) {
        if (samples[j] > maxVal) maxVal = samples[j];
      }
      out.add(maxVal);
    }
    while (out.length > targetPoints) {
      out.removeLast();
    }
    while (out.length < targetPoints) {
      out.add(0.0);
    }
    return out;
  }
}

class _PreviewModeOverlay extends StatefulWidget {
  final VoidCallback? onComplete;

  const _PreviewModeOverlay({super.key, this.onComplete});

  @override
  State<_PreviewModeOverlay> createState() => _PreviewModeOverlayState();
}

class _PreviewModeOverlayState extends State<_PreviewModeOverlay>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late AnimationController _completeController;
  final List<_Particle> _particles = [];
  final math.Random _random = math.Random(42);
  bool _isExiting = false;
  bool _showComplete = false;
  bool _textInCorner = false;

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    )..repeat();

    _completeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    for (int i = 0; i < 40; i++) {
      final p = _Particle(_random);
      p.x = _random.nextDouble() * 1.2;
      _particles.add(p);
    }

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        _textInCorner = true;
      });
    });
  }

  void startExitAnimation() {
    if (_isExiting) return;
    _isExiting = true;
    for (var p in _particles) {
      p.speedMultiplier = 5.0;
    }

    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      setState(() {
        _showComplete = true;
        _textInCorner = false;
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        _completeController.forward();
      });
    });

    Future.delayed(const Duration(milliseconds: 1900), () {
      if (!mounted) return;
      widget.onComplete?.call();
    });
  }

  @override
  void dispose() {
    _particleController.dispose();
    _completeController.dispose();
    super.dispose();
  }

  Widget _buildTextContent({required bool isCenter}) {
    final title = _showComplete ? "完成！" : "正在解码...";
    final subtitle = _showComplete ? "" : "正在解码完整音频...";
    final isComplete = _showComplete;
    return Opacity(
      key: ValueKey('text_state_$isCenter'),
      opacity: 1 - _completeController.value,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: isCenter
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isComplete ? 16 : 12,
              fontWeight: FontWeight.w500,
              color: isComplete
                  ? Colors.white
                  : Colors.white.withValues(alpha: .6),
            ),
          ),
          if (!isComplete) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white.withValues(alpha: .5),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 1.0, end: 0.0).animate(_completeController),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          color: Colors.black.withValues(alpha: .3),
          child: Stack(
            children: [
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _particleController,
                  builder: (context, child) {
                    for (var particle in _particles) {
                      particle.update(shouldRespawn: !_isExiting);
                    }
                    return CustomPaint(painter: _WarpEffectPainter(_particles));
                  },
                ),
              ),
              AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: _textInCorner
                    ? Alignment.bottomRight
                    : Alignment.center,
                child: Padding(
                  padding: _textInCorner
                      ? const EdgeInsets.only(right: 8, bottom: 32)
                      : EdgeInsets.zero,
                  child: _buildTextContent(isCenter: !_textInCorner),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WarpEffectPainter extends CustomPainter {
  final List<_Particle> particles;

  _WarpEffectPainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      if (particle.isAlive) {
        particle.draw(canvas, size);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _WarpEffectPainter oldDelegate) => true;
}

class _Particle {
  double x = 0;
  double y = 0;
  double speed = 0;
  double width = 0;
  double alpha = 0;
  double speedMultiplier = 1.0;
  bool isAlive = true;
  final math.Random random;

  _Particle(this.random) {
    reset();
  }

  void reset() {
    x = -0.15;
    y = random.nextDouble();
    speed = (0.006 + random.nextDouble() * 0.012) / 3;
    width = 3.0 + random.nextDouble() * 4.0;
    alpha = 0.4 + random.nextDouble() * 0.4;
    speedMultiplier = 1.0;
  }

  void update({bool shouldRespawn = true}) {
    if (!isAlive) return;
    x += speed * speedMultiplier;
    if (x > 1.5) {
      if (shouldRespawn) {
        reset();
      } else {
        isAlive = false;
      }
    }
  }

  void draw(Canvas canvas, Size canvasSize) {
    if (!isAlive) return;

    final rectX = x * canvasSize.width;
    final rectY = y * canvasSize.height;
    final rectWidth = width * 8;
    final rectHeight = width;

    final fadeAlpha = alpha * (1 - x * 0.4);

    final shader =
        LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color.fromRGBO(255, 255, 255, 0),
            Color.fromRGBO(255, 255, 255, fadeAlpha),
          ],
        ).createShader(
          Rect.fromLTWH(
            rectX - rectWidth,
            rectY - rectHeight / 2,
            rectWidth,
            rectHeight,
          ),
        );

    final paint = Paint()..shader = shader;

    canvas.drawRect(
      Rect.fromLTWH(
        rectX - rectWidth,
        rectY - rectHeight / 2,
        rectWidth,
        rectHeight,
      ),
      paint,
    );
  }
}
