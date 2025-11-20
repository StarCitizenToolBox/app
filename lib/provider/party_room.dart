import 'dart:async';
import 'package:fixnum/fixnum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grpc/grpc.dart';
import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/common/conf/url_conf.dart';
import 'package:starcitizen_doctor/common/utils/provider.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/generated/proto/auth/auth.pbgrpc.dart' as auth;
import 'package:starcitizen_doctor/generated/proto/partroom/partroom.pbgrpc.dart' as partroom;
import 'package:starcitizen_doctor/generated/proto/common/common.pbgrpc.dart' as common;

part 'party_room.freezed.dart';

part 'party_room.g.dart';

/// PartyRoom 认证状态
@freezed
sealed class PartyRoomAuthState with _$PartyRoomAuthState {
  const factory PartyRoomAuthState({
    @Default('') String uuid,
    @Default('') String secretKey,
    @Default(false) bool isLoggedIn,
    auth.GameUserInfo? userInfo,
    DateTime? lastLoginTime,
  }) = _PartyRoomAuthState;
}

/// PartyRoom 房间状态
@freezed
sealed class PartyRoomState with _$PartyRoomState {
  const factory PartyRoomState({
    partroom.RoomInfo? currentRoom,
    @Default([]) List<partroom.RoomMember> members,
    @Default({}) Map<String, common.Tag> tags,
    @Default({}) Map<String, common.SignalType> signalTypes,
    @Default(false) bool isInRoom,
    @Default(false) bool isOwner,
    String? roomUuid,
    @Default([]) List<partroom.RoomEvent> recentEvents,
  }) = _PartyRoomState;
}

/// PartyRoom gRPC 客户端状态
@freezed
sealed class PartyRoomClientState with _$PartyRoomClientState {
  const factory PartyRoomClientState({
    ClientChannel? channel,
    auth.AuthServiceClient? authClient,
    partroom.PartRoomServiceClient? roomClient,
    common.CommonServiceClient? commonClient,
    @Default(false) bool isConnected,
    @Default('') String serverAddress,
    @Default(0) int serverPort,
  }) = _PartyRoomClientState;
}

/// PartyRoom 完整状态
@freezed
sealed class PartyRoomFullState with _$PartyRoomFullState {
  const factory PartyRoomFullState({
    required PartyRoomAuthState auth,
    required PartyRoomState room,
    required PartyRoomClientState client,
  }) = _PartyRoomFullState;
}

/// PartyRoom Provider
@riverpod
class PartyRoom extends _$PartyRoom {
  static const String _boxName = 'party_room_conf';
  static const String _secretKeyKey = 'party_room_secret_key';

  Box? _confBox;
  StreamSubscription<partroom.RoomEvent>? _eventStreamSubscription;
  Timer? _heartbeatTimer;
  bool _disposed = false;

  @override
  PartyRoomFullState build() {
    ref.onDispose(() {
      _disposed = true;
      _cleanup();
    });

    state = const PartyRoomFullState(
      auth: PartyRoomAuthState(),
      room: PartyRoomState(),
      client: PartyRoomClientState(),
    );

    // 初始化
    _initialize();

    ref.keepAlive();
    return state;
  }

  /// 初始化
  Future<void> _initialize() async {
    try {
      _confBox = await Hive.openBox(_boxName);

      // 加载保存的认证信息
      final uuid = appGlobalState.deviceUUID;
      if (uuid?.isEmpty ?? true) {
        throw Exception('Device UUID is not available');
      }
      final secretKey = _confBox?.get(_secretKeyKey, defaultValue: '');
      state = state.copyWith(
        auth: state.auth.copyWith(uuid: uuid!, secretKey: secretKey),
      );

      dPrint('[PartyRoom] Initialized with UUID: ${state.auth.uuid}');
    } catch (e) {
      dPrint('[PartyRoom] Initialize error: $e');
    }
  }

