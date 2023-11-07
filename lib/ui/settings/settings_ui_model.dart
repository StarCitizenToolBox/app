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

  @override
  loadData() async {
    final LocalAuthentication localAuth = LocalAuthentication();
    isDeviceSupportWinHello = await localAuth.isDeviceSupported();
    notifyListeners();
    if (AppConf.isMSE) {
      _updateAutoLoginAccount();
    }
  }

  Future<void> onResetAutoLogin() async {
    final userBox = await Hive.openBox("rsi_account_data");
    await userBox.deleteFromDisk();
    Win32Credentials.delete("SCToolbox_RSI_Account_secret");
    showToast(context!, "已清理自动填充数据");
    reloadData();
  }

  Future _updateAutoLoginAccount() async {
    final userBox = await Hive.openBox("rsi_account_data");
    autoLoginEmail = userBox.get("account_email", defaultValue: "-");
    isEnableAutoLogin = userBox.get("enable", defaultValue: true);
    isEnableAutoLoginPwd =
        userBox.get("account_pwd_encrypted", defaultValue: "") != "";
    notifyListeners();
  }
}
