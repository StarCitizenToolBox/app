class ConstConf {
  static const String appVersion = "2.10.10 Beta";
  static const int appVersionCode = 45;
  static const String appVersionDate = "2024-03-30";
  static const gameChannels = ["LIVE", "PTU", "EPTU", "TECH-PREVIEW"];
  static const isMSE =
      String.fromEnvironment("MSE", defaultValue: "false") == "true";
}
