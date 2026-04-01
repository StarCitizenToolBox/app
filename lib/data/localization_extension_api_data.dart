class LocalizationExtensionApiData {
  LocalizationExtensionApiData({
    this.enable,
    this.languages,
  });

  LocalizationExtensionApiData.fromJson(dynamic json) {
    enable = json['enable'];
    if (json['languages'] != null) {
      languages = <String, List<LocalizationExtensionItemData>>{};
      json['languages'].forEach((String key, dynamic v) {
        if (v is List) {
          languages![key] = v.map((e) => LocalizationExtensionItemData.fromJson(e)).toList();
        }
      });
    }
  }

  bool? enable;
  Map<String, List<LocalizationExtensionItemData>>? languages;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['enable'] = enable;
    if (languages != null) {
      map['languages'] = languages!.map<String, dynamic>((key, value) {
        return MapEntry(key, value.map((e) => e.toJson()).toList());
      });
    }
    return map;
  }
}

class LocalizationExtensionItemData {
  LocalizationExtensionItemData({
    this.file,
    this.version,
    this.name,
  });

  LocalizationExtensionItemData.fromJson(dynamic json) {
    file = json['file'];
    version = json['version'];
    name = json['name'] ?? file?.replaceAll('.ini', '') ?? 'Unknown';
  }

  String? file;
  String? version;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['file'] = file;
    map['version'] = version;
    map['name'] = name;
    return map;
  }
}
