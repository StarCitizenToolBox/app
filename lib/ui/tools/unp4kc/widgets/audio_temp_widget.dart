import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:starcitizen_doctor/common/rust/rust_audio_player.dart';
import 'package:starcitizen_doctor/common/rust/api/unp4k_api.dart' as unp4k_api;

import '../../../../widgets/widgets.dart';
import 'models.dart';
import 'waveform_painter.dart';

final Map<String, List<double>> audioWaveformCache = <String, List<double>>{};
final Map<String, Future<void>> _wemFullDecodeInFlight =
    <String, Future<void>>{};

double _audioLastVolume = 1.0;
bool _audioAutoPlay = true;

class AudioTempWidget extends HookWidget {
  final String filePath;

  const AudioTempWidget(this.filePath, {super.key});

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
    final isPreparing = useState(true);
    final isPreviewMode = useState(false);
    final isFullDecodeInProgress = useState(false);
    final previewTip = useState<String?>(null);
    final autoPlay = useState(_audioAutoPlay);
    final prepareTokenRef = useRef<int>(0);
    final pollTimerRef = useRef<Timer?>(null);
    final seekRequestRef = useRef<int>(0);
    final overlayKeyRef = useRef<GlobalKey<_PreviewModeOverlayState>>(
      GlobalKey(),
    );
    final pendingFullSwitch = useRef<({String path, bool wasPlaying})?>(null);

    void syncPlayerState(AudioPlaybackState state) {
      if (state.durationMs != null) {
        duration.value = Duration(milliseconds: state.durationMs!);
      }
      position.value = Duration(milliseconds: state.positionMs);
      isPlaying.value = state.isPlaying;
      isPaused.value = state.isPaused;
      volume.value = state.volume;
    }

