class RsiGameLibraryData {
  RsiGameLibraryData({
    this.games,
  });

  RsiGameLibraryData.fromJson(dynamic json) {
    if (json['games'] != null) {
      games = [];
      json['games'].forEach((v) {
        games?.add(RsiGameLibraryGamesData.fromJson(v));
      });
    }
  }

  List<RsiGameLibraryGamesData>? games;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (games != null) {
      map['games'] = games?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class RsiGameLibraryGamesData {
  RsiGameLibraryGamesData({
    this.id,
    this.name,
    this.channels,
  });

  RsiGameLibraryGamesData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    if (json['channels'] != null) {
      channels = [];
      json['channels'].forEach((v) {
        channels?.add(RsiGameLibraryChannelsData.fromJson(v));
      });
    }
  }

  String? id;
  String? name;
  List<RsiGameLibraryChannelsData>? channels;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    if (channels != null) {
      map['channels'] = channels?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class RsiGameLibraryChannelsData {
  RsiGameLibraryChannelsData({
    this.id,
    this.name,
    this.version,
    this.versionLabel,
    this.servicesEndpoint,
    this.network,
    this.platformId,
    this.nid,
    this.weight,
  });

  RsiGameLibraryChannelsData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    version = json['version'];
    versionLabel = json['versionLabel'];
    servicesEndpoint = json['servicesEndpoint'];
    network = json['network'];
    platformId = json['platformId'];
    nid = json['nid'];
    weight = json['weight'];
  }

  String? id;
  String? name;
  num? version;
  String? versionLabel;
  String? servicesEndpoint;
  dynamic network;
  String? platformId;
  String? nid;
  dynamic weight;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['version'] = version;
    map['versionLabel'] = versionLabel;
    map['servicesEndpoint'] = servicesEndpoint;
    map['network'] = network;
    map['platformId'] = platformId;
    map['nid'] = nid;
    map['weight'] = weight;
    return map;
  }
}
