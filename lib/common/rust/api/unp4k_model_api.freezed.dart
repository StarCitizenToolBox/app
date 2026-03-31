// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unp4k_model_api.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AssemblyGraphStats {

 int get nodes; int get geometryNodes; int get objectContainers; int get roots;
/// Create a copy of AssemblyGraphStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssemblyGraphStatsCopyWith<AssemblyGraphStats> get copyWith => _$AssemblyGraphStatsCopyWithImpl<AssemblyGraphStats>(this as AssemblyGraphStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssemblyGraphStats&&(identical(other.nodes, nodes) || other.nodes == nodes)&&(identical(other.geometryNodes, geometryNodes) || other.geometryNodes == geometryNodes)&&(identical(other.objectContainers, objectContainers) || other.objectContainers == objectContainers)&&(identical(other.roots, roots) || other.roots == roots));
}


@override
int get hashCode => Object.hash(runtimeType,nodes,geometryNodes,objectContainers,roots);

@override
String toString() {
  return 'AssemblyGraphStats(nodes: $nodes, geometryNodes: $geometryNodes, objectContainers: $objectContainers, roots: $roots)';
}


}

/// @nodoc
abstract mixin class $AssemblyGraphStatsCopyWith<$Res>  {
  factory $AssemblyGraphStatsCopyWith(AssemblyGraphStats value, $Res Function(AssemblyGraphStats) _then) = _$AssemblyGraphStatsCopyWithImpl;
@useResult
$Res call({
 int nodes, int geometryNodes, int objectContainers, int roots
});




}
/// @nodoc
class _$AssemblyGraphStatsCopyWithImpl<$Res>
    implements $AssemblyGraphStatsCopyWith<$Res> {
  _$AssemblyGraphStatsCopyWithImpl(this._self, this._then);

  final AssemblyGraphStats _self;
  final $Res Function(AssemblyGraphStats) _then;

/// Create a copy of AssemblyGraphStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nodes = null,Object? geometryNodes = null,Object? objectContainers = null,Object? roots = null,}) {
  return _then(_self.copyWith(
nodes: null == nodes ? _self.nodes : nodes // ignore: cast_nullable_to_non_nullable
as int,geometryNodes: null == geometryNodes ? _self.geometryNodes : geometryNodes // ignore: cast_nullable_to_non_nullable
as int,objectContainers: null == objectContainers ? _self.objectContainers : objectContainers // ignore: cast_nullable_to_non_nullable
as int,roots: null == roots ? _self.roots : roots // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AssemblyGraphStats].
extension AssemblyGraphStatsPatterns on AssemblyGraphStats {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssemblyGraphStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssemblyGraphStats() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssemblyGraphStats value)  $default,){
final _that = this;
switch (_that) {
case _AssemblyGraphStats():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssemblyGraphStats value)?  $default,){
final _that = this;
switch (_that) {
case _AssemblyGraphStats() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int nodes,  int geometryNodes,  int objectContainers,  int roots)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssemblyGraphStats() when $default != null:
return $default(_that.nodes,_that.geometryNodes,_that.objectContainers,_that.roots);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int nodes,  int geometryNodes,  int objectContainers,  int roots)  $default,) {final _that = this;
switch (_that) {
case _AssemblyGraphStats():
return $default(_that.nodes,_that.geometryNodes,_that.objectContainers,_that.roots);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int nodes,  int geometryNodes,  int objectContainers,  int roots)?  $default,) {final _that = this;
switch (_that) {
case _AssemblyGraphStats() when $default != null:
return $default(_that.nodes,_that.geometryNodes,_that.objectContainers,_that.roots);case _:
  return null;

}
}

}

/// @nodoc


class _AssemblyGraphStats implements AssemblyGraphStats {
  const _AssemblyGraphStats({required this.nodes, required this.geometryNodes, required this.objectContainers, required this.roots});
  

@override final  int nodes;
@override final  int geometryNodes;
@override final  int objectContainers;
@override final  int roots;

/// Create a copy of AssemblyGraphStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssemblyGraphStatsCopyWith<_AssemblyGraphStats> get copyWith => __$AssemblyGraphStatsCopyWithImpl<_AssemblyGraphStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssemblyGraphStats&&(identical(other.nodes, nodes) || other.nodes == nodes)&&(identical(other.geometryNodes, geometryNodes) || other.geometryNodes == geometryNodes)&&(identical(other.objectContainers, objectContainers) || other.objectContainers == objectContainers)&&(identical(other.roots, roots) || other.roots == roots));
}


@override
int get hashCode => Object.hash(runtimeType,nodes,geometryNodes,objectContainers,roots);

@override
String toString() {
  return 'AssemblyGraphStats(nodes: $nodes, geometryNodes: $geometryNodes, objectContainers: $objectContainers, roots: $roots)';
}


}

