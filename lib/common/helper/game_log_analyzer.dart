import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:starcitizen_doctor/common/helper/log_helper.dart';
import 'package:starcitizen_doctor/generated/l10n.dart';

/// 日志分析结果数据类
class LogAnalyzeLineData {
  final String type;
  final String title;
  final String? data;
  final String? dateTime;
  final String? tag; // 统计标签，用于定位日志（如 "game_start"），不依赖本地化

  // 格式化后的字段
  final String? victimId; // 受害者ID (actor_death)
  final String? killerId; // 击杀者ID (actor_death)
  final String? location; // 位置信息 (request_location_inventory)
  final String? playerName; // 玩家名称 (player_login)

  const LogAnalyzeLineData({
    required this.type,
    required this.title,
    this.data,
    this.dateTime,
    this.tag,
    this.victimId,
    this.killerId,
    this.location,
    this.playerName,
  });

  @override
  String toString() {
    return 'LogAnalyzeLineData(type: $type, title: $title, data: $data, dateTime: $dateTime)';
  }
}

/// 日志分析统计数据
class LogAnalyzeStatistics {
  final String playerName;
  final int killCount;
  final int deathCount;
  final int selfKillCount;
  final int vehicleDestructionCount;
  final int vehicleDestructionCountHard;
  final DateTime? gameStartTime;
  final int gameCrashLineNumber;
  final String? latestLocation; // 最新位置信息（全量查找）

  const LogAnalyzeStatistics({
    required this.playerName,
    required this.killCount,
    required this.deathCount,
    required this.selfKillCount,
    required this.vehicleDestructionCount,
    required this.vehicleDestructionCountHard,
    this.gameStartTime,
    required this.gameCrashLineNumber,
    this.latestLocation,
  });
}

/// 游戏日志分析器
class GameLogAnalyzer {
  static const String unknownValue = "<Unknown>";

  // 正则表达式定义
  static final _baseRegExp = RegExp(r'\[Notice\]\s+<([^>]+)>');
  static final _gameLoadingRegExp = RegExp(
    r'<[^>]+>\s+Loading screen for\s+(\w+)\s+:\s+SC_Frontend closed after\s+(\d+\.\d+)\s+seconds',
  );
  static final _logDateTimeRegExp = RegExp(r'<(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z)>');
  static final DateFormat _dateTimeFormatter = DateFormat('yyyy-MM-dd HH:mm:ss:SSS');

  // 致命碰撞解析
  static final _fatalCollisionPatterns = {
    'zone': RegExp(r'\[Part:[^\]]*?Zone:\s*([^,\]]+)'),
    'player_pilot': RegExp(r'PlayerPilot:\s*(\d)'),
    'hit_entity': RegExp(r'hitting entity:\s*(\w+)'),
    'hit_entity_vehicle': RegExp(r'hitting entity:[^\[]*\[Zone:\s*([^\s-]+)'),
    'distance': RegExp(r'Distance:\s*([\d.]+)'),
  };

  // 载具损毁解析
  static final _vehicleDestructionPattern = RegExp(
    r"Vehicle\s+'([^']+)'.*?" // 载具型号
    r"in zone\s+'([^']+)'.*?" // Zone
    r"destroy level \d+ to (\d+).*?" // 损毁等级
    r"caused by\s+'([^']+)'", // 责任方
  );

  // 角色死亡解析
  static final _actorDeathPattern = RegExp(
    r"CActor::Kill: '([^']+)'.*?" // 受害者ID
    r"in zone '([^']+)'.*?" // 死亡位置区域
    r"killed by '([^']+)'.*?" // 击杀者ID
    r"with damage type '([^']+)'", // 伤害类型
  );

  // 角色名称解析
  static final _characterNamePattern = RegExp(r"name\s+([^-]+)");

  // 本地库存请求解析
  static final _requestLocationInventoryPattern = RegExp(r"Player\[([^\]]+)\].*?Location\[([^\]]+)\]");

