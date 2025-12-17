import 'dart:io';
import 'dart:convert';
import 'package:starcitizen_doctor/common/helper/game_log_analyzer.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';

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

  // 载具统计
  final int yearlyVehicleDestructionCount; // 年度炸船次数
  final String? mostDestroyedVehicle; // 年度炸的最多的船
  final int mostDestroyedVehicleCount; // 炸的最多的船的次数
  final String? mostPilotedVehicle; // 年度最爱驾驶的载具
  final int mostPilotedVehicleCount; // 驾驶次数

  // 战斗统计
  final int yearlyKillCount; // 年度击杀次数
  final int yearlyDeathCount; // 年度死亡次数

  // 账号统计
  final int accountCount; // 账号数量
  final String? mostPlayedAccount; // 游玩最多的账号
  final int mostPlayedAccountSessionCount; // 游玩最多的账号的会话次数

  // 详细数据 (用于展示)
  final Map<String, int> vehicleDestructionDetails; // 载具损毁详情
  final Map<String, int> vehiclePilotedDetails; // 驾驶载具详情
  final Map<String, int> accountSessionDetails; // 账号会话详情

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
    required this.yearlyVehicleDestructionCount,
    this.mostDestroyedVehicle,
    required this.mostDestroyedVehicleCount,
    this.mostPilotedVehicle,
    required this.mostPilotedVehicleCount,
    required this.yearlyKillCount,
    required this.yearlyDeathCount,
    required this.accountCount,
    this.mostPlayedAccount,
    required this.mostPlayedAccountSessionCount,
    required this.vehicleDestructionDetails,
    required this.vehiclePilotedDetails,
    required this.accountSessionDetails,
  });

  /// 将 DateTime 转换为带时区的 ISO 8601 字符串
  /// 输出格式: 2025-12-17T10:30:00.000+08:00
  static String? _toIso8601WithTimezone(DateTime? dateTime) {
    if (dateTime == null) return null;
    final local = dateTime.toLocal();
    final offset = local.timeZoneOffset;
    final sign = offset.isNegative ? '-' : '+';
    final hours = offset.inHours.abs().toString().padLeft(2, '0');
    final minutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
    // 使用本地时间的 ISO 字符串，然后附加时区偏移
    final isoString = local.toIso8601String();
    // 移除可能的 'Z' 后缀（UTC 标记）
    final baseString = isoString.endsWith('Z') ? isoString.substring(0, isoString.length - 1) : isoString;
    return '$baseString$sign$hours:$minutes';
  }

  /// 转换为 JSON Map
  Map<String, dynamic> toJson() {
    final now = DateTime.now();
    final offset = now.timeZoneOffset;
    final sign = offset.isNegative ? '-' : '+';
    final hours = offset.inHours.abs().toString().padLeft(2, '0');
    final minutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');

    return {
      // 元数据
      'generatedAt': _toIso8601WithTimezone(now),
      'timezoneOffset': '$sign$hours:$minutes',
      'timezoneOffsetMinutes': offset.inMinutes,

      // 基础统计
      'totalLaunchCount': totalLaunchCount,
      'totalPlayTimeMs': totalPlayTime.inMilliseconds,
      'yearlyLaunchCount': yearlyLaunchCount,
      'yearlyPlayTimeMs': yearlyPlayTime.inMilliseconds,
      'totalCrashCount': totalCrashCount,
      'yearlyCrashCount': yearlyCrashCount,

      // 时间统计 (带时区)
      'yearlyFirstLaunchTime': _toIso8601WithTimezone(yearlyFirstLaunchTime),
      'earliestPlayDate': _toIso8601WithTimezone(earliestPlayDate),
      'latestPlayDate': _toIso8601WithTimezone(latestPlayDate),

      // 载具统计
      'yearlyVehicleDestructionCount': yearlyVehicleDestructionCount,
      'mostDestroyedVehicle': mostDestroyedVehicle,
      'mostDestroyedVehicleCount': mostDestroyedVehicleCount,
      'mostPilotedVehicle': mostPilotedVehicle,
      'mostPilotedVehicleCount': mostPilotedVehicleCount,

      // 战斗统计
      'yearlyKillCount': yearlyKillCount,
      'yearlyDeathCount': yearlyDeathCount,

      // 账号统计
      'accountCount': accountCount,
      'mostPlayedAccount': mostPlayedAccount,
      'mostPlayedAccountSessionCount': mostPlayedAccountSessionCount,

      // 详细数据
      'vehicleDestructionDetails': vehicleDestructionDetails,
      'vehiclePilotedDetails': vehiclePilotedDetails,
      'accountSessionDetails': accountSessionDetails,
    };
  }

  /// 转换为 JSON 字符串
  String toJsonString() => jsonEncode(toJson());

  /// 转换为 Base64 编码的 JSON 字符串
  String toJsonBase64() => base64Encode(utf8.encode(toJsonString()));

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
  yearlyVehicleDestructionCount: $yearlyVehicleDestructionCount,
  mostDestroyedVehicle: $mostDestroyedVehicle ($mostDestroyedVehicleCount),
  mostPilotedVehicle: $mostPilotedVehicle ($mostPilotedVehicleCount),
  yearlyKillCount: $yearlyKillCount,
  yearlyDeathCount: $yearlyDeathCount,
  accountCount: $accountCount,
  mostPlayedAccount: $mostPlayedAccount ($mostPlayedAccountSessionCount),
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
  Set<String> playerNames = {};
  String? currentPlayerName;
  String? firstPlayerName; // 第一个检测到的玩家名，用于去重

  // 载具损毁: 载具型号 (去除ID后) -> 次数
  Map<String, int> vehicleDestruction = {};

  // 驾驶载具: 载具型号 (去除ID后) -> 次数
  Map<String, int> vehiclePiloted = {};

  // 年度内的时间记录
  List<DateTime> yearlyStartTimes = [];
  List<DateTime> yearlyEndTimes = [];

  /// 生成用于去重的唯一标识
  /// 基于启动时间和第一个玩家名生成
  String? get uniqueKey {
    if (startTime == null) return null;
    final timeKey = startTime!.toUtc().toIso8601String();
    final playerKey = firstPlayerName ?? 'unknown';
    return '$timeKey|$playerKey';
  }
}

