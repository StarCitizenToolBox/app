import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/generated/l10n.dart';
import 'package:starcitizen_doctor/ui/party_room/party_room_ui_model.dart';

/// 连接服务器页面
class PartyRoomConnectPage extends HookConsumerWidget {
  const PartyRoomConnectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiModel = ref.read(partyRoomUIModelProvider.notifier);
    final uiState = ref.watch(partyRoomUIModelProvider);

    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withValues(alpha: 0.3), Colors.black.withValues(alpha: 0.6)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo 或图标
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A5F).withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: const Color(0xFF4A9EFF).withValues(alpha: 0.3), blurRadius: 30, spreadRadius: 5),
                  ],
                ),
                child: const Icon(FluentIcons.group, size: 64, color: Color(0xFF4A9EFF)),
              ),
              const SizedBox(height: 32),

              // 标题
              Text(
                S.current.party_room_title,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFE0E0E0), letterSpacing: 2),
              ),
              const SizedBox(height: 12),

              // 副标题
              Text(S.current.party_room_connecting, style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.7))),
              const SizedBox(height: 32),

              // 加载动画
              const SizedBox(width: 40, height: 40, child: ProgressRing(strokeWidth: 3)),
              const SizedBox(height: 32),

              if (uiState.errorMessage != null) ...[
                Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D1E1E).withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFF6B6B), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(FluentIcons.error_badge, color: Color(0xFFFF6B6B), size: 16),
                          const SizedBox(width: 8),
                          Text(
                            S.current.party_room_connect_failed,
                            style: const TextStyle(color: Color(0xFFFF6B6B), fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(uiState.errorMessage!, style: const TextStyle(color: Color(0xFFE0E0E0))),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: () async {
                          await uiModel.connectToServer();
                        },
                        child: Text(S.current.party_room_retry),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}