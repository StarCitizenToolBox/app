class ConstConf {
  static const String appVersion = "2.13.3";
  static const int appVersionCode = 61;
  static const String appVersionDate = "2024-11-23";
  static const gameChannels = ["LIVE", "4.0_PREVIEW","PTU", "EPTU", "TECH-PREVIEW", "HOTFIX"];
  static const isMSE =
      String.fromEnvironment("MSE", defaultValue: "false") == "true";
  static const dohAddress = "https://223.6.6.6/resolve";
  static const inputMethodServerPort = 59399;
}
