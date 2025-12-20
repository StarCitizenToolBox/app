import 'package:starcitizen_doctor/common/helper/game_log_analyzer.dart';

/// 年度报告数据类
class YearlyReportData {
  // 基础统计
  final int totalLaunchCount;
  final Duration totalPlayTime;
  final int yearlyLaunchCount;
  final Duration yearlyPlayTime;
  final int totalCrashCount;
  final int yearlyCrashCount;

  // 时间统计
  final DateTime? yearlyFirstLaunchTime;
  final DateTime? earliestPlayDate;
  final DateTime? latestPlayDate;

  // 游玩时长统计
  final Duration? longestSession;
  final DateTime? longestSessionDate;
  final Duration? shortestSession;
  final DateTime? shortestSessionDate;
  final Duration? averageSessionTime;

  // 载具统计
  final int yearlyVehicleDestructionCount;
  final String? mostDestroyedVehicle;
  final int mostDestroyedVehicleCount;
  final String? mostPilotedVehicle;
  final int mostPilotedVehicleCount;

  // 账号统计
  final int accountCount;
  final String? mostPlayedAccount;
  final int mostPlayedAccountSessionCount;

  // 地点统计
  final List<MapEntry<String, int>> topLocations;

  // 击杀统计 (K/D)
  final int yearlyKillCount;
  final int yearlyDeathCount;
  final int yearlySelfKillCount;

  // 月份统计
  final int? mostPlayedMonth;
  final int mostPlayedMonthCount;
  final int? leastPlayedMonth;
  final int leastPlayedMonthCount;

  // 连续游玩/离线统计
  final int longestPlayStreak;
  final DateTime? playStreakStartDate;
  final DateTime? playStreakEndDate;
  final int longestOfflineStreak;
  final DateTime? offlineStreakStartDate;
  final DateTime? offlineStreakEndDate;

