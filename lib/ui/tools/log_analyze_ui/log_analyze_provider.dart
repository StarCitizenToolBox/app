import 'dart:async';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart' show debugPrint;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/common/helper/game_log_analyzer.dart';
import 'package:starcitizen_doctor/generated/l10n.dart';
import 'package:watcher/watcher.dart';

part 'log_analyze_provider.g.dart';

final Map<String?, String> logAnalyzeSearchTypeMap = {
  null: S.current.log_analyzer_filter_all,
  "info": S.current.log_analyzer_filter_basic_info,
  "player_login": S.current.log_analyzer_filter_account_related,
  "fatal_collision": S.current.log_analyzer_filter_fatal_collision,
  "vehicle_destruction": S.current.log_analyzer_filter_vehicle_damaged,
  "actor_death": S.current.log_analyzer_filter_character_death,
  "statistics": S.current.log_analyzer_filter_statistics,
  "game_crash": S.current.log_analyzer_filter_game_crash,
  "request_location_inventory": S.current.log_analyzer_filter_local_inventory,
};

@riverpod
class ToolsLogAnalyze extends _$ToolsLogAnalyze {
  @override
  Future<List<LogAnalyzeLineData>> build(String gameInstallPath, bool listSortReverse) async {
    final logFile = File("$gameInstallPath/Game.log");
    debugPrint("[ToolsLogAnalyze] logFile: ${logFile.absolute.path}");
    if (gameInstallPath.isEmpty || !(await logFile.exists())) {
      return [const LogAnalyzeLineData(type: "error", title: "未找到日志文件")];
    }
    state = const AsyncData([]);
    _launchLogAnalyze(logFile);
    return state.value ?? [];
  }

  void _launchLogAnalyze(File logFile) async {
    // 使用新的 GameLogAnalyzer 工具类
    final result = await GameLogAnalyzer.analyzeLogFile(logFile);
    final (results, _) = result;

    _setResult(results);

    _startListenFile(logFile);
  }

  // 避免重复调用
  bool _isListenEnabled = false;

  Future<void> _startListenFile(File logFile) async {
    _isListenEnabled = true;
    debugPrint("[ToolsLogAnalyze] startListenFile: ${logFile.absolute.path}");
    // 监听文件
    late final StreamSubscription sub;
    sub = FileWatcher(logFile.absolute.path, pollingDelay: const Duration(seconds: 1)).events.listen((change) {
      sub.cancel();
      if (!_isListenEnabled) return;
      _isListenEnabled = false;
      debugPrint("[ToolsLogAnalyze] logFile change: ${change.type}");
      switch (change.type) {
        case ChangeType.MODIFY:
          return _launchLogAnalyze(logFile);
        case ChangeType.ADD:
        case ChangeType.REMOVE:
          ref.invalidateSelf();
          return;
      }
    });
    ref.onDispose(() {
      sub.cancel();
    });
  }

  void _setResult(List<LogAnalyzeLineData> data) {
    if (listSortReverse) {
      state = AsyncData(data.reversed.toList());
    } else {
      state = AsyncData(data);
    }
  }
}
