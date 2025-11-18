import 'dart:ui';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/common/conf/url_conf.dart';
import 'package:starcitizen_doctor/provider/party_room.dart';
import 'package:starcitizen_doctor/ui/party_room/party_room_ui_model.dart';
import 'package:starcitizen_doctor/ui/party_room/widgets/create_room_dialog.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';

/// 房间列表页面
class PartyRoomListPage extends HookConsumerWidget {
  const PartyRoomListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiModel = ref.read(partyRoomUIModelProvider.notifier);
    final uiState = ref.watch(partyRoomUIModelProvider);
    final partyRoomState = ref.watch(partyRoomProvider);
    final partyRoom = ref.read(partyRoomProvider.notifier);

    final searchController = useTextEditingController();
    final scrollController = useScrollController();

    useEffect(() {
      // 初次加载房间列表
      Future.microtask(() => uiModel.loadRoomList());
      return null;
    }, []);

    // 无限滑动监听
    useEffect(() {
      void onScroll() {
        if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
          // 距离底部200px时开始加载
          final totalPages = (uiState.totalRooms / uiState.pageSize).ceil();
          if (!uiState.isLoading && uiState.currentPage < totalPages && uiState.errorMessage == null) {
            uiModel.loadMoreRooms();
          }
        }
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [uiState.isLoading, uiState.currentPage, uiState.totalRooms]);

    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: Column(
        children: [
          // 筛选栏
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextBox(
                    controller: searchController,
                    placeholder: '搜索房主名称...',
                    prefix: const Padding(padding: EdgeInsets.only(left: 8), child: Icon(FluentIcons.search)),
                    onSubmitted: (value) {
                      uiModel.loadRoomList(searchName: value, page: 1);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                _buildTagFilter(context, ref, uiState, partyRoomState),
                const SizedBox(width: 12),
                IconButton(icon: const Icon(FluentIcons.refresh), onPressed: () => uiModel.refreshRoomList()),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: () => _showCreateRoomDialog(context, ref),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Icon(FluentIcons.add, size: 16), SizedBox(width: 8), Text('创建房间')],
                  ),
                ),
              ],
            ),
          ),

          // 房间列表
          Expanded(child: _buildRoomList(context, ref, uiState, partyRoom, scrollController)),
        ],
      ),
    );
  }

  Widget _buildTagFilter(
    BuildContext context,
    WidgetRef ref,
    PartyRoomUIState uiState,
    PartyRoomFullState partyRoomState,
  ) {
    final tags = partyRoomState.room.tags;

    return ComboBox<String>(
      placeholder: const Text('选择标签'),
      value: uiState.selectedMainTagId,
      items: [
        const ComboBoxItem(value: null, child: Text('全部标签')),
        ...tags.map((tag) => ComboBoxItem(value: tag.id, child: Text(tag.name))),
      ],
      onChanged: (value) {
        ref.read(partyRoomUIModelProvider.notifier).setSelectedMainTagId(value);
      },
    );
  }

  Widget _buildRoomList(
    BuildContext context,
    WidgetRef ref,
    PartyRoomUIState uiState,
    PartyRoom partyRoom,
    ScrollController scrollController,
  ) {
    if (uiState.isLoading && uiState.roomListItems.isEmpty) {
      return const Center(child: ProgressRing());
    }

    if (uiState.errorMessage != null && uiState.roomListItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(FluentIcons.error, size: 48, color: Color(0xFFFF6B6B)),
            const SizedBox(height: 16),
            Text(uiState.errorMessage!, style: const TextStyle(color: Color(0xFFE0E0E0))),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                ref.read(partyRoomUIModelProvider.notifier).refreshRoomList();
              },
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    if (uiState.roomListItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(FluentIcons.room, size: 48, color: Colors.grey.withValues(alpha: 0.6)),
            const SizedBox(height: 16),
            Text('暂无房间', style: TextStyle(color: Colors.white.withValues(alpha: 0.7))),
            const SizedBox(height: 8),
            Text('成为第一个创建房间的人吧！', style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.5))),
            const SizedBox(height: 16),
            FilledButton(onPressed: () => _showCreateRoomDialog(context, ref), child: const Text('创建房间')),
          ],
        ),
      );
    }

    final totalPages = (uiState.totalRooms / uiState.pageSize).ceil();
    final hasMore = uiState.currentPage < totalPages;

    return MasonryGridView.count(
      controller: scrollController,
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      itemCount: uiState.roomListItems.length + (hasMore || uiState.isLoading ? 1 : 0),
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        // 显示加载更多指示器
        if (index == uiState.roomListItems.length) {
          return Container(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: uiState.isLoading
                  ? const ProgressRing()
                  : Text('已加载全部房间', style: TextStyle(color: Colors.white.withValues(alpha: 0.5))),
            ),
          );
        }

        final room = uiState.roomListItems[index];
        return _buildRoomCard(context, ref, partyRoom, room, index);
      },
    );
  }

  Widget _buildRoomCard(BuildContext context, WidgetRef ref, PartyRoom partyRoom, dynamic room, int index) {
    final avatarUrl = room.ownerAvatar.isNotEmpty ? '${URLConf.rsiAvatarBaseUrl}${room.ownerAvatar}' : '';

    return GridItemAnimator(
      index: index,
      child: GestureDetector(
        onTap: () => _joinRoom(context, ref, partyRoom, room),
        child: Tilt(
          shadowConfig: const ShadowConfig(maxIntensity: .3),
          borderRadius: BorderRadius.circular(12),
          clipBehavior: Clip.hardEdge,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            clipBehavior: Clip.hardEdge,
            child: Stack(
              children: [
                // 背景图片
                if (avatarUrl.isNotEmpty)
                  Positioned.fill(
                    child: CacheNetImage(url: avatarUrl, fit: BoxFit.cover),
                  ),
                // 黑色遮罩
                Positioned.fill(
                  child: Container(decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6))),
                ),
                // 模糊效果
                Positioned.fill(
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                ),
                // 内容
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 头像和房主信息
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: const Color(0xFF4A9EFF).withValues(alpha: 0.5),
                            backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                            child: avatarUrl.isEmpty ? const Icon(FluentIcons.contact, color: Colors.white) : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        room.ownerHandleName.isNotEmpty ? room.ownerHandleName : room.ownerGameId,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (room.hasPassword) ...[
                                      const SizedBox(width: 4),
                                      Icon(FluentIcons.lock, size: 12, color: Colors.white.withValues(alpha: 0.7)),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Icon(FluentIcons.group, size: 11, color: Colors.white.withValues(alpha: 0.6)),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${room.currentMembers}/${room.targetMembers}',
                                      style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.7)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // 标签和时间
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          if (room.mainTagId.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4A9EFF).withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                room.mainTagId,
                                style: const TextStyle(fontSize: 11, color: Color(0xFF4A9EFF)),
                              ),
                            ),
                          if (room.socialLinks.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(FluentIcons.link, size: 10, color: Colors.green.withValues(alpha: 0.8)),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${room.socialLinks.length}',
                                    style: TextStyle(fontSize: 11, color: Colors.green.withValues(alpha: 0.9)),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showCreateRoomDialog(BuildContext context, WidgetRef ref) async {
    await showDialog(context: context, builder: (context) => const CreateRoomDialog());
  }

  Future<void> _joinRoom(BuildContext context, WidgetRef ref, PartyRoom partyRoom, dynamic room) async {
    String? password;

    if (room.hasPassword) {
      password = await showDialog<String>(
        context: context,
        builder: (context) {
          final passwordController = TextEditingController();
          return ContentDialog(
            title: const Text('输入房间密码'),
            content: TextBox(controller: passwordController, placeholder: '请输入密码', obscureText: true),
            actions: [
              Button(child: const Text('取消'), onPressed: () => Navigator.pop(context)),
              FilledButton(child: const Text('加入'), onPressed: () => Navigator.pop(context, passwordController.text)),
            ],
          );
        },
      );

      if (password == null) return;
    }

    try {
      await partyRoom.joinRoom(room.roomUuid, password: password);
    } catch (e) {
      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (context) => ContentDialog(
            title: const Text('加入失败'),
            content: Text(e.toString()),
            actions: [FilledButton(child: const Text('确定'), onPressed: () => Navigator.pop(context))],
          ),
        );
      }
    }
  }
}
