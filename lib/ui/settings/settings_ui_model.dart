import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:local_auth/local_auth.dart';
import 'package:starcitizen_doctor/base/ui_model.dart';
import 'package:starcitizen_doctor/common/conf.dart';
import 'package:starcitizen_doctor/common/win32/credentials.dart';

class SettingUIModel extends BaseUIModel {
  var isDeviceSupportWinHello = false;

  String autoLoginEmail = "-";
  bool isEnableAutoLogin = false;
  bool isEnableAutoLoginPwd = false;
  String inputGameLaunchECore = "0";

  String? customLauncherPath;
  String? customGamePath;

  @override
  loadData() async {
    final LocalAuthentication localAuth = LocalAuthentication();
    isDeviceSupportWinHello = await localAuth.isDeviceSupported();
    notifyListeners();
    if (AppConf.isMSE) {
      _updateAutoLoginAccount();
      _updateGameLaunchECore();
    }
    _loadCustomPath();
  }

  Future<void> onResetAutoLogin() async {
    final ok = await showConfirmDialogs(context!, "确认重置自动填充？",
        const Text("这将会删除本地的账号记录，或在下次启动游戏时将自动填充选择 ‘否’ 以禁用自动填充。"));
    if (ok) {
      final userBox = await Hive.openBox("rsi_account_data");
      await userBox.deleteFromDisk();
      Win32Credentials.delete("SCToolbox_RSI_Account_secret");
      showToast(context!, "已清理自动填充数据");
      reloadData();
    }
  }

  Future _updateAutoLoginAccount() async {
    final userBox = await Hive.openBox("rsi_account_data");
    autoLoginEmail = userBox.get("account_email", defaultValue: "-");
    isEnableAutoLogin = userBox.get("enable", defaultValue: true);
    isEnableAutoLoginPwd =
        userBox.get("account_pwd_encrypted", defaultValue: "") != "";
    notifyListeners();
  }

  Future<void> setGameLaunchECore() async {
    final userBox = await Hive.openBox("app_conf");
    final defaultInput =
        userBox.get("gameLaunch_eCore_count", defaultValue: "0");
    final input = await showInputDialogs(context!,
        title: "请输入要忽略的 CPU 核心数",
        content: "",
        initialValue: defaultInput,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly]);
    if (input == null) return;
    userBox.put("gameLaunch_eCore_count", input);
    reloadData();
  }

  Future _updateGameLaunchECore() async {
    final userBox = await Hive.openBox("app_conf");
    inputGameLaunchECore =
        userBox.get("gameLaunch_eCore_count", defaultValue: "0");
    notifyListeners();
  }

  Future<void> setLauncherPath() async {
    final r = await FilePicker.platform.pickFiles(
        dialogTitle: "请选择RSI启动器位置（RSI Launcher.exe）",
        type: FileType.custom,
        allowedExtensions: ["exe"]);
    if (r == null || r.files.firstOrNull?.path == null) return;
    final fileName = r.files.first.path!;
    if (fileName.endsWith("\\RSI Launcher.exe")) {
      await _saveCustomPath("custom_launcher_path", fileName);
      showToast(context!, "设置成功，在对应页面点击刷新即可扫描出新路径");
      reloadData();
    } else {
      showToast(context!, "路径有误！");
    }
  }

  Future<void> setGamePath() async {
    final r = await FilePicker.platform.pickFiles(
        dialogTitle: "请选择游戏安装位置（StarCitizen.exe）",
        type: FileType.custom,
        allowedExtensions: ["exe"]);
    if (r == null || r.files.firstOrNull?.path == null) return;
    final fileName = r.files.first.path!;
    dPrint(fileName);
    final fileNameRegExp =
        RegExp(r"^(.*\\StarCitizen\\.*\\)Bin64\\StarCitizen\.exe$");
    if (fileNameRegExp.hasMatch(fileName)) {
      RegExp pathRegex = RegExp(r"\\[^\\]+\\Bin64\\StarCitizen\.exe$");
      String extractedPath = fileName.replaceFirst(pathRegex, '');
      await _saveCustomPath("custom_game_path", extractedPath);
      showToast(context!, "设置成功，在对应页面点击刷新即可扫描出新路径");
      reloadData();
    } else {
      showToast(context!, "路径有误！");
    }
  }

  _saveCustomPath(String pathKey, String dir) async {
    final confBox = await Hive.openBox("app_conf");
    await confBox.put(pathKey, dir);
  }

  _loadCustomPath() async {
    final confBox = await Hive.openBox("app_conf");
    customLauncherPath = confBox.get("custom_launcher_path");
    customGamePath = confBox.get("custom_game_path");
  }

  Future<void> delName(String key) async {
    final confBox = await Hive.openBox("app_conf");
    await confBox.delete(key);
    reloadData();
  }
}
