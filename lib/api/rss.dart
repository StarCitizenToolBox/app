import 'dart:io';

import 'package:dart_rss/dart_rss.dart';
import 'package:dio/dio.dart';
import 'package:starcitizen_doctor/common/conf.dart';

class RSSApi {
  static final _dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      responseType: ResponseType.plain));

  static Future<List<RssItem>> getRssVideo() async {
    final r = await _dio.get(AppConf.rssVideoUrl);
    final f = RssFeed.parse(r.data);
    return f.items.sublist(0, 8);
  }

  static Future<List<RssItem>> getRssText() async {
    final r1 = await _dio.get(AppConf.rssTextUrl1);
    final r1f = RssFeed.parse(r1.data);
    final r2 = await _dio.get(AppConf.rssTextUrl2);
    final r2f = RssFeed.parse(r2.data);
    final items = r1f.items..addAll(r2f.items);
    items.sort((a, b) {
      final aDate = HttpDate.parse(a.pubDate ?? "").millisecondsSinceEpoch;
      final bDate = HttpDate.parse(b.pubDate ?? "").millisecondsSinceEpoch;
      return bDate - aDate;
    });
    return items;
  }
}
