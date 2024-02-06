import 'dart:io';

import 'package:dart_rss/dart_rss.dart';
import 'package:starcitizen_doctor/common/rust/api/http_api.dart' as rust_http;
import 'package:starcitizen_doctor/common/conf/url_conf.dart';

class RSSApi {
  static Future<List<RssItem>> getRssVideo() async {
    final r = await rust_http.getString(url: URLConf.rssVideoUrl);
    final f = RssFeed.parse(r);
    return f.items.sublist(0, 8);
  }

  static Future<List<RssItem>> getRssText() async {
    final r1 = await rust_http.getString(url: URLConf.rssTextUrl1);
    final r1f = RssFeed.parse(r1);
    final r2 = await rust_http.getString(url: URLConf.rssTextUrl2);
    final r2f = RssFeed.parse(r2);
    final items = r1f.items..addAll(r2f.items);
    items.sort((a, b) {
      final aDate = HttpDate.parse(a.pubDate ?? "").millisecondsSinceEpoch;
      final bDate = HttpDate.parse(b.pubDate ?? "").millisecondsSinceEpoch;
      return bDate - aDate;
    });
    return items;
  }
}
