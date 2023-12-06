import 'dart:async';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:starcitizen_doctor/api/analytics.dart';
import 'package:starcitizen_doctor/api/api.dart';
import 'package:starcitizen_doctor/base/ui_model.dart';
import 'package:starcitizen_doctor/common/conf.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';
import 'package:starcitizen_doctor/data/sc_localization_data.dart';

class LocalizationUIModel extends BaseUIModel {
  final String scInstallPath;

  static const languageSupport = {
    "chinese_(simplified)": "简体中文",
    "chinese_(traditional)": "繁體中文",
  };

  late String selectedLanguage;

  Map<String, ScLocalizationData>? apiLocalizationData;

  LocalizationUIModel(this.scInstallPath);

  String workingVersion = "";

  final downloadDir =
      Directory("${AppConf.applicationSupportDir}\\Localizations");

  late final customizeDir =
      Directory("${downloadDir.absolute.path}\\Customize_ini");

  late final scDataDir = Directory("$scInstallPath\\data");

  late final cfgFile = File("${scDataDir.absolute.path}\\system.cfg");

  MapEntry<bool, String>? patchStatus;

  List<String>? customizeList;

  StreamSubscription? customizeDirListenSub;

  bool enableCustomize = false;

  @override
  void initModel() {
    selectedLanguage = languageSupport.entries.first.key;
    if (!customizeDir.existsSync()) {
      customizeDir.createSync(recursive: true);
    }
    customizeDirListenSub = customizeDir.watch().listen((event) {
      _scanCustomizeDir();
    });
    super.initModel();
  }

  @override
  Future loadData() async {
    await _updateStatus();
    _checkUserCfg();
    _scanCustomizeDir();
    final l =
        await handleError(() => Api.getScLocalizationData(selectedLanguage));
    if (l != null) {
      apiLocalizationData = {};
      for (var element in l) {
        final isPTU = !scInstallPath.contains("LIVE");
        if (isPTU && element.gameChannel == "PTU") {
          apiLocalizationData![element.versionName ?? ""] = element;
        } else if (!isPTU && element.gameChannel == "PU") {
          apiLocalizationData![element.versionName ?? ""] = element;
        }
      }
    }
    notifyListeners();
  }

  @override
  dispose() {
    customizeDirListenSub?.cancel();
    super.dispose();
  }

  _scanCustomizeDir() {
    final fileList = customizeDir.listSync();
    customizeList = [];
    for (var value in fileList) {
      if (value is File && value.path.endsWith(".ini")) {
        customizeList?.add(value.absolute.path);
      }
    }
    notifyListeners();
  }

  String getCustomizeFileName(String path) {
    return path.split("\\").last;
  }

  _updateStatus() async {
    patchStatus = MapEntry(
        await getLangCfgEnableLang(lang: selectedLanguage),
        await getInstalledIniVersion(
            "${scDataDir.absolute.path}\\Localization\\$selectedLanguage\\global.ini"));
    notifyListeners();
  }

  VoidCallback? onBack() {
    if (workingVersion.isNotEmpty) return null;
    return () {
      Navigator.pop(context!);
    };
  }

  void selectLang(String v) {
    selectedLanguage = v;
    apiLocalizationData = null;
    notifyListeners();
    reloadData();
  }

  VoidCallback? doRefresh() {
    if (workingVersion.isNotEmpty) return null;
    return () {
      apiLocalizationData = null;
      notifyListeners();
      reloadData();
    };
  }

