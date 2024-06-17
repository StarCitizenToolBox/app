class ConstConf {
  static const String appVersion = "2.11.2 Beta";
  static const int appVersionCode = 52;
  static const String appVersionDate = "2024-6-17";
  static const gameChannels = ["LIVE", "PTU", "EPTU", "TECH-PREVIEW"];
  static const isMSE =
      String.fromEnvironment("MSE", defaultValue: "false") == "true";
}
