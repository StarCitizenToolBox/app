import 'dart:io';

import 'package:dart_rss/dart_rss.dart';
import 'package:starcitizen_doctor/common/io/rs_http.dart';
import 'package:starcitizen_doctor/common/conf/url_conf.dart';

class RSSApi {
  static Future<List<RssItem>> getRssVideo() async {
    final r = await RSHttp.getText(URLConf.rssVideoUrl);
    final f = RssFeed.parse(r);
    return f.items.sublist(0, 8);
  }

  static Future<List<RssItem>> getRssText() async {
    final r2 = await RSHttp.getText(URLConf.rssTextUrl2);
    final r2f = RssFeed.parse(r2);
    final items = r2f.items;
    items.sort((a, b) {
      final aDate = HttpDate.parse(a.pubDate ?? "").millisecondsSinceEpoch;
      final bDate = HttpDate.parse(b.pubDate ?? "").millisecondsSinceEpoch;
      return bDate - aDate;
    });
    return items;
  }
}