  // 详细数据
  final Map<String, int> vehiclePilotedDetails;
  final Map<String, int> accountSessionDetails;
  final Map<String, int> locationDetails;

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
    this.mostPlayedMonth,
    required this.mostPlayedMonthCount,
    this.leastPlayedMonth,
    required this.leastPlayedMonthCount,
    required this.longestPlayStreak,
    this.playStreakStartDate,
    this.playStreakEndDate,
    required this.longestOfflineStreak,
    this.offlineStreakStartDate,
    this.offlineStreakEndDate,
    required this.vehiclePilotedDetails,
    required this.accountSessionDetails,
    required this.locationDetails,
  });

  static int? _toUtcTimestamp(DateTime? dateTime) {
    if (dateTime == null) return null;
    return dateTime.toUtc().millisecondsSinceEpoch;
  }

  Map<String, dynamic> toJson() {
    final now = DateTime.now();
    final offset = now.timeZoneOffset;

    return {
      'generatedAtUtc': _toUtcTimestamp(now),
      'timezoneOffsetMinutes': offset.inMinutes,
      'totalLaunchCount': totalLaunchCount,
      'totalPlayTimeMs': totalPlayTime.inMilliseconds,
      'yearlyLaunchCount': yearlyLaunchCount,
      'yearlyPlayTimeMs': yearlyPlayTime.inMilliseconds,
      'totalCrashCount': totalCrashCount,
      'yearlyCrashCount': yearlyCrashCount,
      'yearlyFirstLaunchTimeUtc': _toUtcTimestamp(yearlyFirstLaunchTime),
      'earliestPlayDateUtc': _toUtcTimestamp(earliestPlayDate),
      'latestPlayDateUtc': _toUtcTimestamp(latestPlayDate),
      'longestSessionMs': longestSession?.inMilliseconds,
      'longestSessionDateUtc': _toUtcTimestamp(longestSessionDate),
      'shortestSessionMs': shortestSession?.inMilliseconds,
      'shortestSessionDateUtc': _toUtcTimestamp(shortestSessionDate),
      'averageSessionTimeMs': averageSessionTime?.inMilliseconds,
      'yearlyVehicleDestructionCount': yearlyVehicleDestructionCount,
      'mostDestroyedVehicle': mostDestroyedVehicle,
      'mostDestroyedVehicleCount': mostDestroyedVehicleCount,
      'mostPilotedVehicle': mostPilotedVehicle,
      'mostPilotedVehicleCount': mostPilotedVehicleCount,
      'accountCount': accountCount,
      'mostPlayedAccount': mostPlayedAccount,
      'mostPlayedAccountSessionCount': mostPlayedAccountSessionCount,
      'topLocations': topLocations.map((e) => {'location': e.key, 'count': e.value}).toList(),
      'yearlyKillCount': yearlyKillCount,
      'yearlyDeathCount': yearlyDeathCount,
      'yearlySelfKillCount': yearlySelfKillCount,
      'mostPlayedMonth': mostPlayedMonth,
      'mostPlayedMonthCount': mostPlayedMonthCount,
      'leastPlayedMonth': leastPlayedMonth,
      'leastPlayedMonthCount': leastPlayedMonthCount,
      'longestPlayStreak': longestPlayStreak,
      'playStreakStartDateUtc': _toUtcTimestamp(playStreakStartDate),
      'playStreakEndDateUtc': _toUtcTimestamp(playStreakEndDate),
      'longestOfflineStreak': longestOfflineStreak,
      'offlineStreakStartDateUtc': _toUtcTimestamp(offlineStreakStartDate),
      'offlineStreakEndDateUtc': _toUtcTimestamp(offlineStreakEndDate),
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
  String? firstPlayerName;

  Map<String, int> vehicleDestruction = {};
  Map<String, int> vehiclePiloted = {};
  Map<String, int> locationVisits = {};

  DateTime? _lastDeathTime;
  List<_SessionInfo> yearlySessions = [];

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

/// 年度报告分析器 (Web 版本)
class YearlyReportAnalyzer {
  static final _characterNamePattern = RegExp(r'name\s+([^-]+)');
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
  static final _legacyActorDeathPattern = RegExp(
    r"CActor::Kill: '([^']+)'.*?"
    r"in zone '([^']+)'.*?"
    r"killed by '([^']+)'.*?"
    r"with damage type '([^']+)'",
  );
  static final _requestLocationInventoryPattern = RegExp(r"Player\[([^\]]+)\].*?Location\[([^\]]+)\]");

  /// 分析单个日志文件内容
  static _LogFileStats _analyzeLogContent(String content, int targetYear) {
    final stats = _LogFileStats();

    try {
      final lines = content.split('\n');

      for (final line in lines) {
        if (line.isEmpty) continue;

        final lineTime = GameLogAnalyzer.getLogLineDateTime(line);

        if (stats.startTime == null && lineTime != null) {
          stats.startTime = lineTime;
        }

        if (lineTime != null) {
          stats.endTime = lineTime;
        }

        if (line.contains("Cloud Imperium Games public crash handler")) {
          stats.hasCrash = true;
        }

        if (line.contains('AccountLoginCharacterStatus_Character')) {
          final nameMatch = _characterNamePattern.firstMatch(line);
          if (nameMatch != null) {
            final playerName = nameMatch.group(1)?.trim();
            if (playerName != null &&
                playerName.isNotEmpty &&
                !playerName.contains(' ') &&
                !playerName.contains('/') &&
                !playerName.contains(r'\\') &&
                !playerName.contains('.')) {
              stats.currentPlayerName = playerName;
              if (!stats.playerNames.any((n) => n.toLowerCase() == playerName.toLowerCase())) {
                stats.playerNames.add(playerName);
              }
              stats.firstPlayerName ??= playerName;
            }
          }
        }

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

          final controlMatch = GameLogAnalyzer.vehicleControlPattern.firstMatch(line);
          if (controlMatch != null) {
            final vehicleName = controlMatch.group(1);
            if (vehicleName != null) {
              final cleanVehicleName = GameLogAnalyzer.removeVehicleId(vehicleName);
              if (cleanVehicleName != 'Default') {
                stats.vehiclePiloted[cleanVehicleName] = (stats.vehiclePiloted[cleanVehicleName] ?? 0) + 1;
              }
            }
          }

          var deathMatch = _actorDeathPattern.firstMatch(line);
          if (deathMatch != null) {
            final victimId = deathMatch.group(1)?.trim();
            if (victimId != null && stats.currentPlayerName != null && victimId == stats.currentPlayerName) {
              if (stats._lastDeathTime == null || lineTime.difference(stats._lastDeathTime!).abs().inSeconds > 2) {
                stats.deathCount++;
                stats._lastDeathTime = lineTime;
              }
            }
          }

          final legacyDeathMatch = _legacyActorDeathPattern.firstMatch(line);
          if (legacyDeathMatch != null) {
            final victimId = legacyDeathMatch.group(1)?.trim();
            final killerId = legacyDeathMatch.group(3)?.trim();

            if (victimId != null && stats.currentPlayerName != null) {
              bool isRecent =
                  stats._lastDeathTime != null && lineTime.difference(stats._lastDeathTime!).abs().inSeconds <= 2;

              if (victimId == killerId) {
                if (victimId == stats.currentPlayerName) {
                  if (isRecent) {
                    stats.selfKillCount++;
                    stats._lastDeathTime = lineTime;
                  } else {
                    stats.deathCount++;
                    stats.selfKillCount++;
                    stats._lastDeathTime = lineTime;
                  }
                }
              } else {
                if (victimId == stats.currentPlayerName) {
                  if (!isRecent) {
                    stats.deathCount++;
                    stats._lastDeathTime = lineTime;
                  }
                }
                if (killerId == stats.currentPlayerName) {
                  stats.killCount++;
                }
              }
            }
          }

          final locationMatch = _requestLocationInventoryPattern.firstMatch(line);
          if (locationMatch != null) {
            final location = locationMatch.group(2)?.trim();
            if (location != null && location.isNotEmpty) {
              final cleanLocation = _cleanLocationName(location);
              stats.locationVisits[cleanLocation] = (stats.locationVisits[cleanLocation] ?? 0) + 1;
            }
          }
        }
      }

      if (stats.startTime != null && stats.endTime != null && stats.startTime!.year == targetYear) {
        stats.yearlySessions.add(_SessionInfo(startTime: stats.startTime!, endTime: stats.endTime!));
      }
    } catch (e) {
      // Error handled silently
    }

    return stats;
  }

  static String _cleanLocationName(String location) {
    final cleanPattern = RegExp(r'_\d{6,}$');
    return location.replaceAll(cleanPattern, '');
  }

  /// 从日志文件内容列表生成年度报告 (Web 版本)
  static Future<YearlyReportData> generateReportFromContents(List<String> logContents, int targetYear) async {
    final allStats = <_LogFileStats>[];
    final seenKeys = <String>{};

    for (final content in logContents) {
      try {
        final stats = _analyzeLogContent(content, targetYear);
        final key = stats.uniqueKey;
        if (key == null) {
          allStats.add(stats);
        } else if (!seenKeys.contains(key)) {
          seenKeys.add(key);
          allStats.add(stats);
        }
      } catch (_) {
        // 忽略单个文件分析错误
      }
    }

    return _generateReportFromStats(allStats, targetYear);
  }

  static YearlyReportData _generateReportFromStats(List<_LogFileStats> allStats, int targetYear) {
    int totalLaunchCount = allStats.length;
    Duration totalPlayTime = Duration.zero;
    int yearlyLaunchCount = 0;
    Duration yearlyPlayTime = Duration.zero;
    int totalCrashCount = 0;
    int yearlyCrashCount = 0;
    DateTime? yearlyFirstLaunchTime;
    DateTime? earliestPlayDate;
    DateTime? latestPlayDate;

    Duration? longestSession;
    DateTime? longestSessionDate;
    Duration? shortestSession;
    DateTime? shortestSessionDate;
    List<Duration> allSessionDurations = [];

    int yearlyKillCount = 0;
    int yearlyDeathCount = 0;
    int yearlySelfKillCount = 0;

    final Map<String, int> vehicleDestructionDetails = {};
    final Map<String, int> vehiclePilotedDetails = {};
    final Map<String, int> accountSessionDetails = {};
    final Map<String, int> locationDetails = {};

    for (final stats in allStats) {
      if (stats.startTime != null && stats.endTime != null) {
        totalPlayTime += stats.endTime!.difference(stats.startTime!);
      }

      if (stats.hasCrash) {
        totalCrashCount++;
        if (stats.endTime != null && stats.endTime!.year == targetYear) {
          yearlyCrashCount++;
        }
      }

      for (final session in stats.yearlySessions) {
        yearlyLaunchCount++;
        final sessionDuration = session.duration;
        yearlyPlayTime += sessionDuration;
        allSessionDurations.add(sessionDuration);

        if (yearlyFirstLaunchTime == null || session.startTime.isBefore(yearlyFirstLaunchTime)) {
          yearlyFirstLaunchTime = session.startTime;
        }

        if (session.startTime.hour >= 5) {
          if (earliestPlayDate == null || _timeOfDayIsEarlier(session.startTime, earliestPlayDate)) {
            earliestPlayDate = session.startTime;
          }
        }

        if (session.endTime.hour <= 4) {
          if (latestPlayDate == null || _timeOfDayIsLater(session.endTime, latestPlayDate)) {
            latestPlayDate = session.endTime;
          }
        }

        if (longestSession == null || sessionDuration > longestSession) {
          longestSession = sessionDuration;
          longestSessionDate = session.startTime;
        }

        if (sessionDuration.inMinutes >= 5) {
          if (shortestSession == null || sessionDuration < shortestSession) {
            shortestSession = sessionDuration;
            shortestSessionDate = session.startTime;
          }
        }
      }

      for (final entry in stats.vehicleDestruction.entries) {
        if (!entry.key.contains('PU_')) {
          vehicleDestructionDetails[entry.key] = (vehicleDestructionDetails[entry.key] ?? 0) + entry.value;
        }
      }

      for (final entry in stats.vehiclePiloted.entries) {
        vehiclePilotedDetails[entry.key] = (vehiclePilotedDetails[entry.key] ?? 0) + entry.value;
      }

      yearlyKillCount += stats.killCount;
      yearlyDeathCount += stats.deathCount;
      yearlySelfKillCount += stats.selfKillCount;

      for (final playerName in stats.playerNames) {
        if (playerName.length > 16) continue;
        String targetKey = playerName;
        for (final key in accountSessionDetails.keys) {
          if (key.toLowerCase() == playerName.toLowerCase()) {
            targetKey = key;
            break;
          }
        }
        accountSessionDetails[targetKey] = (accountSessionDetails[targetKey] ?? 0) + 1;
      }

      for (final entry in stats.locationVisits.entries) {
        locationDetails[entry.key] = (locationDetails[entry.key] ?? 0) + entry.value;
      }
    }

    Duration? averageSessionTime;
    if (allSessionDurations.isNotEmpty) {
      final totalMs = allSessionDurations.fold<int>(0, (sum, d) => sum + d.inMilliseconds);
      averageSessionTime = Duration(milliseconds: totalMs ~/ allSessionDurations.length);
    }

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

    final sortedLocations = locationDetails.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final topLocations = sortedLocations.take(10).toList();

    final Map<int, int> monthlyPlayCount = {};
    final Set<DateTime> playDates = {};

    for (final stats in allStats) {
      for (final session in stats.yearlySessions) {
        final month = session.startTime.month;
        monthlyPlayCount[month] = (monthlyPlayCount[month] ?? 0) + 1;
        playDates.add(DateTime(session.startTime.year, session.startTime.month, session.startTime.day));
      }
    }

    int? mostPlayedMonth;
    int mostPlayedMonthCount = 0;
    int? leastPlayedMonth;
    int leastPlayedMonthCount = 0;

    if (monthlyPlayCount.isNotEmpty) {
      for (final entry in monthlyPlayCount.entries) {
        if (entry.value > mostPlayedMonthCount) {
          mostPlayedMonth = entry.key;
          mostPlayedMonthCount = entry.value;
        }
      }
      leastPlayedMonthCount = monthlyPlayCount.values.first;
      for (final entry in monthlyPlayCount.entries) {
        if (entry.value <= leastPlayedMonthCount) {
          leastPlayedMonth = entry.key;
          leastPlayedMonthCount = entry.value;
        }
      }
    }

    int longestPlayStreak = 0;
    DateTime? playStreakStartDate;
    DateTime? playStreakEndDate;
    int longestOfflineStreak = 0;
    DateTime? offlineStreakStartDate;
    DateTime? offlineStreakEndDate;

    if (playDates.isNotEmpty) {
      final sortedDates = playDates.toList()..sort();

      int currentStreak = 1;
      DateTime streakStart = sortedDates.first;

      for (int i = 1; i < sortedDates.length; i++) {
        final diff = sortedDates[i].difference(sortedDates[i - 1]).inDays;
        if (diff == 1) {
          currentStreak++;
        } else {
          if (currentStreak > longestPlayStreak) {
            longestPlayStreak = currentStreak;
            playStreakStartDate = streakStart;
            playStreakEndDate = sortedDates[i - 1];
          }
          currentStreak = 1;
          streakStart = sortedDates[i];
        }
      }
      if (currentStreak > longestPlayStreak) {
        longestPlayStreak = currentStreak;
        playStreakStartDate = streakStart;
        playStreakEndDate = sortedDates.last;
      }

      for (int i = 1; i < sortedDates.length; i++) {
        final gapDays = sortedDates[i].difference(sortedDates[i - 1]).inDays - 1;
        if (gapDays > longestOfflineStreak) {
          longestOfflineStreak = gapDays;
          offlineStreakStartDate = sortedDates[i - 1].add(const Duration(days: 1));
          offlineStreakEndDate = sortedDates[i].subtract(const Duration(days: 1));
        }
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
      mostPlayedMonth: mostPlayedMonth,
      mostPlayedMonthCount: mostPlayedMonthCount,
      leastPlayedMonth: leastPlayedMonth,
      leastPlayedMonthCount: leastPlayedMonthCount,
      longestPlayStreak: longestPlayStreak,
      playStreakStartDate: playStreakStartDate,
      playStreakEndDate: playStreakEndDate,
      longestOfflineStreak: longestOfflineStreak,
      offlineStreakStartDate: offlineStreakStartDate,
      offlineStreakEndDate: offlineStreakEndDate,
      vehiclePilotedDetails: vehiclePilotedDetails,
      accountSessionDetails: accountSessionDetails,
      locationDetails: locationDetails,
    );
  }

  static bool _timeOfDayIsEarlier(DateTime a, DateTime b) {
    if (a.hour < b.hour) return true;
    if (a.hour > b.hour) return false;
    return a.minute < b.minute;
  }

  static bool _timeOfDayIsLater(DateTime a, DateTime b) {
    if (a.hour > b.hour) return true;
    if (a.hour < b.hour) return false;
    return a.minute > b.minute;
  }
}
