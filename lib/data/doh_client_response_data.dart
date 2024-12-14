class DohClientResponseData {
  DohClientResponseData({
    this.status,
    this.tc,
    this.rd,
    this.ra,
    this.ad,
    this.cd,
    this.question,
    this.answer,
  });

  DohClientResponseData.fromJson(dynamic json) {
    status = json['Status'];
    tc = json['TC'];
    rd = json['RD'];
    ra = json['RA'];
    ad = json['AD'];
    cd = json['CD'];
    question = json['Question'] != null
        ? DohClientResponseQuestionData.fromJson(json['Question'])
        : null;
    if (json['Answer'] != null) {
      answer = [];
      json['Answer'].forEach((v) {
        answer?.add(DohClientResponseAnswerData.fromJson(v));
      });
    }
  }

  num? status;
  bool? tc;
  bool? rd;
  bool? ra;
  bool? ad;
  bool? cd;
  DohClientResponseQuestionData? question;
  List<DohClientResponseAnswerData>? answer;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Status'] = status;
    map['TC'] = tc;
    map['RD'] = rd;
    map['RA'] = ra;
    map['AD'] = ad;
    map['CD'] = cd;
    if (question != null) {
      map['Question'] = question?.toJson();
    }
    if (answer != null) {
      map['Answer'] = answer?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class DohClientResponseAnswerData {
  DohClientResponseAnswerData({
    this.name,
    this.ttl,
    this.type,
    this.data,
  });

  DohClientResponseAnswerData.fromJson(dynamic json) {
    name = json['name'];
    ttl = json['TTL'];
    type = json['type'];
    data = json['data'];
  }

  String? name;
  num? ttl;
  num? type;
  String? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['TTL'] = ttl;
    map['type'] = type;
    map['data'] = data;
    return map;
  }
}

class DohClientResponseQuestionData {
  DohClientResponseQuestionData({
    this.name,
    this.type,
  });

  DohClientResponseQuestionData.fromJson(dynamic json) {
    name = json['name'];
    type = json['type'];
  }

  String? name;
  num? type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['type'] = type;
    return map;
  }
}