  /// 连接到服务器
  Future<void> connect() async {
    try {
      // 关闭现有连接
      await disconnect();

      final serverAddress = URLConf.partyRoomServerAddress;
      final serverPort = URLConf.partyRoomServerPort;

      final channel = ClientChannel(serverAddress, port: serverPort);

      final authClient = auth.AuthServiceClient(channel);
      final roomClient = partroom.PartRoomServiceClient(channel);
      final commonClient = common.CommonServiceClient(channel);

      // 测试连接
      await authClient.status(auth.StatusRequest());

      state = state.copyWith(
        client: state.client.copyWith(
          channel: channel,
          authClient: authClient,
          roomClient: roomClient,
          commonClient: commonClient,
          isConnected: true,
          serverAddress: serverAddress,
          serverPort: serverPort,
        ),
      );

      dPrint('[PartyRoom] Connected to $serverAddress:$serverPort');
    } catch (e) {
      dPrint('[PartyRoom] Connect error: $e');
      rethrow;
    }
  }

  /// 断开连接
  Future<void> disconnect() async {
    await _stopHeartbeat();
    await _stopEventStream();

    await state.client.channel?.shutdown();

    state = state.copyWith(client: const PartyRoomClientState());

    dPrint('[PartyRoom] Disconnected');
  }

  /// 获取认证 CallOptions
  CallOptions _getAuthCallOptions() {
    return CallOptions(metadata: {'uuid': state.auth.uuid, 'secret-key': state.auth.secretKey});
  }

  // ========== 认证相关方法 ==========

  /// 登录
  Future<void> login() async {
    try {
      final client = state.client.authClient;
      if (client == null) throw Exception('Not connected to server');

      final response = await client.login(auth.LoginRequest(), options: _getAuthCallOptions());

      state = state.copyWith(
        auth: state.auth.copyWith(
          isLoggedIn: true,
          userInfo: response.userInfo,
          lastLoginTime: DateTime.fromMillisecondsSinceEpoch(response.lastLoginTime.toInt()),
        ),
      );

      dPrint('[PartyRoom] Logged in as ${response.userInfo.gameUserId}');

      // 登录后检查是否有房间
      await _checkMyRoom();
    } catch (e) {
      dPrint('[PartyRoom] Login error: $e');
      rethrow;
    }
  }

  /// 预注册
  Future<auth.PreRegisterResponse> preRegister(String gameUserId) async {
    try {
      final client = state.client.authClient;
      if (client == null) throw Exception('Not connected to server');

      final response = await client.preRegister(auth.PreRegisterRequest(uuid: state.auth.uuid, gameUserId: gameUserId));

      dPrint('[PartyRoom] PreRegister verification code: ${response.verificationCode}');
      return response;
    } catch (e) {
      dPrint('[PartyRoom] PreRegister error: $e');
      rethrow;
    }
  }

  /// 注册
  Future<void> register(String gameUserId) async {
    try {
      final client = state.client.authClient;
      if (client == null) throw Exception('Not connected to server');

      final response = await client.register(auth.RegisterRequest(uuid: state.auth.uuid, gameUserId: gameUserId));

      // 保存 secretKey
      await _confBox?.put(_secretKeyKey, response.partyRoomSecretKey);

      state = state.copyWith(
        auth: state.auth.copyWith(secretKey: response.partyRoomSecretKey, userInfo: response.userInfo),
      );

      dPrint('[PartyRoom] Registered successfully');
    } catch (e) {
      dPrint('[PartyRoom] Register error: $e');
      rethrow;
    }
  }

  /// 注销
  Future<void> unregister() async {
    try {
      final client = state.client.authClient;
      if (client == null) throw Exception('Not connected to server');

      await client.unregister(auth.UnregisterRequest(), options: _getAuthCallOptions());

      // 清除本地认证信息
      await _confBox?.delete(_secretKeyKey);

      _dismissRoom();

      state = state.copyWith(auth: state.auth.copyWith(secretKey: '', isLoggedIn: false, userInfo: null));

      dPrint('[PartyRoom] Unregistered successfully');
    } catch (e) {
      dPrint('[PartyRoom] Unregister error: $e');
      rethrow;
    }
  }

