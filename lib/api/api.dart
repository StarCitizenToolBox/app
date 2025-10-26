import 'dart:convert';

import 'package:hive_ce/hive.dart';
import 'package:starcitizen_doctor/common/conf/url_conf.dart';
import 'package:starcitizen_doctor/common/io/rs_http.dart';
import 'package:starcitizen_doctor/data/app_placard_data.dart';
import 'package:starcitizen_doctor/data/app_torrent_data.dart';
import 'package:starcitizen_doctor/data/app_version_data.dart';
import 'package:starcitizen_doctor/data/countdown_festival_item_data.dart';
import 'package:starcitizen_doctor/data/input_method_api_data.dart';
import 'package:starcitizen_doctor/data/sc_localization_data.dart';

class Api {
  static Future<AppVersionData> getAppVersion() async {
    return AppVersionData.fromJson(
        await getRepoJson("sc_doctor", "version.json"));
  }

  static Future<AppPlacardData> getAppPlacard() async {
    return AppPlacardData.fromJson(
        await getRepoJson("sc_doctor", "placard.json"));
  }

  static Future<List<CountdownFestivalItemData>>
      getFestivalCountdownList() async {
    List<CountdownFestivalItemData> l = [];
    final r = json.decode(await getRepoData("sc_doctor", "countdown.json"));
    if (r is List) {
      for (var element in r) {
        l.add(CountdownFestivalItemData.fromJson(element));
      }
    }
    l.sort((a, b) => (a.time ?? 0) - (b.time ?? 0));
    return l;
  }

  static Future<Map<String, dynamic>> getAppReleaseDataByVersionName(
      String version) async {
    final r = await RSHttp.getText(
        "${URLConf.gitlabApiPath}repos/SCToolBox/Release/releases/tags/$version");
    return json.decode(r);
  }

  static Future<List<ScLocalizationData>> getScLocalizationData(
      String lang) async {
    final data = json.decode(await getRepoData("localizations", "$lang.json"));
    List<ScLocalizationData> l = [];
    if (data is List) {
      for (var element in data) {
        l.add(ScLocalizationData.fromJson(element));
      }
    }
    return l;
  }

  static Future<InputMethodApiData> getCommunityInputMethodIndexData() async {
    final data = await getCommunityInputMethodData("index.json");
    return InputMethodApiData.fromJson(json.decode(data));
  }

  static Future<String> getCommunityInputMethodData(String file) async {
    return getRepoData("input_method", file);
  }

  static Future<List<AppTorrentData>> getAppTorrentDataList() async {
    final data = await getRepoData("sc_doctor", "torrent.json");
    final dataJson = json.decode(data);
    List<AppTorrentData> l = [];
    if (dataJson is List) {
      for (var value in dataJson) {
        l.add(AppTorrentData.fromJson(value));
      }
    }
    return l;
  }

  static Future<String> getTorrentTrackerList() async {
    final data = await getRepoData("sc_doctor", "tracker.list");
    return data;
  }

  static Future<List> getScServerStatus() async {
    final r = await RSHttp.getText(
        "https://status.robertsspaceindustries.com/index.json");
    final map = json.decode(r);
    return map["systems"];
  }

  static Future<Map<String, dynamic>> getRepoJson(
      String dir, String name) async {
    final data = await getRepoData(dir, name);
    return json.decode(data);
  }

  static Future<String> getRepoData(String dir, String name) async {
    final r = await RSHttp.getText("${URLConf.apiRepoPath}/$dir/$name",
        withCustomDns: await isUseInternalDNS());
    return r;
  }

  static Future<bool> isUseInternalDNS() async {
    final userBox = await Hive.openBox("app_conf");
    final isUseInternalDNS =
        userBox.get("isUseInternalDNS", defaultValue: false);
    return isUseInternalDNS;
  }
}
