/// lastVersion : "V2.9.9"
/// lastVersionCode : 25
/// minVersionCode : 15
/// MSE_lastVersion : "V2.9.13"
/// MSE_lastVersionCode : 27
/// MSE_minVersionCode : 27
/// p4kDownloadUrl : "https://p4k.42kit.com/Data.p4k"
/// activityColors : {"enable":true,"startTime":1700236800000,"endTime":1701360000000,"background":"#290859","menu":"#310666","mica":"#270452"}

class AppVersionData {
  AppVersionData({
    this.lastVersion,
    this.lastVersionCode,
    this.minVersionCode,
    this.mSELastVersion,
    this.mSELastVersionCode,
    this.mSEMinVersionCode,
    this.p4kDownloadUrl,
    this.activityColors,
  });

  AppVersionData.fromJson(dynamic json) {
    lastVersion = json['lastVersion'];
    lastVersionCode = json['lastVersionCode'];
    minVersionCode = json['minVersionCode'];
    mSELastVersion = json['MSE_lastVersion'];
    mSELastVersionCode = json['MSE_lastVersionCode'];
    mSEMinVersionCode = json['MSE_minVersionCode'];
    p4kDownloadUrl = json['p4kDownloadUrl'];
    activityColors = json['activityColors'] != null
        ? ActivityColors.fromJson(json['activityColors'])
        : null;
    gameChannels = List.from(json["game_channels"]).cast<String>();
    webMirrors = json["web_mirrors"];
  }

  String? lastVersion;
  num? lastVersionCode;
  num? minVersionCode;
  String? mSELastVersion;
  num? mSELastVersionCode;
  num? mSEMinVersionCode;
  String? p4kDownloadUrl;
  ActivityColors? activityColors;
  List<String>? gameChannels;
  Map? webMirrors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lastVersion'] = lastVersion;
    map['lastVersionCode'] = lastVersionCode;
    map['minVersionCode'] = minVersionCode;
    map['MSE_lastVersion'] = mSELastVersion;
    map['MSE_lastVersionCode'] = mSELastVersionCode;
    map['MSE_minVersionCode'] = mSEMinVersionCode;
    map['p4kDownloadUrl'] = p4kDownloadUrl;
    if (activityColors != null) {
      map['activityColors'] = activityColors?.toJson();
    }
    map["web_mirrors"] = webMirrors;
    map["game_channels"] = gameChannels;
    return map;
  }
}

/// enable : true
/// startTime : 1700236800000
/// endTime : 1701360000000
/// background : "#290859"
/// menu : "#310666"
/// mica : "#270452"

class ActivityColors {
  ActivityColors({
    this.enable,
    this.startTime,
    this.endTime,
    this.background,
    this.menu,
    this.mica,
  });

  ActivityColors.fromJson(dynamic json) {
    enable = json['enable'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    background = json['background'];
    menu = json['menu'];
    mica = json['mica'];
  }

  bool? enable;
  int? startTime;
  int? endTime;
  String? background;
  String? menu;
  String? mica;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['enable'] = enable;
    map['startTime'] = startTime;
    map['endTime'] = endTime;
    map['background'] = background;
    map['menu'] = menu;
    map['mica'] = mica;
    return map;
  }
}
