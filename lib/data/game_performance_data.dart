/// key : "r_displayinfo"
/// name : "屏幕信息（展示帧率）"
/// info : "在屏幕右上角展示帧率，服务器信息等"
/// type : "int"
/// max : 4
/// min : 0
/// value : 0
/// group : "设置"

class GamePerformanceData {
  GamePerformanceData({
    this.key,
    this.name,
    this.info,
    this.type,
    this.max,
    this.min,
    this.value,
    this.group,
  });

  GamePerformanceData.fromJson(dynamic json) {
    key = json['key'];
    name = json['name'];
    info = json['info'];
    type = json['type'];
    max = json['max'];
    min = json['min'];
    value = json['value'];
    group = json['group'];
  }
  String? key;
  String? name;
  String? info;
  String? type;
  num? max;
  num? min;
  num? value;
  String? group;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['key'] = key;
    map['name'] = name;
    map['info'] = info;
    map['type'] = type;
    map['max'] = max;
    map['min'] = min;
    map['value'] = value;
    map['group'] = group;
    return map;
  }
}
