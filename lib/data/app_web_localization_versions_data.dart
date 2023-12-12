/// rsi : "0.2.21"
/// uex : "2.3"
/// addresses : "1.0"
/// concierge : "1.1"
/// hangar : "1.2"
/// orgs : "1.3"
/// dps : "0.1.1"

class AppWebLocalizationVersionsData {
  AppWebLocalizationVersionsData({
      this.rsi, 
      this.uex, 
      this.addresses, 
      this.concierge, 
      this.hangar, 
      this.orgs, 
      this.dps,});

  AppWebLocalizationVersionsData.fromJson(dynamic json) {
    rsi = json['rsi'];
    uex = json['uex'];
    addresses = json['addresses'];
    concierge = json['concierge'];
    hangar = json['hangar'];
    orgs = json['orgs'];
    dps = json['dps'];
  }
  String? rsi;
  String? uex;
  String? addresses;
  String? concierge;
  String? hangar;
  String? orgs;
  String? dps;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['rsi'] = rsi;
    map['uex'] = uex;
    map['addresses'] = addresses;
    map['concierge'] = concierge;
    map['hangar'] = hangar;
    map['orgs'] = orgs;
    map['dps'] = dps;
    return map;
  }

}