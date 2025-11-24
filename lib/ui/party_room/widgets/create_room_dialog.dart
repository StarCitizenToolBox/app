import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/common/utils/base_utils.dart';
import 'package:starcitizen_doctor/generated/proto/partroom/partroom.pb.dart' as partroom;
import 'package:starcitizen_doctor/provider/party_room.dart';

/// 创建/编辑房间对话框
class CreateRoomDialog extends HookConsumerWidget {
  final partroom.RoomInfo? roomInfo;

  const CreateRoomDialog({super.key, this.roomInfo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partyRoomState = ref.watch(partyRoomProvider);
    final partyRoom = ref.read(partyRoomProvider.notifier);
    final isEdit = roomInfo != null;

    final selectedMainTag = useState<String?>(roomInfo?.mainTagId);
    final selectedSubTag = useState<String?>(roomInfo?.subTagId);
    final targetMembersController = useTextEditingController(text: roomInfo?.targetMembers.toString() ?? '6');
    final hasPassword = useState(roomInfo?.hasPassword ?? false);
    final passwordController = useTextEditingController();
    final socialLinksController = useTextEditingController(text: roomInfo?.socialLinks.join('\n'));
    final isCreating = useState(false);

    // 获取选中的主标签
    final selectedMainTagData = selectedMainTag.value != null ? partyRoomState.room.tags[selectedMainTag.value] : null;

    return ContentDialog(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
      title: Text(isEdit ? '编辑房间' : '创建房间'),
      content: SizedBox(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  InfoLabel(
                    label: '房间类型',
                    child: ComboBox<String>(
                      placeholder: const Text('选择主标签'),
                      value: selectedMainTag.value,
                      isExpanded: true,
                      items: partyRoomState.room.tags.values.map((tag) {
                        return ComboBoxItem(
                          value: tag.id,
                          child: Row(
                            children: [
                              if (tag.color.isNotEmpty)
                                Container(
                                  width: 12,
                                  height: 12,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: _parseColor(tag.color),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              Text(tag.name, style: TextStyle(fontSize: 16)),
                              if (tag.info.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text(
                                    tag.info,
                                    style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .7)),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        selectedMainTag.value = value;
                        selectedSubTag.value = null;
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 子标签 - 始终显示，避免布局跳动
                  InfoLabel(
                    label: '子标签 (可选)',
                    child: ComboBox<String>(
                      placeholder: const Text('选择子标签'),
                      value: selectedSubTag.value,
                      isExpanded: true,
                      items: [
                        const ComboBoxItem(value: null, child: Text('无')),
                        if (selectedMainTagData != null)
                          ...selectedMainTagData.subTags.map((subTag) {
                            return ComboBoxItem(
                              value: subTag.id,
                              child: Row(
                                children: [
                                  if (subTag.color.isNotEmpty)
                                    Container(
                                      width: 12,
                                      height: 12,
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        color: _parseColor(subTag.color),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  Text(subTag.name, style: TextStyle(fontSize: 16)),
                                  if (subTag.info.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        subTag.info,
                                        style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .7)),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }),
                      ],
                      onChanged: selectedMainTagData != null
                          ? (value) {
                              selectedSubTag.value = value;
                            }
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              InfoLabel(
                label: '目标人数 (2-100)',
                child: TextBox(
                  controller: targetMembersController,
                  placeholder: '输入目标人数',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 16),
              if (!isEdit) ...[
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
                const SizedBox(height: 8),
                // 密码输入框 - 始终显示，避免布局跳动
                InfoLabel(
                  label: '房间密码',
                  child: TextBox(
                    controller: passwordController,
                    placeholder: isEdit
                        ? "为空则不更新密码，取消勾选则取消密码"
                        : hasPassword.value
                        ? '输入密码'
                        : '未启用密码',
                    obscureText: hasPassword.value,
                    maxLines: 1,
                    maxLength: 12,
                    enabled: hasPassword.value,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              InfoLabel(
                label: '社交链接 (可选)',
                child: TextBox(
                  controller: socialLinksController,
                  placeholder: '以 https:// 开头，目前仅支持 qq、discord、kook、oopz 链接',
                  maxLines: 1,
                ),
              ),
            ],
          ),
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
                  if (targetMembers == null || targetMembers < 2 || targetMembers > 100) {
                    await showDialog(
                      context: context,
                      builder: (context) => ContentDialog(
                        title: const Text('提示'),
                        content: const Text('目标人数必须在 2-100 之间'),
                        actions: [FilledButton(child: const Text('确定'), onPressed: () => Navigator.pop(context))],
                      ),
                    );
                    return;
                  }

                  if (hasPassword.value && passwordController.text.trim().isEmpty) {
                    if (!isEdit) {
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
                  }

                  final socialLinks = socialLinksController.text.split('\n').map((e) => e.trim()).toList();
                  // 移除空链接
                  socialLinks.removeWhere((link) => link.trim().isEmpty);
                  // 检查是否为 https 开头的链接
                  final invalidLinks = socialLinks.where((link) => !link.startsWith('https://')).toList();
                  if (invalidLinks.isNotEmpty) {
                    showToast(context, "链接格式错误！");
                    return;
                  }

                  isCreating.value = true;
                  try {
                    if (isEdit) {
                      await partyRoom.updateRoom(
                        mainTagId: mainTagId,
                        subTagId: selectedSubTag.value,
                        targetMembers: targetMembers,
                        password: !hasPassword.value
                            ? ''
                            : (passwordController.text.isNotEmpty ? passwordController.text : null),
                        socialLinks: socialLinks,
                      );
                    } else {
                      await partyRoom.createRoom(
                        mainTagId: mainTagId,
                        subTagId: selectedSubTag.value,
                        targetMembers: targetMembers,
                        hasPassword: hasPassword.value,
                        password: hasPassword.value ? passwordController.text : null,
                        socialLinks: socialLinks.isEmpty ? null : socialLinks,
                      );
                    }

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  } catch (e) {
                    isCreating.value = false;
                    if (context.mounted) {
                      await showDialog(
                        context: context,
                        builder: (context) => ContentDialog(
                          title: Text(isEdit ? '更新失败' : '创建失败'),
                          content: Text(e.toString()),
                          actions: [FilledButton(child: const Text('确定'), onPressed: () => Navigator.pop(context))],
                        ),
                      );
                    }
                  }
                },
          child: isCreating.value
              ? const SizedBox(width: 16, height: 16, child: ProgressRing(strokeWidth: 2))
              : Text(isEdit ? '保存' : '创建'),
        ),
        Button(onPressed: isCreating.value ? null : () => Navigator.pop(context), child: const Text('取消')),
      ],
    );
  }

  /// 解析颜色字符串
  Color _parseColor(String colorStr) {
    if (colorStr.isEmpty) return Colors.grey;

    try {
      // 移除 # 前缀
      String hexColor = colorStr.replaceAll('#', '');

      // 如果是3位或6位，添加 alpha 通道
      if (hexColor.length == 3) {
        hexColor = hexColor.split('').map((c) => '$c$c').join();
      }
      if (hexColor.length == 6) {
        hexColor = 'FF$hexColor';
      }

      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }
}
