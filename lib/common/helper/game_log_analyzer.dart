import 'package:intl/intl.dart';
import 'package:starcitizen_doctor/generated/l10n.dart';

/// 日志分析结果数据类
class LogAnalyzeLineData {
  final String type;
  final String title;
  final String? data;
  final String? dateTime;
  final String? tag;
  final String? victimId;
  final String? location;
  final String? area;
  final String? playerName;

  const LogAnalyzeLineData({
    required this.type,
    required this.title,
    this.data,
    this.dateTime,
    this.tag,
    this.victimId,
    this.location,
    this.area,
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
  final String? latestLocation;

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

  static final _baseRegExp = RegExp(r'\[Notice\]\s+<([^>]+)>');
  static final _gameLoadingRegExp = RegExp(
    r'<[^>]+>\s+Loading screen for\s+(\w+)\s+:\s+SC_Frontend closed after\s+(\d+\.\d+)\s+seconds',
  );
  static final _logDateTimeRegExp = RegExp(r'<(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z)>');
  static final DateFormat _dateTimeFormatter = DateFormat('yyyy-MM-dd HH:mm:ss:SSS');

  static final _fatalCollisionPatterns = {
    'vehicle': RegExp(r'Fatal Collision occured for vehicle\s+(\S+)'),
    'zone': RegExp(r'Zone:\s*([^,\]]+)'),
    'player_pilot': RegExp(r'PlayerPilot:\s*(\d)'),
    'hit_entity': RegExp(r'hitting entity:\s*(\w+)'),
    'distance': RegExp(r'Distance:\s*([\d.]+)'),
  };

  static final _vehicleDestructionPattern = RegExp(
    r"Vehicle\s+'([^']+)'.*?"
    r"in zone\s+'([^']+)'.*?"
    r"destroy level \d+ to (\d+).*?"
    r"caused by\s+'([^']+)'",
  );

  static final _actorDeathPattern = RegExp(
    r"Actor '([^']+)'.*?"
    r"ejected from zone '([^']+)'.*?"
    r"to zone '([^']+)'",
  );

  static final _characterNamePattern = RegExp(r"name\s+([^-]+)");
  static final _requestLocationInventoryPattern = RegExp(r"Player\[([^\]]+)\].*?Location\[([^\]]+)\]");
  static final vehicleControlPattern = RegExp(r"granted control token for '([^']+)'\s+\[(\d+)\]");

  static DateTime? getLogLineDateTime(String line) => _getLogLineDateTime(line);
  static String? getLogLineDateTimeString(String line) => _getLogLineDateTimeString(line);

  static String removeVehicleId(String vehicleName) {
    final regex = RegExp(r'_\d+$');
    return vehicleName.replaceAll(regex, '');
  }

  /// 从字符串内容分析日志
  static (List<LogAnalyzeLineData>, LogAnalyzeStatistics) analyzeLogContent(String content, {DateTime? startTime}) {
    final logLines = content.split("\n");
    return _analyzeLogLines(logLines, startTime: startTime);
  }

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
    DateTime? gameStartTime;
    String? latestLocation;
    int gameCrashLineNumber = -1;
    bool shouldCount = startTime == null;

    for (var i = 0; i < logLines.length; i++) {
      final line = logLines[i];
      if (line.isEmpty) continue;

      if (startTime != null && !shouldCount) {
        final lineTime = _getLogLineDateTime(line);
        if (lineTime != null && lineTime.isAfter(startTime)) {
          shouldCount = true;
        }
      }

      if (gameStartTime == null) {
        gameStartTime = _getLogLineDateTime(line);
        if (gameStartTime != null) {
          results.add(LogAnalyzeLineData(type: "info", title: S.current.log_analyzer_game_start, tag: "game_start"));
        }
      }

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

      final baseEvent = _parseBaseEvent(line);
      if (baseEvent != null) {
        LogAnalyzeLineData? data;
        switch (baseEvent) {
          case "AccountLoginCharacterStatus_Character":
            data = _parseCharacterName(line);
            if (data != null && data.playerName != null) {
              playerName = data.playerName!;
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
          case "[ActorState] Dead":
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
              latestLocation = data.location;
            }
            break;
        }
        if (data != null) {
          results.add(data);
          continue;
        }
      }

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

      if (line.contains("Cloud Imperium Games public crash handler")) {
        gameCrashLineNumber = i;
      }
    }

    if (gameCrashLineNumber > 0) {
      final lastLineDateTime = gameStartTime != null
          ? _getLogLineDateTime(logLines.lastWhere((e) => e.startsWith("<20")))
          : null;
      final crashInfo = logLines.sublist(gameCrashLineNumber);
      results.add(
        LogAnalyzeLineData(
          type: "game_crash",
          title: S.current.log_analyzer_game_crash,
          data: crashInfo.join("\n"),
          dateTime: lastLineDateTime != null ? _dateTimeFormatter.format(lastLineDateTime) : null,
        ),
      );
    }

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
    final vehicle = _safeExtract(_fatalCollisionPatterns['vehicle']!, line) ?? unknownValue;
    final zone = _safeExtract(_fatalCollisionPatterns['zone']!, line) ?? unknownValue;
    final playerPilot = (_safeExtract(_fatalCollisionPatterns['player_pilot']!, line) ?? '0') == '1';
    final hitEntity = _safeExtract(_fatalCollisionPatterns['hit_entity']!, line) ?? unknownValue;
    final distance = double.tryParse(_safeExtract(_fatalCollisionPatterns['distance']!, line) ?? '') ?? 0.0;

    return LogAnalyzeLineData(
      type: "fatal_collision",
      title: S.current.log_analyzer_filter_fatal_collision,
      data: S.current.log_analyzer_collision_details(
        zone,
        playerPilot ? '✅' : '❌',
        hitEntity,
        vehicle,
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
      final fromZone = match.group(2) ?? unknownValue;
      final toZone = match.group(3) ?? unknownValue;

      if (shouldCount) {
        final isDeath = victimId.trim() == playerName;
        if (isDeath) {
          onDeath(false, true, false);
        }
      }

      return LogAnalyzeLineData(
        type: "actor_death",
        title: S.current.log_analyzer_filter_character_death,
        data: S.current.log_analyzer_death_details(victimId, unknownValue, unknownValue, "$fromZone -> $toZone"),
        dateTime: _getLogLineDateTimeString(line),
        location: fromZone,
        area: toZone,
        victimId: victimId,
        playerName: playerName,
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
        playerName: characterName,
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
        location: location,
      );
    }
    return null;
  }
}
