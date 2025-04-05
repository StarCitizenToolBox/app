// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'log_analyze_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LogAnalyzeLineData {
  String get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get data => throw _privateConstructorUsedError;
  String? get dateTime => throw _privateConstructorUsedError;

  /// Create a copy of LogAnalyzeLineData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LogAnalyzeLineDataCopyWith<LogAnalyzeLineData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LogAnalyzeLineDataCopyWith<$Res> {
  factory $LogAnalyzeLineDataCopyWith(
          LogAnalyzeLineData value, $Res Function(LogAnalyzeLineData) then) =
      _$LogAnalyzeLineDataCopyWithImpl<$Res, LogAnalyzeLineData>;
  @useResult
  $Res call({String type, String title, String? data, String? dateTime});
}

/// @nodoc
class _$LogAnalyzeLineDataCopyWithImpl<$Res, $Val extends LogAnalyzeLineData>
    implements $LogAnalyzeLineDataCopyWith<$Res> {
  _$LogAnalyzeLineDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LogAnalyzeLineData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? title = null,
    Object? data = freezed,
    Object? dateTime = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String?,
      dateTime: freezed == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LogAnalyzeLineDataImplCopyWith<$Res>
    implements $LogAnalyzeLineDataCopyWith<$Res> {
  factory _$$LogAnalyzeLineDataImplCopyWith(_$LogAnalyzeLineDataImpl value,
          $Res Function(_$LogAnalyzeLineDataImpl) then) =
      __$$LogAnalyzeLineDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, String title, String? data, String? dateTime});
}

/// @nodoc
class __$$LogAnalyzeLineDataImplCopyWithImpl<$Res>
    extends _$LogAnalyzeLineDataCopyWithImpl<$Res, _$LogAnalyzeLineDataImpl>
    implements _$$LogAnalyzeLineDataImplCopyWith<$Res> {
  __$$LogAnalyzeLineDataImplCopyWithImpl(_$LogAnalyzeLineDataImpl _value,
      $Res Function(_$LogAnalyzeLineDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of LogAnalyzeLineData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? title = null,
    Object? data = freezed,
    Object? dateTime = freezed,
  }) {
    return _then(_$LogAnalyzeLineDataImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String?,
      dateTime: freezed == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$LogAnalyzeLineDataImpl implements _LogAnalyzeLineData {
  const _$LogAnalyzeLineDataImpl(
      {required this.type, required this.title, this.data, this.dateTime});

  @override
  final String type;
  @override
  final String title;
  @override
  final String? data;
  @override
  final String? dateTime;

  @override
  String toString() {
    return 'LogAnalyzeLineData(type: $type, title: $title, data: $data, dateTime: $dateTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LogAnalyzeLineDataImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime));
  }

  @override
  int get hashCode => Object.hash(runtimeType, type, title, data, dateTime);

  /// Create a copy of LogAnalyzeLineData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LogAnalyzeLineDataImplCopyWith<_$LogAnalyzeLineDataImpl> get copyWith =>
      __$$LogAnalyzeLineDataImplCopyWithImpl<_$LogAnalyzeLineDataImpl>(
          this, _$identity);
}

abstract class _LogAnalyzeLineData implements LogAnalyzeLineData {
  const factory _LogAnalyzeLineData(
      {required final String type,
      required final String title,
      final String? data,
      final String? dateTime}) = _$LogAnalyzeLineDataImpl;

  @override
  String get type;
  @override
  String get title;
  @override
  String? get data;
  @override
  String? get dateTime;

  /// Create a copy of LogAnalyzeLineData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LogAnalyzeLineDataImplCopyWith<_$LogAnalyzeLineDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
