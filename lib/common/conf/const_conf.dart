class ConstConf {
  static const String appVersion = "2.12.2";
  static const int appVersionCode = 56;
  static const String appVersionDate = "2024-6-28";
  static const gameChannels = ["LIVE", "PTU", "EPTU", "TECH-PREVIEW", "HOTFIX"];
  static const isMSE =
      String.fromEnvironment("MSE", defaultValue: "false") == "true";
}
