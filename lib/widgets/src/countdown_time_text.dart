import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:starcitizen_doctor/generated/l10n.dart';

class CountdownTimeText extends StatefulWidget {
  final DateTime targetTime;

  const CountdownTimeText({super.key, required this.targetTime});

  @override
  State<CountdownTimeText> createState() => _CountdownTimeTextState();
}

class _CountdownTimeTextState extends State<CountdownTimeText> {
  Timer? _timer;

  Widget? textWidget;

  bool stopTimer = false;

  @override
  initState() {
    _onUpdateTime(null);
    if (!stopTimer) {
      _timer = Timer.periodic(const Duration(seconds: 1), _onUpdateTime);
    }
    super.initState();
  }

  @override
  dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  void _onUpdateTime(_) {
    final now = DateTime.now();
    final dur = widget.targetTime.difference(now);
    setState(() {
      textWidget = _chineseTimeText(dur);
    });
    // 时间到，停止计时，并向宿主传递超时信息
    if (dur.inMilliseconds <= 0) {
      stopTimer = true;
      setState(() {});
    }
    if (stopTimer) {
      _timer?.cancel();
      _timer = null;
    }
  }

  Widget _chineseTimeText(Duration duration) {
    final surplus = duration;
    int day = (surplus.inSeconds ~/ 3600) ~/ 24;
    int hour = (surplus.inSeconds ~/ 3600) % 24;
    int minute = surplus.inSeconds % 3600 ~/ 60;
    int second = surplus.inSeconds % 60;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          S.current.home_holiday_countdown_days(day),
          style: TextStyle(
              fontSize: 24, color: day < 30 ? Colors.red : Colors.white),
        ),
        Text("${timePart(hour)}:${timePart(minute)}:${timePart(second)}"),
      ],
    );
  }

  String timePart(int p) {
    if (p.toString().length == 1) return "0$p";
    return "$p";
  }

  @override
  Widget build(BuildContext context) {
    if (stopTimer) {
      return Text(
        S.current.home_holiday_countdown_in_progress,
        style: const TextStyle(
            fontSize: 18,
            color: Color.fromRGBO(32, 220, 89, 1.0),
            fontWeight: FontWeight.bold),
      );
    }
    return textWidget ?? const Text("");
  }
}
