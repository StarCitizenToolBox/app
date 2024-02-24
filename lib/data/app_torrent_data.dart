/// name : "Data.p4k"
/// update_at : "2024-02-24 18:00"
/// url : "https://p4k.42kit.com/3.22.1-LIVE.9072370/Data.p4k.torrent"

class AppTorrentData {
  AppTorrentData({
      this.name, 
      this.updateAt, 
      this.url,});

  AppTorrentData.fromJson(dynamic json) {
    name = json['name'];
    updateAt = json['update_at'];
    url = json['url'];
  }
  String? name;
  String? updateAt;
  String? url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['update_at'] = updateAt;
    map['url'] = url;
    return map;
  }

}