class AppAdvancedLocalizationData {
  AppAdvancedLocalizationData({
    this.classKeys,
  });

  AppAdvancedLocalizationData.fromJson(dynamic json) {
    if (json['class_keys'] != null) {
      classKeys = [];
      json['class_keys'].forEach((v) {
        classKeys?.add(AppAdvancedLocalizationClassKeysData.fromJson(v));
      });
    }
  }

  List<AppAdvancedLocalizationClassKeysData>? classKeys;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (classKeys != null) {
      map['class_keys'] = classKeys?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class AppAdvancedLocalizationClassKeysData {
  AppAdvancedLocalizationClassKeysData({
    this.id,
    this.className,
    this.keys,
  });

  AppAdvancedLocalizationClassKeysData.fromJson(dynamic json) {
    id = json['id'];
    className = json['class_name'];
    keys = json['keys'] != null ? json['keys'].cast<String>() : [];
  }

  String? id;
  String? className;
  List<String>? keys;
  Map<String, String> valuesMap = {};
  AppAdvancedLocalizationClassKeysDataMode mode =
      AppAdvancedLocalizationClassKeysDataMode.localization;
  bool lockMod = false;
  bool isWorking = false;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['class_name'] = className;
    map['keys'] = keys;
    return map;
  }
}

enum AppAdvancedLocalizationClassKeysDataMode {
  unLocalization,
  localization,
  mixed,
  mixedNewline,
}
