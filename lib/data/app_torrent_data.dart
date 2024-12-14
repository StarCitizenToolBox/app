/// name : "Data.p4k"
/// update_at : "2024-09-03 15:00"
/// url : "https://p4k.42kit.com/3.24.1-LIVE.9234446/Data.p4k.torrent"
/// info : "3.24.1-LIVE.9234446"

class AppTorrentData {
  AppTorrentData({
    this.name,
    this.updateAt,
    this.url,
    this.info,
  });

  AppTorrentData.fromJson(dynamic json) {
    name = json['name'];
    updateAt = json['update_at'];
    url = json['url'];
    info = json['info'];
  }
  String? name;
  String? updateAt;
  String? url;
  String? info;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['update_at'] = updateAt;
    map['url'] = url;
    map['info'] = info;
    return map;
  }
}
