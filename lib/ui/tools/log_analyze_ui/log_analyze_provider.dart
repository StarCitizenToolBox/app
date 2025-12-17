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

/// 日志文件信息
class LogFileInfo {
  final String path;
  final String displayName;
  final bool isCurrentLog;

  const LogFileInfo({required this.path, required this.displayName, required this.isCurrentLog});
}

/// 获取可用的日志文件列表
Future<List<LogFileInfo>> getAvailableLogFiles(String gameInstallPath) async {
  final List<LogFileInfo> logFiles = [];

  if (gameInstallPath.isEmpty) return logFiles;

  // 添加当前 Game.log
  final currentLogFile = File('$gameInstallPath/Game.log');
  if (await currentLogFile.exists()) {
    logFiles.add(LogFileInfo(path: currentLogFile.path, displayName: 'Game.log (当前)', isCurrentLog: true));
  }

  // 添加 logbackups 目录中的日志文件
  final logBackupsDir = Directory('$gameInstallPath/logbackups');
  if (await logBackupsDir.exists()) {
    final entities = await logBackupsDir.list().toList();
    // 按文件名排序（通常包含时间戳，降序排列显示最新的在前）
    entities.sort((a, b) => b.path.compareTo(a.path));

    for (final entity in entities) {
      if (entity is File && entity.path.endsWith('.log')) {
        final fileName = entity.path.split(Platform.pathSeparator).last;
        logFiles.add(LogFileInfo(path: entity.path, displayName: fileName, isCurrentLog: false));
      }
    }
  }

  return logFiles;
}

@riverpod
class ToolsLogAnalyze extends _$ToolsLogAnalyze {
  @override
  Future<List<LogAnalyzeLineData>> build(
    String gameInstallPath,
    bool listSortReverse, {
    String? selectedLogFile,
  }) async {
    // 确定要分析的日志文件
    final String logFilePath;
    if (selectedLogFile != null && selectedLogFile.isNotEmpty) {
      logFilePath = selectedLogFile;
    } else {
      logFilePath = "$gameInstallPath/Game.log";
    }

    final logFile = File(logFilePath);
    debugPrint("[ToolsLogAnalyze] logFile: ${logFile.absolute.path}");

    if (gameInstallPath.isEmpty || !(await logFile.exists())) {
      return [const LogAnalyzeLineData(type: "error", title: "未找到日志文件")];
    }

    state = const AsyncData([]);
    _launchLogAnalyze(logFile, selectedLogFile == null);
    return state.value ?? [];
  }

  void _launchLogAnalyze(File logFile, bool enableWatch) async {
    // 使用新的 GameLogAnalyzer 工具类
    final result = await GameLogAnalyzer.analyzeLogFile(logFile);
    final (results, _) = result;

    _setResult(results);

    // 只有当前 Game.log 才需要监听变化
    if (enableWatch) {
      _startListenFile(logFile);
    }
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
          return _launchLogAnalyze(logFile, true);
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
