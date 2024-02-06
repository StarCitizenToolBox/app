/// version : "255c1fd9-c49c-4031-8733-b38e5363d666"
/// title : "测试公告"
/// content : "星际公民诊断工具 V3 正在开发中..."
/// link : null
/// link_type : "external"
/// always_show : false
/// enable : true

class AppPlacardData {
  AppPlacardData({
    this.version,
    this.title,
    this.content,
    this.link,
    this.linkType,
    this.alwaysShow,
    this.enable,
  });

  AppPlacardData.fromJson(dynamic json) {
    version = json['version'];
    title = json['title'];
    content = json['content'];
    link = json['link'];
    linkType = json['link_type'];
    alwaysShow = json['always_show'];
    enable = json['enable'];
  }
  String? version;
  String? title;
  String? content;
  dynamic link;
  String? linkType;
  bool? alwaysShow;
  bool? enable;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['version'] = version;
    map['title'] = title;
    map['content'] = content;
    map['link'] = link;
    map['link_type'] = linkType;
    map['always_show'] = alwaysShow;
    map['enable'] = enable;
    return map;
  }
}
