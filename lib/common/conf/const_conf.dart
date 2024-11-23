class ConstConf {
  static const String appVersion = "2.13.2";
  static const int appVersionCode = 60;
  static const String appVersionDate = "2024-11-07";
  static const gameChannels = ["LIVE", "PTU", "EPTU", "TECH-PREVIEW", "HOTFIX"];
  static const isMSE =
      String.fromEnvironment("MSE", defaultValue: "false") == "true";
  static const dohAddress = "https://223.6.6.6/resolve";
  static const inputMethodServerPort = 59399;
}
