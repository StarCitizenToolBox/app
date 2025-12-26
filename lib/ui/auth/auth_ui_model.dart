import 'dart:async';

import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/generated/proto/auth/auth.pb.dart';
import 'package:starcitizen_doctor/provider/party_room.dart';
import 'package:starcitizen_doctor/ui/party_room/party_room_ui_model.dart';

part 'auth_ui_model.freezed.dart';
part 'auth_ui_model.g.dart';

@freezed
sealed class AuthUIState with _$AuthUIState {
  const factory AuthUIState({
    @Default(false) bool isLoading,
    @Default(false) bool isLoggedIn,
    @Default(false) bool isWaitingForConnection,
    String? domain,
    String? callbackUrl,
    String? stateParameter,
    String? nonce,
    String? code,
    String? error,
    @Default(false) bool isDomainTrusted,
    String? domainName,
  }) = _AuthUIState;
}

@riverpod
class AuthUIModel extends _$AuthUIModel {
  @override
  AuthUIState build({String? callbackUrl, String? stateParameter, String? nonce}) {
    // Listen to party room connection and auth state changes
    ref.listen(partyRoomProvider, (previous, next) {
      // If we're waiting for connection and now connected, re-initialize
      if (state.isWaitingForConnection && next.client.isConnected && next.client.authClient != null) {
        dPrint('[AuthUI] Connection established, re-initializing...');
        Future.microtask(() => initialize());
      }

      // If not logged in before and now logged in, re-initialize
      if (!state.isLoggedIn && previous?.auth.isLoggedIn == false && next.auth.isLoggedIn) {
        dPrint('[AuthUI] User logged in, re-initializing...');
        Future.microtask(() => initialize());
      }
    });

    // Listen to party room UI model for login status changes
    ref.listen(partyRoomUIModelProvider, (previous, next) {
      // If was logging in and now finished (success or fail), re-check logic
      if (previous?.isLoggingIn == true && !next.isLoggingIn) {
        dPrint('[AuthUI] Login process finished, re-initializing...');
        Future.microtask(() => initialize());
      }
    });

    return AuthUIState(callbackUrl: callbackUrl, stateParameter: stateParameter, nonce: nonce);
  }

  Future<void> initialize() async {
    state = state.copyWith(isLoading: true, error: null, isWaitingForConnection: false);

    try {
      // Check if domain and callbackUrl are provided

      if (state.callbackUrl == null || state.callbackUrl!.isEmpty) {
        state = state.copyWith(isLoading: false, error: '缺少回调地址参数');
        return;
      }

      if (state.stateParameter == null || state.stateParameter!.isEmpty) {
        state = state.copyWith(isLoading: false, error: '缺少 state 参数');
        return;
      }

      // Extract domain from callbackUrl
      String? domain;
      try {
        final uri = Uri.parse(state.callbackUrl!);
        if (uri.host.isNotEmpty) {
          domain = uri.host;
        }
      } catch (e) {
        dPrint('Failed to parse callbackUrl: $e');
      }

      if (domain == null || domain.isEmpty) {
        state = state.copyWith(isLoading: false, error: '无法从回调地址解析域名');
        return;
      }

      // Update state with extracted domain
      state = state.copyWith(domain: domain);

      // Get party room providers
      final partyRoom = ref.read(partyRoomProvider);
      final partyRoomUI = ref.read(partyRoomUIModelProvider);

      // Check if connected to server
      if (!partyRoom.client.isConnected || partyRoom.client.authClient == null) {
        dPrint('[AuthUI] Server not connected, waiting for connection...');
        state = state.copyWith(isLoading: false, isWaitingForConnection: true);
        return;
      }

      // Check if user is logged in
      if (!partyRoom.auth.isLoggedIn) {
        // If still logging in process (auto-login after connect), keep waiting
        if (partyRoomUI.isLoggingIn) {
          dPrint('[AuthUI] Auto-login in progress, waiting...');
          state = state.copyWith(isLoading: false, isWaitingForConnection: true);
          return;
        }

        state = state.copyWith(isLoading: false, isLoggedIn: false);
        return;
      }

      // Check domain trust status
      final domainListResponse = await _getDomainList();
      bool isDomainTrusted = false;
      String? domainName;

      if (domainListResponse != null) {
        final domainInfo = domainListResponse.domains
            .cast<
              JWTDomainInfo?
            >() // Cast to nullable to use firstWhere with orElse returning null if needed, though JWTDomainInfo is not nullable in proto usually
            .firstWhere((d) => d?.domain.toLowerCase() == state.domain!.toLowerCase(), orElse: () => null);

        if (domainInfo != null && domainInfo.domain.isNotEmpty) {
          isDomainTrusted = true;
          domainName = domainInfo.name;
        }
      }

      // Don't generate token yet - wait for user confirmation
      state = state.copyWith(
        isLoading: false,
        isLoggedIn: true,
        isDomainTrusted: isDomainTrusted,
        domainName: domainName,
      );
    } catch (e) {
      dPrint('Auth initialization error: $e');
      state = state.copyWith(isLoading: false, error: '初始化失败: $e');
    }
  }

