class ConstConf {
  static const String appVersion = "2.15.0";
  static const int appVersionCode = 70;
  static const String appVersionDate = "2025-11-8";
  static const _gameChannels = [
    "LIVE",
    "4.0_PREVIEW",
    "PTU",
    "EPTU",
    "TECH-PREVIEW",
    "HOTFIX",
  ];
  static const isMSE = String.fromEnvironment("MSE", defaultValue: "false") == "true";
  static const win32AppId = isMSE
      ? "56575xkeyC.MSE_bsn1nexg8e4qe!starcitizendoctor"
      : "{6D809377-6AF0-444B-8957-A3773F02200E}\\Starcitizen_Doctor\\starcitizen_doctor.exe";
  static const dohAddress = "https://223.6.6.6/resolve";
  static const inputMethodServerPort = 59399;
}

class AppConf {
  static List<String>? _networkGameChannels;

  static void setNetworkChannels(List<String>? channels) {
    _networkGameChannels = channels;
  }

  static List<String> get gameChannels => _networkGameChannels ?? ConstConf._gameChannels;
}
