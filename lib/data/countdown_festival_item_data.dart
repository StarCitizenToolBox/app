class CountdownFestivalItemData {
  CountdownFestivalItemData({
    this.name,
    this.time,
    this.icon,
  });

  CountdownFestivalItemData.fromJson(dynamic json) {
    name = json['name'];
    time = json['time'];
    icon = json['icon'];
  }
  String? name;
  int? time;
  String? icon;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['time'] = time;
    map['icon'] = icon;
    return map;
  }
}