  /// 分析整个日志文件
  ///
  /// [logFile] 日志文件
  /// [startTime] 开始时间，如果提供则只统计此时间之后的数据
  /// 返回日志分析结果列表和统计数据
  static Future<(List<LogAnalyzeLineData>, LogAnalyzeStatistics)> analyzeLogFile(
    File logFile, {
    DateTime? startTime,
  }) async {
    if (!(await logFile.exists())) {
      return (
        [LogAnalyzeLineData(type: "error", title: S.current.log_analyzer_no_log_file)],
        LogAnalyzeStatistics(
          playerName: "",
          killCount: 0,
          deathCount: 0,
          selfKillCount: 0,
          vehicleDestructionCount: 0,
          vehicleDestructionCountHard: 0,
          gameCrashLineNumber: -1,
        ),
      );
    }

    final logLines = utf8.decode((await logFile.readAsBytes()), allowMalformed: true).split("\n");
    return _analyzeLogLines(logLines, startTime: startTime);
  }

  /// 分析日志行列表
  ///
  /// [logLines] 日志行列表
  /// [startTime] 开始时间，如果提供则只影响计数统计，不影响 gameStartTime 和位置的全量查找
  /// 返回日志分析结果列表和统计数据
  static (List<LogAnalyzeLineData>, LogAnalyzeStatistics) _analyzeLogLines(
    List<String> logLines, {
    DateTime? startTime,
  }) {
    final results = <LogAnalyzeLineData>[];
    String playerName = "";
    int killCount = 0;
    int deathCount = 0;
    int selfKillCount = 0;
    int vehicleDestructionCount = 0;
    int vehicleDestructionCountHard = 0;
    DateTime? gameStartTime; // 全量查找，不受 startTime 影响
    String? latestLocation; // 全量查找最新位置
    int gameCrashLineNumber = -1;
    bool shouldCount = startTime == null; // 只影响计数

    for (var i = 0; i < logLines.length; i++) {
      final line = logLines[i];
      if (line.isEmpty) continue;

      // 如果设置了 startTime，检查当前行时间
      if (startTime != null && !shouldCount) {
        final lineTime = _getLogLineDateTime(line);
        if (lineTime != null && lineTime.isAfter(startTime)) {
          shouldCount = true;
        }
      }

      // 处理游戏开始（全量查找第一次出现）
      if (gameStartTime == null) {
        gameStartTime = _getLogLineDateTime(line);
        if (gameStartTime != null) {
          results.add(
            LogAnalyzeLineData(
              type: "info",
              title: S.current.log_analyzer_game_start,
              tag: "game_start", // 使用 tag 标识，不依赖本地化
            ),
          );
        }
      }

      // 游戏加载时间
      final gameLoading = _parseGameLoading(line);
      if (gameLoading != null) {
        results.add(
          LogAnalyzeLineData(
            type: "info",
            title: S.current.log_analyzer_game_loading,
            data: S.current.log_analyzer_mode_loading_time(gameLoading.$1, gameLoading.$2),
            dateTime: _getLogLineDateTimeString(line),
          ),
        );
        continue;
      }

      // 基础事件解析
      final baseEvent = _parseBaseEvent(line);
      if (baseEvent != null) {
        LogAnalyzeLineData? data;
        switch (baseEvent) {
          case "AccountLoginCharacterStatus_Character":
            data = _parseCharacterName(line);
            if (data != null && data.playerName != null) {
              playerName = data.playerName!; // 全量更新玩家名称
            }
            break;
          case "FatalCollision":
            data = _parseFatalCollision(line);
            break;
          case "Vehicle Destruction":
            data = _parseVehicleDestruction(line, playerName, shouldCount, (isHard) {
              if (isHard) {
                vehicleDestructionCountHard++;
              } else {
                vehicleDestructionCount++;
              }
            });
            break;
          case "Actor Death":
            data = _parseActorDeath(line, playerName, shouldCount, (isKill, isDeath, isSelfKill) {
              if (isSelfKill) {
                selfKillCount++;
              } else {
                if (isKill) killCount++;
                if (isDeath) deathCount++;
              }
            });
            break;
          case "RequestLocationInventory":
            data = _parseRequestLocationInventory(line);
            if (data != null && data.location != null) {
              latestLocation = data.location; // 全量更新最新位置
            }
            break;
        }
        if (data != null) {
          results.add(data);
          continue;
        }
      }

      // 游戏关闭
      if (line.contains("[CIG] CCIGBroker::FastShutdown")) {
        results.add(
          LogAnalyzeLineData(
            type: "info",
            title: S.current.log_analyzer_game_close,
            dateTime: _getLogLineDateTimeString(line),
          ),
        );
        continue;
      }

      // 游戏崩溃
      if (line.contains("Cloud Imperium Games public crash handler")) {
        gameCrashLineNumber = i;
      }
    }

    // 处理崩溃信息
    if (gameCrashLineNumber > 0) {
      final lastLineDateTime = gameStartTime != null
          ? _getLogLineDateTime(logLines.lastWhere((e) => e.startsWith("<20")))
          : null;
      final crashInfo = logLines.sublist(gameCrashLineNumber);
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
      results.add(
        LogAnalyzeLineData(
          type: "game_crash",
          title: S.current.log_analyzer_game_crash,
          data: crashInfo.join("\n"),
          dateTime: lastLineDateTime != null ? _dateTimeFormatter.format(lastLineDateTime) : null,
        ),
      );
    }

    // 添加统计信息
    if (killCount > 0 || deathCount > 0) {
      results.add(
        LogAnalyzeLineData(
          type: "statistics",
          title: S.current.log_analyzer_kill_summary,
          data: S.current.log_analyzer_kill_death_suicide_count(
            killCount,
            deathCount,
            selfKillCount,
            vehicleDestructionCount,
            vehicleDestructionCountHard,
          ),
        ),
      );
    }

    // 统计游戏时长
    if (gameStartTime != null) {
      final lastLineDateTime = _getLogLineDateTime(logLines.lastWhere((e) => e.startsWith("<20"), orElse: () => ""));
      if (lastLineDateTime != null) {
        final duration = lastLineDateTime.difference(gameStartTime);
        results.add(
          LogAnalyzeLineData(
            type: "statistics",
            title: S.current.log_analyzer_play_time,
            data: S.current.log_analyzer_play_time_format(
              duration.inHours,
              duration.inMinutes.remainder(60),
              duration.inSeconds.remainder(60),
            ),
          ),
        );
      }
    }

    final statistics = LogAnalyzeStatistics(
      playerName: playerName,
      killCount: killCount,
      deathCount: deathCount,
      selfKillCount: selfKillCount,
      vehicleDestructionCount: vehicleDestructionCount,
      vehicleDestructionCountHard: vehicleDestructionCountHard,
      gameStartTime: gameStartTime,
      gameCrashLineNumber: gameCrashLineNumber,
      latestLocation: latestLocation,
    );

    return (results, statistics);
  }

