import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common/rust/api/unp4k_model_api.dart' as model_api;
import '../../../../widgets/widgets.dart';

/// 将 Color 转换为 Float32List (RGBA, 0-1 范围)
Float32List colorToFloat32List(Color color) {
  return Float32List.fromList([
    color.r, // red (0.0 - 1.0)
    color.g, // green (0.0 - 1.0)
    color.b, // blue (0.0 - 1.0)
    color.a, // alpha (0.0 - 1.0)
  ]);
}

/// 模型查看器配置
class ModelViewerConfig {
  final double initialDistance;
  final double minDistance;
  final double maxDistance;
  final double rotationSpeed;
  final double moveSpeed;
  final double zoomSpeed;

  const ModelViewerConfig({
    this.initialDistance = 3.0,
    this.minDistance = 0.01,
    this.maxDistance = 500.0,
    this.rotationSpeed = 0.01,
    this.moveSpeed = 0.03,
    this.zoomSpeed = 1.1,
  });
}

class ModelTempWidget extends HookConsumerWidget {
  final Uint8List? glbBytes;
  final String? glbPath;
  final String? p4kPath;
  final String? modelPath;
  final ModelViewerConfig config;

  const ModelTempWidget(
    this.glbBytes, {
    super.key,
    this.config = const ModelViewerConfig(),
  }) : glbPath = null,
       p4kPath = null,
       modelPath = null;

  const ModelTempWidget.fromPath(
    this.glbPath, {
    super.key,
    this.config = const ModelViewerConfig(),
  }) : glbBytes = null,
       p4kPath = null,
       modelPath = null;

  const ModelTempWidget.fromP4k({
    super.key,
    required this.p4kPath,
    required this.modelPath,
    this.config = const ModelViewerConfig(),
  }) : glbBytes = null,
       glbPath = null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionId = useState<String?>(null);
    final image = useState<ui.Image?>(null);
    final isInitializing = useState(true);
    final errorMessage = useState<String?>(null);
    final loadingStage = useState<String?>(null);
    final modelRadius = useState(1.0);

    final cameraDistance = useState(config.initialDistance);
    final cameraYaw = useState(0.0);
    final cameraPitch = useState(0.0);
    final targetX = useState(0.0);
    final targetY = useState(0.0);
    final targetZ = useState(0.0);

    final lastPosition = useState<Offset?>(null);
    // 拖动类型：0=无, 1=左键旋转, 2=右键平移
    final dragType = useRef<int>(0);

    // 是否已卸载（防止 async gap 后在 defunct element 上 setState）
    final isMounted = useRef<bool>(true);

    // 是否正在渲染（限制并发）
    final isRendering = useRef<bool>(false);
    // 是否有待处理的渲染请求
    final hasPendingRender = useRef<bool>(false);
    // 是否正在拖动（拖动时不通过 useEffect 触发渲染）
    final isDragging = useRef<bool>(false);
    // 上次渲染时的相机角度（用于采样防抖）
    final lastRenderedYaw = useRef<double>(0.0);
    final lastRenderedPitch = useRef<double>(0.0);
    final initGeneration = useRef<int>(0);

    // 渲染计数和 FPS 计算
    final renderCount = useRef<int>(0);
    final lastFpsTime = useRef<DateTime>(DateTime.now());
    final fps = useState<double>(0.0);

    final size = MediaQuery.of(context).size;
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(
      context,
    ).clamp(1.0, 2.0);
    final width = (size.width * 0.5 * devicePixelRatio)
        .clamp(512, 1024)
        .toInt();
    final height = (size.height * 0.6 * devicePixelRatio)
        .clamp(512, 1024)
        .toInt();

