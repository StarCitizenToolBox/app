import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/ui/auth/auth_page.dart';

/// URL Scheme handler for deep linking
/// Handles: sctoolbox://auth?callbackUrl=https://example.com
class UrlSchemeHandler {
  static final UrlSchemeHandler _instance = UrlSchemeHandler._internal();
  factory UrlSchemeHandler() => _instance;
  UrlSchemeHandler._internal();

  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;
  BuildContext? _context;

  // Debouncing variables
  String? _lastHandledUri;
  DateTime? _lastHandledTime;
  static const _debounceDuration = Duration(seconds: 2);

  /// Initialize URL scheme handler
  Future<void> initialize(BuildContext context) async {
    _context = context;

    // Handle initial link when app is launched via URL scheme
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        dPrint('Initial URI: $initialUri');
        _handleUri(initialUri);
      }
    } catch (e) {
      dPrint('Failed to get initial URI: $e');
    }

    // Handle links while app is running
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) {
        dPrint('Received URI: $uri');
        _handleUri(uri);
      },
      onError: (err) {
        dPrint('URI link stream error: $err');
      },
    );
  }

  /// Handle incoming URI with debouncing
  void _handleUri(Uri uri) {
    final uriString = uri.toString();
    final now = DateTime.now();

    // Check if this is a duplicate URI within debounce duration
    if (_lastHandledUri == uriString && _lastHandledTime != null) {
      final timeSinceLastHandle = now.difference(_lastHandledTime!);
      if (timeSinceLastHandle < _debounceDuration) {
        dPrint('Debounced duplicate URI: $uriString (${timeSinceLastHandle.inMilliseconds}ms since last)');
        return;
      }
    }

    // Update last handled URI and time
    _lastHandledUri = uriString;
    _lastHandledTime = now;

    dPrint('Handling URI: $uri');

    // Check if it's an auth request
    // Check if it's an auth request
    // Expected format: sctoolbox://auth?callbackUrl=https://example.com&state=...&nonce=...
    // Note: old format with domain in path (sctoolbox://auth/domain?...) is also supported but domain is ignored
    if (uri.scheme == 'sctoolbox' && uri.host == 'auth') {
      final callbackUrl = uri.queryParameters['callbackUrl'];
      final state = uri.queryParameters['state'];
      final nonce = uri.queryParameters['nonce'];

      if (callbackUrl == null || callbackUrl.isEmpty) {
        dPrint('Invalid auth URI: missing callbackUrl parameter');
        return;
      }

      if (state == null || state.isEmpty) {
        dPrint('Invalid auth URI: missing state parameter');
        return;
      }

      dPrint('Auth request - callbackUrl: $callbackUrl, state: $state');
      _showAuthDialog(callbackUrl, state, nonce);
    }
  }

  /// Show auth dialog
  void _showAuthDialog(String callbackUrl, String state, String? nonce) {
    if (_context == null || !_context!.mounted) {
      dPrint('Cannot show auth dialog: context not available');
      return;
    }

    showDialog(
      context: _context!,
      builder: (context) => AuthPage(callbackUrl: callbackUrl, stateParameter: state, nonce: nonce),
    );
  }

  /// Dispose the handler
  void dispose() {
    _linkSubscription?.cancel();
    _linkSubscription = null;
    _context = null;
    _lastHandledUri = null;
    _lastHandledTime = null;
  }

  /// Update context (useful when switching screens)
  void updateContext(BuildContext context) {
    _context = context;
  }
}
