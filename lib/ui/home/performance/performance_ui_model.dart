// ignore_for_file: avoid_build_context_in_providers, avoid_public_notifier_properties
import 'dart:convert';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/api/analytics.dart';
import 'package:starcitizen_doctor/common/helper/log_helper.dart';
import 'package:starcitizen_doctor/common/utils/base_utils.dart';
import 'package:starcitizen_doctor/data/game_performance_data.dart';
import 'package:starcitizen_doctor/ui/home/home_ui_model.dart';

part 'performance_ui_model.freezed.dart';

part 'performance_ui_model.g.dart';

@freezed
class HomePerformanceUIState with _$HomePerformanceUIState {
  const factory HomePerformanceUIState({
    @Default(true) bool showGraphicsPerformanceTip,
    @Default(false) bool enabled,
    Map<String, List<GamePerformanceData>>? performanceMap,
    @Default("") String workingString,
  }) = _HomePerformanceUIState;
}

@riverpod
class HomePerformanceUIModel extends _$HomePerformanceUIModel {
  String get scPath => ref.read(homeUIModelProvider).scInstalledPath!;

  final customizeCtrl = TextEditingController(text: "");

  final List<String> _inAppKeys = [];

  late final confFile = File("$scPath\\USER.cfg");

  static const _graphicsPerformanceTipVersion = 1;

  @override
  HomePerformanceUIState build() {
    state = const HomePerformanceUIState();
    _init();
    return state;
  }

  Future<void> _init() async {
    customizeCtrl.clear();
    _inAppKeys.clear();
    final String jsonString =
        await rootBundle.loadString('assets/performance.json');
    final list = json.decode(jsonString);

    if (list is List) {
      final performanceMap = <String, List<GamePerformanceData>>{};
      for (var element in list) {
        final item = GamePerformanceData.fromJson(element);
        if (item.key != "customize") {
          _inAppKeys.add(item.key ?? "");
        }
        performanceMap[item.group!] ??= [];
        performanceMap[item.group]?.add(item);
      }
      state = state.copyWith(performanceMap: performanceMap);
    }

    if (await confFile.exists()) {
      await _readConf();
    } else {
      state = state.copyWith(enabled: false);
    }

    final box = await Hive.openBox("app_conf");
    final v = box.get("close_graphics_performance_tip", defaultValue: -1);
    state = state.copyWith(
        showGraphicsPerformanceTip: v != _graphicsPerformanceTipVersion);
  }

  _readConf() async {
    if (state.performanceMap == null) return;
    state = state.copyWith(enabled: true);

    final confString = await confFile.readAsString();
    for (var value in confString.split("\n")) {
      final kv = value.split("=");
      for (var m in state.performanceMap!.entries) {
        for (var value in m.value) {
          if (value.key == kv[0].trim()) {
            final v = int.tryParse(kv[1].trim());
            if (v != null) value.value = v;
          }
        }
      }
      if (kv.length == 2 && !_inAppKeys.contains(kv[0].trim())) {
        customizeCtrl.text =
            "${customizeCtrl.text}${kv[0].trim()}=${kv[1].trim()}\n";
      }
    }
  }

  closeTip() async {
    final box = await Hive.openBox("app_conf");
    await box.put(
        "close_graphics_performance_tip", _graphicsPerformanceTipVersion);
    _init();
  }

  onChangePreProfile(String key) {
    switch (key) {
      case "low":
        state.performanceMap?.forEach((key, v) {
          if (key.contains("图形")) {
            for (var element in v) {
              element.value = element.min;
            }
          }
        });
        break;
      case "medium":
        state.performanceMap?.forEach((key, v) {
          if (key.contains("图形")) {
            for (var element in v) {
              element.value = ((element.max ?? 0) ~/ 2);
            }
          }
        });
        break;
      case "high":
        state.performanceMap?.forEach((key, v) {
          if (key.contains("图形")) {
            for (var element in v) {
              element.value = ((element.max ?? 0) / 1.5).ceil();
            }
          }
        });
        break;
      case "ultra":
        state.performanceMap?.forEach((key, v) {
          if (key.contains("图形")) {
            for (var element in v) {
              element.value = element.max;
            }
          }
        });
        break;
    }
    state = state.copyWith();
  }

  refresh() async {
    _init();
  }

  clean(BuildContext context) async {
    state = state.copyWith(workingString: "删除配置文件...");
    if (await confFile.exists()) {
      await confFile.delete(recursive: true);
    }
    state = state.copyWith(workingString: "清理着色器");
    if (!context.mounted) return;
    await cleanShaderCache(context);
    state = state.copyWith(workingString: "完成...");
    await await Future.delayed(const Duration(milliseconds: 300));
    await _init();
    state = state.copyWith(workingString: "");
  }

  cleanShaderCache(BuildContext? context) async {
    final gameShaderCachePath = await SCLoggerHelper.getShaderCachePath();
    final l =
        await Directory(gameShaderCachePath!).list(recursive: false).toList();
    for (var value in l) {
      if (value is Directory) {
        if (!value.absolute.path.contains("Crashes")) {
          await value.delete(recursive: true);
        }
      }
    }
    await Future.delayed(const Duration(milliseconds: 300));
    if (context != null && context.mounted) {
      showToast(context, "清理着色器后首次进入游戏可能会出现卡顿，请耐心等待游戏初始化完毕。");
    }
  }

  applyProfile(bool cleanShader) async {
    if (state.performanceMap == null) return;
    AnalyticsApi.touch("performance_apply");
    state = state.copyWith(workingString: "生成配置文件");
    String conf = "";
    for (var v in state.performanceMap!.entries) {
      for (var c in v.value) {
        if (c.key != "customize") {
          conf = "$conf${c.key}=${c.value}\n";
        }
      }
    }
    if (customizeCtrl.text.trim().isNotEmpty) {
      final lines = customizeCtrl.text.split("\n");
      for (var value in lines) {
        final sp = value.split("=");
        // 忽略无效的配置文件
        if (sp.length == 2) {
          conf = "$conf${sp[0].trim()}=${sp[1].trim()}\n";
        }
      }
    }
    state = state.copyWith(workingString: "写出配置文件");
    if (await confFile.exists()) {
      await confFile.delete();
    }
    await confFile.create();
    await confFile.writeAsString(conf);
    if (cleanShader) {
      state = state.copyWith(workingString: "清理着色器");
      await cleanShaderCache(null);
    }
    state = state.copyWith(workingString: "完成...");
    await await Future.delayed(const Duration(milliseconds: 300));
    await _init();
    state = state.copyWith(workingString: "清理着色器");
  }

  updateState() {
    state = state.copyWith();
  }
}
