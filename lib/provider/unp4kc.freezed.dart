// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unp4kc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Unp4kcState implements DiagnosticableTreeMixin {
  bool get startUp;
  Map<String, AppUnp4kP4kItemData>? get files;
  MemoryFileSystem? get fs;
  String get curPath;
  String? get endMessage;
  MapEntry<String, String>? get tempOpenFile;
  String get errorMessage;

  /// Create a copy of Unp4kcState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $Unp4kcStateCopyWith<Unp4kcState> get copyWith =>
      _$Unp4kcStateCopyWithImpl<Unp4kcState>(this as Unp4kcState, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'Unp4kcState'))
      ..add(DiagnosticsProperty('startUp', startUp))
      ..add(DiagnosticsProperty('files', files))
      ..add(DiagnosticsProperty('fs', fs))
      ..add(DiagnosticsProperty('curPath', curPath))
      ..add(DiagnosticsProperty('endMessage', endMessage))
      ..add(DiagnosticsProperty('tempOpenFile', tempOpenFile))
      ..add(DiagnosticsProperty('errorMessage', errorMessage));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Unp4kcState &&
            (identical(other.startUp, startUp) || other.startUp == startUp) &&
            const DeepCollectionEquality().equals(other.files, files) &&
            (identical(other.fs, fs) || other.fs == fs) &&
            (identical(other.curPath, curPath) || other.curPath == curPath) &&
            (identical(other.endMessage, endMessage) ||
                other.endMessage == endMessage) &&
            (identical(other.tempOpenFile, tempOpenFile) ||
                other.tempOpenFile == tempOpenFile) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      startUp,
      const DeepCollectionEquality().hash(files),
      fs,
      curPath,
      endMessage,
      tempOpenFile,
      errorMessage);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Unp4kcState(startUp: $startUp, files: $files, fs: $fs, curPath: $curPath, endMessage: $endMessage, tempOpenFile: $tempOpenFile, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $Unp4kcStateCopyWith<$Res> {
  factory $Unp4kcStateCopyWith(
          Unp4kcState value, $Res Function(Unp4kcState) _then) =
      _$Unp4kcStateCopyWithImpl;
  @useResult
  $Res call(
      {bool startUp,
      Map<String, AppUnp4kP4kItemData>? files,
      MemoryFileSystem? fs,
      String curPath,
      String? endMessage,
      MapEntry<String, String>? tempOpenFile,
      String errorMessage});
}

/// @nodoc
class _$Unp4kcStateCopyWithImpl<$Res> implements $Unp4kcStateCopyWith<$Res> {
  _$Unp4kcStateCopyWithImpl(this._self, this._then);

  final Unp4kcState _self;
  final $Res Function(Unp4kcState) _then;

  /// Create a copy of Unp4kcState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startUp = null,
    Object? files = freezed,
    Object? fs = freezed,
    Object? curPath = null,
    Object? endMessage = freezed,
    Object? tempOpenFile = freezed,
    Object? errorMessage = null,
  }) {
    return _then(_self.copyWith(
      startUp: null == startUp
          ? _self.startUp
          : startUp // ignore: cast_nullable_to_non_nullable
              as bool,
      files: freezed == files
          ? _self.files
          : files // ignore: cast_nullable_to_non_nullable
              as Map<String, AppUnp4kP4kItemData>?,
      fs: freezed == fs
          ? _self.fs
          : fs // ignore: cast_nullable_to_non_nullable
              as MemoryFileSystem?,
      curPath: null == curPath
          ? _self.curPath
          : curPath // ignore: cast_nullable_to_non_nullable
              as String,
      endMessage: freezed == endMessage
          ? _self.endMessage
          : endMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      tempOpenFile: freezed == tempOpenFile
          ? _self.tempOpenFile
          : tempOpenFile // ignore: cast_nullable_to_non_nullable
              as MapEntry<String, String>?,
      errorMessage: null == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _Unp4kcState with DiagnosticableTreeMixin implements Unp4kcState {
  const _Unp4kcState(
      {required this.startUp,
      final Map<String, AppUnp4kP4kItemData>? files,
      this.fs,
      required this.curPath,
      this.endMessage,
      this.tempOpenFile,
      this.errorMessage = ""})
      : _files = files;

  @override
  final bool startUp;
  final Map<String, AppUnp4kP4kItemData>? _files;
  @override
  Map<String, AppUnp4kP4kItemData>? get files {
    final value = _files;
    if (value == null) return null;
    if (_files is EqualUnmodifiableMapView) return _files;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final MemoryFileSystem? fs;
  @override
  final String curPath;
  @override
  final String? endMessage;
  @override
  final MapEntry<String, String>? tempOpenFile;
  @override
  @JsonKey()
  final String errorMessage;

  /// Create a copy of Unp4kcState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$Unp4kcStateCopyWith<_Unp4kcState> get copyWith =>
      __$Unp4kcStateCopyWithImpl<_Unp4kcState>(this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'Unp4kcState'))
      ..add(DiagnosticsProperty('startUp', startUp))
      ..add(DiagnosticsProperty('files', files))
      ..add(DiagnosticsProperty('fs', fs))
      ..add(DiagnosticsProperty('curPath', curPath))
      ..add(DiagnosticsProperty('endMessage', endMessage))
      ..add(DiagnosticsProperty('tempOpenFile', tempOpenFile))
      ..add(DiagnosticsProperty('errorMessage', errorMessage));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Unp4kcState &&
            (identical(other.startUp, startUp) || other.startUp == startUp) &&
            const DeepCollectionEquality().equals(other._files, _files) &&
            (identical(other.fs, fs) || other.fs == fs) &&
            (identical(other.curPath, curPath) || other.curPath == curPath) &&
            (identical(other.endMessage, endMessage) ||
                other.endMessage == endMessage) &&
            (identical(other.tempOpenFile, tempOpenFile) ||
                other.tempOpenFile == tempOpenFile) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      startUp,
      const DeepCollectionEquality().hash(_files),
      fs,
      curPath,
      endMessage,
      tempOpenFile,
      errorMessage);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Unp4kcState(startUp: $startUp, files: $files, fs: $fs, curPath: $curPath, endMessage: $endMessage, tempOpenFile: $tempOpenFile, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$Unp4kcStateCopyWith<$Res>
    implements $Unp4kcStateCopyWith<$Res> {
  factory _$Unp4kcStateCopyWith(
          _Unp4kcState value, $Res Function(_Unp4kcState) _then) =
      __$Unp4kcStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool startUp,
      Map<String, AppUnp4kP4kItemData>? files,
      MemoryFileSystem? fs,
      String curPath,
      String? endMessage,
      MapEntry<String, String>? tempOpenFile,
      String errorMessage});
}

/// @nodoc
class __$Unp4kcStateCopyWithImpl<$Res> implements _$Unp4kcStateCopyWith<$Res> {
  __$Unp4kcStateCopyWithImpl(this._self, this._then);

  final _Unp4kcState _self;
  final $Res Function(_Unp4kcState) _then;

  /// Create a copy of Unp4kcState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? startUp = null,
    Object? files = freezed,
    Object? fs = freezed,
    Object? curPath = null,
    Object? endMessage = freezed,
    Object? tempOpenFile = freezed,
    Object? errorMessage = null,
  }) {
    return _then(_Unp4kcState(
      startUp: null == startUp
          ? _self.startUp
          : startUp // ignore: cast_nullable_to_non_nullable
              as bool,
      files: freezed == files
          ? _self._files
          : files // ignore: cast_nullable_to_non_nullable
              as Map<String, AppUnp4kP4kItemData>?,
      fs: freezed == fs
          ? _self.fs
          : fs // ignore: cast_nullable_to_non_nullable
              as MemoryFileSystem?,
      curPath: null == curPath
          ? _self.curPath
          : curPath // ignore: cast_nullable_to_non_nullable
              as String,
      endMessage: freezed == endMessage
          ? _self.endMessage
          : endMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      tempOpenFile: freezed == tempOpenFile
          ? _self.tempOpenFile
          : tempOpenFile // ignore: cast_nullable_to_non_nullable
              as MapEntry<String, String>?,
      errorMessage: null == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
