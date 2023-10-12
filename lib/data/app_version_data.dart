/// lastVersion : "V2.9"
/// lastVersionCode : 13
/// lastBetaVersion : "V2.9"
/// lastBetaVersionCode : 13
/// minVersionCode : 13
/// minBetaVersionCode : 13
/// p4kDownloadUrl : "https://p4k.42kit.com/Data.p4k"

class AppVersionData {
  AppVersionData({
      this.lastVersion, 
      this.lastVersionCode, 
      this.lastBetaVersion, 
      this.lastBetaVersionCode, 
      this.minVersionCode, 
      this.minBetaVersionCode, 
      this.p4kDownloadUrl,});

  AppVersionData.fromJson(dynamic json) {
    lastVersion = json['lastVersion'];
    lastVersionCode = json['lastVersionCode'];
    lastBetaVersion = json['lastBetaVersion'];
    lastBetaVersionCode = json['lastBetaVersionCode'];
    minVersionCode = json['minVersionCode'];
    minBetaVersionCode = json['minBetaVersionCode'];
    p4kDownloadUrl = json['p4kDownloadUrl'];
  }
  String? lastVersion;
  num? lastVersionCode;
  String? lastBetaVersion;
  num? lastBetaVersionCode;
  num? minVersionCode;
  num? minBetaVersionCode;
  String? p4kDownloadUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lastVersion'] = lastVersion;
    map['lastVersionCode'] = lastVersionCode;
    map['lastBetaVersion'] = lastBetaVersion;
    map['lastBetaVersionCode'] = lastBetaVersionCode;
    map['minVersionCode'] = minVersionCode;
    map['minBetaVersionCode'] = minBetaVersionCode;
    map['p4kDownloadUrl'] = p4kDownloadUrl;
    return map;
  }

}