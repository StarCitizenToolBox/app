// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'log_analyze_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LogAnalyzeLineData {
  String get type;
  String get title;
  String? get data;
  String? get dateTime;

  /// Create a copy of LogAnalyzeLineData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LogAnalyzeLineDataCopyWith<LogAnalyzeLineData> get copyWith =>
      _$LogAnalyzeLineDataCopyWithImpl<LogAnalyzeLineData>(
          this as LogAnalyzeLineData, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LogAnalyzeLineData &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime));
  }

  @override
  int get hashCode => Object.hash(runtimeType, type, title, data, dateTime);

  @override
  String toString() {
    return 'LogAnalyzeLineData(type: $type, title: $title, data: $data, dateTime: $dateTime)';
  }
}

/// @nodoc
abstract mixin class $LogAnalyzeLineDataCopyWith<$Res> {
  factory $LogAnalyzeLineDataCopyWith(
          LogAnalyzeLineData value, $Res Function(LogAnalyzeLineData) _then) =
      _$LogAnalyzeLineDataCopyWithImpl;
  @useResult
  $Res call({String type, String title, String? data, String? dateTime});
}

/// @nodoc
class _$LogAnalyzeLineDataCopyWithImpl<$Res>
    implements $LogAnalyzeLineDataCopyWith<$Res> {
  _$LogAnalyzeLineDataCopyWithImpl(this._self, this._then);

  final LogAnalyzeLineData _self;
  final $Res Function(LogAnalyzeLineData) _then;

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
    return _then(_self.copyWith(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as String?,
      dateTime: freezed == dateTime
          ? _self.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _LogAnalyzeLineData implements LogAnalyzeLineData {
  const _LogAnalyzeLineData(
      {required this.type, required this.title, this.data, this.dateTime});

  @override
  final String type;
  @override
  final String title;
  @override
  final String? data;
  @override
  final String? dateTime;

  /// Create a copy of LogAnalyzeLineData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LogAnalyzeLineDataCopyWith<_LogAnalyzeLineData> get copyWith =>
      __$LogAnalyzeLineDataCopyWithImpl<_LogAnalyzeLineData>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LogAnalyzeLineData &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime));
  }

  @override
  int get hashCode => Object.hash(runtimeType, type, title, data, dateTime);

  @override
  String toString() {
    return 'LogAnalyzeLineData(type: $type, title: $title, data: $data, dateTime: $dateTime)';
  }
}

/// @nodoc
abstract mixin class _$LogAnalyzeLineDataCopyWith<$Res>
    implements $LogAnalyzeLineDataCopyWith<$Res> {
  factory _$LogAnalyzeLineDataCopyWith(
          _LogAnalyzeLineData value, $Res Function(_LogAnalyzeLineData) _then) =
      __$LogAnalyzeLineDataCopyWithImpl;
  @override
  @useResult
  $Res call({String type, String title, String? data, String? dateTime});
}

/// @nodoc
class __$LogAnalyzeLineDataCopyWithImpl<$Res>
    implements _$LogAnalyzeLineDataCopyWith<$Res> {
  __$LogAnalyzeLineDataCopyWithImpl(this._self, this._then);

  final _LogAnalyzeLineData _self;
  final $Res Function(_LogAnalyzeLineData) _then;

  /// Create a copy of LogAnalyzeLineData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? type = null,
    Object? title = null,
    Object? data = freezed,
    Object? dateTime = freezed,
  }) {
    return _then(_LogAnalyzeLineData(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as String?,
      dateTime: freezed == dateTime
          ? _self.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
