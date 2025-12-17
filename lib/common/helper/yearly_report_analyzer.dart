import 'dart:io';
import 'dart:convert';
import 'dart:isolate';
import 'package:starcitizen_doctor/common/helper/game_log_analyzer.dart';

/// 年度报告数据类
class YearlyReportData {
  // 基础统计
  final int totalLaunchCount; // 累计启动次数
  final Duration totalPlayTime; // 累计游玩时长
  final int yearlyLaunchCount; // 年度启动次数
  final Duration yearlyPlayTime; // 年度游玩时长
  final int totalCrashCount; // 总崩溃次数
  final int yearlyCrashCount; // 年度崩溃次数

  // 时间统计
  final DateTime? yearlyFirstLaunchTime; // 年度第一次启动时间
  final DateTime? earliestPlayDate; // 年度游玩最早的一天 (05:00及以后)
  final DateTime? latestPlayDate; // 年度游玩最晚的一天 (04:00及以前)

  // 游玩时长统计
  final Duration? longestSession; // 最长单次游玩时长
  final DateTime? longestSessionDate; // 最长游玩那一天
  final Duration? shortestSession; // 最短单次游玩时长 (超过5分钟的)
  final DateTime? shortestSessionDate; // 最短游玩那一天
  final Duration? averageSessionTime; // 平均单次游玩时长

  // 载具统计
  final int yearlyVehicleDestructionCount; // 年度炸船次数
  final String? mostDestroyedVehicle; // 年度炸的最多的船
  final int mostDestroyedVehicleCount; // 炸的最多的船的次数
  final String? mostPilotedVehicle; // 年度最爱驾驶的载具
  final int mostPilotedVehicleCount; // 驾驶次数

  // 账号统计
  final int accountCount; // 账号数量
  final String? mostPlayedAccount; // 游玩最多的账号
  final int mostPlayedAccountSessionCount; // 游玩最多的账号的会话次数

  // 地点统计
  final List<MapEntry<String, int>> topLocations; // Top 地点访问统计

  // 击杀统计 (K/D)
  final int yearlyKillCount; // 年度击杀次数
  final int yearlyDeathCount; // 年度死亡次数
  final int yearlySelfKillCount; // 年度自杀次数

  // 详细数据 (用于展示)
  final Map<String, int> vehiclePilotedDetails; // 驾驶载具详情
  final Map<String, int> accountSessionDetails; // 账号会话详情
  final Map<String, int> locationDetails; // 地点访问详情

  const YearlyReportData({
    required this.totalLaunchCount,
    required this.totalPlayTime,
    required this.yearlyLaunchCount,
    required this.yearlyPlayTime,
    required this.totalCrashCount,
    required this.yearlyCrashCount,
    this.yearlyFirstLaunchTime,
    this.earliestPlayDate,
    this.latestPlayDate,
    this.longestSession,
    this.longestSessionDate,
    this.shortestSession,
    this.shortestSessionDate,
    this.averageSessionTime,
    required this.yearlyVehicleDestructionCount,
    this.mostDestroyedVehicle,
    required this.mostDestroyedVehicleCount,
    this.mostPilotedVehicle,
    required this.mostPilotedVehicleCount,
    required this.accountCount,
    this.mostPlayedAccount,
    required this.mostPlayedAccountSessionCount,
    required this.topLocations,
    required this.yearlyKillCount,
    required this.yearlyDeathCount,
    required this.yearlySelfKillCount,
    required this.vehiclePilotedDetails,
    required this.accountSessionDetails,
    required this.locationDetails,
  });

  /// 将 DateTime 转换为 UTC 毫秒时间戳
  static int? _toUtcTimestamp(DateTime? dateTime) {
    if (dateTime == null) return null;
    return dateTime.toUtc().millisecondsSinceEpoch;
  }

