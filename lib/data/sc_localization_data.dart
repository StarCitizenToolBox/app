/// enable : false
/// versionName : "3.21.0(PU)_CN_V0"
/// updateAt : "2023-10-5: 10:15:00"
/// info : "简体中文汉化"
/// channel : "PTU"

class ScLocalizationData {
  ScLocalizationData({
      this.enable, 
      this.versionName, 
      this.updateAt, 
      this.info, 
      this.channel,});

  ScLocalizationData.fromJson(dynamic json) {
    enable = json['enable'];
    versionName = json['versionName'];
    updateAt = json['updateAt'];
    info = json['info'];
    channel = json['channel'];
  }
  bool? enable;
  String? versionName;
  String? updateAt;
  String? info;
  String? channel;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['enable'] = enable;
    map['versionName'] = versionName;
    map['updateAt'] = updateAt;
    map['info'] = info;
    map['channel'] = channel;
    return map;
  }

}