/// 年度报告分析器
class YearlyReportAnalyzer {
  // 复用 GameLogAnalyzer 中的正则表达式和方法
  static final _characterNamePattern = RegExp(r"name\s+([^-]+)");
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

          // 记录年度内的时间
          if (lineTime.year == targetYear) {
            if (stats.yearlyStartTimes.isEmpty ||
                stats.yearlyStartTimes.last.difference(lineTime).abs().inMinutes > 30) {
              // 新的会话开始
              stats.yearlyStartTimes.add(lineTime);
            }
            // 总是更新最后的结束时间
            if (stats.yearlyEndTimes.isEmpty) {
              stats.yearlyEndTimes.add(lineTime);
            } else {
              stats.yearlyEndTimes[stats.yearlyEndTimes.length - 1] = lineTime;
            }
          }
        }

        // 检测崩溃
        if (line.contains("Cloud Imperium Games public crash handler")) {
          stats.hasCrash = true;
        }

        // 检测玩家登录
        final nameMatch = _characterNamePattern.firstMatch(line);
        if (nameMatch != null) {
          final playerName = nameMatch.group(1)?.trim();
          if (playerName != null && playerName.isNotEmpty) {
            stats.currentPlayerName = playerName;
            stats.playerNames.add(playerName);
            // 记录第一个玩家名用于去重
            stats.firstPlayerName ??= playerName;
          }
        }

        // 检测载具损毁 (仅年度内)
        if (lineTime != null && lineTime.year == targetYear) {
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

          // 检测死亡
          final deathMatch = _actorDeathPattern.firstMatch(line);
          if (deathMatch != null) {
            final victimId = deathMatch.group(1)?.trim();

            if (victimId != null && stats.currentPlayerName != null && victimId == stats.currentPlayerName) {
              stats.deathCount++;
            }
          }
        }
      }
    } catch (e) {
      dPrint('[YearlyReportAnalyzer] Error analyzing log file: $e');
    }

    return stats;
  }

  /// 生成年度报告
  ///
  /// [gameInstallPaths] 游戏安装路径列表 (完整路径，如 ["D:/Games/StarCitizen/LIVE", "D:/Games/StarCitizen/PTU"])
  /// [targetYear] 目标年份
  static Future<YearlyReportData> generateReport(List<String> gameInstallPaths, int targetYear) async {
    final List<File> allLogFiles = [];

    // 从所有安装路径收集日志文件
    for (final installPath in gameInstallPaths) {
      final installDir = Directory(installPath);

      // 检查安装目录是否存在
      if (!await installDir.exists()) {
        dPrint('[YearlyReportAnalyzer] Install path does not exist: $installPath');
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

    dPrint(
      '[YearlyReportAnalyzer] Found ${allLogFiles.length} log files from ${gameInstallPaths.length} install paths',
    );

    // 并发分析所有日志文件
    final futures = allLogFiles.map((file) => _analyzeLogFile(file, targetYear));
    final allStatsRaw = await Future.wait(futures);

    // 去重: 使用 uniqueKey (启动时间 + 玩家名) 来过滤重复的日志
    final seenKeys = <String>{};
    final allStats = <_LogFileStats>[];

    for (final stats in allStatsRaw) {
      final key = stats.uniqueKey;
      if (key == null) {
        // 无法生成唯一标识的日志仍然保留
        allStats.add(stats);
      } else if (!seenKeys.contains(key)) {
        seenKeys.add(key);
        allStats.add(stats);
      } else {
        dPrint('[YearlyReportAnalyzer] Skipping duplicate log: $key');
      }
    }

    dPrint('[YearlyReportAnalyzer] After deduplication: ${allStats.length} unique logs');

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
    int yearlyKillCount = 0;
    int yearlyDeathCount = 0;

    final Map<String, int> vehicleDestructionDetails = {};
    final Map<String, int> vehiclePilotedDetails = {};
    final Map<String, int> accountSessionDetails = {};

    for (final stats in allStats) {
      // 累计游玩时长
      if (stats.startTime != null && stats.endTime != null) {
        totalPlayTime += stats.endTime!.difference(stats.startTime!);
      }

      // 崩溃统计
      if (stats.hasCrash) {
        totalCrashCount++;
        // 检查是否为年度内的崩溃
        if (stats.endTime != null && stats.endTime!.year == targetYear) {
          yearlyCrashCount++;
        }
      }

      // 年度统计
      for (int i = 0; i < stats.yearlyStartTimes.length; i++) {
        yearlyLaunchCount++;
        final startTime = stats.yearlyStartTimes[i];
        final endTime = i < stats.yearlyEndTimes.length ? stats.yearlyEndTimes[i] : startTime;
        yearlyPlayTime += endTime.difference(startTime);

        // 年度第一次启动时间
        if (yearlyFirstLaunchTime == null || startTime.isBefore(yearlyFirstLaunchTime)) {
          yearlyFirstLaunchTime = startTime;
        }

        // 最早游玩的一天 (05:00及以后开始游戏)
        if (startTime.hour >= 5) {
          if (earliestPlayDate == null || _timeOfDayIsEarlier(startTime, earliestPlayDate)) {
            earliestPlayDate = startTime;
          }
        }

        // 最晚游玩的一天 (04:00及以前结束游戏)
        if (endTime.hour <= 4) {
          if (latestPlayDate == null || _timeOfDayIsLater(endTime, latestPlayDate)) {
            latestPlayDate = endTime;
          }
        }
      }

      // 累加战斗统计
      yearlyKillCount += stats.killCount;
      yearlyDeathCount += stats.deathCount;

      // 合并载具损毁详情
      for (final entry in stats.vehicleDestruction.entries) {
        vehicleDestructionDetails[entry.key] = (vehicleDestructionDetails[entry.key] ?? 0) + entry.value;
      }

      // 合并驾驶载具详情
      for (final entry in stats.vehiclePiloted.entries) {
        vehiclePilotedDetails[entry.key] = (vehiclePilotedDetails[entry.key] ?? 0) + entry.value;
      }

      // 合并账号会话详情
      for (final playerName in stats.playerNames) {
        accountSessionDetails[playerName] = (accountSessionDetails[playerName] ?? 0) + 1;
      }
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
      yearlyVehicleDestructionCount: yearlyVehicleDestructionCount,
      mostDestroyedVehicle: mostDestroyedVehicle,
      mostDestroyedVehicleCount: mostDestroyedVehicleCount,
      mostPilotedVehicle: mostPilotedVehicle,
      mostPilotedVehicleCount: mostPilotedVehicleCount,
      yearlyKillCount: yearlyKillCount,
      yearlyDeathCount: yearlyDeathCount,
      accountCount: accountSessionDetails.length,
      mostPlayedAccount: mostPlayedAccount,
      mostPlayedAccountSessionCount: mostPlayedAccountSessionCount,
      vehicleDestructionDetails: vehicleDestructionDetails,
      vehiclePilotedDetails: vehiclePilotedDetails,
      accountSessionDetails: accountSessionDetails,
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