/// @nodoc
abstract mixin class _$AssemblyGraphStatsCopyWith<$Res> implements $AssemblyGraphStatsCopyWith<$Res> {
  factory _$AssemblyGraphStatsCopyWith(_AssemblyGraphStats value, $Res Function(_AssemblyGraphStats) _then) = __$AssemblyGraphStatsCopyWithImpl;
@override @useResult
$Res call({
 int nodes, int geometryNodes, int objectContainers, int roots
});




}
/// @nodoc
class __$AssemblyGraphStatsCopyWithImpl<$Res>
    implements _$AssemblyGraphStatsCopyWith<$Res> {
  __$AssemblyGraphStatsCopyWithImpl(this._self, this._then);

  final _AssemblyGraphStats _self;
  final $Res Function(_AssemblyGraphStats) _then;

/// Create a copy of AssemblyGraphStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nodes = null,Object? geometryNodes = null,Object? objectContainers = null,Object? roots = null,}) {
  return _then(_AssemblyGraphStats(
nodes: null == nodes ? _self.nodes : nodes // ignore: cast_nullable_to_non_nullable
as int,geometryNodes: null == geometryNodes ? _self.geometryNodes : geometryNodes // ignore: cast_nullable_to_non_nullable
as int,objectContainers: null == objectContainers ? _self.objectContainers : objectContainers // ignore: cast_nullable_to_non_nullable
as int,roots: null == roots ? _self.roots : roots // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$LocalBatchConvertResult {

 bool get success; String? get mergedOutputPath; String? get assemblyManifestPath; String? get assemblyReportPath; int get successCount; int get emptyCount; int get failedCount; List<String> get warnings; List<LocalBatchFileResult> get files; String get sourceMode; AssemblyGraphStats get assemblyGraphStats; List<String> get fallbackReasonByFile; String? get errorCode; String? get errorMessage;
/// Create a copy of LocalBatchConvertResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocalBatchConvertResultCopyWith<LocalBatchConvertResult> get copyWith => _$LocalBatchConvertResultCopyWithImpl<LocalBatchConvertResult>(this as LocalBatchConvertResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalBatchConvertResult&&(identical(other.success, success) || other.success == success)&&(identical(other.mergedOutputPath, mergedOutputPath) || other.mergedOutputPath == mergedOutputPath)&&(identical(other.assemblyManifestPath, assemblyManifestPath) || other.assemblyManifestPath == assemblyManifestPath)&&(identical(other.assemblyReportPath, assemblyReportPath) || other.assemblyReportPath == assemblyReportPath)&&(identical(other.successCount, successCount) || other.successCount == successCount)&&(identical(other.emptyCount, emptyCount) || other.emptyCount == emptyCount)&&(identical(other.failedCount, failedCount) || other.failedCount == failedCount)&&const DeepCollectionEquality().equals(other.warnings, warnings)&&const DeepCollectionEquality().equals(other.files, files)&&(identical(other.sourceMode, sourceMode) || other.sourceMode == sourceMode)&&(identical(other.assemblyGraphStats, assemblyGraphStats) || other.assemblyGraphStats == assemblyGraphStats)&&const DeepCollectionEquality().equals(other.fallbackReasonByFile, fallbackReasonByFile)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,success,mergedOutputPath,assemblyManifestPath,assemblyReportPath,successCount,emptyCount,failedCount,const DeepCollectionEquality().hash(warnings),const DeepCollectionEquality().hash(files),sourceMode,assemblyGraphStats,const DeepCollectionEquality().hash(fallbackReasonByFile),errorCode,errorMessage);

@override
String toString() {
  return 'LocalBatchConvertResult(success: $success, mergedOutputPath: $mergedOutputPath, assemblyManifestPath: $assemblyManifestPath, assemblyReportPath: $assemblyReportPath, successCount: $successCount, emptyCount: $emptyCount, failedCount: $failedCount, warnings: $warnings, files: $files, sourceMode: $sourceMode, assemblyGraphStats: $assemblyGraphStats, fallbackReasonByFile: $fallbackReasonByFile, errorCode: $errorCode, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $LocalBatchConvertResultCopyWith<$Res>  {
  factory $LocalBatchConvertResultCopyWith(LocalBatchConvertResult value, $Res Function(LocalBatchConvertResult) _then) = _$LocalBatchConvertResultCopyWithImpl;
@useResult
$Res call({
 bool success, String? mergedOutputPath, String? assemblyManifestPath, String? assemblyReportPath, int successCount, int emptyCount, int failedCount, List<String> warnings, List<LocalBatchFileResult> files, String sourceMode, AssemblyGraphStats assemblyGraphStats, List<String> fallbackReasonByFile, String? errorCode, String? errorMessage
});


$AssemblyGraphStatsCopyWith<$Res> get assemblyGraphStats;

}
/// @nodoc
class _$LocalBatchConvertResultCopyWithImpl<$Res>
    implements $LocalBatchConvertResultCopyWith<$Res> {
  _$LocalBatchConvertResultCopyWithImpl(this._self, this._then);

  final LocalBatchConvertResult _self;
  final $Res Function(LocalBatchConvertResult) _then;

/// Create a copy of LocalBatchConvertResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? mergedOutputPath = freezed,Object? assemblyManifestPath = freezed,Object? assemblyReportPath = freezed,Object? successCount = null,Object? emptyCount = null,Object? failedCount = null,Object? warnings = null,Object? files = null,Object? sourceMode = null,Object? assemblyGraphStats = null,Object? fallbackReasonByFile = null,Object? errorCode = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,mergedOutputPath: freezed == mergedOutputPath ? _self.mergedOutputPath : mergedOutputPath // ignore: cast_nullable_to_non_nullable
as String?,assemblyManifestPath: freezed == assemblyManifestPath ? _self.assemblyManifestPath : assemblyManifestPath // ignore: cast_nullable_to_non_nullable
as String?,assemblyReportPath: freezed == assemblyReportPath ? _self.assemblyReportPath : assemblyReportPath // ignore: cast_nullable_to_non_nullable
as String?,successCount: null == successCount ? _self.successCount : successCount // ignore: cast_nullable_to_non_nullable
as int,emptyCount: null == emptyCount ? _self.emptyCount : emptyCount // ignore: cast_nullable_to_non_nullable
as int,failedCount: null == failedCount ? _self.failedCount : failedCount // ignore: cast_nullable_to_non_nullable
as int,warnings: null == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<LocalBatchFileResult>,sourceMode: null == sourceMode ? _self.sourceMode : sourceMode // ignore: cast_nullable_to_non_nullable
as String,assemblyGraphStats: null == assemblyGraphStats ? _self.assemblyGraphStats : assemblyGraphStats // ignore: cast_nullable_to_non_nullable
as AssemblyGraphStats,fallbackReasonByFile: null == fallbackReasonByFile ? _self.fallbackReasonByFile : fallbackReasonByFile // ignore: cast_nullable_to_non_nullable
as List<String>,errorCode: freezed == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of LocalBatchConvertResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssemblyGraphStatsCopyWith<$Res> get assemblyGraphStats {
  
  return $AssemblyGraphStatsCopyWith<$Res>(_self.assemblyGraphStats, (value) {
    return _then(_self.copyWith(assemblyGraphStats: value));
  });
}
}


/// Adds pattern-matching-related methods to [LocalBatchConvertResult].
extension LocalBatchConvertResultPatterns on LocalBatchConvertResult {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocalBatchConvertResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocalBatchConvertResult() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocalBatchConvertResult value)  $default,){
final _that = this;
switch (_that) {
case _LocalBatchConvertResult():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocalBatchConvertResult value)?  $default,){
final _that = this;
switch (_that) {
case _LocalBatchConvertResult() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  String? mergedOutputPath,  String? assemblyManifestPath,  String? assemblyReportPath,  int successCount,  int emptyCount,  int failedCount,  List<String> warnings,  List<LocalBatchFileResult> files,  String sourceMode,  AssemblyGraphStats assemblyGraphStats,  List<String> fallbackReasonByFile,  String? errorCode,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocalBatchConvertResult() when $default != null:
return $default(_that.success,_that.mergedOutputPath,_that.assemblyManifestPath,_that.assemblyReportPath,_that.successCount,_that.emptyCount,_that.failedCount,_that.warnings,_that.files,_that.sourceMode,_that.assemblyGraphStats,_that.fallbackReasonByFile,_that.errorCode,_that.errorMessage);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  String? mergedOutputPath,  String? assemblyManifestPath,  String? assemblyReportPath,  int successCount,  int emptyCount,  int failedCount,  List<String> warnings,  List<LocalBatchFileResult> files,  String sourceMode,  AssemblyGraphStats assemblyGraphStats,  List<String> fallbackReasonByFile,  String? errorCode,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _LocalBatchConvertResult():
return $default(_that.success,_that.mergedOutputPath,_that.assemblyManifestPath,_that.assemblyReportPath,_that.successCount,_that.emptyCount,_that.failedCount,_that.warnings,_that.files,_that.sourceMode,_that.assemblyGraphStats,_that.fallbackReasonByFile,_that.errorCode,_that.errorMessage);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  String? mergedOutputPath,  String? assemblyManifestPath,  String? assemblyReportPath,  int successCount,  int emptyCount,  int failedCount,  List<String> warnings,  List<LocalBatchFileResult> files,  String sourceMode,  AssemblyGraphStats assemblyGraphStats,  List<String> fallbackReasonByFile,  String? errorCode,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _LocalBatchConvertResult() when $default != null:
return $default(_that.success,_that.mergedOutputPath,_that.assemblyManifestPath,_that.assemblyReportPath,_that.successCount,_that.emptyCount,_that.failedCount,_that.warnings,_that.files,_that.sourceMode,_that.assemblyGraphStats,_that.fallbackReasonByFile,_that.errorCode,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _LocalBatchConvertResult implements LocalBatchConvertResult {
  const _LocalBatchConvertResult({required this.success, this.mergedOutputPath, this.assemblyManifestPath, this.assemblyReportPath, required this.successCount, required this.emptyCount, required this.failedCount, required final  List<String> warnings, required final  List<LocalBatchFileResult> files, required this.sourceMode, required this.assemblyGraphStats, required final  List<String> fallbackReasonByFile, this.errorCode, this.errorMessage}): _warnings = warnings,_files = files,_fallbackReasonByFile = fallbackReasonByFile;
  

@override final  bool success;
@override final  String? mergedOutputPath;
@override final  String? assemblyManifestPath;
@override final  String? assemblyReportPath;
@override final  int successCount;
@override final  int emptyCount;
@override final  int failedCount;
 final  List<String> _warnings;
@override List<String> get warnings {
  if (_warnings is EqualUnmodifiableListView) return _warnings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_warnings);
}

 final  List<LocalBatchFileResult> _files;
@override List<LocalBatchFileResult> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}

@override final  String sourceMode;
@override final  AssemblyGraphStats assemblyGraphStats;
 final  List<String> _fallbackReasonByFile;
@override List<String> get fallbackReasonByFile {
  if (_fallbackReasonByFile is EqualUnmodifiableListView) return _fallbackReasonByFile;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fallbackReasonByFile);
}

@override final  String? errorCode;
@override final  String? errorMessage;

/// Create a copy of LocalBatchConvertResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocalBatchConvertResultCopyWith<_LocalBatchConvertResult> get copyWith => __$LocalBatchConvertResultCopyWithImpl<_LocalBatchConvertResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocalBatchConvertResult&&(identical(other.success, success) || other.success == success)&&(identical(other.mergedOutputPath, mergedOutputPath) || other.mergedOutputPath == mergedOutputPath)&&(identical(other.assemblyManifestPath, assemblyManifestPath) || other.assemblyManifestPath == assemblyManifestPath)&&(identical(other.assemblyReportPath, assemblyReportPath) || other.assemblyReportPath == assemblyReportPath)&&(identical(other.successCount, successCount) || other.successCount == successCount)&&(identical(other.emptyCount, emptyCount) || other.emptyCount == emptyCount)&&(identical(other.failedCount, failedCount) || other.failedCount == failedCount)&&const DeepCollectionEquality().equals(other._warnings, _warnings)&&const DeepCollectionEquality().equals(other._files, _files)&&(identical(other.sourceMode, sourceMode) || other.sourceMode == sourceMode)&&(identical(other.assemblyGraphStats, assemblyGraphStats) || other.assemblyGraphStats == assemblyGraphStats)&&const DeepCollectionEquality().equals(other._fallbackReasonByFile, _fallbackReasonByFile)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,success,mergedOutputPath,assemblyManifestPath,assemblyReportPath,successCount,emptyCount,failedCount,const DeepCollectionEquality().hash(_warnings),const DeepCollectionEquality().hash(_files),sourceMode,assemblyGraphStats,const DeepCollectionEquality().hash(_fallbackReasonByFile),errorCode,errorMessage);

@override
String toString() {
  return 'LocalBatchConvertResult(success: $success, mergedOutputPath: $mergedOutputPath, assemblyManifestPath: $assemblyManifestPath, assemblyReportPath: $assemblyReportPath, successCount: $successCount, emptyCount: $emptyCount, failedCount: $failedCount, warnings: $warnings, files: $files, sourceMode: $sourceMode, assemblyGraphStats: $assemblyGraphStats, fallbackReasonByFile: $fallbackReasonByFile, errorCode: $errorCode, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$LocalBatchConvertResultCopyWith<$Res> implements $LocalBatchConvertResultCopyWith<$Res> {
  factory _$LocalBatchConvertResultCopyWith(_LocalBatchConvertResult value, $Res Function(_LocalBatchConvertResult) _then) = __$LocalBatchConvertResultCopyWithImpl;
@override @useResult
$Res call({
 bool success, String? mergedOutputPath, String? assemblyManifestPath, String? assemblyReportPath, int successCount, int emptyCount, int failedCount, List<String> warnings, List<LocalBatchFileResult> files, String sourceMode, AssemblyGraphStats assemblyGraphStats, List<String> fallbackReasonByFile, String? errorCode, String? errorMessage
});


@override $AssemblyGraphStatsCopyWith<$Res> get assemblyGraphStats;

}
/// @nodoc
class __$LocalBatchConvertResultCopyWithImpl<$Res>
    implements _$LocalBatchConvertResultCopyWith<$Res> {
  __$LocalBatchConvertResultCopyWithImpl(this._self, this._then);

  final _LocalBatchConvertResult _self;
  final $Res Function(_LocalBatchConvertResult) _then;

/// Create a copy of LocalBatchConvertResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? mergedOutputPath = freezed,Object? assemblyManifestPath = freezed,Object? assemblyReportPath = freezed,Object? successCount = null,Object? emptyCount = null,Object? failedCount = null,Object? warnings = null,Object? files = null,Object? sourceMode = null,Object? assemblyGraphStats = null,Object? fallbackReasonByFile = null,Object? errorCode = freezed,Object? errorMessage = freezed,}) {
  return _then(_LocalBatchConvertResult(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,mergedOutputPath: freezed == mergedOutputPath ? _self.mergedOutputPath : mergedOutputPath // ignore: cast_nullable_to_non_nullable
as String?,assemblyManifestPath: freezed == assemblyManifestPath ? _self.assemblyManifestPath : assemblyManifestPath // ignore: cast_nullable_to_non_nullable
as String?,assemblyReportPath: freezed == assemblyReportPath ? _self.assemblyReportPath : assemblyReportPath // ignore: cast_nullable_to_non_nullable
as String?,successCount: null == successCount ? _self.successCount : successCount // ignore: cast_nullable_to_non_nullable
as int,emptyCount: null == emptyCount ? _self.emptyCount : emptyCount // ignore: cast_nullable_to_non_nullable
as int,failedCount: null == failedCount ? _self.failedCount : failedCount // ignore: cast_nullable_to_non_nullable
as int,warnings: null == warnings ? _self._warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<LocalBatchFileResult>,sourceMode: null == sourceMode ? _self.sourceMode : sourceMode // ignore: cast_nullable_to_non_nullable
as String,assemblyGraphStats: null == assemblyGraphStats ? _self.assemblyGraphStats : assemblyGraphStats // ignore: cast_nullable_to_non_nullable
as AssemblyGraphStats,fallbackReasonByFile: null == fallbackReasonByFile ? _self._fallbackReasonByFile : fallbackReasonByFile // ignore: cast_nullable_to_non_nullable
as List<String>,errorCode: freezed == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of LocalBatchConvertResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssemblyGraphStatsCopyWith<$Res> get assemblyGraphStats {
  
  return $AssemblyGraphStatsCopyWith<$Res>(_self.assemblyGraphStats, (value) {
    return _then(_self.copyWith(assemblyGraphStats: value));
  });
}
}

/// @nodoc
mixin _$LocalBatchFileResult {

 String get modelPath; String? get outputPath; bool get hasGeometry; String? get errorCode; String? get errorMessage; List<String> get warnings; String get sourceMode; String? get fallbackReason;
/// Create a copy of LocalBatchFileResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocalBatchFileResultCopyWith<LocalBatchFileResult> get copyWith => _$LocalBatchFileResultCopyWithImpl<LocalBatchFileResult>(this as LocalBatchFileResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalBatchFileResult&&(identical(other.modelPath, modelPath) || other.modelPath == modelPath)&&(identical(other.outputPath, outputPath) || other.outputPath == outputPath)&&(identical(other.hasGeometry, hasGeometry) || other.hasGeometry == hasGeometry)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other.warnings, warnings)&&(identical(other.sourceMode, sourceMode) || other.sourceMode == sourceMode)&&(identical(other.fallbackReason, fallbackReason) || other.fallbackReason == fallbackReason));
}


@override
int get hashCode => Object.hash(runtimeType,modelPath,outputPath,hasGeometry,errorCode,errorMessage,const DeepCollectionEquality().hash(warnings),sourceMode,fallbackReason);

@override
String toString() {
  return 'LocalBatchFileResult(modelPath: $modelPath, outputPath: $outputPath, hasGeometry: $hasGeometry, errorCode: $errorCode, errorMessage: $errorMessage, warnings: $warnings, sourceMode: $sourceMode, fallbackReason: $fallbackReason)';
}


}

/// @nodoc
abstract mixin class $LocalBatchFileResultCopyWith<$Res>  {
  factory $LocalBatchFileResultCopyWith(LocalBatchFileResult value, $Res Function(LocalBatchFileResult) _then) = _$LocalBatchFileResultCopyWithImpl;
@useResult
$Res call({
 String modelPath, String? outputPath, bool hasGeometry, String? errorCode, String? errorMessage, List<String> warnings, String sourceMode, String? fallbackReason
});




}
/// @nodoc
class _$LocalBatchFileResultCopyWithImpl<$Res>
    implements $LocalBatchFileResultCopyWith<$Res> {
  _$LocalBatchFileResultCopyWithImpl(this._self, this._then);

  final LocalBatchFileResult _self;
  final $Res Function(LocalBatchFileResult) _then;

/// Create a copy of LocalBatchFileResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? modelPath = null,Object? outputPath = freezed,Object? hasGeometry = null,Object? errorCode = freezed,Object? errorMessage = freezed,Object? warnings = null,Object? sourceMode = null,Object? fallbackReason = freezed,}) {
  return _then(_self.copyWith(
modelPath: null == modelPath ? _self.modelPath : modelPath // ignore: cast_nullable_to_non_nullable
as String,outputPath: freezed == outputPath ? _self.outputPath : outputPath // ignore: cast_nullable_to_non_nullable
as String?,hasGeometry: null == hasGeometry ? _self.hasGeometry : hasGeometry // ignore: cast_nullable_to_non_nullable
as bool,errorCode: freezed == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,warnings: null == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,sourceMode: null == sourceMode ? _self.sourceMode : sourceMode // ignore: cast_nullable_to_non_nullable
as String,fallbackReason: freezed == fallbackReason ? _self.fallbackReason : fallbackReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LocalBatchFileResult].
extension LocalBatchFileResultPatterns on LocalBatchFileResult {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocalBatchFileResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocalBatchFileResult() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocalBatchFileResult value)  $default,){
final _that = this;
switch (_that) {
case _LocalBatchFileResult():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocalBatchFileResult value)?  $default,){
final _that = this;
switch (_that) {
case _LocalBatchFileResult() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String modelPath,  String? outputPath,  bool hasGeometry,  String? errorCode,  String? errorMessage,  List<String> warnings,  String sourceMode,  String? fallbackReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocalBatchFileResult() when $default != null:
return $default(_that.modelPath,_that.outputPath,_that.hasGeometry,_that.errorCode,_that.errorMessage,_that.warnings,_that.sourceMode,_that.fallbackReason);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String modelPath,  String? outputPath,  bool hasGeometry,  String? errorCode,  String? errorMessage,  List<String> warnings,  String sourceMode,  String? fallbackReason)  $default,) {final _that = this;
switch (_that) {
case _LocalBatchFileResult():
return $default(_that.modelPath,_that.outputPath,_that.hasGeometry,_that.errorCode,_that.errorMessage,_that.warnings,_that.sourceMode,_that.fallbackReason);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String modelPath,  String? outputPath,  bool hasGeometry,  String? errorCode,  String? errorMessage,  List<String> warnings,  String sourceMode,  String? fallbackReason)?  $default,) {final _that = this;
switch (_that) {
case _LocalBatchFileResult() when $default != null:
return $default(_that.modelPath,_that.outputPath,_that.hasGeometry,_that.errorCode,_that.errorMessage,_that.warnings,_that.sourceMode,_that.fallbackReason);case _:
  return null;

}
}

}

/// @nodoc


class _LocalBatchFileResult implements LocalBatchFileResult {
  const _LocalBatchFileResult({required this.modelPath, this.outputPath, required this.hasGeometry, this.errorCode, this.errorMessage, required final  List<String> warnings, required this.sourceMode, this.fallbackReason}): _warnings = warnings;
  

@override final  String modelPath;
@override final  String? outputPath;
@override final  bool hasGeometry;
@override final  String? errorCode;
@override final  String? errorMessage;
 final  List<String> _warnings;
@override List<String> get warnings {
  if (_warnings is EqualUnmodifiableListView) return _warnings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_warnings);
}

@override final  String sourceMode;
@override final  String? fallbackReason;

/// Create a copy of LocalBatchFileResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocalBatchFileResultCopyWith<_LocalBatchFileResult> get copyWith => __$LocalBatchFileResultCopyWithImpl<_LocalBatchFileResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocalBatchFileResult&&(identical(other.modelPath, modelPath) || other.modelPath == modelPath)&&(identical(other.outputPath, outputPath) || other.outputPath == outputPath)&&(identical(other.hasGeometry, hasGeometry) || other.hasGeometry == hasGeometry)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other._warnings, _warnings)&&(identical(other.sourceMode, sourceMode) || other.sourceMode == sourceMode)&&(identical(other.fallbackReason, fallbackReason) || other.fallbackReason == fallbackReason));
}


@override
int get hashCode => Object.hash(runtimeType,modelPath,outputPath,hasGeometry,errorCode,errorMessage,const DeepCollectionEquality().hash(_warnings),sourceMode,fallbackReason);

@override
String toString() {
  return 'LocalBatchFileResult(modelPath: $modelPath, outputPath: $outputPath, hasGeometry: $hasGeometry, errorCode: $errorCode, errorMessage: $errorMessage, warnings: $warnings, sourceMode: $sourceMode, fallbackReason: $fallbackReason)';
}


}

/// @nodoc
abstract mixin class _$LocalBatchFileResultCopyWith<$Res> implements $LocalBatchFileResultCopyWith<$Res> {
  factory _$LocalBatchFileResultCopyWith(_LocalBatchFileResult value, $Res Function(_LocalBatchFileResult) _then) = __$LocalBatchFileResultCopyWithImpl;
@override @useResult
$Res call({
 String modelPath, String? outputPath, bool hasGeometry, String? errorCode, String? errorMessage, List<String> warnings, String sourceMode, String? fallbackReason
});




}
/// @nodoc
class __$LocalBatchFileResultCopyWithImpl<$Res>
    implements _$LocalBatchFileResultCopyWith<$Res> {
  __$LocalBatchFileResultCopyWithImpl(this._self, this._then);

  final _LocalBatchFileResult _self;
  final $Res Function(_LocalBatchFileResult) _then;

/// Create a copy of LocalBatchFileResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? modelPath = null,Object? outputPath = freezed,Object? hasGeometry = null,Object? errorCode = freezed,Object? errorMessage = freezed,Object? warnings = null,Object? sourceMode = null,Object? fallbackReason = freezed,}) {
  return _then(_LocalBatchFileResult(
modelPath: null == modelPath ? _self.modelPath : modelPath // ignore: cast_nullable_to_non_nullable
as String,outputPath: freezed == outputPath ? _self.outputPath : outputPath // ignore: cast_nullable_to_non_nullable
as String?,hasGeometry: null == hasGeometry ? _self.hasGeometry : hasGeometry // ignore: cast_nullable_to_non_nullable
as bool,errorCode: freezed == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,warnings: null == warnings ? _self._warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,sourceMode: null == sourceMode ? _self.sourceMode : sourceMode // ignore: cast_nullable_to_non_nullable
as String,fallbackReason: freezed == fallbackReason ? _self.fallbackReason : fallbackReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$ModelConvertOptions {

 bool get embedTextures; bool get overwrite; int? get maxTextureSize;
/// Create a copy of ModelConvertOptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModelConvertOptionsCopyWith<ModelConvertOptions> get copyWith => _$ModelConvertOptionsCopyWithImpl<ModelConvertOptions>(this as ModelConvertOptions, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModelConvertOptions&&(identical(other.embedTextures, embedTextures) || other.embedTextures == embedTextures)&&(identical(other.overwrite, overwrite) || other.overwrite == overwrite)&&(identical(other.maxTextureSize, maxTextureSize) || other.maxTextureSize == maxTextureSize));
}


@override
int get hashCode => Object.hash(runtimeType,embedTextures,overwrite,maxTextureSize);

@override
String toString() {
  return 'ModelConvertOptions(embedTextures: $embedTextures, overwrite: $overwrite, maxTextureSize: $maxTextureSize)';
}


}

/// @nodoc
abstract mixin class $ModelConvertOptionsCopyWith<$Res>  {
  factory $ModelConvertOptionsCopyWith(ModelConvertOptions value, $Res Function(ModelConvertOptions) _then) = _$ModelConvertOptionsCopyWithImpl;
@useResult
$Res call({
 bool embedTextures, bool overwrite, int? maxTextureSize
});




}
/// @nodoc
class _$ModelConvertOptionsCopyWithImpl<$Res>
    implements $ModelConvertOptionsCopyWith<$Res> {
  _$ModelConvertOptionsCopyWithImpl(this._self, this._then);

  final ModelConvertOptions _self;
  final $Res Function(ModelConvertOptions) _then;

/// Create a copy of ModelConvertOptions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? embedTextures = null,Object? overwrite = null,Object? maxTextureSize = freezed,}) {
  return _then(_self.copyWith(
embedTextures: null == embedTextures ? _self.embedTextures : embedTextures // ignore: cast_nullable_to_non_nullable
as bool,overwrite: null == overwrite ? _self.overwrite : overwrite // ignore: cast_nullable_to_non_nullable
as bool,maxTextureSize: freezed == maxTextureSize ? _self.maxTextureSize : maxTextureSize // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ModelConvertOptions].
extension ModelConvertOptionsPatterns on ModelConvertOptions {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModelConvertOptions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModelConvertOptions() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModelConvertOptions value)  $default,){
final _that = this;
switch (_that) {
case _ModelConvertOptions():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModelConvertOptions value)?  $default,){
final _that = this;
switch (_that) {
case _ModelConvertOptions() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool embedTextures,  bool overwrite,  int? maxTextureSize)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModelConvertOptions() when $default != null:
return $default(_that.embedTextures,_that.overwrite,_that.maxTextureSize);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool embedTextures,  bool overwrite,  int? maxTextureSize)  $default,) {final _that = this;
switch (_that) {
case _ModelConvertOptions():
return $default(_that.embedTextures,_that.overwrite,_that.maxTextureSize);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool embedTextures,  bool overwrite,  int? maxTextureSize)?  $default,) {final _that = this;
switch (_that) {
case _ModelConvertOptions() when $default != null:
return $default(_that.embedTextures,_that.overwrite,_that.maxTextureSize);case _:
  return null;

}
}

}

/// @nodoc


class _ModelConvertOptions implements ModelConvertOptions {
  const _ModelConvertOptions({required this.embedTextures, required this.overwrite, this.maxTextureSize});
  

@override final  bool embedTextures;
@override final  bool overwrite;
@override final  int? maxTextureSize;

/// Create a copy of ModelConvertOptions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModelConvertOptionsCopyWith<_ModelConvertOptions> get copyWith => __$ModelConvertOptionsCopyWithImpl<_ModelConvertOptions>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModelConvertOptions&&(identical(other.embedTextures, embedTextures) || other.embedTextures == embedTextures)&&(identical(other.overwrite, overwrite) || other.overwrite == overwrite)&&(identical(other.maxTextureSize, maxTextureSize) || other.maxTextureSize == maxTextureSize));
}


@override
int get hashCode => Object.hash(runtimeType,embedTextures,overwrite,maxTextureSize);

@override
String toString() {
  return 'ModelConvertOptions(embedTextures: $embedTextures, overwrite: $overwrite, maxTextureSize: $maxTextureSize)';
}


}

/// @nodoc
abstract mixin class _$ModelConvertOptionsCopyWith<$Res> implements $ModelConvertOptionsCopyWith<$Res> {
  factory _$ModelConvertOptionsCopyWith(_ModelConvertOptions value, $Res Function(_ModelConvertOptions) _then) = __$ModelConvertOptionsCopyWithImpl;
@override @useResult
$Res call({
 bool embedTextures, bool overwrite, int? maxTextureSize
});




}
/// @nodoc
class __$ModelConvertOptionsCopyWithImpl<$Res>
    implements _$ModelConvertOptionsCopyWith<$Res> {
  __$ModelConvertOptionsCopyWithImpl(this._self, this._then);

  final _ModelConvertOptions _self;
  final $Res Function(_ModelConvertOptions) _then;

/// Create a copy of ModelConvertOptions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? embedTextures = null,Object? overwrite = null,Object? maxTextureSize = freezed,}) {
  return _then(_ModelConvertOptions(
embedTextures: null == embedTextures ? _self.embedTextures : embedTextures // ignore: cast_nullable_to_non_nullable
as bool,overwrite: null == overwrite ? _self.overwrite : overwrite // ignore: cast_nullable_to_non_nullable
as bool,maxTextureSize: freezed == maxTextureSize ? _self.maxTextureSize : maxTextureSize // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$ModelConvertResult {

 bool get success; String? get outputPath; String? get errorCode; String? get errorMessage; List<String> get warnings;
/// Create a copy of ModelConvertResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModelConvertResultCopyWith<ModelConvertResult> get copyWith => _$ModelConvertResultCopyWithImpl<ModelConvertResult>(this as ModelConvertResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModelConvertResult&&(identical(other.success, success) || other.success == success)&&(identical(other.outputPath, outputPath) || other.outputPath == outputPath)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other.warnings, warnings));
}


@override
int get hashCode => Object.hash(runtimeType,success,outputPath,errorCode,errorMessage,const DeepCollectionEquality().hash(warnings));

@override
String toString() {
  return 'ModelConvertResult(success: $success, outputPath: $outputPath, errorCode: $errorCode, errorMessage: $errorMessage, warnings: $warnings)';
}


}

/// @nodoc
abstract mixin class $ModelConvertResultCopyWith<$Res>  {
  factory $ModelConvertResultCopyWith(ModelConvertResult value, $Res Function(ModelConvertResult) _then) = _$ModelConvertResultCopyWithImpl;
@useResult
$Res call({
 bool success, String? outputPath, String? errorCode, String? errorMessage, List<String> warnings
});




}
/// @nodoc
class _$ModelConvertResultCopyWithImpl<$Res>
    implements $ModelConvertResultCopyWith<$Res> {
  _$ModelConvertResultCopyWithImpl(this._self, this._then);

  final ModelConvertResult _self;
  final $Res Function(ModelConvertResult) _then;

/// Create a copy of ModelConvertResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? outputPath = freezed,Object? errorCode = freezed,Object? errorMessage = freezed,Object? warnings = null,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,outputPath: freezed == outputPath ? _self.outputPath : outputPath // ignore: cast_nullable_to_non_nullable
as String?,errorCode: freezed == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,warnings: null == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ModelConvertResult].
extension ModelConvertResultPatterns on ModelConvertResult {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModelConvertResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModelConvertResult() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModelConvertResult value)  $default,){
final _that = this;
switch (_that) {
case _ModelConvertResult():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModelConvertResult value)?  $default,){
final _that = this;
switch (_that) {
case _ModelConvertResult() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  String? outputPath,  String? errorCode,  String? errorMessage,  List<String> warnings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModelConvertResult() when $default != null:
return $default(_that.success,_that.outputPath,_that.errorCode,_that.errorMessage,_that.warnings);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  String? outputPath,  String? errorCode,  String? errorMessage,  List<String> warnings)  $default,) {final _that = this;
switch (_that) {
case _ModelConvertResult():
return $default(_that.success,_that.outputPath,_that.errorCode,_that.errorMessage,_that.warnings);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  String? outputPath,  String? errorCode,  String? errorMessage,  List<String> warnings)?  $default,) {final _that = this;
switch (_that) {
case _ModelConvertResult() when $default != null:
return $default(_that.success,_that.outputPath,_that.errorCode,_that.errorMessage,_that.warnings);case _:
  return null;

}
}

}

/// @nodoc


class _ModelConvertResult implements ModelConvertResult {
  const _ModelConvertResult({required this.success, this.outputPath, this.errorCode, this.errorMessage, required final  List<String> warnings}): _warnings = warnings;
  

@override final  bool success;
@override final  String? outputPath;
@override final  String? errorCode;
@override final  String? errorMessage;
 final  List<String> _warnings;
@override List<String> get warnings {
  if (_warnings is EqualUnmodifiableListView) return _warnings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_warnings);
}


/// Create a copy of ModelConvertResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModelConvertResultCopyWith<_ModelConvertResult> get copyWith => __$ModelConvertResultCopyWithImpl<_ModelConvertResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModelConvertResult&&(identical(other.success, success) || other.success == success)&&(identical(other.outputPath, outputPath) || other.outputPath == outputPath)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other._warnings, _warnings));
}


@override
int get hashCode => Object.hash(runtimeType,success,outputPath,errorCode,errorMessage,const DeepCollectionEquality().hash(_warnings));

@override
String toString() {
  return 'ModelConvertResult(success: $success, outputPath: $outputPath, errorCode: $errorCode, errorMessage: $errorMessage, warnings: $warnings)';
}


}

/// @nodoc
abstract mixin class _$ModelConvertResultCopyWith<$Res> implements $ModelConvertResultCopyWith<$Res> {
  factory _$ModelConvertResultCopyWith(_ModelConvertResult value, $Res Function(_ModelConvertResult) _then) = __$ModelConvertResultCopyWithImpl;
@override @useResult
$Res call({
 bool success, String? outputPath, String? errorCode, String? errorMessage, List<String> warnings
});




}
/// @nodoc
class __$ModelConvertResultCopyWithImpl<$Res>
    implements _$ModelConvertResultCopyWith<$Res> {
  __$ModelConvertResultCopyWithImpl(this._self, this._then);

  final _ModelConvertResult _self;
  final $Res Function(_ModelConvertResult) _then;

/// Create a copy of ModelConvertResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? outputPath = freezed,Object? errorCode = freezed,Object? errorMessage = freezed,Object? warnings = null,}) {
  return _then(_ModelConvertResult(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,outputPath: freezed == outputPath ? _self.outputPath : outputPath // ignore: cast_nullable_to_non_nullable
as String?,errorCode: freezed == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,warnings: null == warnings ? _self._warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