    useEffect(() {
      var disposed = false;
      final currentToken = ++prepareTokenRef.value;
      pollTimerRef.value?.cancel();

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
          final state = await player.refresh();
          if (disposed || prepareTokenRef.value != currentToken) return;
          syncPlayerState(state);
        } catch (e) {
          if (disposed || prepareTokenRef.value != currentToken) return;
          errorMessage.value = _friendlyAudioError(e);
        }
      });

      () async {
        try {
          if (disposed) return;
          await unp4k_api.p4KCancelWemDecode();
          isPreparing.value = true;
          errorMessage.value = null;
          isPreviewMode.value = false;
          isFullDecodeInProgress.value = false;
          previewTip.value = null;
          final prepared = await _preparePlayableFile(filePath);
          if (disposed) return;
          if (prepareTokenRef.value != currentToken) return;
          playablePath.value = prepared.playPath;
          isPreviewMode.value = prepared.isPreviewMode;
          isFullDecodeInProgress.value = prepared.fullDecodeFuture != null;
          previewTip.value = prepared.fullDecodeFuture == null
              ? null
              : "预览模式：完整文件解码中";
          final cachedWaveform = audioWaveformCache[prepared.playPath];
          if (cachedWaveform != null) {
            waveform.value = cachedWaveform;
          } else {
            final data = await File(prepared.playPath).readAsBytes();
            if (disposed) return;
            if (prepareTokenRef.value != currentToken) return;
            estimatedDuration.value = _estimateDurationFromAudioBytes(data);
            final computed = await compute(_computeWaveformFromBytes, data);
            if (disposed || prepareTokenRef.value != currentToken) return;
            audioWaveformCache[prepared.playPath] = computed;
            waveform.value = computed;
          }
          try {
            final state = await player.refresh();
            if (!disposed && prepareTokenRef.value == currentToken) {
              syncPlayerState(state);
            }
          } catch (e) {
            if (!disposed && prepareTokenRef.value == currentToken) {
              errorMessage.value = _friendlyAudioError(e);
            }
          }
          if (prepared.fullDecodeFuture != null) {
            unawaited(() async {
              try {
                await prepared.fullDecodeFuture;
              } catch (_) {}
              if (disposed || prepareTokenRef.value != currentToken) return;
              final fullPath = prepared.fullWavPath;
              if (fullPath == null || !await File(fullPath).exists()) {
                isFullDecodeInProgress.value = false;
                isPreviewMode.value = false;
                previewTip.value = null;
                return;
              }

              final wasPlaying = isPlaying.value;
              final shouldAutoPlay = autoPlay.value;
              final totalMs = duration.value.inMilliseconds;
              final currentMs = position.value.inMilliseconds;
              final atEnd = totalMs > 0 && currentMs >= totalMs - 500;

              pendingFullSwitch.value = (
                path: fullPath,
                wasPlaying: wasPlaying || atEnd || shouldAutoPlay,
              );

              overlayKeyRef.value.currentState?.startExitAnimation();
            }());
          }
        } catch (e) {
          if (disposed) return;
          if (prepareTokenRef.value != currentToken) return;
          errorMessage.value = _friendlyAudioError(e);
        }

        if (!disposed && prepareTokenRef.value == currentToken) {
          isPreparing.value = false;
          if (autoPlay.value && playablePath.value != null) {
            await Future.delayed(const Duration(seconds: 1));
            if (disposed || prepareTokenRef.value != currentToken) return;
            try {
              final state = await player.playFile(playablePath.value!);
              syncPlayerState(state);
            } catch (e) {
              errorMessage.value = _friendlyAudioError(e);
            }
          }
        }
      }();

      return () {
        disposed = true;
        pollTimerRef.value?.cancel();
        unawaited(unp4k_api.p4KCancelWemDecode());
        unawaited(player.dispose());
      };
    }, [filePath]);

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

    if (isPreparing.value) {
      return makeLoading(context);
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
                  "音频预览失败：${errorMessage.value}",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        );
      }
      return const Center(child: Text("音频预览失败：未找到可播放文件"));
    }

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

    Future<void> seekToPosition(
      int targetMs, {
      required bool resumeIfPlaying,
    }) async {
      final requestId = ++seekRequestRef.value;
      final int clampedTargetMs = targetMs.clamp(0, totalMs).toInt();
      final previousPosition = position.value;
      position.value = Duration(milliseconds: clampedTargetMs);
      dragMs.value = clampedTargetMs.toDouble();

      try {
        final state = await player.seek(
          Duration(milliseconds: clampedTargetMs),
        );
        if (requestId != seekRequestRef.value) return;
        syncPlayerState(state);
        position.value = Duration(milliseconds: clampedTargetMs);
        if (resumeIfPlaying && state.isPaused) {
          final resumed = await player.resume();
          if (requestId != seekRequestRef.value) return;
          syncPlayerState(resumed);
          position.value = Duration(milliseconds: clampedTargetMs);
        }
      } catch (e) {
        if (requestId != seekRequestRef.value) return;
        position.value = previousPosition;
        errorMessage.value = e.toString();
      } finally {
        if (requestId == seekRequestRef.value) {
          dragMs.value = null;
        }
      }
    }

    Future<void> togglePlay() async {
      final sourcePath = playablePath.value;
      if (sourcePath == null) return;
      if (isPlaying.value) {
        try {
          final state = await player.pause();
          syncPlayerState(state);
        } catch (_) {}
        return;
      }
      bool shouldReplay = false;
      if (totalMs > 0 && currentMs >= totalMs - 500) {
        shouldReplay = true;
      }
      final startAt = shouldReplay
          ? Duration.zero
          : Duration(milliseconds: effectiveMs.round());
      try {
        final state =
            player.currentSourcePath == sourcePath &&
                isPaused.value &&
                !shouldReplay
            ? await player.resume()
            : await player.playFile(sourcePath, position: startAt);
        syncPlayerState(state);
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
                  child: Container(
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
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CustomPaint(
                              painter: WaveformPainter(
                                samples: waveform.value,
                                progress: progress,
                                totalMs: totalMs,
                              ),
                            ),
                          ),
                          if (isPreviewMode.value &&
                              isFullDecodeInProgress.value)
                            Positioned.fill(
                              child: _PreviewModeOverlay(
                                key: overlayKeyRef.value,
                                onComplete: () async {
                                  final pending = pendingFullSwitch.value;
                                  if (pending == null) return;
                                  pendingFullSwitch.value = null;

                                  isFullDecodeInProgress.value = false;
                                  isPreviewMode.value = false;

                                  try {
                                    await player.stop();
                                  } catch (_) {}

                                  playablePath.value = pending.path;

                                  final cached =
                                      audioWaveformCache[pending.path];
                                  if (cached != null) {
                                    waveform.value = cached;
                                  } else {
                                    try {
                                      final data = await File(
                                        pending.path,
                                      ).readAsBytes();
                                      estimatedDuration.value =
                                          _estimateDurationFromAudioBytes(data);
                                      final computed = await compute(
                                        _computeWaveformFromBytes,
                                        data,
                                      );
                                      audioWaveformCache[pending.path] =
                                          computed;
                                      waveform.value = computed;
                                    } catch (_) {}
                                  }

                                  position.value = Duration.zero;
                                  if (pending.wasPlaying) {
                                    try {
                                      final state = await player.playFile(
                                        pending.path,
                                      );
                                      syncPlayerState(state);
                                    } catch (_) {}
                                  }
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
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
                        dragVolume.value = dxToRatio(localPosition.dx) * 3.0;
                      },
                      onHorizontalDragUpdate: (details) {
                        final localPosition = localOffsetFromGlobal(
                          details.globalPosition,
                        );
                        if (localPosition == null) return;
                        final ratio = dxToRatio(localPosition.dx);
                        dragVolume.value = ratio * 3.0;
                      },
                      onHorizontalDragEnd: (_) async {
                        if (dragVolume.value == null) return;
                        final v = dragVolume.value!.clamp(0.0, 3.0);
                        volume.value = v;
                        final state = await player.setVolume(v);
                        syncPlayerState(state);
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

  Future<PreparedPlayableFile> _preparePlayableFile(String sourcePath) async {
    final lower = sourcePath.toLowerCase();
    if (lower.endsWith(".wav") ||
        lower.endsWith(".mp3") ||
        lower.endsWith(".ogg") ||
        lower.endsWith(".flac") ||
        lower.endsWith(".m4a")) {
      return PreparedPlayableFile(playPath: sourcePath);
    }

    if (lower.endsWith(".wem")) {
      final previewPath = "$sourcePath.preview.mid10s.v1.wav";
      final targetPath = "$sourcePath.preview.v2.wav";
      final sourceFile = File(sourcePath);
      final previewFile = File(previewPath);
      final targetFile = File(targetPath);
      final legacyPreviewOgg = File("$sourcePath.preview.mid10s.v1.ogg");
      final legacyTargetOgg = File("$sourcePath.preview.v2.ogg");
      String? previewDecodeError;
      String? fullDecodeError;

      Future<void> clearLegacyOggCache() async {
        for (final file in [legacyPreviewOgg, legacyTargetOgg]) {
          if (await file.exists()) {
            try {
              await file.delete();
            } catch (_) {}
          }
        }
      }

      await clearLegacyOggCache();

      bool isFreshCache(File f) {
        if (!f.existsSync()) return false;
        final srcStat = sourceFile.statSync();
        final outStat = f.statSync();
        return outStat.size > 0 &&
            (outStat.modified.isAfter(srcStat.modified) ||
                outStat.modified.isAtSameMomentAs(srcStat.modified));
      }

      Future<void>? warmupFullWavInBackground() {
        if (isFreshCache(targetFile)) return null;
        final existing = _wemFullDecodeInFlight[targetPath];
        if (existing != null) return existing;
        final task = () async {
          try {
            await unp4k_api.p4KDecodeWemToWav(
              inputPath: sourcePath,
              outputPath: targetPath,
            );
          } catch (e) {
            fullDecodeError ??= e.toString();
            rethrow;
          } finally {
            _wemFullDecodeInFlight.remove(targetPath);
          }
        }();
        _wemFullDecodeInFlight[targetPath] = task;
        return task;
      }

      if (isFreshCache(targetFile)) {
        return PreparedPlayableFile(playPath: targetPath);
      }

      if (isFreshCache(previewFile)) {
        final fullTask = warmupFullWavInBackground();
        return PreparedPlayableFile(
          playPath: previewPath,
          isPreviewMode: fullTask != null,
          fullWavPath: targetPath,
          fullDecodeFuture: fullTask,
        );
      }

      try {
        await unp4k_api.p4KDecodeWemToWavPreview(
          inputPath: sourcePath,
          outputPath: previewPath,
          clipSeconds: 10,
        );
      } catch (e) {
        previewDecodeError = e.toString();
      }
      final ok = isFreshCache(previewFile);

      final fullTask = warmupFullWavInBackground();
      if (ok) {
        return PreparedPlayableFile(
          playPath: previewPath,
          isPreviewMode: fullTask != null,
          fullWavPath: targetPath,
          fullDecodeFuture: fullTask,
        );
      }
      if (fullTask != null) {
        try {
          await fullTask;
        } catch (e) {
          fullDecodeError ??= e.toString();
        }
      }
      if (await targetFile.exists()) {
        final stat = await targetFile.stat();
        if (stat.size > 44) {
          return PreparedPlayableFile(playPath: targetPath);
        }
      }
      if (await previewFile.exists()) {
        final stat = await previewFile.stat();
        if (stat.size > 44) {
          return PreparedPlayableFile(playPath: previewPath);
        }
      }
      throw Exception(
        "WEM 转 WAV 失败：未生成可播放文件\n"
        "preview=${previewFile.path}\n"
        "full=${targetFile.path}\n"
        "previewError=${previewDecodeError ?? 'none'}\n"
        "fullError=${fullDecodeError ?? 'none'}",
      );
    }

    return PreparedPlayableFile(playPath: sourcePath);
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

  static List<double> _buildWaveform(Uint8List data, {int points = 120}) {
    if (data.isEmpty) return const [];
    final pcm = _extractPcm16Data(data);
    if (pcm != null) {
      return _bucketizePcm16(pcm, points);
    }
    return _bucketizeBytes(data, points);
  }

  static Uint8List? _extractPcm16Data(Uint8List bytes) {
    if (bytes.length < 44) return null;
    if (String.fromCharCodes(bytes.sublist(0, 4)) != "RIFF") return null;
    if (String.fromCharCodes(bytes.sublist(8, 12)) != "WAVE") return null;

    int? audioFormat;
    int? bitsPerSample;
    int? dataOffset;
    int? dataLength;
    int offset = 12;

    while (offset + 8 <= bytes.length) {
      final chunkId = String.fromCharCodes(bytes.sublist(offset, offset + 4));
      final chunkSize = bytes.buffer.asByteData().getUint32(
        offset + 4,
        Endian.little,
      );
      final chunkDataStart = offset + 8;
      final chunkDataEnd = chunkDataStart + chunkSize;
      if (chunkDataEnd > bytes.length) break;

      if (chunkId == "fmt " && chunkSize >= 16) {
        final bd = bytes.buffer.asByteData();
        audioFormat = bd.getUint16(chunkDataStart, Endian.little);
        bitsPerSample = bd.getUint16(chunkDataStart + 14, Endian.little);
      } else if (chunkId == "data") {
        dataOffset = chunkDataStart;
        dataLength = chunkSize;
      }

      offset = chunkDataEnd + (chunkSize.isOdd ? 1 : 0);
    }

    if (audioFormat != 1 ||
        bitsPerSample != 16 ||
        dataOffset == null ||
        dataLength == null) {
      return null;
    }
    return Uint8List.sublistView(bytes, dataOffset, dataOffset + dataLength);
  }

  static List<double> _bucketizePcm16(Uint8List pcm, int points) {
    final sampleCount = pcm.length ~/ 2;
    if (sampleCount == 0) return const [];
    final bd = pcm.buffer.asByteData(pcm.offsetInBytes, pcm.lengthInBytes);
    final bucket = math.max(1, sampleCount ~/ points).toInt();
    final out = <double>[];
    for (int i = 0; i < sampleCount; i += bucket) {
      final end = math.min(sampleCount, i + bucket);
      double peak = 0;
      for (int j = i; j < end; j++) {
        final v = bd.getInt16(j * 2, Endian.little).abs() / 32768.0;
        if (v > peak) peak = v;
      }
      out.add(peak.clamp(0.0, 1.0));
    }
    return out;
  }

  static List<double> _bucketizeBytes(Uint8List data, int points) {
    final bucket = math.max(1, data.length ~/ points).toInt();
    final out = <double>[];
    for (int i = 0; i < data.length; i += bucket) {
      final end = math.min(data.length, i + bucket);
      double peak = 0;
      for (int j = i; j < end; j++) {
        final v = (data[j] - 128).abs() / 128.0;
        if (v > peak) peak = v;
      }
      out.add(peak.clamp(0.0, 1.0));
    }
    return out;
  }

  static Duration _estimateDurationFromAudioBytes(Uint8List bytes) {
    if (bytes.length < 44) return Duration.zero;
    if (String.fromCharCodes(bytes.sublist(0, 4)) != "RIFF") {
      return Duration.zero;
    }
    if (String.fromCharCodes(bytes.sublist(8, 12)) != "WAVE") {
      return Duration.zero;
    }

    int? channels;
    int? sampleRate;
    int? bitsPerSample;
    int? dataLength;
    int offset = 12;

    while (offset + 8 <= bytes.length) {
      final chunkId = String.fromCharCodes(bytes.sublist(offset, offset + 4));
      final chunkSize = bytes.buffer.asByteData().getUint32(
        offset + 4,
        Endian.little,
      );
      final chunkDataStart = offset + 8;
      final chunkDataEnd = chunkDataStart + chunkSize;
      if (chunkDataEnd > bytes.length) break;

      if (chunkId == "fmt " && chunkSize >= 16) {
        final bd = bytes.buffer.asByteData();
        channels = bd.getUint16(chunkDataStart + 2, Endian.little);
        sampleRate = bd.getUint32(chunkDataStart + 4, Endian.little);
        bitsPerSample = bd.getUint16(chunkDataStart + 14, Endian.little);
      } else if (chunkId == "data") {
        dataLength = chunkSize;
      }

      offset = chunkDataEnd + (chunkSize.isOdd ? 1 : 0);
    }

    if (channels == null ||
        sampleRate == null ||
        bitsPerSample == null ||
        dataLength == null ||
        channels <= 0 ||
        sampleRate <= 0 ||
        bitsPerSample <= 0) {
      return Duration.zero;
    }

    final bytesPerSecond = sampleRate * channels * (bitsPerSample / 8.0);
    if (bytesPerSecond <= 0) return Duration.zero;
    final ms = (dataLength * 1000.0 / bytesPerSecond).round();
    return Duration(milliseconds: ms);
  }
}

List<double> _computeWaveformFromBytes(Uint8List data) {
  return AudioTempWidget._buildWaveform(data, points: 160);
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
    final title = _showComplete ? "完成，播放完整音频" : "预览模式";
    final subtitle = _showComplete ? "正在切换..." : "正在解码完整音频...";
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
  double size = 0;
  double alpha = 0;
  double speedMultiplier = 1.0;
  bool isAlive = true;
  final math.Random random;

  _Particle(this.random) {
    reset();
  }

  void reset() {
    x = -0.1;
    y = random.nextDouble();
    speed = (0.008 + random.nextDouble() * 0.015) / 3;
    size = 1.5 + random.nextDouble() * 2.5;
    alpha = 0.3 + random.nextDouble() * 0.3;
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
    final paint = Paint()
      ..color = Color.fromRGBO(255, 255, 255, alpha * (1 - x * 0.3))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    final centerX = x * canvasSize.width;
    final centerY = y * canvasSize.height;

    canvas.drawCircle(Offset(centerX, centerY), size, paint);

    final trailLength = 0.08 + speed * 6 * speedMultiplier;
    final trailPaint = Paint()
      ..color = Color.fromRGBO(255, 255, 255, alpha * 0.3 * (1 - x * 0.3))
      ..strokeWidth = size * 0.6
      ..strokeCap = StrokeCap.round;

    final trailPath = Path()
      ..moveTo(centerX, centerY)
      ..lineTo((x - trailLength).clamp(0, 1.5) * canvasSize.width, centerY);

    canvas.drawPath(trailPath, trailPaint..style = PaintingStyle.stroke);
  }
}
