/// enable : true
/// versionName : "3.20.0(PU)_CN_V1"
/// updateAt : "2023-10-11: 11:10:00"
/// info : "简体中文汉化"
/// channel : "PU"
/// node : "已知问题：\n3D中文字体不显示（临时解决方法：将交互恢复成英文，但由于数量繁多，难免有遗漏，汉化组正在尽力找）\n·角色抬头显示器(HUD)的中文字体不显示\n·某些元素字体过小\n·搜索栏无法输入中文\n·部位文本未翻译（在翻了，在翻了！）"

class ScLocalizationData {
  ScLocalizationData({
      this.enable, 
      this.versionName, 
      this.updateAt, 
      this.info, 
      this.channel, 
      this.node,});

  ScLocalizationData.fromJson(dynamic json) {
    enable = json['enable'];
    versionName = json['versionName'];
    updateAt = json['updateAt'];
    info = json['info'];
    channel = json['channel'];
    node = json['node'];
  }
  bool? enable;
  String? versionName;
  String? updateAt;
  String? info;
  String? channel;
  String? node;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['enable'] = enable;
    map['versionName'] = versionName;
    map['updateAt'] = updateAt;
    map['info'] = info;
    map['channel'] = channel;
    map['node'] = node;
    return map;
  }

}