  // ========== 房间相关方法 ==========

  /// 加载标签和信号类型
  Future<void> loadTags() async {
    try {
      final roomClient = state.client.roomClient;
      final commonClient = state.client.commonClient;
      if (roomClient == null || commonClient == null) throw Exception('Not connected to server');

      final response = await commonClient.getTags(common.GetTagsRequest());
      final signalTypesResponse = await commonClient.getSignalTypes(common.GetSignalTypesRequest());

      // 转换为 Map
      final tagsMap = {for (var tag in response.tags) tag.id: tag};
      final signalTypesMap = {for (var signal in signalTypesResponse.signals) signal.id: signal};

      state = state.copyWith(
        room: state.room.copyWith(tags: tagsMap, signalTypes: signalTypesMap),
      );

      dPrint('[PartyRoom] Tags and SignalTypes loaded: ${tagsMap.length} tags, ${signalTypesMap.length} signal types');
    } catch (e) {
      dPrint('[PartyRoom] LoadTags error: $e');
      rethrow;
    }
  }

  /// 获取房间列表
  Future<partroom.GetRoomListResponse> getRoomList({
    String? mainTagId,
    String? subTagId,
    String? searchOwnerName,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final client = state.client.roomClient;
      if (client == null) throw Exception('Not connected to server');

      final response = await client.getRoomList(
        partroom.GetRoomListRequest(
          mainTagId: mainTagId ?? '',
          subTagId: subTagId ?? '',
          searchOwnerName: searchOwnerName ?? '',
          page: page,
          pageSize: pageSize,
        ),
      );

      return response;
    } catch (e) {
      dPrint('[PartyRoom] GetRoomList error: $e');
      rethrow;
    }
  }

  /// 创建房间
  Future<void> createRoom({
    required String mainTagId,
    String? subTagId,
    required int targetMembers,
    bool hasPassword = false,
    String? password,
    List<String>? socialLinks,
  }) async {
    try {
      final client = state.client.roomClient;
      if (client == null) throw Exception('Not connected to server');

      final response = await client.createRoom(
        partroom.CreateRoomRequest(
          mainTagId: mainTagId,
          subTagId: subTagId ?? '',
          targetMembers: targetMembers,
          hasPassword: hasPassword,
          password_5: password ?? '',
          socialLinks: socialLinks ?? [],
        ),
        options: _getAuthCallOptions(),
      );

      state = state.copyWith(room: state.room.copyWith(roomUuid: response.roomUuid, isInRoom: true, isOwner: true));

      dPrint('[PartyRoom] Room created: ${response.roomUuid}');

      // 获取房间详情
      await getRoomInfo(response.roomUuid);

      // 启动心跳和事件监听
      await _startHeartbeat(response.roomUuid);
      await _startEventStream(response.roomUuid);
    } catch (e) {
      dPrint('[PartyRoom] CreateRoom error: $e');
      rethrow;
    }
  }

  /// 加入房间
  Future<void> joinRoom(String roomUuid, {String? password}) async {
    try {
      final client = state.client.roomClient;
      if (client == null) throw Exception('Not connected to server');

      await client.joinRoom(
        partroom.JoinRoomRequest(roomUuid: roomUuid, password: password ?? ''),
        options: _getAuthCallOptions(),
      );

      state = state.copyWith(room: state.room.copyWith(roomUuid: roomUuid, isInRoom: true, isOwner: false));

      dPrint('[PartyRoom] Joined room: $roomUuid');

      // 获取房间详情
      await getRoomInfo(roomUuid);

      // 启动心跳和事件监听
      await _startHeartbeat(roomUuid);
      await _startEventStream(roomUuid);
    } catch (e) {
      dPrint('[PartyRoom] JoinRoom error: $e');
      rethrow;
    }
  }

