import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/provider/party_room.dart';

/// 创建房间对话框
class CreateRoomDialog extends HookConsumerWidget {
  const CreateRoomDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partyRoomState = ref.watch(partyRoomProvider);
    final partyRoom = ref.read(partyRoomProvider.notifier);

    final selectedMainTag = useState<String?>(null);
    final selectedSubTag = useState<String?>(null);
    final targetMembersController = useTextEditingController(text: '6');
    final hasPassword = useState(false);
    final passwordController = useTextEditingController();
    final socialLinksController = useTextEditingController();
    final isCreating = useState(false);

    return ContentDialog(
      constraints: const BoxConstraints(maxWidth: 500),
      title: const Text('创建房间'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoLabel(
              label: '房间类型',
              child: ComboBox<String>(
                placeholder: const Text('选择主标签'),
                value: selectedMainTag.value,
                items: partyRoomState.room.tags.map((tag) {
                  return ComboBoxItem(value: tag.id, child: Text(tag.name));
                }).toList(),
                onChanged: (value) {
                  selectedMainTag.value = value;
                  selectedSubTag.value = null;
                },
              ),
            ),
            const SizedBox(height: 12),

            if (selectedMainTag.value != null) ...[
              InfoLabel(
                label: '子标签 (可选)',
                child: ComboBox<String>(
                  placeholder: const Text('选择子标签'),
                  value: selectedSubTag.value,
                  items: [
                    const ComboBoxItem(value: null, child: Text('无')),
                    ...partyRoomState.room.tags.firstWhere((tag) => tag.id == selectedMainTag.value).subTags.map((
                      subTag,
                    ) {
                      return ComboBoxItem(value: subTag.id, child: Text(subTag.name));
                    }),
                  ],
                  onChanged: (value) {
                    selectedSubTag.value = value;
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],

            InfoLabel(
              label: '目标人数 (2-600)',
              child: TextBox(
                controller: targetMembersController,
                placeholder: '输入目标人数',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Checkbox(
                  checked: hasPassword.value,
                  onChanged: (value) {
                    hasPassword.value = value ?? false;
                  },
                  content: const Text('设置密码'),
                ),
              ],
            ),
            if (hasPassword.value) ...[
              const SizedBox(height: 8),
              InfoLabel(
                label: '房间密码',
                child: TextBox(controller: passwordController, placeholder: '输入密码', obscureText: true),
              ),
            ],
            const SizedBox(height: 12),

            InfoLabel(
              label: '社交链接 (可选)',
              child: TextBox(controller: socialLinksController, placeholder: 'https://discord.gg/xxxxx', maxLines: 1),
            ),
          ],
        ),
      ),
      actions: [
        FilledButton(
          onPressed: isCreating.value
              ? null
              : () async {
                  final mainTagId = selectedMainTag.value;
                  if (mainTagId == null || mainTagId.isEmpty) {
                    await showDialog(
                      context: context,
                      builder: (context) => ContentDialog(
                        title: const Text('提示'),
                        content: const Text('请选择房间类型'),
                        actions: [FilledButton(child: const Text('确定'), onPressed: () => Navigator.pop(context))],
                      ),
                    );
                    return;
                  }

                  final targetMembers = int.tryParse(targetMembersController.text);
                  if (targetMembers == null || targetMembers < 2 || targetMembers > 600) {
                    await showDialog(
                      context: context,
                      builder: (context) => ContentDialog(
                        title: const Text('提示'),
                        content: const Text('目标人数必须在 2-600 之间'),
                        actions: [FilledButton(child: const Text('确定'), onPressed: () => Navigator.pop(context))],
                      ),
                    );
                    return;
                  }

                  if (hasPassword.value && passwordController.text.trim().isEmpty) {
                    await showDialog(
                      context: context,
                      builder: (context) => ContentDialog(
                        title: const Text('提示'),
                        content: const Text('请输入密码'),
                        actions: [FilledButton(child: const Text('确定'), onPressed: () => Navigator.pop(context))],
                      ),
                    );
                    return;
                  }

                  final socialLinks = socialLinksController.text
                      .split('\n')
                      .where((link) => link.trim().isNotEmpty && link.trim().startsWith('http'))
                      .toList();

                  isCreating.value = true;
                  try {
                    await partyRoom.createRoom(
                      mainTagId: mainTagId,
                      subTagId: selectedSubTag.value,
                      targetMembers: targetMembers,
                      hasPassword: hasPassword.value,
                      password: hasPassword.value ? passwordController.text : null,
                      socialLinks: socialLinks.isEmpty ? null : socialLinks,
                    );

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  } catch (e) {
                    isCreating.value = false;
                    if (context.mounted) {
                      await showDialog(
                        context: context,
                        builder: (context) => ContentDialog(
                          title: const Text('创建失败'),
                          content: Text(e.toString()),
                          actions: [FilledButton(child: const Text('确定'), onPressed: () => Navigator.pop(context))],
                        ),
                      );
                    }
                  }
                },
          child: isCreating.value
              ? const SizedBox(width: 16, height: 16, child: ProgressRing(strokeWidth: 2))
              : const Text('创建'),
        ),
        Button(onPressed: isCreating.value ? null : () => Navigator.pop(context), child: const Text('取消')),
      ],
    );
  }
}
