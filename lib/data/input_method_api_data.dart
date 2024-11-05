class InputMethodApiData {
  InputMethodApiData({
    this.enable,
    this.languages,
  });

  InputMethodApiData.fromJson(dynamic json) {
    enable = json['enable'];
    if (json['languages'] != null) {
      languages = <String, InputMethodApiLanguageData>{};
      json['languages'].forEach((String key, dynamic v) {
        languages![key] = InputMethodApiLanguageData.fromJson(v);
      });
    }
  }

  bool? enable;
  Map<String, InputMethodApiLanguageData>? languages;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['enable'] = enable;
    if (languages != null) {
      map['languages'] = languages!.map<String, dynamic>((key, value) {
        return MapEntry(key, value.toJson());
      });
    }
    return map;
  }
}

class InputMethodApiLanguageData {
  InputMethodApiLanguageData({
    this.file,
    this.version,
  });

  InputMethodApiLanguageData.fromJson(dynamic json) {
    file = json['file'];
    version = json['version'];
  }

  String? file;
  String? version;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['file'] = file;
    map['version'] = version;
    return map;
  }
}
