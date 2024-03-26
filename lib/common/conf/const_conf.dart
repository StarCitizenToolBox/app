class ConstConf {
  static const String appVersion = "2.10.9 Beta";
  static const int appVersionCode = 44;
  static const String appVersionDate = "2024-03-26";
  static const gameChannels = ["LIVE", "PTU", "EPTU"];
  static const isMSE =
      String.fromEnvironment("MSE", defaultValue: "false") == "true";
}
