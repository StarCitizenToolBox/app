import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart' show debugPrint;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/common/helper/log_helper.dart';
import 'package:starcitizen_doctor/generated/l10n.dart';
import 'package:watcher/watcher.dart';

part 'log_analyze_provider.g.dart';

part 'log_analyze_provider.freezed.dart';

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

@freezed
class LogAnalyzeLineData with _$LogAnalyzeLineData {
  const factory LogAnalyzeLineData({
    required String type,
    required String title,
    String? data,
    String? dateTime,
  }) = _LogAnalyzeLineData;
}

@riverpod
class ToolsLogAnalyze extends _$ToolsLogAnalyze {
  @override
  Future<List<LogAnalyzeLineData>> build(String gameInstallPath) async {
    final logFile = File("$gameInstallPath/Game.log");
    debugPrint("[ToolsLogAnalyze] logFile: ${logFile.absolute.path}");
    if (gameInstallPath.isEmpty || !(await logFile.exists())) {
      return [
        LogAnalyzeLineData(
          type: "error",
          title: S.current.log_analyzer_no_log_file,
        )
      ];
    }
    state = AsyncData([]);
    _launchLogAnalyze(logFile);
    return state.value ?? [];
  }

  String _playerName = ""; // 记录玩家名称
  int _killCount = 0; // 记录击杀其他实体次数
  int _deathCount = 0; // 记录被击杀次数
  int _selfKillCount = 0; // 记录自杀次数
  int _vehicleDestructionCount = 0; // 记录载具损毁次数 （软死亡）
  int _vehicleDestructionCountHard = 0; // 记录载具损毁次数 （解体）
  DateTime? _gameStartTime; // 记录游戏开始时间
  int _gameCrashLineNumber = -1; // 记录${S.current.log_analyzer_filter_game_crash}行号
  int _currentLineNumber = 0; // 当前行号

  void _launchLogAnalyze(File logFile, {int startLine = 0}) async {
    final logLines = utf8.decode((await logFile.readAsBytes()), allowMalformed: true).split("\n");
    debugPrint("[ToolsLogAnalyze] logLines: ${logLines.length}");
    if (startLine == 0) {
      _killCount = 0;
      _deathCount = 0;
      _selfKillCount = 0;
      _vehicleDestructionCount = 0;
      _vehicleDestructionCountHard = 0;
      _gameStartTime = null;
      _gameCrashLineNumber = -1;
    } else if (startLine > logLines.length) {
      // 考虑文件重新写入的情况
      ref.invalidateSelf();
    }
    _currentLineNumber = logLines.length;
    // for i in logLines
    for (var i = 0; i < logLines.length; i++) {
      // 支持追加模式
      if (i < startLine) continue;
      final line = logLines[i];
      if (line.isEmpty) continue;
      final data = _handleLogLine(line, i);
      if (data != null) {
        _appendResult(data);
        // wait for ui update
        await Future.delayed(Duration(seconds: 0));
      }
    }

    final lastLineDateTime =
        _gameStartTime != null ? _getLogLineDateTime(logLines.lastWhere((e) => e.startsWith("<20"))) : null;

    // 检查${S.current.log_analyzer_filter_game_crash}行号
    if (_gameCrashLineNumber > 0) {
      // crashInfo 从 logLines _gameCrashLineNumber 开始到最后一行
      final crashInfo = logLines.sublist(_gameCrashLineNumber);
      // 运行一键诊断
      final info = SCLoggerHelper.getGameRunningLogInfo(crashInfo);
      crashInfo.add(S.current.log_analyzer_one_click_diagnosis_header);
      if (info != null) {
        crashInfo.add(info.key);
        if (info.value.isNotEmpty) {
          crashInfo.add(S.current.log_analyzer_details_info(info.value));
        }
      } else {
        crashInfo.add(S.current.log_analyzer_no_crash_detected);
      }
      _appendResult(LogAnalyzeLineData(
        type: "game_crash",
        title: S.current.log_analyzer_game_crash,
        data: crashInfo.join("\n"),
        dateTime: lastLineDateTime != null ? _dateTimeFormatter.format(lastLineDateTime) : null,
      ));
    }

    // ${S.current.log_analyzer_kill_summary}
    if (_killCount > 0 || _deathCount > 0) {
      _appendResult(LogAnalyzeLineData(
        type: "statistics",
        title: S.current.log_analyzer_kill_summary,
        data: S.current.log_analyzer_kill_death_suicide_count(
          _killCount,
          _deathCount,
          _selfKillCount,
          _vehicleDestructionCount,
          _vehicleDestructionCountHard,
        ),
      ));
    }

    // 统计${S.current.log_analyzer_play_time}，_gameStartTime 减去 最后一行的时间
    if (_gameStartTime != null) {
      if (lastLineDateTime != null) {
        final duration = lastLineDateTime.difference(_gameStartTime!);
        _appendResult(LogAnalyzeLineData(
          type: "statistics",
          title: S.current.log_analyzer_play_time,
          data: S.current.log_analyzer_play_time_format(
            duration.inHours,
            duration.inMinutes.remainder(60),
            duration.inSeconds.remainder(60),
          ),
        ));
      }
    }

    _startListenFile(logFile);
  }

