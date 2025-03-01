class ConstConf {
  static const String appVersion = "2.13.5";
  static const int appVersionCode = 63;
  static const String appVersionDate = "2025-03-01";
  static const _gameChannels = [
    "LIVE",
    "4.0_PREVIEW",
    "PTU",
    "EPTU",
    "TECH-PREVIEW",
    "HOTFIX"
  ];
  static const isMSE =
      String.fromEnvironment("MSE", defaultValue: "false") == "true";
  static const dohAddress = "https://223.6.6.6/resolve";
  static const inputMethodServerPort = 59399;
}

class AppConf {
  static List<String>? _networkGameChannels;

  static setNetworkChannels(List<String>? channels) {
    _networkGameChannels = channels;
  }

  static List<String> get gameChannels =>
      _networkGameChannels ?? ConstConf._gameChannels;
}
