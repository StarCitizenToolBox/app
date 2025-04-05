import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart' show debugPrint;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/common/helper/log_helper.dart';
import 'package:watcher/watcher.dart';

part 'log_analyze_provider.g.dart';

part 'log_analyze_provider.freezed.dart';

const Map<String?, String> logAnalyzeSearchTypeMap = {
  null: "全部",
  "info": "基础信息",
  "player_login": "账户相关",
  "fatal_collision": "致命碰撞",
  "vehicle_destruction": "载具损毁",
  "actor_death": "角色死亡",
  "statistics": "统计信息",
  "game_crash": "游戏崩溃",
  "request_location_inventory": "本地库存",
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
          title: "未找到 log 文件",
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
  DateTime? _gameStartTime; // 记录游戏开始时间
  int _gameCrashLineNumber = -1; // 记录游戏崩溃行号
  int _currentLineNumber = 0; // 当前行号

  void _launchLogAnalyze(File logFile, {int startLine = 0}) async {
    final logLines = utf8.decode((await logFile.readAsBytes()), allowMalformed: true).split("\n");
    debugPrint("[ToolsLogAnalyze] logLines: ${logLines.length}");
    if (startLine == 0) {
      _killCount = 0;
      _deathCount = 0;
      _selfKillCount = 0;
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

    // 检查游戏崩溃行号
    if (_gameCrashLineNumber > 0) {
      // crashInfo 从 logLines _gameCrashLineNumber 开始到最后一行
      final crashInfo = logLines.sublist(_gameCrashLineNumber);
      // 运行一键诊断
      final info = SCLoggerHelper.getGameRunningLogInfo(crashInfo);
      crashInfo.add("----- 汉化盒子一键诊断 -----");
      if (info != null) {
        crashInfo.add(info.key);
        if (info.value.isNotEmpty) {
          crashInfo.add("详细信息：${info.value}");
        }
      } else {
        crashInfo.add("未检测到游戏崩溃信息");
      }
      _appendResult(LogAnalyzeLineData(
        type: "game_crash",
        title: "游戏崩溃 ",
        data: crashInfo.join("\n"),
        dateTime: lastLineDateTime != null ? _dateTimeFormatter.format(lastLineDateTime) : null,
      ));
    }

    // 击杀总结
    if (_killCount > 0 || _deathCount > 0) {
      _appendResult(LogAnalyzeLineData(
        type: "statistics",
        title: "击杀总结",
        data: "击杀次数：$_killCount   死亡次数：$_deathCount   自杀次数：$_selfKillCount",
      ));
    }

    // 统计游玩时长，_gameStartTime 减去 最后一行的时间
    if (_gameStartTime != null) {
      if (lastLineDateTime != null) {
        final duration = lastLineDateTime.difference(_gameStartTime!);
        _appendResult(LogAnalyzeLineData(
          type: "statistics",
          title: "游玩时长",
          data: "${duration.inHours} 小时 ${duration.inMinutes.remainder(60)} 分钟 ${duration.inSeconds.remainder(60)} 秒",
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
          // 移除统计信息
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
        title: "游戏启动",
        dateTime: _getLogLineDateTimeString(line),
      );
    }
    // 读取游戏加载时间
    final gameLoading = _logGetGameLoading(line);
    if (gameLoading != null) {
      return LogAnalyzeLineData(
        type: "info",
        title: "游戏加载",
        data: "模式：${gameLoading.$1}   用时：${gameLoading.$2} 秒",
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
          // 载具致命碰撞
          return _logGetFatalCollision(line);
        case "Vehicle Destruction":
          // 载具损毁
          return _logGetVehicleDestruction(line);
        case "Actor Death":
          // 角色死亡
          return _logGetActorDeath(line);
        case "RequestLocationInventory":
          // 请求本地库存
          return _logGetRequestLocationInventory(line);
      }
    }

    if (line.contains("[CIG] CCIGBroker::FastShutdown")) {
      return LogAnalyzeLineData(
        type: "info",
        title: "游戏关闭",
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
        return DateTime.parse(dateTimeString);
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
      title: "致命碰撞",
      data: "区域：$zone   玩家驾驶：${playerPilot ? '✅' : '❌'}   碰撞实体：$hitEntity \n碰撞载具: $hitEntityVehicle   碰撞距离：$distance ",
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

      const destructionLevelMap = {1: "软死亡", 2: "解体"};

      return LogAnalyzeLineData(
        type: "vehicle_destruction",
        title: "载具损毁",
        data:
            "载具型号：$vehicleModel   \n区域：$zone \n损毁等级：$destructionLevel （${destructionLevelMap[destructionLevel]}）   责任方：$causedBy",
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
        title: "角色死亡",
        data: "受害者ID：$victimId    死因：$damageType \n击杀者ID：$killerId  \n区域：$zone",
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
        title: "玩家 $characterName 登录 ...",
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
        title: "查看本地库存",
        data: "玩家ID：$playerId   位置：$location",
        dateTime: _getLogLineDateTimeString(line),
      );
    }
    return null;
  }
}