  // 避免重复调用
  bool _isListenEnabled = false;

  Future<void> _startListenFile(File logFile) async {
    _isListenEnabled = true;
    debugPrint("[ToolsLogAnalyze] startListenFile: ${logFile.absolute.path}");
    // 监听文件
    late final StreamSubscription sub;
    sub = FileWatcher(logFile.absolute.path, pollingDelay: Duration(seconds: 1)).events.listen((change) {
      sub.cancel();
      if (!_isListenEnabled) return;
      _isListenEnabled = false;
      debugPrint("[ToolsLogAnalyze] logFile change: ${change.type}");
      switch (change.type) {
        case ChangeType.MODIFY:
          // 移除${S.current.log_analyzer_filter_statistics}
          final newList = state.value?.where((e) => e.type != "statistics").toList();
          state = AsyncData(newList ?? []);
          return _launchLogAnalyze(logFile, startLine: _currentLineNumber);
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

  LogAnalyzeLineData? _handleLogLine(String line, int index) {
    // 处理 log 行，检测可以提取的内容
    if (_gameStartTime == null) {
      _gameStartTime = _getLogLineDateTime(line);
      return LogAnalyzeLineData(
        type: "info",
        title: S.current.log_analyzer_game_start,
        dateTime: _getLogLineDateTimeString(line),
      );
    }
    // 读取${S.current.log_analyzer_game_loading}时间
    final gameLoading = _logGetGameLoading(line);
    if (gameLoading != null) {
      return LogAnalyzeLineData(
        type: "info",
        title: S.current.log_analyzer_game_loading,
        data: S.current.log_analyzer_mode_loading_time(
          gameLoading.$1,
          gameLoading.$2,
        ),
        dateTime: _getLogLineDateTimeString(line),
      );
    }

    // 运行基础时间解析器
    final baseEvent = _baseEventDecoder(line);
    if (baseEvent != null) {
      switch (baseEvent) {
        case "AccountLoginCharacterStatus_Character":
          // 角色登录
          return _logGetCharacterName(line);
        case "FatalCollision":
          // 载具${S.current.log_analyzer_filter_fatal_collision}
          return _logGetFatalCollision(line);
        case "Vehicle Destruction":
          // ${S.current.log_analyzer_filter_vehicle_damaged}
          return _logGetVehicleDestruction(line);
        case "Actor Death":
          // ${S.current.log_analyzer_filter_character_death}
          return _logGetActorDeath(line);
        case "RequestLocationInventory":
          // 请求${S.current.log_analyzer_filter_local_inventory}
          return _logGetRequestLocationInventory(line);
      }
    }

    if (line.contains("[CIG] CCIGBroker::FastShutdown")) {
      return LogAnalyzeLineData(
        type: "info",
        title: S.current.log_analyzer_game_close,
        dateTime: _getLogLineDateTimeString(line),
      );
    }

    if (line.contains("Cloud Imperium Games public crash handler")) {
      _gameCrashLineNumber = index;
    }

    return null;
  }

  void _appendResult(LogAnalyzeLineData data) {
    // 追加结果到 state
    final currentState = state.value;
    if (currentState != null) {
      state = AsyncData([...currentState, data]);
    } else {
      state = AsyncData([data]);
    }
  }

  final _baseRegExp = RegExp(r'\[Notice\]\s+<([^>]+)>');

  String? _baseEventDecoder(String line) {
    // 解析 log 行的基本信息
    final match = _baseRegExp.firstMatch(line);
    if (match != null) {
      final type = match.group(1);
      return type;
    }
    return null;
  }

  final _gameLoadingRegExp =
      RegExp(r'<[^>]+>\s+Loading screen for\s+(\w+)\s+:\s+SC_Frontend closed after\s+(\d+\.\d+)\s+seconds');

  (String, String)? _logGetGameLoading(String line) {
    final match = _gameLoadingRegExp.firstMatch(line);
    if (match != null) {
      return (match.group(1) ?? "-", match.group(2) ?? "-");
    }
    return null;
  }

  final DateFormat _dateTimeFormatter = DateFormat('yyyy-MM-dd HH:mm:ss:SSS');
  final _logDateTimeRegExp = RegExp(r'<(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z)>');

  DateTime? _getLogLineDateTime(String line) {
    // 提取 log 行的时间
    final match = _logDateTimeRegExp.firstMatch(line);
    if (match != null) {
      final dateTimeString = match.group(1);
      if (dateTimeString != null) {
        return DateTime.parse(dateTimeString).toLocal();
      }
    }
    return null;
  }

  String? _getLogLineDateTimeString(String line) {
    // 提取 log 行的时间
    final dateTime = _getLogLineDateTime(line);
    if (dateTime != null) {
      return _dateTimeFormatter.format(dateTime);
    }
    return null;
  }

  // 安全提取函数
  String? safeExtract(RegExp pattern, String line) => pattern.firstMatch(line)?.group(1)?.trim();

  LogAnalyzeLineData? _logGetFatalCollision(String line) {
    final patterns = {
      'zone': RegExp(r'\[Part:[^\]]*?Zone:\s*([^,\]]+)'),
      'player_pilot': RegExp(r'PlayerPilot:\s*(\d)'),
      'hit_entity': RegExp(r'hitting entity:\s*(\w+)'),
      'hit_entity_vehicle': RegExp(r'hitting entity:[^\[]*\[Zone:\s*([^\s-]+)'),
      'distance': RegExp(r'Distance:\s*([\d.]+)')
    };

    final zone = safeExtract(patterns['zone']!, line) ?? 'Unknown';
    final playerPilot = (safeExtract(patterns['player_pilot']!, line) ?? '0') == '1';
    final hitEntity = safeExtract(patterns['hit_entity']!, line) ?? 'Unknown';
    final hitEntityVehicle = safeExtract(patterns['hit_entity_vehicle']!, line) ?? 'Unknown Vehicle';
    final distance = double.tryParse(safeExtract(patterns['distance']!, line) ?? '') ?? 0.0;
    return LogAnalyzeLineData(
      type: "fatal_collision",
      title: S.current.log_analyzer_filter_fatal_collision,
      data: S.current.log_analyzer_collision_details(
        zone,
        playerPilot ? '✅' : '❌',
        hitEntity,
        hitEntityVehicle,
        distance.toStringAsFixed(2),
      ),
      dateTime: _getLogLineDateTimeString(line),
    );
  }

  LogAnalyzeLineData? _logGetVehicleDestruction(String line) {
    final pattern = RegExp(r"Vehicle\s+'([^']+)'.*?" // 载具型号
        r"in zone\s+'([^']+)'.*?" // Zone
        r"destroy level \d+ to (\d+).*?" // 损毁等级
        r"caused by\s+'([^']+)'" // 责任方
        );
    final match = pattern.firstMatch(line);
    if (match != null) {
      final vehicleModel = match.group(1) ?? 'Unknown';
      final zone = match.group(2) ?? 'Unknown';
      final destructionLevel = int.tryParse(match.group(3) ?? '') ?? 0;
      final causedBy = match.group(4) ?? 'Unknown';

      final destructionLevelMap = {1: S.current.log_analyzer_soft_death, 2: S.current.log_analyzer_disintegration};

      if (causedBy.trim() == _playerName) {
        if (destructionLevel == 1) {
          _vehicleDestructionCount++;
        } else if (destructionLevel == 2) {
          _vehicleDestructionCountHard++;
        }
      }

      return LogAnalyzeLineData(
        type: "vehicle_destruction",
        title: S.current.log_analyzer_filter_vehicle_damaged,
        data: S.current.log_analyzer_vehicle_damage_details(
          vehicleModel,
          zone,
          destructionLevel.toString(),
          destructionLevelMap[destructionLevel] ?? "Unknown",
          causedBy,
        ),
        dateTime: _getLogLineDateTimeString(line),
      );
    }
    return null;
  }

  LogAnalyzeLineData? _logGetActorDeath(String line) {
    final pattern = RegExp(r"CActor::Kill: '([^']+)'.*?" // 受害者ID
        r"in zone '([^']+)'.*?" // 死亡位置区域
        r"killed by '([^']+)'.*?" // 击杀者ID
        r"with damage type '([^']+)'" // 伤害类型
        );

    final match = pattern.firstMatch(line);
    if (match != null) {
      final victimId = match.group(1) ?? 'Unknown';
      final zone = match.group(2) ?? 'Unknown';
      final killerId = match.group(3) ?? 'Unknown';
      final damageType = match.group(4) ?? 'Unknown';

      if (victimId.trim() == killerId.trim()) {
        // 自杀
        _selfKillCount++;
      } else {
        if (victimId.trim() == _playerName) {
          _deathCount++;
        }
        if (killerId.trim() == _playerName) {
          _killCount++;
        }
      }

      return LogAnalyzeLineData(
        type: "actor_death",
        title: S.current.log_analyzer_filter_character_death,
        data: S.current.log_analyzer_death_details(
          victimId,
          damageType,
          killerId,
          zone,
        ),
        dateTime: _getLogLineDateTimeString(line),
      );
    }

    return null;
  }

  LogAnalyzeLineData? _logGetCharacterName(String line) {
    final pattern = RegExp(r"name\s+([^-]+)");
    final match = pattern.firstMatch(line);
    if (match != null) {
      final characterName = match.group(1)?.trim() ?? 'Unknown';
      _playerName = characterName.trim(); // 更新玩家名称
      return LogAnalyzeLineData(
        type: "player_login",
        title: S.current.log_analyzer_player_login(characterName),
        dateTime: _getLogLineDateTimeString(line),
      );
    }
    return null;
  }

  LogAnalyzeLineData? _logGetRequestLocationInventory(String line) {
    final pattern = RegExp(r"Player\[([^\]]+)\].*?Location\[([^\]]+)\]");
    final match = pattern.firstMatch(line);
    if (match != null) {
      final playerId = match.group(1) ?? 'Unknown';
      final location = match.group(2) ?? 'Unknown';

      return LogAnalyzeLineData(
        type: "request_location_inventory",
        title: S.current.log_analyzer_view_local_inventory,
        data: S.current.log_analyzer_player_location(playerId, location),
        dateTime: _getLogLineDateTimeString(line),
      );
    }
    return null;
  }
}
