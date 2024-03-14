import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/generated/l10n.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PartyRoomUI extends HookConsumerWidget {
  const PartyRoomUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            S.current.lobby_online_lobby_coming_soon,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              launchUrlString("https://wj.qq.com/s2/14112124/f4c8/");
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(S.current.lobby_invitation_to_participate),
                Text(
                  S.current.lobby_survey,
                  style: const TextStyle(
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