  /// 转换为 JSON Map
  ///
  /// 时间字段使用 UTC 毫秒时间戳 (int)，配合 timezoneOffsetMinutes 可在客户端还原本地时间
  Map<String, dynamic> toJson() {
    final now = DateTime.now();
    final offset = now.timeZoneOffset;

    return {
      // 元数据
      'generatedAtUtc': _toUtcTimestamp(now),
      'timezoneOffsetMinutes': offset.inMinutes,

      // 基础统计
      'totalLaunchCount': totalLaunchCount,
      'totalPlayTimeMs': totalPlayTime.inMilliseconds,
      'yearlyLaunchCount': yearlyLaunchCount,
      'yearlyPlayTimeMs': yearlyPlayTime.inMilliseconds,
      'totalCrashCount': totalCrashCount,
      'yearlyCrashCount': yearlyCrashCount,

      // 时间统计 (UTC 毫秒时间戳)
      'yearlyFirstLaunchTimeUtc': _toUtcTimestamp(yearlyFirstLaunchTime),
      'earliestPlayDateUtc': _toUtcTimestamp(earliestPlayDate),
      'latestPlayDateUtc': _toUtcTimestamp(latestPlayDate),

      // 游玩时长统计
      'longestSessionMs': longestSession?.inMilliseconds,
      'longestSessionDateUtc': _toUtcTimestamp(longestSessionDate),
      'shortestSessionMs': shortestSession?.inMilliseconds,
      'shortestSessionDateUtc': _toUtcTimestamp(shortestSessionDate),
      'averageSessionTimeMs': averageSessionTime?.inMilliseconds,

      // 载具统计
      'yearlyVehicleDestructionCount': yearlyVehicleDestructionCount,
      'mostDestroyedVehicle': mostDestroyedVehicle,
      'mostDestroyedVehicleCount': mostDestroyedVehicleCount,
      'mostPilotedVehicle': mostPilotedVehicle,
      'mostPilotedVehicleCount': mostPilotedVehicleCount,

      // 账号统计
      'accountCount': accountCount,
      'mostPlayedAccount': mostPlayedAccount,
      'mostPlayedAccountSessionCount': mostPlayedAccountSessionCount,

      // 地点统计
      'topLocations': topLocations.map((e) => {'location': e.key, 'count': e.value}).toList(),

      // 击杀统计
      'yearlyKillCount': yearlyKillCount,
      'yearlyDeathCount': yearlyDeathCount,
      'yearlySelfKillCount': yearlySelfKillCount,

      // 详细数据
      'vehiclePilotedDetails': vehiclePilotedDetails,
      'accountSessionDetails': accountSessionDetails,
      'locationDetails': locationDetails,
    };
  }

  @override
  String toString() {
    return '''YearlyReportData(
  totalLaunchCount: $totalLaunchCount,
  totalPlayTime: $totalPlayTime,
  yearlyLaunchCount: $yearlyLaunchCount,
  yearlyPlayTime: $yearlyPlayTime,
  totalCrashCount: $totalCrashCount,
  yearlyCrashCount: $yearlyCrashCount,
  yearlyFirstLaunchTime: $yearlyFirstLaunchTime,
  earliestPlayDate: $earliestPlayDate,
  latestPlayDate: $latestPlayDate,
  longestSession: $longestSession (on $longestSessionDate),
  shortestSession: $shortestSession (on $shortestSessionDate),
  averageSessionTime: $averageSessionTime,
  yearlyVehicleDestructionCount: $yearlyVehicleDestructionCount,
  mostDestroyedVehicle: $mostDestroyedVehicle ($mostDestroyedVehicleCount),
  mostPilotedVehicle: $mostPilotedVehicle ($mostPilotedVehicleCount),
  accountCount: $accountCount,
  mostPlayedAccount: $mostPlayedAccount ($mostPlayedAccountSessionCount),
  topLocations: ${topLocations.take(5).map((e) => '${e.key}: ${e.value}').join(', ')},
)''';
  }
}

/// 单个日志文件的统计结果 (内部使用)
class _LogFileStats {
  DateTime? startTime;
  DateTime? endTime;
  bool hasCrash = false;
  int killCount = 0;
  int deathCount = 0;
  int selfKillCount = 0;
  Set<String> playerNames = {};
  String? currentPlayerName;
  String? firstPlayerName; // 第一个检测到的玩家名，用于去重

  // 载具损毁: 载具型号 (去除ID后) -> 次数
  Map<String, int> vehicleDestruction = {};

  // 驾驶载具: 载具型号 (去除ID后) -> 次数
  Map<String, int> vehiclePiloted = {};

  // 地点访问: 地点名 -> 次数
  Map<String, int> locationVisits = {};

