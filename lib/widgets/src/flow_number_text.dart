import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class FlowNumberText extends HookConsumerWidget {
  final int targetValue;
  final Duration duration;
  final TextStyle? style;
  final Curve curve;

  FlowNumberText({
    super.key,
    required this.targetValue,
    this.duration = const Duration(seconds: 1),
    this.style,
    this.curve = Curves.bounceOut,
  });

  final _formatter = NumberFormat.decimalPattern();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = useState<double>(0.0);
    final timer = useState<Timer?>(null);

    useEffect(() {
      final totalTicks = duration.inMilliseconds ~/ 10;
      var currentTick = 0;
      if (value.value != 0) {
        currentTick = (value.value / targetValue * totalTicks).toInt();
      }

      timer.value = Timer.periodic(const Duration(milliseconds: 10), (timer) {
        final progress = curve.transform(currentTick / totalTicks);
        value.value = (progress * targetValue).toDouble();

        if (currentTick >= totalTicks) {
          value.value = targetValue.toDouble();
          timer.cancel();
        } else {
          currentTick++;
        }
      });

      return timer.value?.cancel;
    }, [targetValue]);

    return Text(_formatter.format(value.value.toInt()), style: style);
  }
}
