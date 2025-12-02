import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/generated/proto/partroom/partroom.pb.dart';
import 'package:starcitizen_doctor/provider/party_room.dart';
import 'package:starcitizen_doctor/ui/party_room/utils/party_room_utils.dart' show PartyRoomUtils;

import 'utils/game_log_tracker_provider.dart';

part 'party_room_ui_model.freezed.dart';

part 'party_room_ui_model.g.dart';

@freezed
sealed class PartyRoomUIState with _$PartyRoomUIState {
  const factory PartyRoomUIState({
    @Default(false) bool isConnecting,
    @Default(false) bool showRoomList,
    @Default([]) List<RoomListItem> roomListItems,
    @Default(1) int currentPage,
    @Default(20) int pageSize,
    @Default(0) int totalRooms,
    String? selectedMainTagId,
    String? selectedSubTagId,
    @Default('') String searchOwnerName,
    @Default(false) bool isLoading,
    String? errorMessage,
    @Default('') String preRegisterCode,
    @Default('') String registerGameUserId,
    @Default(false) bool isReconnecting,
    @Default(0) int reconnectAttempts,
    @Default(false) bool isMinimized,
    @Default(true) bool isLoggingIn,
    @Default(true) bool isGuestMode,
  }) = _PartyRoomUIState;
}

@riverpod
class PartyRoomUIModel extends _$PartyRoomUIModel {
  Timer? _reconnectTimer;
  ProviderSubscription? _gameLogSubscription;

  @override
  PartyRoomUIState build() {
    state = const PartyRoomUIState();
    ref.listen(partyRoomProvider, (previous, next) {
      _handleConnectionStateChange(previous, next);

      // 如果房间被解散或离开房间，重置最小化状态
      if (previous?.room.isInRoom == true && !next.room.isInRoom) {
        state = state.copyWith(isMinimized: false);
      }

      // 监听房间创建时间变化，设置游戏日志监听
      if (previous?.room.currentRoom?.createdAt != next.room.currentRoom?.createdAt) {
        _setupGameLogListener(next.room.currentRoom?.createdAt);
      }
    });

    connectToServer();

    // 在 dispose 时清理定时器和订阅
    ref.onDispose(() {
      _reconnectTimer?.cancel();
      _gameLogSubscription?.close();
    });
    return state;
  }

  /// 设置游戏日志监听
  void _setupGameLogListener(Int64? createdAt) {
    // 清除之前的订阅
    _gameLogSubscription?.close();
    _gameLogSubscription = null;

    final dateTime = PartyRoomUtils.getDateTime(createdAt);
    if (dateTime != null) {
      _gameLogSubscription = ref.listen<PartyRoomGameLogTrackerProviderState>(
        partyRoomGameLogTrackerProviderProvider(startTime: dateTime),
        (previous, next) => _onUpdateGameStatus(previous, next),
      );
    }
  }

  /// 处理游戏状态更新
  void _onUpdateGameStatus(PartyRoomGameLogTrackerProviderState? previous, PartyRoomGameLogTrackerProviderState next) {
    // 防抖
    final currentGameStartTime = previous?.gameStartTime?.millisecondsSinceEpoch;
    final gameStartTime = next.gameStartTime?.microsecondsSinceEpoch;
    if (next.kills != previous?.kills ||
        next.deaths != previous?.deaths ||
        next.location != previous?.location ||
        currentGameStartTime != gameStartTime) {
      // 更新状态
      ref
          .read(partyRoomProvider.notifier)
          .setStatus(
            kills: next.kills != previous?.kills ? next.kills : null,
            deaths: next.deaths != previous?.deaths ? next.deaths : null,
            currentLocation: next.location != previous?.location ? next.location : null,
            playTime: currentGameStartTime != gameStartTime ? gameStartTime : null,
          );
    }

    if (next.deathEvents?.isNotEmpty ?? false) {
      for (final event in next.deathEvents!) {
        ref.read(partyRoomProvider.notifier).sendSignal("special_death", params: {"location": event.$1, "area": event.$2});
      }
    }
  }

  /// 处理连接状态变化
  void _handleConnectionStateChange(PartyRoomFullState? previous, PartyRoomFullState next) {
    // 检测断线：之前已连接但现在未连接
    if (previous != null && previous.client.isConnected && !next.client.isConnected && !state.isReconnecting) {
      dPrint('[PartyRoomUI] Connection lost, starting reconnection...');
      _startReconnection();
    }
  }

  /// 开始断线重连
  Future<void> _startReconnection() async {
    if (state.isReconnecting) return;

    state = state.copyWith(isReconnecting: true, reconnectAttempts: 0);

    try {
      // 尝试重新连接和登录
      await _attemptReconnect();
    } catch (e) {
      dPrint('[PartyRoomUI] Reconnection failed: $e');
      state = state.copyWith(isReconnecting: false, errorMessage: '重连失败: $e');
    }
  }

  /// 尝试重新连接
  Future<void> _attemptReconnect() async {
    const maxAttempts = 5;
    const baseDelay = Duration(seconds: 2);

    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      state = state.copyWith(reconnectAttempts: attempt);
      dPrint('[PartyRoomUI] Reconnection attempt $attempt/$maxAttempts');

      try {
        final partyRoom = ref.read(partyRoomProvider.notifier);

        // 重新连接
        await partyRoom.connect();

        // 重新登录
        await partyRoom.login();

        // 重新加载标签和房间列表
        await partyRoom.loadTags();
        if (state.showRoomList) {
          await loadRoomList();
        }

        // 重连成功
        state = state.copyWith(isReconnecting: false, reconnectAttempts: 0, errorMessage: null);

        dPrint('[PartyRoomUI] Reconnection successful');
        return;
      } catch (e) {
        dPrint('[PartyRoomUI] Reconnection attempt $attempt failed: $e');

        if (attempt < maxAttempts) {
          // 使用指数退避策略
          final delay = baseDelay * (1 << (attempt - 1));
          dPrint('[PartyRoomUI] Waiting ${delay.inSeconds}s before next attempt...');
          await Future.delayed(delay);
        }
      }
    }