  VoidCallback? doRemoteInstall(ScLocalizationData value) {
    return () async {
      AnalyticsApi.touch("install_localization");
      final downloadUrl =
          "${AppConf.gitlabLocalizationUrl}/archive/${value.versionName}.tar.gz";
      final savePath =
          File("${downloadDir.absolute.path}\\${value.versionName}.sclang");
      try {
        workingVersion = value.versionName!;
        notifyListeners();
        if (!await savePath.exists()) {
          // download
          dPrint("downloading file to $savePath");
          await Dio().download(downloadUrl, savePath.absolute.path);
        } else {
          dPrint("use cache $savePath");
        }
        await Future.delayed(const Duration(milliseconds: 300));
        // check file
        final globalIni = await compute(_readArchive, savePath.absolute.path);
        if (globalIni.isEmpty) {
          throw "文件受损，请重新下载";
        }
        await _installFormString(globalIni, value.versionName ?? "");
      } catch (e) {
        await showToast(context!, "安装出错！\n\n $e");
        if (await savePath.exists()) await savePath.delete();
      }
      workingVersion = "";
      notifyListeners();
    };
  }

  Future<bool> getLangCfgEnableLang({String lang = ""}) async {
    if (!await cfgFile.exists()) return false;
    final str = (await cfgFile.readAsString()).replaceAll(" ", "");
    return str.contains("sys_languages=$lang") &&
        str.contains("g_language=$lang") &&
        str.contains("g_languageAudio=english");
  }

  static Future<String> getInstalledIniVersion(String iniPath) async {
    final iniFile = File(iniPath);
    if (!await iniFile.exists()) return "游戏内置";
    final iniStringSplit = (await iniFile.readAsString()).split("\n");
    for (var i = iniStringSplit.length - 1; i > 0; i--) {
      if (iniStringSplit[i]
          .contains("_starcitizen_doctor_localization_version=")) {
        final v = iniStringSplit[i]
            .trim()
            .split("_starcitizen_doctor_localization_version=")[1];
        return v;
      }
    }
    return "自定义文件";
  }

  _installFormString(StringBuffer globalIni, String versionName) async {
    final iniFile = File(
        "${scDataDir.absolute.path}\\Localization\\$selectedLanguage\\global.ini");
    if (versionName.isNotEmpty) {
      if (!globalIni.toString().endsWith("\n")) {
        globalIni.write("\n");
      }
      globalIni.write("_starcitizen_doctor_localization_version=$versionName");
    }

    /// write cfg
    if (await cfgFile.exists()) {}

    /// write ini
    if (await iniFile.exists()) {
      await iniFile.delete();
    }
    await iniFile.create(recursive: true);
    await iniFile.writeAsString("\uFEFF${globalIni.toString().trim()}",
        flush: true);
    await updateLangCfg(true);
    await _updateStatus();
  }

  openDir() async {
    showToast(context!,
        "即将打开本地化文件夹，请将自定义的 任意名称.ini 文件放入 Customize_ini 文件夹。\n\n添加新文件后未显示请使用右上角刷新按钮。\n\n安装时请确保选择了正确的语言。");
    await Process.run(SystemHelper.powershellPath,
        ["explorer.exe", "/select,\"${customizeDir.absolute.path}\"\\"]);
  }

  updateLangCfg(bool enable) async {
    final status = await getLangCfgEnableLang(lang: selectedLanguage);
    final exists = await cfgFile.exists();
    if (status == enable) {
      await _updateStatus();
      return;
    }
    StringBuffer newStr = StringBuffer();
    var str = <String>[];
    if (exists) {
      str = (await cfgFile.readAsString()).replaceAll(" ", "").split("\n");
    }
    if (enable) {
      if (exists) {
        for (var value in str) {
          if (value.contains("sys_languages")) {
            value = "sys_languages=$selectedLanguage";
          } else if (value.contains("g_language")) {
            value = "g_language=$selectedLanguage";
          } else if (value.contains("g_languageAudio")) {
            value = "g_language=english";
          }
          if (value.trim().isNotEmpty) newStr.writeln(value);
        }
      }
      if (!newStr.toString().contains("sys_languages=$selectedLanguage")) {
        newStr.writeln("sys_languages=$selectedLanguage");
      }
      if (!newStr.toString().contains("g_language=$selectedLanguage")) {
        newStr.writeln("g_language=$selectedLanguage");
      }
      if (!newStr.toString().contains("g_languageAudio")) {
        newStr.writeln("g_languageAudio=english");
      }
    } else {
      if (exists) {
        for (var value in str) {
          if (value.contains("sys_languages=")) {
            continue;
          } else if (value.contains("g_language")) {
            continue;
          }
          newStr.writeln(value);
        }
      }
    }
    if (exists) await cfgFile.delete(recursive: true);
    await cfgFile.create(recursive: true);
    await cfgFile.writeAsString(newStr.toString());
    await _updateStatus();
    notifyListeners();
  }