  // 年度内的会话记录
  List<_SessionInfo> yearlySessions = [];

  /// 生成用于去重的唯一标识
  /// 基于启动时间和第一个玩家名生成
  String? get uniqueKey {
    if (startTime == null) return null;
    final timeKey = startTime!.toUtc().toIso8601String();
    final playerKey = firstPlayerName ?? 'unknown';
    return '$timeKey|$playerKey';
  }
}

/// 单次游玩会话信息
class _SessionInfo {
  final DateTime startTime;
  final DateTime endTime;

  _SessionInfo({required this.startTime, required this.endTime});

  Duration get duration => endTime.difference(startTime);
}

/// 年度报告分析器
class YearlyReportAnalyzer {
  // 新版日志格式的正则表达式
  static final _characterNamePattern = RegExp(r'name\s+(\w+)\s+signedIn');
  static final _vehicleDestructionPattern = RegExp(
    r"Vehicle\s+'([^']+)'.*?" // 载具型号
    r"in zone\s+'([^']+)'.*?" // Zone
    r"destroy level \d+ to (\d+).*?" // 损毁等级
    r"caused by\s+'([^']+)'", // 责任方
  );
  static final _actorDeathPattern = RegExp(
    r"Actor '([^']+)'.*?" // 受害者ID
    r"ejected from zone '([^']+)'.*?" // 原载具/区域
    r"to zone '([^']+)'", // 目标区域
  );

  // Legacy 格式的正则表达式 (旧版日志)
  static final _legacyCharacterNamePattern = RegExp(r"name\s+([^-]+)");
  static final _legacyActorDeathPattern = RegExp(
    r"CActor::Kill: '([^']+)'.*?" // 受害者ID
    r"in zone '([^']+)'.*?" // 死亡位置区域
    r"killed by '([^']+)'.*?" // 击杀者ID
    r"with damage type '([^']+)'", // 伤害类型
  );
  static final _requestLocationInventoryPattern = RegExp(r"Player\[([^\]]+)\].*?Location\[([^\]]+)\]");