    // 所有重连尝试都失败
    state = state.copyWith(isReconnecting: false, errorMessage: '重连失败，已尝试 $maxAttempts 次');
    throw Exception('Max reconnection attempts reached');
  }

  /// 连接到服务器
  Future<void> connectToServer() async {
    state = state.copyWith(isConnecting: true, errorMessage: null);
    await Future.delayed(Duration(seconds: 1));
    try {
      final partyRoom = ref.read(partyRoomProvider.notifier);
      await partyRoom.connect();

      // 加载标签（游客和登录用户都需要）
      await partyRoom.loadTags();
      try {
        state = state.copyWith(isLoggingIn: true);
        await partyRoom.login();
        // 登录成功，加载房间列表
        await loadRoomList();
        state = state.copyWith(showRoomList: true, isLoggingIn: false, isGuestMode: false);
      } catch (e) {
        // 未注册，保持在连接状态
        dPrint('[PartyRoomUI] Login failed, need register: $e');
        state = state.copyWith(isGuestMode: true);
      } finally {
        state = state.copyWith(isLoggingIn: false);
      }

      state = state.copyWith(isConnecting: false);
    } catch (e) {
      state = state.copyWith(isConnecting: false, errorMessage: '连接失败: $e');
      rethrow;
    }
  }

  /// 请求注册验证码
  Future<void> requestPreRegister(String gameUserId) async {
    state = state.copyWith(isLoading: true, errorMessage: null, registerGameUserId: gameUserId);

    try {
      final partyRoom = ref.read(partyRoomProvider.notifier);
      final response = await partyRoom.preRegister(gameUserId);

      state = state.copyWith(isLoading: false, preRegisterCode: response.verificationCode);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: '获取验证码失败: $e');
      rethrow;
    }
  }

  /// 完成注册
  Future<void> completeRegister() async {
    if (state.registerGameUserId.isEmpty) {
      throw Exception('${S.current.party_room_game_id_empty}');
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final partyRoom = ref.read(partyRoomProvider.notifier);
      await partyRoom.register(state.registerGameUserId);

      // 注册成功，登录并加载数据
      await partyRoom.login();
      await partyRoom.loadTags();
      await loadRoomList();

      state = state.copyWith(isLoading: false, showRoomList: true, preRegisterCode: '', registerGameUserId: '');
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: '注册失败: $e');
      rethrow;
    }
  }

  /// 加载房间列表
  Future<void> loadRoomList({
    String? mainTagId,
    String? subTagId,
    String? searchName,
    int? page,
    bool append = false,
  }) async {
    try {
      state = state.copyWith(isLoading: true);

      // 更新筛选条件
      if (mainTagId != null) state = state.copyWith(selectedMainTagId: mainTagId);
      if (subTagId != null) state = state.copyWith(selectedSubTagId: subTagId);
      if (searchName != null) state = state.copyWith(searchOwnerName: searchName);
      if (page != null) state = state.copyWith(currentPage: page);

      final partyRoom = ref.read(partyRoomProvider.notifier);
      final response = await partyRoom.getRoomList(
        mainTagId: state.selectedMainTagId,
        subTagId: state.selectedSubTagId,
        searchOwnerName: state.searchOwnerName,
        page: state.currentPage,
        pageSize: state.pageSize,
      );

      // 追加模式：合并数据，否则替换数据
      final newRooms = append ? [...state.roomListItems, ...response.rooms] : response.rooms;

      state = state.copyWith(isLoading: false, roomListItems: newRooms, totalRooms: response.total, errorMessage: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: '加载房间列表失败: $e');
    }
  }

  /// 加载更多房间（无限滑动）
  Future<void> loadMoreRooms() async {
    final totalPages = (state.totalRooms / state.pageSize).ceil();
    if (state.currentPage >= totalPages || state.isLoading) return;

    await loadRoomList(page: state.currentPage + 1, append: true);
  }

  /// 刷新房间列表
  Future<void> refreshRoomList() async {
    state = state.copyWith(currentPage: 1, roomListItems: []);
    await loadRoomList(page: 1);
  }

  /// 进入游客模式
  void enterGuestMode() {
    state = state.copyWith(isGuestMode: true, showRoomList: false);
  }

  /// 退出游客模式（进入登录/注册流程）
  void exitGuestMode() {
    state = state.copyWith(isGuestMode: false, showRoomList: false);
  }

  /// 清除错误消息
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// 断开连接
  Future<void> disconnect() async {
    final partyRoom = ref.read(partyRoomProvider.notifier);
    await partyRoom.disconnect();

    state = const PartyRoomUIState();
  }

  void setSelectedMainTagId(String? value) {
    state = state.copyWith(selectedMainTagId: value);
    refreshRoomList();
  }

  void dismissRoom() {
    ref.read(partyRoomProvider.notifier).dismissRoom();
    ref.read(partyRoomProvider.notifier).loadTags();
  }

  void setMinimized(bool minimized) {
    state = state.copyWith(isMinimized: minimized);
  }
}