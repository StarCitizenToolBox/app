/// name : "Data\\Textures\\planets\\surface\\ground\\architecture\\city\\city_suburbs_02_displ.dds.6"
/// size : 524288
/// compressedSize : 169812
/// isDirectory : false

class AppUnp4kP4kItemData {
  AppUnp4kP4kItemData({this.name, this.size, this.compressedSize, this.isDirectory, this.dateModified});

  AppUnp4kP4kItemData.fromJson(dynamic json) {
    name = json['name'];
    size = json['size'];
    compressedSize = json['compressedSize'];
    isDirectory = json['isDirectory'];
    dateModified = json['dateModified'];
  }

  String? name;
  num? size;
  num? compressedSize;
  bool? isDirectory;

  /// 文件修改时间（毫秒时间戳）
  int? dateModified;
  List<AppUnp4kP4kItemData> children = [];

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['size'] = size;
    map['compressedSize'] = compressedSize;
    map['isDirectory'] = isDirectory;
    map['dateModified'] = dateModified;
    return map;
  }
}
