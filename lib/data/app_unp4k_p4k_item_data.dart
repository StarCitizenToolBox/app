/// name : "Data\\Textures\\planets\\surface\\ground\\architecture\\city\\city_suburbs_02_displ.dds.6"
/// size : 524288
/// compressedSize : 169812
/// isDirectory : false
/// isFile : true
/// isEncrypted : false
/// isUnicodeText : false
/// dateTime : "2019-12-16T15:11:18"
/// version : 45

class AppUnp4kP4kItemData {
  AppUnp4kP4kItemData({
    this.name,
    this.size,
    this.compressedSize,
    this.isDirectory,
    this.isFile,
    this.isEncrypted,
    this.isUnicodeText,
    this.dateTime,
    this.version,
  });

  AppUnp4kP4kItemData.fromJson(dynamic json) {
    name = json['name'];
    size = json['size'];
    compressedSize = json['compressedSize'];
    isDirectory = json['isDirectory'];
    isFile = json['isFile'];
    isEncrypted = json['isEncrypted'];
    isUnicodeText = json['isUnicodeText'];
    dateTime = json['dateTime'];
    version = json['version'];
  }

  String? name;
  num? size;
  num? compressedSize;
  bool? isDirectory;
  bool? isFile;
  bool? isEncrypted;
  bool? isUnicodeText;
  String? dateTime;
  num? version;
  List<AppUnp4kP4kItemData> children = [];

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['size'] = size;
    map['compressedSize'] = compressedSize;
    map['isDirectory'] = isDirectory;
    map['isFile'] = isFile;
    map['isEncrypted'] = isEncrypted;
    map['isUnicodeText'] = isUnicodeText;
    map['dateTime'] = dateTime;
    map['version'] = version;
    return map;
  }
}
