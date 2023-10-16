import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:starcitizen_doctor/common/conf.dart';
import 'package:starcitizen_doctor/data/app_placard_data.dart';
import 'package:starcitizen_doctor/data/app_version_data.dart';
import 'package:starcitizen_doctor/data/sc_localization_data.dart';

class Api {
  static final dio =
      Dio(BaseOptions(connectTimeout: const Duration(seconds: 10)));

  static Future<AppVersionData> getAppVersion() async {
    return AppVersionData.fromJson(
        await getRepoJson("sc_doctor", "version.json"));
  }

  static Future<AppPlacardData> getAppPlacard() async {
    return AppPlacardData.fromJson(
        await getRepoJson("sc_doctor", "placard.json"));
  }

  static Future<Map<String, dynamic>> getAppReleaseDataByVersionName(
      String version) async {
    final r = await dio
        .get("${AppConf.gitlabApiPath}/projects/152243/releases/$version");
    return r.data;
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

  static Future<List> getScServerStatus() async {
    final r =
        await dio.get("https://status.robertsspaceindustries.com/index.json");
    return r.data["systems"];
  }

  static Future<Map<String, dynamic>> getRepoJson(
      String dir, String name) async {
    final data = await getRepoData(dir, name);
    return json.decode(data);
  }

  static Future getRepoData(String dir, String name) async {
    final r = await dio.get("${AppConf.apiRepoPath}/$dir/$name");
    return r.data;
  }
}