  /// 离开房间
  Future<void> leaveRoom() async {
    try {
      final client = state.client.roomClient;
      if (client == null) throw Exception('Not connected to server');

      final roomUuid = state.room.roomUuid;
      if (roomUuid == null) return;

      await client.leaveRoom(partroom.LeaveRoomRequest(roomUuid: roomUuid), options: _getAuthCallOptions());

      await _stopHeartbeat();
      await _stopEventStream();

      _dismissRoom();

      dPrint('[PartyRoom] Left room: $roomUuid');
    } catch (e) {
      dPrint('[PartyRoom] LeaveRoom error: $e');
      rethrow;
    }
  }

  /// 解散房间
  Future<void> dismissRoom() async {
    try {
      final client = state.client.roomClient;
      if (client == null) throw Exception('Not connected to server');

      final roomUuid = state.room.roomUuid;
      if (roomUuid == null) return;

      await client.dismissRoom(partroom.DismissRoomRequest(roomUuid: roomUuid), options: _getAuthCallOptions());

      await _stopHeartbeat();
      await _stopEventStream();

      _dismissRoom();

      dPrint('[PartyRoom] Dismissed room: $roomUuid');
    } catch (e) {
      dPrint('[PartyRoom] DismissRoom error: $e');
      rethrow;
    }
  }

  /// 获取房间详情
  Future<void> getRoomInfo(String roomUuid) async {
    try {
      final client = state.client.roomClient;
      if (client == null) throw Exception('Not connected to server');

      final response = await client.getRoomInfo(
        partroom.GetRoomInfoRequest(roomUuid: roomUuid),
        options: _getAuthCallOptions(),
      );

      // 检查是否为房主
      final isOwner = response.room.ownerGameId == state.auth.userInfo?.gameUserId;

      state = state.copyWith(
        room: state.room.copyWith(currentRoom: response.room, isOwner: isOwner),
      );

      // 同时获取成员列表
      await getRoomMembers(roomUuid);

      dPrint('[PartyRoom] Room info loaded');
    } catch (e) {
      dPrint('[PartyRoom] GetRoomInfo error: $e');
      rethrow;
    }
  }

  /// 获取房间成员
  Future<void> getRoomMembers(String roomUuid, {int page = 1, int pageSize = 100}) async {
    try {
      final client = state.client.roomClient;
      if (client == null) throw Exception('Not connected to server');

      final response = await client.getRoomMembers(
        partroom.GetRoomMembersRequest(roomUuid: roomUuid, page: page, pageSize: pageSize),
        options: _getAuthCallOptions(),
      );

      state = state.copyWith(room: state.room.copyWith(members: response.members));

      dPrint('[PartyRoom] Loaded ${response.members.length} members');
    } catch (e) {
      dPrint('[PartyRoom] GetRoomMembers error: $e');
      rethrow;
    }
  }

  /// 检查当前用户所在房间
  Future<void> _checkMyRoom() async {
    try {
      final client = state.client.roomClient;
      if (client == null) return;

      final response = await client.getMyRoom(partroom.GetMyRoomRequest(), options: _getAuthCallOptions());

      if (response.hasRoom() && response.room.roomUuid.isNotEmpty) {
        final isOwner = response.room.ownerGameId == state.auth.userInfo?.gameUserId;

        state = state.copyWith(
          room: state.room.copyWith(
            currentRoom: response.room,
            roomUuid: response.room.roomUuid,
            isInRoom: true,
            isOwner: isOwner,
          ),
        );

        dPrint('[PartyRoom] Rejoined room: ${response.room.roomUuid}');

        // 重新启动心跳和事件监听
        await _startHeartbeat(response.room.roomUuid);
        await _startEventStream(response.room.roomUuid);
        await getRoomMembers(response.room.roomUuid);
      }
    } catch (e) {
      dPrint('[PartyRoom] CheckMyRoom error: $e');
    }
  }

