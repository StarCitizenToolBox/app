// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unp4kc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Unp4kcState {
  bool get startUp => throw _privateConstructorUsedError;
  Map<String, AppUnp4kP4kItemData>? get files =>
      throw _privateConstructorUsedError;
  MemoryFileSystem? get fs => throw _privateConstructorUsedError;
  String get curPath => throw _privateConstructorUsedError;
  String? get endMessage => throw _privateConstructorUsedError;
  MapEntry<String, String>? get tempOpenFile =>
      throw _privateConstructorUsedError;
  String get errorMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $Unp4kcStateCopyWith<Unp4kcState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $Unp4kcStateCopyWith<$Res> {
  factory $Unp4kcStateCopyWith(
          Unp4kcState value, $Res Function(Unp4kcState) then) =
      _$Unp4kcStateCopyWithImpl<$Res, Unp4kcState>;
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
class _$Unp4kcStateCopyWithImpl<$Res, $Val extends Unp4kcState>
    implements $Unp4kcStateCopyWith<$Res> {
  _$Unp4kcStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      startUp: null == startUp
          ? _value.startUp
          : startUp // ignore: cast_nullable_to_non_nullable
              as bool,
      files: freezed == files
          ? _value.files
          : files // ignore: cast_nullable_to_non_nullable
              as Map<String, AppUnp4kP4kItemData>?,
      fs: freezed == fs
          ? _value.fs
          : fs // ignore: cast_nullable_to_non_nullable
              as MemoryFileSystem?,
      curPath: null == curPath
          ? _value.curPath
          : curPath // ignore: cast_nullable_to_non_nullable
              as String,
      endMessage: freezed == endMessage
          ? _value.endMessage
          : endMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      tempOpenFile: freezed == tempOpenFile
          ? _value.tempOpenFile
          : tempOpenFile // ignore: cast_nullable_to_non_nullable
              as MapEntry<String, String>?,
      errorMessage: null == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$Unp4kcStateImplCopyWith<$Res>
    implements $Unp4kcStateCopyWith<$Res> {
  factory _$$Unp4kcStateImplCopyWith(
          _$Unp4kcStateImpl value, $Res Function(_$Unp4kcStateImpl) then) =
      __$$Unp4kcStateImplCopyWithImpl<$Res>;
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
class __$$Unp4kcStateImplCopyWithImpl<$Res>
    extends _$Unp4kcStateCopyWithImpl<$Res, _$Unp4kcStateImpl>
    implements _$$Unp4kcStateImplCopyWith<$Res> {
  __$$Unp4kcStateImplCopyWithImpl(
      _$Unp4kcStateImpl _value, $Res Function(_$Unp4kcStateImpl) _then)
      : super(_value, _then);

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
    return _then(_$Unp4kcStateImpl(
      startUp: null == startUp
          ? _value.startUp
          : startUp // ignore: cast_nullable_to_non_nullable
              as bool,
      files: freezed == files
          ? _value._files
          : files // ignore: cast_nullable_to_non_nullable
              as Map<String, AppUnp4kP4kItemData>?,
      fs: freezed == fs
          ? _value.fs
          : fs // ignore: cast_nullable_to_non_nullable
              as MemoryFileSystem?,
      curPath: null == curPath
          ? _value.curPath
          : curPath // ignore: cast_nullable_to_non_nullable
              as String,
      endMessage: freezed == endMessage
          ? _value.endMessage
          : endMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      tempOpenFile: freezed == tempOpenFile
          ? _value.tempOpenFile
          : tempOpenFile // ignore: cast_nullable_to_non_nullable
              as MapEntry<String, String>?,
      errorMessage: null == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$Unp4kcStateImpl with DiagnosticableTreeMixin implements _Unp4kcState {
  const _$Unp4kcStateImpl(
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

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Unp4kcState(startUp: $startUp, files: $files, fs: $fs, curPath: $curPath, endMessage: $endMessage, tempOpenFile: $tempOpenFile, errorMessage: $errorMessage)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
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
            other is _$Unp4kcStateImpl &&
            (identical(other.startUp, startUp) || other.startUp == startUp) &&
            const DeepCollectionEquality().equals(other._files, _files) &&
            const DeepCollectionEquality().equals(other.fs, fs) &&
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
      const DeepCollectionEquality().hash(fs),
      curPath,
      endMessage,
      tempOpenFile,
      errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$Unp4kcStateImplCopyWith<_$Unp4kcStateImpl> get copyWith =>
      __$$Unp4kcStateImplCopyWithImpl<_$Unp4kcStateImpl>(this, _$identity);
}

abstract class _Unp4kcState implements Unp4kcState {
  const factory _Unp4kcState(
      {required final bool startUp,
      final Map<String, AppUnp4kP4kItemData>? files,
      final MemoryFileSystem? fs,
      required final String curPath,
      final String? endMessage,
      final MapEntry<String, String>? tempOpenFile,
      final String errorMessage}) = _$Unp4kcStateImpl;

  @override
  bool get startUp;
  @override
  Map<String, AppUnp4kP4kItemData>? get files;
  @override
  MemoryFileSystem? get fs;
  @override
  String get curPath;
  @override
  String? get endMessage;
  @override
  MapEntry<String, String>? get tempOpenFile;
  @override
  String get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$Unp4kcStateImplCopyWith<_$Unp4kcStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
