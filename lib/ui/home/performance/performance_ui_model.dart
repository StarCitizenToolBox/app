import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:starcitizen_doctor/api/analytics.dart';
import 'package:starcitizen_doctor/base/ui_model.dart';
import 'package:starcitizen_doctor/common/helper/log_helper.dart';
import 'package:starcitizen_doctor/data/game_performance_data.dart';

class PerformanceUIModel extends BaseUIModel {
  String scPath;

  PerformanceUIModel(this.scPath);

  TextEditingController customizeCtrl = TextEditingController();

  Map<String?, List<GamePerformanceData>>? performanceMap;

  List<String> inAppKeys = [];

  String workingString = "";

  late final confFile = File("$scPath\\USER.cfg");

  bool enabled = false;

  bool showGraphicsPerformanceTip = false;
  static const _graphicsPerformanceTipVersion = 1;

  @override
  Future loadData() async {
    customizeCtrl.clear();
    inAppKeys.clear();
    final String jsonString =
        await rootBundle.loadString('assets/performance.json');
    final list = json.decode(jsonString);

    if (list is List) {
      performanceMap = {};
      for (var element in list) {
        final item = GamePerformanceData.fromJson(element);
        if (item.key != "customize") {
          inAppKeys.add(item.key ?? "");
        }
        performanceMap?[item.group] ??= [];
        performanceMap?[item.group]?.add(item);
      }
    }

    if (await confFile.exists()) {
      await _readConf();
    } else {
      enabled = false;
    }

    final box = await Hive.openBox("app_conf");
    final v = box.get("close_graphics_performance_tip", defaultValue: -1);
    showGraphicsPerformanceTip = v != _graphicsPerformanceTipVersion;
    notifyListeners();
  }

  onChangePreProfile(String key) {
    switch (key) {
      case "low":
        performanceMap?.forEach((key, v) {
          if (key?.contains("图形") ?? false) {
            for (var element in v) {
              element.value = element.min;
            }
          }
        });
        break;
      case "medium":
        performanceMap?.forEach((key, v) {
          if (key?.contains("图形") ?? false) {
            for (var element in v) {
              element.value = ((element.max ?? 0) ~/ 2);
            }
          }
        });
        break;
      case "high":
        performanceMap?.forEach((key, v) {
          if (key?.contains("图形") ?? false) {
            for (var element in v) {
              element.value = ((element.max ?? 0) / 1.5).ceil();
            }
          }
        });
        break;
      case "ultra":
        performanceMap?.forEach((key, v) {
          if (key?.contains("图形") ?? false) {
            for (var element in v) {
              element.value = element.max;
            }
          }
        });
        break;
    }
    notifyListeners();
  }

  applyProfile(bool cleanShader) async {
    if (performanceMap == null) return;
    AnalyticsApi.touch("performance_apply");
    workingString = "生成配置文件";
    notifyListeners();
    String conf = "";
    for (var v in performanceMap!.entries) {
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
    workingString = "写出配置文件";
    notifyListeners();
    if (await confFile.exists()) {
      await confFile.delete();
    }
    await confFile.create();
    await confFile.writeAsString(conf);
    if (cleanShader) {
      workingString = "清理着色器";
      notifyListeners();
      await _cleanShaderCache();
    }
    workingString = "完成...";
    notifyListeners();
    await await Future.delayed(const Duration(milliseconds: 300));
    await reloadData();
    workingString = "";
    notifyListeners();
  }

  Future<void> _cleanShaderCache() async {
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
    showToast(context!, "清理着色器后首次进入游戏可能会出现卡顿，请耐心等待游戏初始化完毕。");
  }

  _readConf() async {
    if (performanceMap == null) return;
    enabled = true;
    final confString = await confFile.readAsString();
    for (var value in confString.split("\n")) {
      final kv = value.split("=");
      for (var m in performanceMap!.entries) {
        for (var value in m.value) {
          if (value.key == kv[0].trim()) {
            final v = int.tryParse(kv[1].trim());
            if (v != null) value.value = v;
          }
        }
      }
      if (kv.length == 2 && !inAppKeys.contains(kv[0].trim())) {
        customizeCtrl.text =
            "${customizeCtrl.text}${kv[0].trim()}=${kv[1].trim()}\n";
      }
    }
    notifyListeners();
  }

  clean() async {
    workingString = "删除配置文件...";
    notifyListeners();
    if (await confFile.exists()) {
      await confFile.delete(recursive: true);
    }
    workingString = "清理着色器";
    notifyListeners();
    await _cleanShaderCache();
    workingString = "完成...";
    await await Future.delayed(const Duration(milliseconds: 300));
    await reloadData();
    workingString = "";
    notifyListeners();
  }

  refresh() async {
    await reloadData();
  }

  closeTip() async {
    final box = await Hive.openBox("app_conf");
    await box.put(
        "close_graphics_performance_tip", _graphicsPerformanceTipVersion);
    loadData();
  }
}
