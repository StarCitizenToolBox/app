import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:starcitizen_doctor/common/helper/game_log_analyzer.dart';
import 'package:starcitizen_doctor/common/rust/api/win32_api.dart' as win32;
import 'package:starcitizen_doctor/common/utils/log.dart';

part 'game_log_tracker_provider.freezed.dart';

part 'game_log_tracker_provider.g.dart';

@freezed
sealed class PartyRoomGameLogTrackerProviderState with _$PartyRoomGameLogTrackerProviderState {
  const factory PartyRoomGameLogTrackerProviderState({
    @Default('') String location,
    @Default(0) int kills,
    @Default(0) int deaths,
    DateTime? gameStartTime,
    List<(String, String)>? deathEvents,
  }) = _PartyRoomGameLogTrackerProviderState;
}

@riverpod
class PartyRoomGameLogTrackerProvider extends _$PartyRoomGameLogTrackerProvider {
  var _disposed = false;

  // 记录上次查询的时间点，用于计算增量
  DateTime? _lastQueryTime;

  @override
  PartyRoomGameLogTrackerProviderState build({required DateTime startTime}) {
    startTime = DateTime.now();
    dPrint("[PartyRoomGameLogTrackerProvider] init $startTime");
    ref.onDispose(() {
      _disposed = true;
      dPrint("[PartyRoomGameLogTrackerProvider] disposed $startTime");
    });
    _lastQueryTime = startTime;
    _listenToGameLogs(startTime);
    return const PartyRoomGameLogTrackerProviderState();
  }

  Future<void> _listenToGameLogs(DateTime startTime) async {
    await Future.delayed(const Duration(seconds: 1));
    while (!_disposed) {
      try {
        // 获取正在运行的游戏进程
        final l = await win32.getProcessListByName(processName: "StarCitizen.exe");
        final p = l
            .where((e) => e.path.toLowerCase().contains("starcitizen") && e.path.toLowerCase().contains("bin64"))
            .firstOrNull;

        if (p == null) throw Exception("process not found");

        final logPath = _getLogPath(p);
        final logFile = File(logPath);

        if (await logFile.exists()) {
          // 分析日志文件
          await _analyzeLog(logFile, startTime);
        } else {
          state = state.copyWith(location: '<Unknown>', gameStartTime: null);
        }
      } catch (e) {
        // 游戏未启动或发生错误
        state = state.copyWith(location: '<游戏未启动>', gameStartTime: null, kills: 0, deaths: 0);
      }
      await Future.delayed(const Duration(seconds: 10));
    }
  }

  Future<void> _analyzeLog(File logFile, DateTime startTime) async {
    try {
      final now = DateTime.now();

      // 使用 GameLogAnalyzer 分析日志
      // startTime 只影响计数统计
      final result = await GameLogAnalyzer.analyzeLogFile(logFile, startTime: startTime);
      final (logData, statistics) = result;

      // 从统计数据中直接获取最新位置（全量查找的结果）
      final location = statistics.latestLocation == null ? '<主菜单>' : '[${statistics.latestLocation}]';

      List<(String, String)> deathEvents = [];

      if (_lastQueryTime != null) {
        // 遍历所有 actor_death 事件
        for (final data in logData) {
          if (data.type != "actor_death") continue;

          // 解析事件时间
          if (data.dateTime != null) {
            try {
              // 日志时间格式: "yyyy-MM-dd HH:mm:ss:SSS"
              // 转换为 ISO 8601 格式再解析
              final parts = data.dateTime!.split(' ');
              if (parts.length >= 2) {
                final datePart = parts[0]; // yyyy-MM-dd
                final timeParts = parts[1].split(':');
                if (timeParts.length >= 3) {
                  final hour = timeParts[0];
                  final minute = timeParts[1];
                  final secondMillis = timeParts[2]; // ss:SSS 或 ss.SSS
                  final timeStr = '$datePart $hour:$minute:${secondMillis.replaceAll(':', '.')}';
                  final eventTime = DateTime.parse(timeStr);

                  // 只处理在 _lastQueryTime 之后的事件
                  if (eventTime.isBefore(_lastQueryTime!)) continue;
                }
              }
            } catch (e) {
              dPrint("[PartyRoomGameLogTrackerProvider] Failed to parse dateTime: ${data.dateTime}, error: $e");
              // 时间解析失败，继续处理该事件（保守策略）
            }
          }

          if (data.playerName == data.victimId) {
            // 玩家死亡，增加记录
            deathEvents.add((data.location ?? "-", data.area ?? "-"));
          }
        }
      }
      // debugPrint(
      //   "[PartyRoomGameLogTrackerProvider] location $location killCount ${statistics.killCount} deathCount ${statistics.deathCount}",
      // );
      // 更新状态，只存储本次迭代的增量数据
      state = state.copyWith(
        location: location,
        kills: statistics.killCount,
        // 从 startTime 开始的总计数
        deaths: statistics.deathCount,
        // 从 startTime 开始的总计数
        gameStartTime: statistics.gameStartTime,
        deathEvents: deathEvents,
      );

      // 更新查询时间为本次查询的时刻
      _lastQueryTime = now;
    } catch (e, stackTrace) {
      dPrint("[PartyRoomGameLogTrackerProvider] Error analyzing log: $e");
      dPrint("[PartyRoomGameLogTrackerProvider] Stack trace: $stackTrace");
    }
  }

  String _getLogPath(win32.ProcessInfo p) {
    var path = p.path;
    return path.replaceAll(r"Bin64\StarCitizen.exe", "Game.log");
  }
}
