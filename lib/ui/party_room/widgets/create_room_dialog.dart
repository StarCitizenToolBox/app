import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/common/utils/base_utils.dart';
import 'package:starcitizen_doctor/generated/proto/partroom/partroom.pb.dart' as partroom;
import 'package:starcitizen_doctor/provider/party_room.dart';
import 'package:starcitizen_doctor/generated/l10n.dart';

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
      title: Text(isEdit ? S.current.party_room_edit_room : '创建房间'),
      content: SizedBox(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  InfoLabel(
                    label: S.current.party_room_room_type,
                    child: ComboBox<String>(
                      placeholder: Text(S.current.party_room_select_main_tag),
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
                    label: S.current.party_room_sub_tag_optional,
                    child: ComboBox<String>(
                      placeholder: Text(S.current.party_room_select_sub_tag),
                      value: selectedSubTag.value,
                      isExpanded: true,
                      items: [
                        ComboBoxItem(value: null, child: Text(S.current.party_room_none)),
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
                label: S.current.party_room_target_members,
                child: TextBox(
                  controller: targetMembersController,
                  placeholder: S.current.party_room_enter_target_members,
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
                      content: Text(S.current.party_room_set_password),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // 密码输入框 - 始终显示，避免布局跳动
                InfoLabel(
                  label: S.current.party_room_room_password,
                  child: TextBox(
                    controller: passwordController,
                    placeholder: isEdit
                        ? S.current.party_room_password_empty_hint
                        : hasPassword.value
                        ? S.current.party_room_enter_password
                        : S.current.party_room_password_disabled,
                    obscureText: hasPassword.value,
                    maxLines: 1,
                    maxLength: 12,
                    enabled: hasPassword.value,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              InfoLabel(
                label: S.current.party_room_social_links_optional,
                child: TextBox(
                  controller: socialLinksController,
                  placeholder: S.current.party_room_social_links_placeholder,
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
                        title: Text(S.current.app_common_tip),
                        content: Text(S.current.party_room_select_room_type),
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
                        title: Text(S.current.app_common_tip),
                        content: Text(S.current.party_room_target_members_range),
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
                          title: Text(S.current.app_common_tip),
                          content: Text(S.current.party_room_enter_password_required),
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
                    showToast(context, S.current.party_room_link_format_error);
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
                          title: Text(isEdit ? S.current.party_room_update_failed : '创建失败'),
                          content: Text(e.toString()),
                          actions: [FilledButton(child: const Text('确定'), onPressed: () => Navigator.pop(context))],
                        ),
                      );
                    }
                  }
                },
          child: isCreating.value
              ? const SizedBox(width: 16, height: 16, child: ProgressRing(strokeWidth: 2))
              : Text(isEdit ? S.current.party_room_save : '创建'),
        ),
        Button(onPressed: isCreating.value ? null : () => Navigator.pop(context), child: Text(S.current.home_action_cancel)),
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