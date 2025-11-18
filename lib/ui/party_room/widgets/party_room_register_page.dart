import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/ui/party_room/party_room_ui_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// 注册页面
class PartyRoomRegisterPage extends HookConsumerWidget {
  const PartyRoomRegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiModel = ref.read(partyRoomUIModelProvider.notifier);
    final uiState = ref.watch(partyRoomUIModelProvider);

    final gameIdController = useTextEditingController();
    final currentStep = useState(0);

    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .6,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      '注册账号',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFE0E0E0)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              if (uiState.errorMessage != null) ...[
                InfoBar(
                  title: const Text('错误'),
                  content: Text(uiState.errorMessage!),
                  severity: InfoBarSeverity.error,
                  onClose: () => uiModel.clearError(),
                ),
                const SizedBox(height: 16),
              ],

              // 步骤指示器
              Row(
                children: [
                  _buildStepIndicator(
                    context,
                    number: 1,
                    title: '输入游戏ID',
                    isActive: currentStep.value == 0,
                    isCompleted: currentStep.value > 0,
                  ),
                  const Expanded(child: Divider()),
                  _buildStepIndicator(
                    context,
                    number: 2,
                    title: '验证RSI账号',
                    isActive: currentStep.value == 1,
                    isCompleted: currentStep.value > 1,
                  ),
                  const Expanded(child: Divider()),
                  _buildStepIndicator(
                    context,
                    number: 3,
                    title: '完成注册',
                    isActive: currentStep.value == 2,
                    isCompleted: false,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              if (currentStep.value == 0) ..._buildStep1(context, uiModel, uiState, gameIdController, currentStep),

              if (currentStep.value == 1) ..._buildStep2(context, uiModel, uiState, gameIdController, currentStep),

              if (currentStep.value == 2) ..._buildStep3(context, uiModel, uiState, currentStep),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              InfoBar(
                title: const Text('关于账号验证'),
                content: const Text('接下来，您需要在 RSI 账号简介中添加验证码以证明账号所有权，验证通过后，您可以移除该验证码。'),
                severity: InfoBarSeverity.info,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildStepIndicator(
    BuildContext context, {
    required int number,
    required String title,
    required bool isActive,
    required bool isCompleted,
  }) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isCompleted
                ? const Color(0xFF4CAF50)
                : isActive
                ? const Color(0xFF4A9EFF)
                : Colors.grey.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(FluentIcons.check_mark, size: 16, color: Colors.white)
                : Text(
                    '$number',
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.grey.withValues(alpha: 0.7),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            color: isActive ? const Color(0xFF4A9EFF) : Colors.grey.withValues(alpha: 0.7),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  static List<Widget> _buildStep1(
    BuildContext context,
    PartyRoomUIModel uiModel,
    PartyRoomUIState uiState,
    TextEditingController gameIdController,
    ValueNotifier<int> currentStep,
  ) {
    return [
      const Text(
        '步骤 1: 输入您的游戏ID',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFE0E0E0)),
      ),
      const SizedBox(height: 12),
      Text(
        '请输入您在星际公民中的游戏ID（Handle），'
        '这是您在游戏中使用的唯一标识符。',
        style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.6)),
      ),
      const SizedBox(height: 16),

      TextBox(
        controller: gameIdController,
        placeholder: '例如: Citizen123',
        enabled: !uiState.isLoading,
        onSubmitted: (value) async {
          if (value.trim().isEmpty) return;
          await _requestVerificationCode(uiModel, uiState, value.trim(), currentStep);
        },
      ),
      const SizedBox(height: 16),

      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Button(
            onPressed: () {
              launchUrlString('https://robertsspaceindustries.com/en/account/dashboard');
            },
            child: const Text('查看我的游戏ID'),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: uiState.isLoading
                ? null
                : () async {
                    final gameId = gameIdController.text.trim();
                    if (gameId.isEmpty) {
                      await showDialog(
                        context: context,
                        builder: (context) => ContentDialog(
                          title: const Text('提示'),
                          content: const Text('请输入游戏ID'),
                          actions: [FilledButton(child: const Text('确定'), onPressed: () => Navigator.pop(context))],
                        ),
                      );
                      return;
                    }
                    await _requestVerificationCode(uiModel, uiState, gameId, currentStep);
                  },
            child: uiState.isLoading
                ? const SizedBox(width: 16, height: 16, child: ProgressRing(strokeWidth: 2))
                : const Text('下一步'),
          ),
        ],
      ),
    ];
  }

  static Future<void> _requestVerificationCode(
    PartyRoomUIModel uiModel,
    PartyRoomUIState uiState,
    String gameId,
    ValueNotifier<int> currentStep,
  ) async {
    try {
      await uiModel.requestPreRegister(gameId);
      currentStep.value = 1;
    } catch (e) {
      // 错误已在 state 中设置
    }
  }

  static List<Widget> _buildStep2(
    BuildContext context,
    PartyRoomUIModel uiModel,
    PartyRoomUIState uiState,
    TextEditingController gameIdController,
    ValueNotifier<int> currentStep,
  ) {
    return [
      const Text(
        '步骤 2: 验证 RSI 账号',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFE0E0E0)),
      ),
      const SizedBox(height: 12),
      Text('请按照以下步骤完成账号验证：', style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.6))),
      const SizedBox(height: 16),

      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E3A5F).withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF4A9EFF).withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '1. 复制以下验证码:',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE0E0E0)),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                SelectableText(
                  'SCB:${uiState.preRegisterCode}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A9EFF),
                  ),
                ),
                SizedBox(width: 12),
                Button(
                  child: Icon(FluentIcons.copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: 'SCB:${uiState.preRegisterCode}'));
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              '2. 访问您的 RSI 账号资设置页',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE0E0E0)),
            ),
            const SizedBox(height: 8),
            Button(
              onPressed: () {
                launchUrlString('https://robertsspaceindustries.com/en/account/profile');
              },
              child: const Text('打开资料页'),
            ),
            const SizedBox(height: 16),
            const Text(
              '3. 编辑您的个人简介，将验证码添加到简介中',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE0E0E0)),
            ),
            const SizedBox(height: 8),
            Text(
              '在简介的任意位置添加验证码即可，验证码30分钟内有效',
              style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.5)),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Button(
            onPressed: () {
              currentStep.value = 0;
            },
            child: const Text('上一步'),
          ),
          FilledButton(
            onPressed: uiState.isLoading
                ? null
                : () async {
                    await _completeRegistration(uiModel, currentStep);
                  },
            child: uiState.isLoading
                ? const SizedBox(width: 16, height: 16, child: ProgressRing(strokeWidth: 2))
                : const Text('我已添加，验证并注册'),
          ),
        ],
      ),
    ];
  }

  static Future<void> _completeRegistration(PartyRoomUIModel uiModel, ValueNotifier<int> currentStep) async {
    try {
      await uiModel.completeRegister();
      currentStep.value = 2;
    } catch (e) {
      // 错误已在 state 中设置
    }
  }

  static List<Widget> _buildStep3(
    BuildContext context,
    PartyRoomUIModel uiModel,
    PartyRoomUIState uiState,
    ValueNotifier<int> currentStep,
  ) {
    return [
      Center(
        child: Column(
          children: [
            const Icon(FluentIcons.completed_solid, size: 64, color: Color(0xFF4CAF50)),
            const SizedBox(height: 16),
            const Text(
              '注册成功！',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFE0E0E0)),
            ),
            const SizedBox(height: 8),
            Text('您已成功注册组队大厅，现在可以开始使用了', style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.6))),
          ],
        ),
      ),
    ];
  }
}
