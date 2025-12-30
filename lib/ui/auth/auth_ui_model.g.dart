// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_ui_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthUIModel)
final authUIModelProvider = AuthUIModelFamily._();

final class AuthUIModelProvider
    extends $NotifierProvider<AuthUIModel, AuthUIState> {
  AuthUIModelProvider._({
    required AuthUIModelFamily super.from,
    required ({String? callbackUrl, String? stateParameter, String? nonce})
    super.argument,
  }) : super(
         retry: null,
         name: r'authUIModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$authUIModelHash();

  @override
  String toString() {
    return r'authUIModelProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  AuthUIModel create() => AuthUIModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthUIState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthUIState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AuthUIModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$authUIModelHash() => r'485bf56e488ba01cd1371131e6d92077c76176df';

final class AuthUIModelFamily extends $Family
    with
        $ClassFamilyOverride<
          AuthUIModel,
          AuthUIState,
          AuthUIState,
          AuthUIState,
          ({String? callbackUrl, String? stateParameter, String? nonce})
        > {
  AuthUIModelFamily._()
    : super(
        retry: null,
        name: r'authUIModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AuthUIModelProvider call({
    String? callbackUrl,
    String? stateParameter,
    String? nonce,
  }) => AuthUIModelProvider._(
    argument: (
      callbackUrl: callbackUrl,
      stateParameter: stateParameter,
      nonce: nonce,
    ),
    from: this,
  );

  @override
  String toString() => r'authUIModelProvider';
}

abstract class _$AuthUIModel extends $Notifier<AuthUIState> {
  late final _$args =
      ref.$arg
          as ({String? callbackUrl, String? stateParameter, String? nonce});
  String? get callbackUrl => _$args.callbackUrl;
  String? get stateParameter => _$args.stateParameter;
  String? get nonce => _$args.nonce;

  AuthUIState build({
    String? callbackUrl,
    String? stateParameter,
    String? nonce,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AuthUIState, AuthUIState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthUIState, AuthUIState>,
              AuthUIState,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(
        callbackUrl: _$args.callbackUrl,
        stateParameter: _$args.stateParameter,
        nonce: _$args.nonce,
      ),
    );
  }
}