  VoidCallback? doDelIniFile() {
    final iniFile = File(
        "${scDataDir.absolute.path}\\Localization\\$selectedLanguage\\global.ini");
    return () async {
      if (await iniFile.exists()) await iniFile.delete();
      await updateLangCfg(false);
      await _updateStatus();
    };
  }

  /// read locale active
  static StringBuffer _readArchive(String savePath) {
    final inputStream = InputFileStream(savePath);
    final archive =
        TarDecoder().decodeBytes(GZipDecoder().decodeBuffer(inputStream));
    StringBuffer globalIni = StringBuffer("");
    for (var element in archive.files) {
      if (element.name.contains("global.ini")) {
        for (var value
            in (element.rawContent?.readString() ?? "").split("\n")) {
          final tv = value.trim();
          if (tv.isNotEmpty) globalIni.writeln(tv);
        }
      }
    }
    archive.clear();
    return globalIni;
  }

  VoidCallback? doLocalInstall(String filePath) {
    if (workingVersion.isNotEmpty) return null;
    return () async {
      final f = File(filePath);
      if (!await f.exists()) return;
      workingVersion = filePath;
      notifyListeners();
      final str = await f.readAsString();
      await _installFormString(
          StringBuffer(str), "自定义_${getCustomizeFileName(filePath)}");
      workingVersion = "";
      notifyListeners();
    };
  }

  void _checkUserCfg() async {
    final userCfgFile = File("$scInstallPath\\USER.cfg");
    if (await userCfgFile.exists()) {
      final cfgString = await userCfgFile.readAsString();
      if (cfgString.contains("g_language") &&
          !cfgString.contains("g_language=$selectedLanguage")) {
        final ok = await showConfirmDialogs(
            context!,
            "是否移除不兼容的汉化参数",
            const Text(
                "USER.cfg 包含不兼容的汉化参数，这可能是以前的汉化文件的残留信息。\n\n这将可能导致汉化无效或乱码，点击确认为您一键移除（不会影响其他配置）。"),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context!).size.width * .35));
        if (ok == true) {
          var finalString = "";
          for (var item in cfgString.split("\n")) {
            if (!item.trim().startsWith("g_language")) {
              finalString = "$finalString$item\n";
            }
          }
          await userCfgFile.delete();
          await userCfgFile.create();
          await userCfgFile.writeAsString(finalString, flush: true);
          reloadData();
        }
      }
    }
  }

  static Future<MapEntry<String, bool>?> checkLocalizationUpdates(
      List<String> gameInstallPaths) async {
    final updateInfo = <String, bool>{};
    for (var kv in languageSupport.entries) {
      final l = await Api.getScLocalizationData(kv.key);
      for (var value in gameInstallPaths) {
        final iniPath = "$value\\data\\Localization\\${kv.key}\\global.ini";
        if (!await File(iniPath).exists()) {
          continue;
        }
        final installed = await getInstalledIniVersion(iniPath);
        if (installed == "游戏内置" || installed == "自定义文件") {
          continue;
        }
        final hasUpdate = l
                .where((element) => element.versionName == installed)
                .firstOrNull ==
            null;
        updateInfo[value] = hasUpdate;
      }
    }
    dPrint("checkLocalizationUpdates ==== $updateInfo");
    for (var v in updateInfo.entries) {
      if (v.value) {
        for (var element in AppConf.gameChannels) {
          if (v.key.contains("StarCitizen\\$element")) {
            return MapEntry(element, true);
          }else {
            return const MapEntry("", true);
          }
        }
      }
    }
    return null;
  }
}
