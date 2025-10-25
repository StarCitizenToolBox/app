import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/api/analytics.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';
import 'package:starcitizen_doctor/common/io/rs_http.dart';
import 'package:starcitizen_doctor/common/utils/async.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';

class HostsBoosterDialogUI extends HookConsumerWidget {
  const HostsBoosterDialogUI({super.key});

  static final _hostsMap = {
    "Recaptcha": ["www.recaptcha.net", "recaptcha.net"],
    S.current.tools_hosts_info_rsi_official_website: ["robertsspaceindustries.com"],
    S.current.tools_hosts_info_rsi_customer_service: ["support.robertsspaceindustries.com"],
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkedMap = useState<Map<String, bool>>({});
    final workingMap = useState<Map<String, int?>>({});
    final workingText = useState<String>("");

    doHost(BuildContext context) async {
      if (workingMap.value.isEmpty) {
        final hasTrue = checkedMap.value.values.where((element) => element).firstOrNull != null;
        if (!hasTrue) {
          for (var k in _hostsMap.keys) {
            checkedMap.value[k] = true;
          }
          checkedMap.value = Map.from(checkedMap.value);
        }
      }
      workingText.value = S.current.tools_hosts_info_dns_query_and_test;
      final ipsMap = await _doCheckDns(workingMap, checkedMap);
      workingText.value = S.current.tools_hosts_info_writing_hosts;
      if (!context.mounted) return;
      await _doWriteHosts(ipsMap).unwrap(context: context);
      workingText.value = S.current.tools_hosts_info_reading_config;
      await _readHostsState(workingMap, checkedMap);
      workingText.value = "";
    }

    useEffect(() {
      AnalyticsApi.touch("host_dns_boost");
      // 监听 Hosts 文件变更
      _readHostsState(workingMap, checkedMap);
      return null;
    }, []);

    return ContentDialog(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .55),
      title: Row(
        children: [
          IconButton(
            icon: const Icon(FluentIcons.back, size: 22),
            onPressed: workingText.value.isEmpty ? Navigator.of(context).pop : null,
          ),
          const SizedBox(width: 12),
          Text(S.current.tools_hosts_info_hosts_acceleration),
          const Spacer(),
          Button(
            onPressed: () => _openHostsFile(context),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Row(
                children: [
                  const Icon(FluentIcons.open_file),
                  const SizedBox(width: 6),
                  Text(S.current.tools_hosts_info_open_hosts_file),
                ],
              ),
            ),
          ),
        ],
      ),
      content: AnimatedSize(
        duration: const Duration(milliseconds: 200),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Row(
              children: [
                const SizedBox(width: 12),
                Text(S.current.tools_hosts_info_status),
                const SizedBox(width: 38),
                Text(S.current.tools_hosts_info_site),
                const Spacer(),
                Text(S.current.tools_hosts_info_enable),
                const SizedBox(width: 12),
              ],
            ),
            const SizedBox(height: 12),
            ListView.builder(
              itemCount: _hostsMap.length,
              shrinkWrap: true,
              padding: const EdgeInsets.all(6),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                final isEnable = checkedMap.value[_hostsMap.keys.elementAt(index)] ?? false;
                final workingState = workingMap.value[_hostsMap.keys.elementAt(index)];
                return Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: FluentTheme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      if (workingState == null) Icon(FontAwesomeIcons.xmark, size: 24, color: Colors.red),
                      if (workingState == 0) const SizedBox(width: 24, height: 24, child: ProgressRing()),
                      if (workingState == 1) Icon(FontAwesomeIcons.check, size: 24, color: Colors.green),
                      const SizedBox(width: 24),
                      const SizedBox(width: 12),
                      Text(_hostsMap.keys.elementAt(index)),
                      const Spacer(),
                      ToggleSwitch(
                        onChanged: (value) {
                          checkedMap.value[_hostsMap.keys.elementAt(index)] = value;
                          checkedMap.value = Map.from(checkedMap.value);
                        },
                        checked: isEnable,
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            if (workingText.value.isNotEmpty)
              SizedBox(
                height: 86,
                child: Column(
                  children: [
                    const SizedBox(height: 42, width: 42, child: ProgressRing()),
                    const SizedBox(height: 12),
                    Text(workingText.value),
                  ],
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(12),
                child: FilledButton(
                  onPressed: () => doHost(context),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3, bottom: 3, left: 12, right: 12),
                    child: Text(S.current.tools_hosts_action_one_click_acceleration),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _openHostsFile(BuildContext context) async {
    // 使用管理员权限调用记事本${S.current.tools_hosts_info_open_hosts_file}
    // Use powershell.exe directly instead of SystemHelper reference
    Process.run("powershell.exe", [
      "-Command",
      "Start-Process notepad.exe -Verb runAs -ArgumentList ${SystemHelper.getHostsFilePath()}",
      // ignore: use_build_context_synchronously
    ]).unwrap(context: context);
  }

  Future<Map<String, String>> _doCheckDns(
    ValueNotifier<Map<String, int?>> workingMap,
    ValueNotifier<Map<String, bool>> checkedMap,
  ) async {
    Map<String, String> result = {};
    final trueLen = checkedMap.value.values.where((element) => element).length;
    if (trueLen == 0) {
      return result;
    }
    for (var kv in _hostsMap.entries) {
      final siteName = kv.key;
      final siteHost = kv.value.first;
      if (!(checkedMap.value[siteName] ?? false)) {
        continue;
      }
      workingMap.value[siteName] = 0;
      workingMap.value = Map.from(workingMap.value);
      RSHttp.dnsLookupIps(siteHost).then(
        (ips) async {
          int tryCount = ips.length;
          try {
            for (var ip in ips) {
              final resp = await RSHttp.head("https://$siteHost", withIpAddress: ip);
              dPrint("[HostsBooster] host== $siteHost ip== $ip resp== ${resp.headers}");
              if (resp.headers.isNotEmpty) {
                if (result[siteName] == null) {
                  result[siteName] = ip;
                  workingMap.value[siteName] = 1;
                  workingMap.value = Map.from(workingMap.value);
                  break;
                }
              }
            }
          } catch (e) {
            tryCount--;
            if (tryCount == 0) {
              workingMap.value[siteName] = null;
              workingMap.value = Map.from(workingMap.value);
              result[siteName] = "";
            }
          }
        },
        onError: (e) {
          workingMap.value[siteName] = null;
          workingMap.value = Map.from(workingMap.value);
          result[siteName] = "";
        },
      );
    }
    while (true) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (result.length == trueLen) {
        return result;
      }
    }
  }

  Future<void> _doWriteHosts(Map<String, String> ipsMap) async {
    // 读取 hosts 文件
    final hostsFile = File(SystemHelper.getHostsFilePath());
    final hostsFileString = await hostsFile.readAsString();
    final hostsFileLines = hostsFileString.split("\n");
    final newHostsFileLines = <String>[];

    // copy Lines
    for (var line in hostsFileLines) {
      if (line.contains("#StarCitizenToolBox")) {
        break;
      }
      newHostsFileLines.add(line);
    }
    dPrint("userHostsFile == $hostsFileString");
    for (var kv in ipsMap.entries) {
      final domains = _hostsMap[kv.key] ?? <String>[];
      for (var domain in domains) {
        if (kv.value != "") {
          newHostsFileLines.add("${kv.value}     $domain     #StarCitizenToolBox");
        }
      }
    }
    await hostsFile.writeAsString(newHostsFileLines.join("\n"), flush: true);
  }

  Future<void> _readHostsState(
    ValueNotifier<Map<String, int?>> workingMap,
    ValueNotifier<Map<String, bool>> checkedMap,
  ) async {
    workingMap.value.clear();
    final hostsFile = File(SystemHelper.getHostsFilePath());
    final hostsFileString = await hostsFile.readAsString();
    final hostsFileLines = hostsFileString.split("\n");
    dPrint("userHostsFile == $hostsFileString");
    for (var line in hostsFileLines) {
      if (line.contains("#StarCitizenToolBox")) {
        for (var host in _hostsMap.entries) {
          if (line.contains(" ${host.value.first}")) {
            workingMap.value[host.key] = 1;
            workingMap.value = Map.from(workingMap.value);
            checkedMap.value[host.key] = true;
            checkedMap.value = Map.from(checkedMap.value);
          }
        }
      }
    }
  }
}
