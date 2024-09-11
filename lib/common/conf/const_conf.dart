class ConstConf {
  static const String appVersion = "2.12.1";
  static const int appVersionCode = 55;
  static const String appVersionDate = "2024-6-28";
  static const gameChannels = ["LIVE", "PTU", "EPTU", "TECH-PREVIEW", "HOTFIX"];
  static const isMSE =
      String.fromEnvironment("MSE", defaultValue: "false") == "true";
}