  /// 更新房间信息
  Future<void> updateRoom({
    int? targetMembers,
    String? password,
    String? mainTagId,
    String? subTagId,
    List<String>? socialLinks,
  }) async {
    try {
      final client = state.client.roomClient;
      if (client == null) throw Exception('Not connected to server');

      final roomUuid = state.room.roomUuid;
      if (roomUuid == null) return;

      final request = partroom.UpdateRoomRequest(
        roomUuid: roomUuid,
        targetMembers: targetMembers ?? state.room.currentRoom?.targetMembers ?? 0,
        mainTagId: mainTagId ?? state.room.currentRoom?.mainTagId ?? '',
        subTagId: subTagId ?? state.room.currentRoom?.subTagId ?? '',
      );

      if (password != null) {
        request.password = password;
      }

      if (socialLinks != null) {
        request.socialLinks.addAll(socialLinks);
      } else if (state.room.currentRoom?.socialLinks != null) {
        request.socialLinks.addAll(state.room.currentRoom!.socialLinks);
      }

      await client.updateRoom(request, options: _getAuthCallOptions());

      // 刷新房间信息
      await getRoomInfo(roomUuid);

      dPrint('[PartyRoom] Room updated');
    } catch (e) {
      dPrint('[PartyRoom] UpdateRoom error: $e');
      rethrow;
    }
  }

  /// 踢出成员
  Future<void> kickMember(String targetGameUserId) async {
    try {
      final client = state.client.roomClient;
      if (client == null) throw Exception('Not connected to server');

      final roomUuid = state.room.roomUuid;
      if (roomUuid == null) return;

      await client.kickMember(
        partroom.KickMemberRequest(roomUuid: roomUuid, targetGameUserId: targetGameUserId),
        options: _getAuthCallOptions(),
      );

      dPrint('[PartyRoom] Member kicked: $targetGameUserId');

      // 刷新成员列表
      await getRoomMembers(roomUuid);
    } catch (e) {
      dPrint('[PartyRoom] KickMember error: $e');
      rethrow;
    }
  }

  /// 设置状态
  Future<void> setStatus({String? currentLocation, int? kills, int? deaths, int? playTime}) async {
    try {
      final client = state.client.roomClient;
      if (client == null) throw Exception('Not connected to server');

      final roomUuid = state.room.roomUuid;
      if (roomUuid == null) return;

      await client.setStatus(
        partroom.SetStatusRequest(
          roomUuid: roomUuid,
          status: partroom.MemberStatus(
            currentLocation: currentLocation ?? '',
            kills: kills ?? 0,
            deaths: deaths ?? 0,
            playTime: Int64(playTime ?? 0),
          ),
        ),
        options: _getAuthCallOptions(),
      );

      dPrint('[PartyRoom] Status updated');
    } catch (e) {
      dPrint('[PartyRoom] SetStatus error: $e');
      rethrow;
    }
  }

  /// 发送信号
  Future<void> sendSignal(String signalId, {Map<String, String>? params}) async {
    try {
      final client = state.client.roomClient;
      if (client == null) throw Exception('Not connected to server');

      final roomUuid = state.room.roomUuid;
      if (roomUuid == null) return;

      // 验证信号类型是否有效
      if (state.room.signalTypes.isNotEmpty && !state.room.signalTypes.containsKey(signalId)) {
        throw Exception('Invalid signal ID: $signalId. Valid IDs: ${state.room.signalTypes.keys.join(", ")}');
      }

      final request = partroom.SendSignalRequest(roomUuid: roomUuid, signalId: signalId);

      if (params != null) {
        request.params.addAll(params);
      }

      await client.sendSignal(request, options: _getAuthCallOptions());

      dPrint('[PartyRoom] Signal sent: $signalId');
    } catch (e) {
      dPrint('[PartyRoom] SendSignal error: $e');
      rethrow;
    }
  }