    Future<void> renderModel() async {
      final renderSessionId = sessionId.value;
      if (renderSessionId == null) return;

      // 如果正在渲染，标记有待处理请求，然后返回
      if (isRendering.value) {
        hasPendingRender.value = true;
        return;
      }

      isRendering.value = true;
      try {
        final camX =
            cameraDistance.value *
                math.cos(cameraYaw.value) *
                math.cos(cameraPitch.value) +
            targetX.value;
        final camY =
            cameraDistance.value * math.sin(cameraPitch.value) + targetY.value;
        final camZ =
            cameraDistance.value *
                math.sin(cameraYaw.value) *
                math.cos(cameraPitch.value) +
            targetZ.value;

        final result = await model_api.p4KModelSessionRender(
          sessionId: renderSessionId,
          cameraX: camX,
          cameraY: camY,
          cameraZ: camZ,
          targetX: targetX.value,
          targetY: targetY.value,
          targetZ: targetZ.value,
        );

        // async gap 后检查是否已卸载，避免在 defunct element 上 setState
        if (!isMounted.value || sessionId.value != renderSessionId) return;

        if (result.success && result.rgbaData != null) {
          final completer = Completer<ui.Image>();
          ui.decodeImageFromPixels(
            result.rgbaData!,
            result.width,
            result.height,
            ui.PixelFormat.rgba8888,
            (img) => completer.complete(img),
          );
          final newImage = await completer.future;

          if (!isMounted.value || sessionId.value != renderSessionId) {
            newImage.dispose();
            return;
          }

          // 释放旧的 ui.Image，避免 GPU 资源泄漏
          final oldImage = image.value;
          image.value = newImage;
          oldImage?.dispose();

          // FPS 计算
          renderCount.value++;
          final now = DateTime.now();
          final elapsed = now.difference(lastFpsTime.value).inMilliseconds;
          if (elapsed >= 1000) {
            fps.value = (renderCount.value * 1000) / elapsed;
            renderCount.value = 0;
            lastFpsTime.value = now;
          }
        }
      } catch (e) {
        if (!isMounted.value) return;
        if (loadingStage.value == "upgrading_renderer" &&
            e.toString().contains("Session not found")) {
          return;
        }
        errorMessage.value = e.toString();
      } finally {
        isRendering.value = false;
        // 如果渲染期间有新的请求，继续渲染
        if (hasPendingRender.value && isMounted.value) {
          hasPendingRender.value = false;
          // 使用 microtask 避免栈溢出
          scheduleMicrotask(renderModel);
        }
      }
    }

    // 直接渲染，无防抖
    void scheduleRender({bool immediate = false}) {
      renderModel();
    }

    // 基于角度变化的采样防抖
    // 只有当累积的角度变化超过阈值时才触发渲染
    // 阈值约 1.15 度
    void tryScheduleRenderByAngle() {
      const double angleThreshold = 0.02;
      final deltaYaw = (cameraYaw.value - lastRenderedYaw.value).abs();
      final deltaPitch = (cameraPitch.value - lastRenderedPitch.value).abs();

      if (deltaYaw >= angleThreshold || deltaPitch >= angleThreshold) {
        lastRenderedYaw.value = cameraYaw.value;
        lastRenderedPitch.value = cameraPitch.value;
        scheduleRender();
      }
    }

    Future<void> initializeSession(int generation) async {
      try {
        isInitializing.value = true;
        errorMessage.value = null;

        // Initialize the OpenGL context (required on Windows)
        await model_api.p4KModelInitContext();

        if (!isMounted.value || initGeneration.value != generation) return;

        // Background color: #3B4750
        final bgColor = colorToFloat32List(Color.fromRGBO(9, 13, 16, 1.0));

        if (p4kPath != null && modelPath != null) {
          loadingStage.value = "queued";
          final start = await model_api.p4KModelSessionStartFromP4K(
            p4KPath: p4kPath!,
            modelPath: modelPath!,
            width: width,
            height: height,
            bgColor: bgColor,
            options: const model_api.ModelConvertOptions(
              embedTextures: true,
              overwrite: true,
              maxTextureSize: 1024,
            ),
          );
          if (!isMounted.value || initGeneration.value != generation) {
            final staleSessionId = start.sessionId;
            if (staleSessionId != null) {
              await model_api.p4KModelSessionRelease(sessionId: staleSessionId);
            }
            return;
          }
          if (!start.success || start.sessionId == null) {
            errorMessage.value =
                start.errorMessage ?? "Failed to start session";
            return;
          }
          sessionId.value = start.sessionId;
          var hasRenderedPreview = false;
          while (isMounted.value) {
            await Future<void>.delayed(const Duration(milliseconds: 180));
            final status = await model_api.p4KModelSessionStatus(
              sessionId: start.sessionId!,
            );
            if (!isMounted.value || initGeneration.value != generation) return;
            loadingStage.value = status.stage;
            if (status.failed) {
              errorMessage.value =
                  status.errorMessage ?? "Failed to create session";
              return;
            }
            if (status.ready) {
              if (!hasRenderedPreview || status.stage == "ready") {
                modelRadius.value = status.modelRadius;
                cameraDistance.value = status.modelRadius * 2.75;
                lastRenderedYaw.value = cameraYaw.value;
                lastRenderedPitch.value = cameraPitch.value;
                await renderModel();
                hasRenderedPreview = true;
                isInitializing.value = false;
              }
              if (status.stage == "ready" ||
                  status.stage == "previewing_geometry_texture_failed" ||
                  status.stage == "previewing_untextured_texture_failed") {
                return;
              }
            }
          }
          return;
        }

        final result = glbPath != null
            ? await model_api.p4KModelSessionCreate(
                glbPath: glbPath!,
                width: width,
                height: height,
                bgColor: bgColor,
              )
            : await model_api.p4KModelSessionCreateFromBytes(
                glbBytes: glbBytes!,
                width: width,
                height: height,
                bgColor: bgColor,
              );

        if (!isMounted.value || initGeneration.value != generation) return;

        if (result.success && result.sessionId != null) {
          sessionId.value = result.sessionId;
          modelRadius.value = result.modelRadius;
          cameraDistance.value = result.modelRadius * 2.75;
          // 初始化渲染角度记录
          lastRenderedYaw.value = cameraYaw.value;
          lastRenderedPitch.value = cameraPitch.value;
          await renderModel();
        } else {
          errorMessage.value =
              result.errorMessage ?? "Failed to create session";
        }
      } catch (e) {
        if (!isMounted.value || initGeneration.value != generation) return;
        errorMessage.value = e.toString();
      } finally {
        if (isMounted.value && initGeneration.value == generation) {
          isInitializing.value = false;
          loadingStage.value = null;
        }
      }
    }