  /// 分析单个日志文件
  static Future<_LogFileStats> _analyzeLogFile(File logFile, int targetYear) async {
    final stats = _LogFileStats();

    if (!(await logFile.exists())) {
      return stats;
    }

    try {
      final content = utf8.decode(await logFile.readAsBytes(), allowMalformed: true);
      final lines = content.split('\n');

      for (final line in lines) {
        if (line.isEmpty) continue;

        final lineTime = GameLogAnalyzer.getLogLineDateTime(line);

        // 记录开始时间 (第一个有效时间)
        if (stats.startTime == null && lineTime != null) {
          stats.startTime = lineTime;
        }

        // 更新结束时间 (最后一个有效时间)
        if (lineTime != null) {
          stats.endTime = lineTime;
        }

        // 检测崩溃
        if (line.contains("Cloud Imperium Games public crash handler")) {
          stats.hasCrash = true;
        }

        // 检测玩家登录 (尝试新版格式，失败则用旧版)
        var nameMatch = _characterNamePattern.firstMatch(line);
        nameMatch ??= _legacyCharacterNamePattern.firstMatch(line);
        if (nameMatch != null) {
          final playerName = nameMatch.group(1)?.trim();
          if (playerName != null && playerName.isNotEmpty && !playerName.contains(' ')) {
            stats.currentPlayerName = playerName;
            stats.playerNames.add(playerName);
            stats.firstPlayerName ??= playerName;
          }
        }

        // 年度内的统计
        if (lineTime != null && lineTime.year == targetYear) {
          // 检测载具损毁
          final destructionMatch = _vehicleDestructionPattern.firstMatch(line);
          if (destructionMatch != null) {
            final vehicleModel = destructionMatch.group(1);
            final causedBy = destructionMatch.group(4)?.trim();

            if (vehicleModel != null &&
                causedBy != null &&
                stats.currentPlayerName != null &&
                causedBy == stats.currentPlayerName) {
              final cleanVehicleName = GameLogAnalyzer.removeVehicleId(vehicleModel);
              stats.vehicleDestruction[cleanVehicleName] = (stats.vehicleDestruction[cleanVehicleName] ?? 0) + 1;
            }
          }

          // 检测驾驶载具
          final controlMatch = GameLogAnalyzer.vehicleControlPattern.firstMatch(line);
          if (controlMatch != null) {
            final vehicleName = controlMatch.group(1);
            if (vehicleName != null) {
              final cleanVehicleName = GameLogAnalyzer.removeVehicleId(vehicleName);
              stats.vehiclePiloted[cleanVehicleName] = (stats.vehiclePiloted[cleanVehicleName] ?? 0) + 1;
            }
          }

          // 检测死亡 (新版格式)
          var deathMatch = _actorDeathPattern.firstMatch(line);
          if (deathMatch != null) {
            final victimId = deathMatch.group(1)?.trim();
            if (victimId != null && stats.currentPlayerName != null && victimId == stats.currentPlayerName) {
              stats.deathCount++;
            }
          }

          // 检测死亡 (旧版格式 - Legacy)
          final legacyDeathMatch = _legacyActorDeathPattern.firstMatch(line);
          if (legacyDeathMatch != null) {
            final victimId = legacyDeathMatch.group(1)?.trim();
            final killerId = legacyDeathMatch.group(3)?.trim();

            if (victimId != null && stats.currentPlayerName != null) {
              // 检测自杀
              if (victimId == killerId) {
                if (victimId == stats.currentPlayerName) {
                  stats.selfKillCount++;
                }
              } else {
                // 检测死亡
                if (victimId == stats.currentPlayerName) {
                  stats.deathCount++;
                }
                // 检测击杀
                if (killerId == stats.currentPlayerName) {
                  stats.killCount++;
                }
              }
            }
          }

          // 检测地点访问 (RequestLocationInventory)
          final locationMatch = _requestLocationInventoryPattern.firstMatch(line);
          if (locationMatch != null) {
            final location = locationMatch.group(2)?.trim();
            if (location != null && location.isNotEmpty) {
              // 清理地点名称，移除数字ID后缀
              final cleanLocation = _cleanLocationName(location);
              stats.locationVisits[cleanLocation] = (stats.locationVisits[cleanLocation] ?? 0) + 1;
            }
          }
        }
      }

      // 记录会话信息
      if (stats.startTime != null && stats.endTime != null && stats.startTime!.year == targetYear) {
        stats.yearlySessions.add(_SessionInfo(startTime: stats.startTime!, endTime: stats.endTime!));
      }
    } catch (e) {
      // Error handled silently in isolate
    }

    return stats;
  }

  /// 清理地点名称，移除数字ID后缀
  static String _cleanLocationName(String location) {
    // 移除末尾的数字ID (如 "_12345678")
    final cleanPattern = RegExp(r'_\d{6,}$');
    return location.replaceAll(cleanPattern, '');
  }

  /// 生成年度报告
  ///
  /// [gameInstallPaths] 游戏安装路径列表 (完整路径，如 ["D:/Games/StarCitizen/LIVE", "D:/Games/StarCitizen/PTU"])
  /// [targetYear] 目标年份
  ///
  /// 该方法在独立 Isolate 中运行，避免阻塞 UI
  static Future<YearlyReportData> generateReport(List<String> gameInstallPaths, int targetYear) async {
    // 在独立 Isolate 中运行以避免阻塞 UI
    return await Isolate.run(() async {
      return await _generateReportInIsolate(gameInstallPaths, targetYear);
    });
  }

