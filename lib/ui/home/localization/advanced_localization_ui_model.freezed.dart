// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'advanced_localization_ui_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AdvancedLocalizationUIState {
  String get workingText => throw _privateConstructorUsedError;
  Map<String, AppAdvancedLocalizationClassKeysData>? get classMap =>
      throw _privateConstructorUsedError;
  String? get p4kGlobalIni => throw _privateConstructorUsedError;
  String? get serverGlobalIni => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AdvancedLocalizationUIStateCopyWith<AdvancedLocalizationUIState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdvancedLocalizationUIStateCopyWith<$Res> {
  factory $AdvancedLocalizationUIStateCopyWith(
          AdvancedLocalizationUIState value,
          $Res Function(AdvancedLocalizationUIState) then) =
      _$AdvancedLocalizationUIStateCopyWithImpl<$Res,
          AdvancedLocalizationUIState>;
  @useResult
  $Res call(
      {String workingText,
      Map<String, AppAdvancedLocalizationClassKeysData>? classMap,
      String? p4kGlobalIni,
      String? serverGlobalIni});
}

/// @nodoc
class _$AdvancedLocalizationUIStateCopyWithImpl<$Res,
        $Val extends AdvancedLocalizationUIState>
    implements $AdvancedLocalizationUIStateCopyWith<$Res> {
  _$AdvancedLocalizationUIStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workingText = null,
    Object? classMap = freezed,
    Object? p4kGlobalIni = freezed,
    Object? serverGlobalIni = freezed,
  }) {
    return _then(_value.copyWith(
      workingText: null == workingText
          ? _value.workingText
          : workingText // ignore: cast_nullable_to_non_nullable
              as String,
      classMap: freezed == classMap
          ? _value.classMap
          : classMap // ignore: cast_nullable_to_non_nullable
              as Map<String, AppAdvancedLocalizationClassKeysData>?,
      p4kGlobalIni: freezed == p4kGlobalIni
          ? _value.p4kGlobalIni
          : p4kGlobalIni // ignore: cast_nullable_to_non_nullable
              as String?,
      serverGlobalIni: freezed == serverGlobalIni
          ? _value.serverGlobalIni
          : serverGlobalIni // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AdvancedLocalizationUIStateImplCopyWith<$Res>
    implements $AdvancedLocalizationUIStateCopyWith<$Res> {
  factory _$$AdvancedLocalizationUIStateImplCopyWith(
          _$AdvancedLocalizationUIStateImpl value,
          $Res Function(_$AdvancedLocalizationUIStateImpl) then) =
      __$$AdvancedLocalizationUIStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String workingText,
      Map<String, AppAdvancedLocalizationClassKeysData>? classMap,
      String? p4kGlobalIni,
      String? serverGlobalIni});
}

/// @nodoc
class __$$AdvancedLocalizationUIStateImplCopyWithImpl<$Res>
    extends _$AdvancedLocalizationUIStateCopyWithImpl<$Res,
        _$AdvancedLocalizationUIStateImpl>
    implements _$$AdvancedLocalizationUIStateImplCopyWith<$Res> {
  __$$AdvancedLocalizationUIStateImplCopyWithImpl(
      _$AdvancedLocalizationUIStateImpl _value,
      $Res Function(_$AdvancedLocalizationUIStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workingText = null,
    Object? classMap = freezed,
    Object? p4kGlobalIni = freezed,
    Object? serverGlobalIni = freezed,
  }) {
    return _then(_$AdvancedLocalizationUIStateImpl(
      workingText: null == workingText
          ? _value.workingText
          : workingText // ignore: cast_nullable_to_non_nullable
              as String,
      classMap: freezed == classMap
          ? _value._classMap
          : classMap // ignore: cast_nullable_to_non_nullable
              as Map<String, AppAdvancedLocalizationClassKeysData>?,
      p4kGlobalIni: freezed == p4kGlobalIni
          ? _value.p4kGlobalIni
          : p4kGlobalIni // ignore: cast_nullable_to_non_nullable
              as String?,
      serverGlobalIni: freezed == serverGlobalIni
          ? _value.serverGlobalIni
          : serverGlobalIni // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AdvancedLocalizationUIStateImpl
    with DiagnosticableTreeMixin
    implements _AdvancedLocalizationUIState {
  _$AdvancedLocalizationUIStateImpl(
      {this.workingText = "",
      final Map<String, AppAdvancedLocalizationClassKeysData>? classMap,
      this.p4kGlobalIni,
      this.serverGlobalIni})
      : _classMap = classMap;

  @override
  @JsonKey()
  final String workingText;
  final Map<String, AppAdvancedLocalizationClassKeysData>? _classMap;
  @override
  Map<String, AppAdvancedLocalizationClassKeysData>? get classMap {
    final value = _classMap;
    if (value == null) return null;
    if (_classMap is EqualUnmodifiableMapView) return _classMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? p4kGlobalIni;
  @override
  final String? serverGlobalIni;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AdvancedLocalizationUIState(workingText: $workingText, classMap: $classMap, p4kGlobalIni: $p4kGlobalIni, serverGlobalIni: $serverGlobalIni)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AdvancedLocalizationUIState'))
      ..add(DiagnosticsProperty('workingText', workingText))
      ..add(DiagnosticsProperty('classMap', classMap))
      ..add(DiagnosticsProperty('p4kGlobalIni', p4kGlobalIni))
      ..add(DiagnosticsProperty('serverGlobalIni', serverGlobalIni));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdvancedLocalizationUIStateImpl &&
            (identical(other.workingText, workingText) ||
                other.workingText == workingText) &&
            const DeepCollectionEquality().equals(other._classMap, _classMap) &&
            (identical(other.p4kGlobalIni, p4kGlobalIni) ||
                other.p4kGlobalIni == p4kGlobalIni) &&
            (identical(other.serverGlobalIni, serverGlobalIni) ||
                other.serverGlobalIni == serverGlobalIni));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      workingText,
      const DeepCollectionEquality().hash(_classMap),
      p4kGlobalIni,
      serverGlobalIni);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AdvancedLocalizationUIStateImplCopyWith<_$AdvancedLocalizationUIStateImpl>
      get copyWith => __$$AdvancedLocalizationUIStateImplCopyWithImpl<
          _$AdvancedLocalizationUIStateImpl>(this, _$identity);
}

abstract class _AdvancedLocalizationUIState
    implements AdvancedLocalizationUIState {
  factory _AdvancedLocalizationUIState(
      {final String workingText,
      final Map<String, AppAdvancedLocalizationClassKeysData>? classMap,
      final String? p4kGlobalIni,
      final String? serverGlobalIni}) = _$AdvancedLocalizationUIStateImpl;

  @override
  String get workingText;
  @override
  Map<String, AppAdvancedLocalizationClassKeysData>? get classMap;
  @override
  String? get p4kGlobalIni;
  @override
  String? get serverGlobalIni;
  @override
  @JsonKey(ignore: true)
  _$$AdvancedLocalizationUIStateImplCopyWith<_$AdvancedLocalizationUIStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