  /// 转移房主
  Future<void> transferOwnership(String targetGameUserId) async {
    try {
      final client = state.client.roomClient;
      if (client == null) throw Exception('Not connected to server');

      final roomUuid = state.room.roomUuid;
      if (roomUuid == null) return;

      await client.transferOwnership(
        partroom.TransferOwnershipRequest(roomUuid: roomUuid, targetGameUserId: targetGameUserId),
        options: _getAuthCallOptions(),
      );

      // 更新房主状态
      state = state.copyWith(room: state.room.copyWith(isOwner: false));

      dPrint('[PartyRoom] Ownership transferred to: $targetGameUserId');

      // 刷新房间信息
      await getRoomInfo(roomUuid);
    } catch (e) {
      dPrint('[PartyRoom] TransferOwnership error: $e');
      rethrow;
    }
  }

  /// 获取被踢出成员列表
  Future<partroom.GetKickedMembersResponse> getKickedMembers({int page = 1, int pageSize = 20}) async {
    try {
      final client = state.client.roomClient;
      if (client == null) throw Exception('Not connected to server');

      final roomUuid = state.room.roomUuid;
      if (roomUuid == null) throw Exception('Not in a room');

      final response = await client.getKickedMembers(
        partroom.GetKickedMembersRequest(roomUuid: roomUuid, page: page, pageSize: pageSize),
        options: _getAuthCallOptions(),
      );

      return response;
    } catch (e) {
      dPrint('[PartyRoom] GetKickedMembers error: $e');
      rethrow;
    }
  }

  /// 移除被踢出成员（解除黑名单）
  Future<void> removeKickedMember(String gameUserId) async {
    try {
      final client = state.client.roomClient;
      if (client == null) throw Exception('Not connected to server');

      final roomUuid = state.room.roomUuid;
      if (roomUuid == null) return;

      await client.removeKickedMember(
        partroom.RemoveKickedMemberRequest(roomUuid: roomUuid, gameUserId: gameUserId),
        options: _getAuthCallOptions(),
      );

      dPrint('[PartyRoom] Kicked member removed: $gameUserId');
    } catch (e) {
      dPrint('[PartyRoom] RemoveKickedMember error: $e');
      rethrow;
    }
  }

  // ========== 心跳和事件流 ==========

