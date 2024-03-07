class ConstConf {
  static const String appVersion = "2.10.7 Beta";
  static const int appVersionCode = 42;
  static const String appVersionDate = "2024-03-01";
  static const gameChannels = ["LIVE", "PTU", "EPTU"];
  static const isMSE =
      String.fromEnvironment("MSE", defaultValue: "false") == "true";
}
