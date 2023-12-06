/// enable : true
/// versionName : "3.21.1(PU)_CNE_V2"
/// updateAt : "2023-12-03: 14:50:00"
/// info : "简体中文半汉化（物品名称英文版）"
/// game_channel : "PU"
/// note : ""

class ScLocalizationData {
  ScLocalizationData({
      this.enable, 
      this.versionName, 
      this.updateAt, 
      this.info, 
      this.gameChannel, 
      this.note,});

  ScLocalizationData.fromJson(dynamic json) {
    enable = json['enable'];
    versionName = json['versionName'];
    updateAt = json['updateAt'];
    info = json['info'];
    gameChannel = json['game_channel'];
    note = json['note'];
  }
  bool? enable;
  String? versionName;
  String? updateAt;
  String? info;
  String? gameChannel;
  String? note;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['enable'] = enable;
    map['versionName'] = versionName;
    map['updateAt'] = updateAt;
    map['info'] = info;
    map['game_channel'] = gameChannel;
    map['note'] = note;
    return map;
  }

}