  /// 启动心跳
  Future<void> _startHeartbeat(String roomUuid) async {
    await _stopHeartbeat();

    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      if (_disposed || state.room.roomUuid == null) {
        timer.cancel();
        return;
      }

      try {
        final client = state.client.roomClient;
        if (client == null) return;

        await client.heartbeat(partroom.HeartbeatRequest(roomUuid: roomUuid), options: _getAuthCallOptions());

        dPrint('[PartyRoom] Heartbeat sent');
      } catch (e) {
        dPrint('[PartyRoom] Heartbeat error: $e');
      }
    });

    dPrint('[PartyRoom] Heartbeat started');
  }

  /// 停止心跳
  Future<void> _stopHeartbeat() async {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    dPrint('[PartyRoom] Heartbeat stopped');
  }

  /// 启动事件流监听
  Future<void> _startEventStream(String roomUuid) async {
    await _stopEventStream();

    try {
      final client = state.client.roomClient;
      if (client == null) return;

      final stream = client.listenRoomEvents(
        partroom.ListenRoomEventsRequest(roomUuid: roomUuid),
        options: _getAuthCallOptions(),
      );

      _eventStreamSubscription = stream.listen(
        (event) {
          _handleRoomEvent(event);
        },
        onError: (error) {
          dPrint('[PartyRoom] Event stream error: $error');
        },
        onDone: () {
          dPrint('[PartyRoom] Event stream closed');
        },
      );

      dPrint('[PartyRoom] Event stream started');
    } catch (e) {
      dPrint('[PartyRoom] StartEventStream error: $e');
    }
  }

  /// 停止事件流监听
  Future<void> _stopEventStream() async {
    await _eventStreamSubscription?.cancel();
    _eventStreamSubscription = null;
    dPrint('[PartyRoom] Event stream stopped');
  }

  /// 处理房间事件
  void _handleRoomEvent(partroom.RoomEvent event) {
    dPrint('[PartyRoom] Event received: ${event.type}');

    // 添加到最近事件列表（保留最近 1000 条）
    final recentEvents = [...state.room.recentEvents, event];
    if (recentEvents.length > 1000) {
      recentEvents.removeAt(0);
    }

    state = state.copyWith(room: state.room.copyWith(recentEvents: recentEvents));

    // 根据事件类型处理
    switch (event.type) {
      case partroom.RoomEventType.MEMBER_JOINED:
      case partroom.RoomEventType.MEMBER_LEFT:
      case partroom.RoomEventType.MEMBER_KICKED:
        // 刷新成员列表
        if (state.room.roomUuid != null) {
          getRoomMembers(state.room.roomUuid!);
        }
        break;
      case partroom.RoomEventType.MEMBER_STATUS_UPDATED:
        // 刷新成员状态
        state = state.copyWith(
          room: state.room.copyWith(
            members: state.room.members.map((member) {
              if (member.gameUserId == event.member.gameUserId) {
                return event.member;
              }
              return member;
            }).toList(),
          ),
        );
        break;
      case partroom.RoomEventType.OWNER_CHANGED:
        // 检查是否自己成为房主
        final isOwner = event.member.gameUserId == state.auth.userInfo?.gameUserId;
        state = state.copyWith(room: state.room.copyWith(isOwner: isOwner));
        // 刷新房间信息
        if (state.room.roomUuid != null) {
          getRoomInfo(state.room.roomUuid!);
        }
        break;

      case partroom.RoomEventType.ROOM_UPDATED:
        // 刷新房间信息
        if (state.room.roomUuid != null) {
          getRoomInfo(state.room.roomUuid!);
        }
        break;

      case partroom.RoomEventType.ROOM_DISMISSED:
        // 房间被解散
        _stopHeartbeat();
        _stopEventStream();
        _dismissRoom();
        break;

      case partroom.RoomEventType.SIGNAL_BROADCAST:
        // 信号广播，UI 层可以监听 state.room.recentEvents 来处理
        break;

      default:
        break;
    }
  }

  // ========== 通用服务方法 ==========

  /// 获取服务器时间
  Future<common.GetServerTimeResponse> getServerTime() async {
    try {
      final client = state.client.commonClient;
      if (client == null) throw Exception('Not connected to server');

      return await client.getServerTime(common.GetServerTimeRequest());
    } catch (e) {
      dPrint('[PartyRoom] GetServerTime error: $e');
      rethrow;
    }
  }

  /// 获取版本信息
  Future<common.GetVersionResponse> getVersion() async {
    try {
      final client = state.client.commonClient;
      if (client == null) throw Exception('Not connected to server');

      return await client.getVersion(common.GetVersionRequest());
    } catch (e) {
      dPrint('[PartyRoom] GetVersion error: $e');
      rethrow;
    }
  }

  /// 获取信号类型列表
  Future<common.GetSignalTypesResponse> getSignalTypes() async {
    try {
      final client = state.client.commonClient;
      if (client == null) throw Exception('Not connected to server');

      return await client.getSignalTypes(common.GetSignalTypesRequest());
    } catch (e) {
      dPrint('[PartyRoom] GetSignalTypes error: $e');
      rethrow;
    }
  }

  // ========== 清理 ==========

  /// 重置房间状态（保留 tags 和 signalTypes）
  void _dismissRoom() {
    state = state.copyWith(
      room: PartyRoomState(tags: state.room.tags, signalTypes: state.room.signalTypes),
    );
  }

  void _cleanup() {
    _stopHeartbeat();
    _stopEventStream();
    _confBox?.close();
  }

  common.Tag? getMainTagById(String mainTagId) {
    return state.room.tags[mainTagId];
  }
}
