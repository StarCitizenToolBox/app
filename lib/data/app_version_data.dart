/// lastVersion : "V2.5"
/// lastVersionCode : 8
/// lastBetaVersion : "V2.5"
/// lastBetaVersionCode : 8
/// minVersionCode : 7
/// minBetaVersionCode : 7

class AppVersionData {
  AppVersionData({
      this.lastVersion, 
      this.lastVersionCode, 
      this.lastBetaVersion, 
      this.lastBetaVersionCode, 
      this.minVersionCode, 
      this.minBetaVersionCode,});

  AppVersionData.fromJson(dynamic json) {
    lastVersion = json['lastVersion'];
    lastVersionCode = json['lastVersionCode'];
    lastBetaVersion = json['lastBetaVersion'];
    lastBetaVersionCode = json['lastBetaVersionCode'];
    minVersionCode = json['minVersionCode'];
    minBetaVersionCode = json['minBetaVersionCode'];
  }
  String? lastVersion;
  num? lastVersionCode;
  String? lastBetaVersion;
  num? lastBetaVersionCode;
  num? minVersionCode;
  num? minBetaVersionCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lastVersion'] = lastVersion;
    map['lastVersionCode'] = lastVersionCode;
    map['lastBetaVersion'] = lastBetaVersion;
    map['lastBetaVersionCode'] = lastBetaVersionCode;
    map['minVersionCode'] = minVersionCode;
    map['minBetaVersionCode'] = minBetaVersionCode;
    return map;
  }

}