  // ==================== 解析辅助方法 ====================

  static String? _parseBaseEvent(String line) {
    final match = _baseRegExp.firstMatch(line);
    return match?.group(1);
  }

  static (String, String)? _parseGameLoading(String line) {
    final match = _gameLoadingRegExp.firstMatch(line);
    if (match != null) {
      return (match.group(1) ?? "-", match.group(2) ?? "-");
    }
    return null;
  }

  static DateTime? _getLogLineDateTime(String line) {
    final match = _logDateTimeRegExp.firstMatch(line);
    if (match != null) {
      final dateTimeString = match.group(1);
      if (dateTimeString != null) {
        return DateTime.parse(dateTimeString).toLocal();
      }
    }
    return null;
  }

  static String? _getLogLineDateTimeString(String line) {
    final dateTime = _getLogLineDateTime(line);
    if (dateTime != null) {
      return _dateTimeFormatter.format(dateTime);
    }
    return null;
  }

  static String? _safeExtract(RegExp pattern, String line) => pattern.firstMatch(line)?.group(1)?.trim();

  static LogAnalyzeLineData? _parseFatalCollision(String line) {
    final zone = _safeExtract(_fatalCollisionPatterns['zone']!, line) ?? unknownValue;
    final playerPilot = (_safeExtract(_fatalCollisionPatterns['player_pilot']!, line) ?? '0') == '1';
    final hitEntity = _safeExtract(_fatalCollisionPatterns['hit_entity']!, line) ?? unknownValue;
    final hitEntityVehicle = _safeExtract(_fatalCollisionPatterns['hit_entity_vehicle']!, line) ?? unknownValue;
    final distance = double.tryParse(_safeExtract(_fatalCollisionPatterns['distance']!, line) ?? '') ?? 0.0;

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

  static LogAnalyzeLineData? _parseVehicleDestruction(
    String line,
    String playerName,
    bool shouldCount,
    void Function(bool isHard) onDestruction,
  ) {
    final match = _vehicleDestructionPattern.firstMatch(line);
    if (match != null) {
      final vehicleModel = match.group(1) ?? unknownValue;
      final zone = match.group(2) ?? unknownValue;
      final destructionLevel = int.tryParse(match.group(3) ?? '') ?? 0;
      final causedBy = match.group(4) ?? unknownValue;

      final destructionLevelMap = {1: S.current.log_analyzer_soft_death, 2: S.current.log_analyzer_disintegration};

      if (shouldCount && causedBy.trim() == playerName) {
        onDestruction(destructionLevel == 2);
      }

      return LogAnalyzeLineData(
        type: "vehicle_destruction",
        title: S.current.log_analyzer_filter_vehicle_damaged,
        data: S.current.log_analyzer_vehicle_damage_details(
          vehicleModel,
          zone,
          destructionLevel.toString(),
          destructionLevelMap[destructionLevel] ?? unknownValue,
          causedBy,
        ),
        dateTime: _getLogLineDateTimeString(line),
      );
    }
    return null;
  }

  static LogAnalyzeLineData? _parseActorDeath(
    String line,
    String playerName,
    bool shouldCount,
    void Function(bool isKill, bool isDeath, bool isSelfKill) onDeath,
  ) {
    final match = _actorDeathPattern.firstMatch(line);
    if (match != null) {
      final victimId = match.group(1) ?? unknownValue;
      final zone = match.group(2) ?? unknownValue;
      final killerId = match.group(3) ?? unknownValue;
      final damageType = match.group(4) ?? unknownValue;

      if (shouldCount) {
        if (victimId.trim() == killerId.trim()) {
          onDeath(false, false, true); // 自杀
        } else {
          final isDeath = victimId.trim() == playerName;
          final isKill = killerId.trim() == playerName;
          onDeath(isKill, isDeath, false);
        }
      }

      return LogAnalyzeLineData(
        type: "actor_death",
        title: S.current.log_analyzer_filter_character_death,
        data: S.current.log_analyzer_death_details(victimId, damageType, killerId, zone),
        dateTime: _getLogLineDateTimeString(line),
        victimId: victimId, // 格式化字段
        killerId: killerId, // 格式化字段
      );
    }
    return null;
  }

  static LogAnalyzeLineData? _parseCharacterName(String line) {
    final match = _characterNamePattern.firstMatch(line);
    if (match != null) {
      final characterName = match.group(1)?.trim() ?? unknownValue;
      return LogAnalyzeLineData(
        type: "player_login",
        title: S.current.log_analyzer_player_login(characterName),
        dateTime: _getLogLineDateTimeString(line),
        playerName: characterName, // 格式化字段
      );
    }
    return null;
  }

  static LogAnalyzeLineData? _parseRequestLocationInventory(String line) {
    final match = _requestLocationInventoryPattern.firstMatch(line);
    if (match != null) {
      final playerId = match.group(1) ?? unknownValue;
      final location = match.group(2) ?? unknownValue;

      return LogAnalyzeLineData(
        type: "request_location_inventory",
        title: S.current.log_analyzer_view_local_inventory,
        data: S.current.log_analyzer_player_location(playerId, location),
        dateTime: _getLogLineDateTimeString(line),
        location: location, // 格式化字段
      );
    }
    return null;
  }
}