    // 重置视角
    void resetView() {
      cameraDistance.value = modelRadius.value * 2.75;
      cameraYaw.value = 0.0;
      cameraPitch.value = 0.0;
      targetX.value = 0.0;
      targetY.value = 0.0;
      targetZ.value = 0.0;
    }

    useEffect(() {
      initGeneration.value++;
      final generation = initGeneration.value;
      isMounted.value = true;
      isInitializing.value = true;
      errorMessage.value = null;
      loadingStage.value = null;
      final previousSessionId = sessionId.value;
      sessionId.value = null;
      if (previousSessionId != null) {
        model_api.p4KModelSessionRelease(sessionId: previousSessionId);
      }
      final oldImage = image.value;
      image.value = null;
      oldImage?.dispose();
      initializeSession(generation);
      // 清理时释放 session 和 ui.Image
      return () {
        final isCurrentGeneration = initGeneration.value == generation;
        if (isCurrentGeneration) {
          isMounted.value = false;
        }
        final oldImage = image.value;
        // 不设置 image.value = null，避免在 defunct element 上触发 setState
        // dispose 后 ValueNotifier 会被 GC 回收，无需清空
        oldImage?.dispose();
        final currentSessionId = isCurrentGeneration ? sessionId.value : null;
        if (currentSessionId != null) {
          sessionId.value = null;
          model_api.p4KModelSessionRelease(sessionId: currentSessionId);
        }
      };
    }, [glbBytes, glbPath, p4kPath, modelPath, width, height]);

    useEffect(
      () {
        // 拖动时不通过 useEffect 触发渲染（避免高频触发）
        if (sessionId.value != null &&
            !isInitializing.value &&
            !isDragging.value) {
          scheduleRender();
        }
        return null;
      },
      [
        cameraDistance.value,
        cameraYaw.value,
        cameraPitch.value,
        targetX.value,
        targetY.value,
        targetZ.value,
      ],
    );

