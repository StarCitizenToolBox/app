import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PartyRoomUI extends HookConsumerWidget {
  const PartyRoomUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "联机大厅，敬请期待 ！",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              launchUrlString("https://wj.qq.com/s2/14112124/f4c8/");
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("诚邀您参与 "),
                Text(
                  "问卷调查。",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
