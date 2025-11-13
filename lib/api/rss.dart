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
      final aDate = _parseHttpDate(a.pubDate ?? "");
      final bDate = _parseHttpDate(b.pubDate ?? "");
      return bDate - aDate;
    });
    return items;
  }

  /// Parse HTTP date string to milliseconds since epoch
  /// Web-compatible alternative to HttpDate.parse from dart:io
  static int _parseHttpDate(String dateString) {
    if (dateString.isEmpty) return 0;
    
    try {
      // Try standard ISO 8601 format first
      final date = DateTime.parse(dateString);
      return date.millisecondsSinceEpoch;
    } catch (e) {
      // Try to parse common RSS date formats (RFC 822/2822)
      try {
        // Remove timezone names and extra spaces
        String cleaned = dateString.trim();
        
        // Try parsing with DateTime.tryParse which is more lenient
        final date = DateTime.tryParse(cleaned);
        if (date != null) {
          return date.millisecondsSinceEpoch;
        }
        
        // If still fails, return 0 to put it at the beginning
        return 0;
      } catch (e) {
        return 0;
      }
    }
  }
}