  /// 内部方法：在 Isolate 中执行的报告生成逻辑
  static Future<YearlyReportData> _generateReportInIsolate(List<String> gameInstallPaths, int targetYear) async {
    final List<File> allLogFiles = [];

    // 从所有安装路径收集日志文件
    for (final installPath in gameInstallPaths) {
      final installDir = Directory(installPath);

      // 检查安装目录是否存在
      if (!await installDir.exists()) {
        continue;
      }

      final gameLogFile = File('$installPath/Game.log');
      final logBackupsDir = Directory('$installPath/logbackups');

      // 添加当前 Game.log
      if (await gameLogFile.exists()) {
        allLogFiles.add(gameLogFile);
      }

      // 添加备份日志
      if (await logBackupsDir.exists()) {
        await for (final entity in logBackupsDir.list()) {
          if (entity is File && entity.path.endsWith('.log')) {
            allLogFiles.add(entity);
          }
        }
      }
    }

    // 并发分析所有日志文件
    final futures = allLogFiles.map((file) => _analyzeLogFile(file, targetYear));
    final allStatsRaw = await Future.wait(futures);

    // 去重: 使用 uniqueKey (启动时间 + 玩家名) 来过滤重复的日志
    final seenKeys = <String>{};
    final allStats = <_LogFileStats>[];

    for (final stats in allStatsRaw) {
      final key = stats.uniqueKey;
      if (key == null) {
        allStats.add(stats);
      } else if (!seenKeys.contains(key)) {
        seenKeys.add(key);
        allStats.add(stats);
      }
    }

    // 合并统计数据
    int totalLaunchCount = allStats.length;
    Duration totalPlayTime = Duration.zero;
    int yearlyLaunchCount = 0;
    Duration yearlyPlayTime = Duration.zero;
    int totalCrashCount = 0;
    int yearlyCrashCount = 0;
    DateTime? yearlyFirstLaunchTime;
    DateTime? earliestPlayDate;
    DateTime? latestPlayDate;

    // 会话时长统计
    Duration? longestSession;
    DateTime? longestSessionDate;
    Duration? shortestSession;
    DateTime? shortestSessionDate;
    List<Duration> allSessionDurations = [];

    // K/D 统计
    int yearlyKillCount = 0;
    int yearlyDeathCount = 0;
    int yearlySelfKillCount = 0;

    final Map<String, int> vehicleDestructionDetails = {};
    final Map<String, int> vehiclePilotedDetails = {};
    final Map<String, int> accountSessionDetails = {};
    final Map<String, int> locationDetails = {};

    for (final stats in allStats) {
      // 累计游玩时长
      if (stats.startTime != null && stats.endTime != null) {
        totalPlayTime += stats.endTime!.difference(stats.startTime!);
      }

      // 崩溃统计
      if (stats.hasCrash) {
        totalCrashCount++;
        if (stats.endTime != null && stats.endTime!.year == targetYear) {
          yearlyCrashCount++;
        }
      }

      // 年度会话统计
      for (final session in stats.yearlySessions) {
        yearlyLaunchCount++;
        final sessionDuration = session.duration;
        yearlyPlayTime += sessionDuration;
        allSessionDurations.add(sessionDuration);

        // 年度第一次启动时间
        if (yearlyFirstLaunchTime == null || session.startTime.isBefore(yearlyFirstLaunchTime)) {
          yearlyFirstLaunchTime = session.startTime;
        }

        // 最早游玩的一天 (05:00及以后开始游戏)
        if (session.startTime.hour >= 5) {
          if (earliestPlayDate == null || _timeOfDayIsEarlier(session.startTime, earliestPlayDate)) {
            earliestPlayDate = session.startTime;
          }
        }

        // 最晚游玩的一天 (04:00及以前结束游戏)
        if (session.endTime.hour <= 4) {
          if (latestPlayDate == null || _timeOfDayIsLater(session.endTime, latestPlayDate)) {
            latestPlayDate = session.endTime;
          }
        }

        // 最长游玩时长
        if (longestSession == null || sessionDuration > longestSession) {
          longestSession = sessionDuration;
          longestSessionDate = session.startTime;
        }

        // 最短游玩时长 (超过5分钟的)
        if (sessionDuration.inMinutes >= 5) {
          if (shortestSession == null || sessionDuration < shortestSession) {
            shortestSession = sessionDuration;
            shortestSessionDate = session.startTime;
          }
        }
      }

      // 合并载具损毁详情 (过滤包含 PU 的载具)
      for (final entry in stats.vehicleDestruction.entries) {
        if (!entry.key.contains('PU_')) {
          vehicleDestructionDetails[entry.key] = (vehicleDestructionDetails[entry.key] ?? 0) + entry.value;
        }
      }

      // 合并驾驶载具详情
      for (final entry in stats.vehiclePiloted.entries) {
        vehiclePilotedDetails[entry.key] = (vehiclePilotedDetails[entry.key] ?? 0) + entry.value;
      }

      // 累计 K/D
      yearlyKillCount += stats.killCount;
      yearlyDeathCount += stats.deathCount;
      yearlySelfKillCount += stats.selfKillCount;

      // 合并账号会话详情
      for (final playerName in stats.playerNames) {
        if (playerName.length > 16) continue;
        String targetKey = playerName;
        // 查找是否存在忽略大小写的相同 key
        for (final key in accountSessionDetails.keys) {
          if (key.toLowerCase() == playerName.toLowerCase()) {
            targetKey = key;
            break;
          }
        }
        accountSessionDetails[targetKey] = (accountSessionDetails[targetKey] ?? 0) + 1;
      }

      // 合并地点访问详情
      for (final entry in stats.locationVisits.entries) {
        locationDetails[entry.key] = (locationDetails[entry.key] ?? 0) + entry.value;
      }
    }

    // 计算平均游玩时长
    Duration? averageSessionTime;
    if (allSessionDurations.isNotEmpty) {
      final totalMs = allSessionDurations.fold<int>(0, (sum, d) => sum + d.inMilliseconds);
      averageSessionTime = Duration(milliseconds: totalMs ~/ allSessionDurations.length);
    }

    // 计算派生统计
    final yearlyVehicleDestructionCount = vehicleDestructionDetails.values.fold(0, (a, b) => a + b);

    String? mostDestroyedVehicle;
    int mostDestroyedVehicleCount = 0;
    for (final entry in vehicleDestructionDetails.entries) {
      if (entry.value > mostDestroyedVehicleCount) {
        mostDestroyedVehicle = entry.key;
        mostDestroyedVehicleCount = entry.value;
      }
    }

    String? mostPilotedVehicle;
    int mostPilotedVehicleCount = 0;
    for (final entry in vehiclePilotedDetails.entries) {
      if (entry.value > mostPilotedVehicleCount) {
        mostPilotedVehicle = entry.key;
        mostPilotedVehicleCount = entry.value;
      }
    }

    String? mostPlayedAccount;
    int mostPlayedAccountSessionCount = 0;
    for (final entry in accountSessionDetails.entries) {
      if (entry.value > mostPlayedAccountSessionCount) {
        mostPlayedAccount = entry.key;
        mostPlayedAccountSessionCount = entry.value;
      }
    }

    // 计算 Top 10 地点
    final sortedLocations = locationDetails.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final topLocations = sortedLocations.take(10).toList();

    return YearlyReportData(
      totalLaunchCount: totalLaunchCount,
      totalPlayTime: totalPlayTime,
      yearlyLaunchCount: yearlyLaunchCount,
      yearlyPlayTime: yearlyPlayTime,
      totalCrashCount: totalCrashCount,
      yearlyCrashCount: yearlyCrashCount,
      yearlyFirstLaunchTime: yearlyFirstLaunchTime,
      earliestPlayDate: earliestPlayDate,
      latestPlayDate: latestPlayDate,
      longestSession: longestSession,
      longestSessionDate: longestSessionDate,
      shortestSession: shortestSession,
      shortestSessionDate: shortestSessionDate,
      averageSessionTime: averageSessionTime,
      yearlyVehicleDestructionCount: yearlyVehicleDestructionCount,
      mostDestroyedVehicle: mostDestroyedVehicle,
      mostDestroyedVehicleCount: mostDestroyedVehicleCount,
      mostPilotedVehicle: mostPilotedVehicle,
      mostPilotedVehicleCount: mostPilotedVehicleCount,
      accountCount: accountSessionDetails.length,
      mostPlayedAccount: mostPlayedAccount,
      mostPlayedAccountSessionCount: mostPlayedAccountSessionCount,
      topLocations: topLocations,
      yearlyKillCount: yearlyKillCount,
      yearlyDeathCount: yearlyDeathCount,
      yearlySelfKillCount: yearlySelfKillCount,
      vehiclePilotedDetails: vehiclePilotedDetails,
      accountSessionDetails: accountSessionDetails,
      locationDetails: locationDetails,
    );
  }

  /// 比较两个时间的 时:分 是否更早
  static bool _timeOfDayIsEarlier(DateTime a, DateTime b) {
    if (a.hour < b.hour) return true;
    if (a.hour > b.hour) return false;
    return a.minute < b.minute;
  }

  /// 比较两个时间的 时:分 是否更晚
  static bool _timeOfDayIsLater(DateTime a, DateTime b) {
    if (a.hour > b.hour) return true;
    if (a.hour < b.hour) return false;
    return a.minute > b.minute;
  }
}
