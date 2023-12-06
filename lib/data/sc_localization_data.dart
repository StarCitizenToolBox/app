/// enable : true
/// versionName : "3.21.1(PU)_CN_V2"
/// updateAt : "2023-12-03: 14:50:00"
/// info : "简体中文汉化（首选）"
/// game_channel : "PU"
/// note : "·因游戏暂不支持3D字体汉化，F键交互将依旧为英文。\n·角色抬头显示器(HUD)的中文字体不显示。\n·某些元素字体过小。\n·搜索栏无法输入中文。\n·部位文本未翻译（在翻了，在翻了！）"
/// upgrade_channel : "CN"

class ScLocalizationData {
  ScLocalizationData({
      this.enable, 
      this.versionName, 
      this.updateAt, 
      this.info, 
      this.gameChannel, 
      this.note, 
      this.upgradeChannel,});

  ScLocalizationData.fromJson(dynamic json) {
    enable = json['enable'];
    versionName = json['versionName'];
    updateAt = json['updateAt'];
    info = json['info'];
    gameChannel = json['game_channel'];
    note = json['note'];
    upgradeChannel = json['upgrade_channel'];
  }
  bool? enable;
  String? versionName;
  String? updateAt;
  String? info;
  String? gameChannel;
  String? note;
  String? upgradeChannel;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['enable'] = enable;
    map['versionName'] = versionName;
    map['updateAt'] = updateAt;
    map['info'] = info;
    map['game_channel'] = gameChannel;
    map['note'] = note;
    map['upgrade_channel'] = upgradeChannel;
    return map;
  }

}