  Future<bool> generateCodeOnConfirm() async {
    // Only generate code if user is logged in and no previous error
    if (!state.isLoggedIn) {
      return false;
    }

    state = state.copyWith(isLoading: true);

    try {
      // Generate OIDC Auth Code
      final code = await _generateOIDCAuthCode();

      if (code == null) {
        state = state.copyWith(isLoading: false, error: '生成授权码失败');
        return false;
      }

      state = state.copyWith(isLoading: false, code: code);
      return true;
    } catch (e) {
      dPrint('Generate code on confirm error: $e');
      state = state.copyWith(isLoading: false, error: '生成授权码失败: $e');
      return false;
    }
  }

  Future<GetJWTDomainListResponse?> _getDomainList() async {
    try {
      final partyRoom = ref.read(partyRoomProvider);
      final partyRoomNotifier = ref.read(partyRoomProvider.notifier);
      final client = partyRoom.client.authClient;
      if (client == null) return null;

      final response = await client.getJWTDomainList(
        GetJWTDomainListRequest(),
        options: partyRoomNotifier.getAuthCallOptions(),
      );
      return response;
    } catch (e) {
      dPrint('Get domain list error: $e');
      return null;
    }
  }

  Future<String?> _generateOIDCAuthCode() async {
    try {
      final partyRoom = ref.read(partyRoomProvider);
      final partyRoomNotifier = ref.read(partyRoomProvider.notifier);
      final client = partyRoom.client.authClient;
      if (client == null || state.callbackUrl == null) return null;

      final request = GenerateOIDCAuthCodeRequest(redirectUri: state.callbackUrl!, nonce: state.nonce ?? '');

      final response = await client.generateOIDCAuthCode(request, options: partyRoomNotifier.getAuthCallOptions());
      return response.code;
    } catch (e) {
      dPrint('Generate OIDC Auth Code error: $e');
      return null;
    }
  }

  String? getAuthorizationUrl() {
    if (state.code == null || state.callbackUrl == null || state.stateParameter == null) {
      return null;
    }

    // Build authorization URL
    // Using query parameters (?) to allow both server-side and client-side processing
    final uri = Uri.parse(state.callbackUrl!);

    // Merge existing query parameters with new ones
    final newQueryParameters = Map<String, dynamic>.from(uri.queryParameters);
    newQueryParameters['code'] = state.code!;
    newQueryParameters['state'] = state.stateParameter!;

    final authUri = uri.replace(queryParameters: newQueryParameters);
    return authUri.toString();
  }

  Future<void> copyAuthorizationUrl() async {
    final url = getAuthorizationUrl();
    if (url != null) {
      await Clipboard.setData(ClipboardData(text: url));
    }
  }
}
