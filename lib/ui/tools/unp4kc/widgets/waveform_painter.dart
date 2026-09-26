import 'dart:math' as math;

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';

import 'models.dart';

/// Digits of equal width, so time labels keep their width as they count.
const _tabularFigures = [FontFeature.tabularFigures()];

class WaveformPainter extends CustomPainter {
  final List<double> samples;

  /// Playback position in milliseconds. The painter repaints on its own when
  /// it changes, without rebuilding the widget around it.
  final ValueListenable<double> positionMs;

  /// Overrides [positionMs] while the playhead is being dragged.
  final double? dragMs;
  final int totalMs;

  /// Mark labels only change with [totalMs]; laid out once per painter, which
  /// lives across the per-frame repaints.
  final _labelCache = <String, TextPainter>{};

  WaveformPainter({
    required this.samples,
    required this.positionMs,
    required this.dragMs,
    required this.totalMs,
  }) : super(repaint: positionMs);

  double get progress => totalMs > 0
      ? ((dragMs ?? positionMs.value) / totalMs).clamp(0.0, 1.0)
      : 0.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (samples.isEmpty || size.width <= 0 || size.height <= 0) return;
    final progress = this.progress;

    final topLabelH = 14.0;
    final bottomLabelH = 14.0;
    final timelineH = 16.0;
    final waveTop = topLabelH + 4;
    final waveBottom = size.height - bottomLabelH - timelineH - 4;
    if (waveBottom <= waveTop) return;

    final midY = (waveTop + waveBottom) / 2;
    final halfWave = (waveBottom - waveTop) / 2;
    final progressX = size.width * progress.clamp(0.0, 1.0);
    final marks = _buildMarks(totalMs);

    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: .2)
      ..strokeWidth = 1;
    final centerPaint = Paint()
      ..color = Colors.white.withValues(alpha: .18)
      ..strokeWidth = 1;
    final timelinePaint = Paint()
      ..color = Colors.white.withValues(alpha: .4)
      ..strokeWidth = 2;
    final progressPaint = Paint()
      ..color = Colors.white.withValues(alpha: .95)
      ..strokeWidth = 1.2;

    canvas.drawLine(Offset(0, midY), Offset(size.width, midY), centerPaint);
    for (final mark in marks) {
      final x = size.width * mark.ratio;
      canvas.drawLine(Offset(x, waveTop), Offset(x, waveBottom), gridPaint);
      _paintTimeLabel(
        canvas,
        _fmtSeconds(mark.second),
        x,
        0,
        alignTop: true,
        canvasWidth: size.width,
      );
      _paintTimeLabel(
        canvas,
        _fmtSeconds(mark.second),
        x,
        size.height - bottomLabelH,
        alignTop: false,
        canvasWidth: size.width,
      );
    }

    final barWidth = size.width / samples.length;
    for (int i = 0; i < samples.length; i++) {
      final amp = samples[i].clamp(0.02, 1.0);
      final halfH = math.max(1.0, halfWave * amp);
      final x = i * barWidth;
      final base = const Color(0xFF56D4FF);
      final color = x <= progressX
          ? base.withValues(alpha: .96)
          : base.withValues(alpha: .45);
      final rect = Rect.fromLTWH(
        x,
        midY - halfH,
        math.max(1, barWidth - 1),
        halfH * 2,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(1)),
        Paint()..color = color,
      );
    }

    final timelineY = size.height - bottomLabelH - (timelineH / 2);
    canvas.drawLine(
      Offset(0, timelineY),
      Offset(size.width, timelineY),
      timelinePaint,
    );
    canvas.drawLine(
      Offset(progressX, waveTop - 2),
      Offset(progressX, size.height - 1),
      progressPaint,
    );

    // Truncated like the time readout under the waveform, so both agree.
    final currentSec = totalMs <= 0 ? 0 : (totalMs * progress) ~/ 1000;
    _paintCurrentTag(
      canvas,
      _fmtSeconds(currentSec),
      progressX,
      timelineY - 16,
      size.width,
    );
  }

  static List<WaveMark> _buildMarks(int totalMs) {
    final totalSec = (totalMs / 1000).ceil();
    if (totalSec <= 0) return const [];
    int step = 300;
    if (totalSec <= 30) {
      step = 5;
    } else if (totalSec <= 120) {
      step = 15;
    } else if (totalSec <= 600) {
      step = 60;
    } else if (totalSec <= 1800) {
      step = 120;
    }
    final marks = <WaveMark>[];
    for (int sec = step; sec < totalSec; sec += step) {
      marks.add(WaveMark(sec / totalSec, sec));
    }
    return marks;
  }

  static String _fmtSeconds(int sec) {
    final m = (sec ~/ 60).toString();
    final s = (sec % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  void _paintTimeLabel(
    Canvas canvas,
    String text,
    double x,
    double y, {
    required bool alignTop,
    required double canvasWidth,
  }) {
    final tp = _labelCache.putIfAbsent(
      text,
      () => TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: Colors.white.withValues(alpha: .7),
            fontSize: 10,
            fontFeatures: _tabularFigures,
          ),
        ),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout(),
    );
    final dx = ((x - (tp.width / 2)).clamp(
      0.0,
      math.max(0.0, canvasWidth - tp.width),
    )).toDouble();
    final dy = alignTop ? y : (y + (14 - tp.height));
    tp.paint(canvas, Offset(dx, dy));
  }

  void _paintCurrentTag(
    Canvas canvas,
    String text,
    double x,
    double y,
    double canvasWidth,
  ) {
    const style = TextStyle(
      color: Colors.white,
      fontSize: 11,
      fontWeight: FontWeight.w600,
      fontFeatures: _tabularFigures,
    );
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    // Size the tag for the widest digits ("0:00" pattern) rather than the
    // text itself: with proportional digits the box would change width as
    // the seconds tick, and being centred on the playhead it would wobble.
    final template = _labelCache.putIfAbsent(
      "tag:${text.replaceAll(RegExp(r'\d'), '0')}",
      () => TextPainter(
        text: TextSpan(text: text.replaceAll(RegExp(r'\d'), '0'), style: style),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout(),
    );
    final textWidth = math.max(tp.width, template.width);
    final pad = 4.0;
    final rect = Rect.fromLTWH(
      ((x - textWidth / 2 - pad).clamp(
        0.0,
        math.max(0.0, canvasWidth - textWidth - pad * 2),
      )).toDouble(),
      y - tp.height / 2 - 2,
      textWidth + pad * 2,
      tp.height + 4,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(3)),
      Paint()..color = const Color(0xFF0B121B).withValues(alpha: .85),
    );
    tp.paint(
      canvas,
      Offset(rect.left + pad + (textWidth - tp.width) / 2, rect.top + 2),
    );
  }

  @override
  bool shouldRepaint(covariant WaveformPainter oldDelegate) {
    return oldDelegate.samples != samples ||
        oldDelegate.positionMs != positionMs ||
        oldDelegate.dragMs != dragMs ||
        oldDelegate.totalMs != totalMs;
  }
}