    if (isInitializing.value) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            makeLoading(context),
            if (loadingStage.value != null) ...[
              const SizedBox(height: 12),
              Text(loadingStage.value!),
            ],
          ],
        ),
      );
    }

    if (errorMessage.value != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              FluentIcons.error,
              size: 48,
              color: Colors.errorPrimaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage.value!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.errorPrimaryColor),
            ),
          ],
        ),
      );
    }

    // 平移速度因子
    const panSpeedFactor = 0.002;
    final minCameraDistance = math.min(
      config.minDistance,
      modelRadius.value * 0.05,
    );
    final maxCameraDistance = math.max(
      config.maxDistance,
      modelRadius.value * 20.0,
    );

    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerSignal: (signal) {
        if (signal is PointerScrollEvent) {
          final delta = signal.scrollDelta.dy > 0
              ? config.zoomSpeed
              : 1.0 / config.zoomSpeed;
          cameraDistance.value = (cameraDistance.value * delta).clamp(
            minCameraDistance,
            maxCameraDistance,
          );
        }
      },
      onPointerDown: (event) {
        lastPosition.value = event.localPosition;
        isDragging.value = true;
        lastRenderedYaw.value = cameraYaw.value;
        lastRenderedPitch.value = cameraPitch.value;
        // 0=左键旋转, 2=右键平移
        dragType.value = event.buttons == 2 ? 2 : 1;
      },
      onPointerMove: (event) {
        if (lastPosition.value == null) return;

        final delta = event.localPosition - lastPosition.value!;

        if (dragType.value == 2) {
          // 右键：平移
          final panSpeed = cameraDistance.value * panSpeedFactor;
          // 水平移动：垂直于视线方向
          targetX.value -= delta.dx * panSpeed * math.sin(cameraYaw.value);
          targetZ.value += delta.dx * panSpeed * math.cos(cameraYaw.value);
          // 垂直移动：Y轴（向上拖动时目标点上移）
          targetY.value += delta.dy * panSpeed;
          scheduleRender();
        } else {
          // 左键：旋转
          cameraYaw.value += delta.dx * config.rotationSpeed;
          cameraPitch.value =
              (cameraPitch.value + delta.dy * config.rotationSpeed).clamp(
                -math.pi / 2 + 0.01,
                math.pi / 2 - 0.01,
              );
          tryScheduleRenderByAngle();
        }

        lastPosition.value = event.localPosition;
      },
      onPointerUp: (_) {
        lastPosition.value = null;
        isDragging.value = false;
        dragType.value = 0;
        lastRenderedYaw.value = cameraYaw.value;
        lastRenderedPitch.value = cameraPitch.value;
        scheduleRender(immediate: true);
      },
      onPointerCancel: (_) {
        lastPosition.value = null;
        isDragging.value = false;
        dragType.value = 0;
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          color: Colors.transparent,
          child: Stack(
            children: [
              // 模型渲染区域 - 填充整个容器
              if (image.value != null)
                Positioned.fill(
                  child: CustomPaint(
                    painter: _ImagePainter(image.value!, fitContainer: true),
                  ),
                ),
              // 信息面板
              Positioned(
                top: 8,
                left: 8,
                child: _InfoPanel(
                  fps: fps.value,
                  distance: cameraDistance.value,
                  modelRadius: modelRadius.value,
                ),
              ),
              if (loadingStage.value != null && loadingStage.value != 'ready')
                Positioned(
                  top: 8,
                  right: 8,
                  child: _StageBadge(stage: loadingStage.value!),
                ),
              // 操作提示
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'LMB: Rotate | RMB: Pan | Scroll: Zoom',
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ),
              // 重置按钮
              Positioned(
                bottom: 8,
                right: 8,
                child: Tooltip(
                  message: 'Reset View',
                  child: IconButton(
                    icon: const Icon(FluentIcons.reset, size: 16),
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Colors.black.withValues(alpha: 0.5),
                      ),
                      foregroundColor: const WidgetStatePropertyAll(
                        Colors.white,
                      ),
                    ),
                    onPressed: resetView,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 信息面板组件
class _InfoPanel extends StatelessWidget {
  final double fps;
  final double distance;
  final double modelRadius;

  const _InfoPanel({
    required this.fps,
    required this.distance,
    required this.modelRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width - 32,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (fps > 0)
            Text(
              'FPS: ${fps.toStringAsFixed(1)}',
              style: const TextStyle(color: Colors.white, fontSize: 11),
            ),
          Text(
            'Distance: ${distance.toStringAsFixed(2)}',
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
          Text(
            'Radius: ${modelRadius.toStringAsFixed(2)}',
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _StageBadge extends StatelessWidget {
  final String stage;

  const _StageBadge({required this.stage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width - 32,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        stage,
        style: const TextStyle(color: Colors.white, fontSize: 11),
      ),
    );
  }
}

class _ImagePainter extends CustomPainter {
  final ui.Image image;
  final bool fitContainer;

  _ImagePainter(this.image, {this.fitContainer = true});

  @override
  void paint(Canvas canvas, Size size) {
    // 启用透明通道
    final paint = Paint()
      ..isAntiAlias = true
      ..filterQuality = ui.FilterQuality.high;

    if (fitContainer) {
      // 计算缩放以填充容器 (cover 模式)
      final imageAspect = image.width / image.height;
      final containerAspect = size.width / size.height;

      double drawWidth, drawHeight;
      if (imageAspect > containerAspect) {
        // 图像更宽，以高度为准
        drawHeight = size.height;
        drawWidth = drawHeight * imageAspect;
      } else {
        // 图像更高，以宽度为准
        drawWidth = size.width;
        drawHeight = drawWidth / imageAspect;
      }

      // 居中绘制
      final dx = (size.width - drawWidth) / 2;
      final dy = (size.height - drawHeight) / 2;

      final srcRect = Rect.fromLTWH(
        0,
        0,
        image.width.toDouble(),
        image.height.toDouble(),
      );
      final dstRect = Rect.fromLTWH(dx, dy, drawWidth, drawHeight);

      canvas.drawImageRect(image, srcRect, dstRect, paint);
    } else {
      canvas.drawImage(image, Offset.zero, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ImagePainter oldDelegate) {
    return oldDelegate.image != image ||
        oldDelegate.fitContainer != fitContainer;
  }
}
