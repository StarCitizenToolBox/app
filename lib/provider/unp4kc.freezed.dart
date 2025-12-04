// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
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

 bool get startUp; Map<String, AppUnp4kP4kItemData>? get files; MemoryFileSystem? get fs; String get curPath; String? get endMessage; MapEntry<String, String>? get tempOpenFile; String get errorMessage; String get searchQuery; bool get isSearching;/// 搜索结果的虚拟文件系统（支持分级展示）
 MemoryFileSystem? get searchFs;/// 搜索匹配的文件路径集合
 Set<String>? get searchMatchedFiles; Unp4kSortType get sortType;/// 是否处于多选模式
 bool get isMultiSelectMode;/// 多选模式下选中的文件路径集合
 Set<String> get selectedItems;
/// Create a copy of Unp4kcState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Unp4kcStateCopyWith<Unp4kcState> get copyWith => _$Unp4kcStateCopyWithImpl<Unp4kcState>(this as Unp4kcState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Unp4kcState'))
    ..add(DiagnosticsProperty('startUp', startUp))..add(DiagnosticsProperty('files', files))..add(DiagnosticsProperty('fs', fs))..add(DiagnosticsProperty('curPath', curPath))..add(DiagnosticsProperty('endMessage', endMessage))..add(DiagnosticsProperty('tempOpenFile', tempOpenFile))..add(DiagnosticsProperty('errorMessage', errorMessage))..add(DiagnosticsProperty('searchQuery', searchQuery))..add(DiagnosticsProperty('isSearching', isSearching))..add(DiagnosticsProperty('searchFs', searchFs))..add(DiagnosticsProperty('searchMatchedFiles', searchMatchedFiles))..add(DiagnosticsProperty('sortType', sortType))..add(DiagnosticsProperty('isMultiSelectMode', isMultiSelectMode))..add(DiagnosticsProperty('selectedItems', selectedItems));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Unp4kcState&&(identical(other.startUp, startUp) || other.startUp == startUp)&&const DeepCollectionEquality().equals(other.files, files)&&(identical(other.fs, fs) || other.fs == fs)&&(identical(other.curPath, curPath) || other.curPath == curPath)&&(identical(other.endMessage, endMessage) || other.endMessage == endMessage)&&(identical(other.tempOpenFile, tempOpenFile) || other.tempOpenFile == tempOpenFile)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.isSearching, isSearching) || other.isSearching == isSearching)&&(identical(other.searchFs, searchFs) || other.searchFs == searchFs)&&const DeepCollectionEquality().equals(other.searchMatchedFiles, searchMatchedFiles)&&(identical(other.sortType, sortType) || other.sortType == sortType)&&(identical(other.isMultiSelectMode, isMultiSelectMode) || other.isMultiSelectMode == isMultiSelectMode)&&const DeepCollectionEquality().equals(other.selectedItems, selectedItems));
}


@override
int get hashCode => Object.hash(runtimeType,startUp,const DeepCollectionEquality().hash(files),fs,curPath,endMessage,tempOpenFile,errorMessage,searchQuery,isSearching,searchFs,const DeepCollectionEquality().hash(searchMatchedFiles),sortType,isMultiSelectMode,const DeepCollectionEquality().hash(selectedItems));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Unp4kcState(startUp: $startUp, files: $files, fs: $fs, curPath: $curPath, endMessage: $endMessage, tempOpenFile: $tempOpenFile, errorMessage: $errorMessage, searchQuery: $searchQuery, isSearching: $isSearching, searchFs: $searchFs, searchMatchedFiles: $searchMatchedFiles, sortType: $sortType, isMultiSelectMode: $isMultiSelectMode, selectedItems: $selectedItems)';
}


}

/// @nodoc
abstract mixin class $Unp4kcStateCopyWith<$Res>  {
  factory $Unp4kcStateCopyWith(Unp4kcState value, $Res Function(Unp4kcState) _then) = _$Unp4kcStateCopyWithImpl;
@useResult
$Res call({
 bool startUp, Map<String, AppUnp4kP4kItemData>? files, MemoryFileSystem? fs, String curPath, String? endMessage, MapEntry<String, String>? tempOpenFile, String errorMessage, String searchQuery, bool isSearching, MemoryFileSystem? searchFs, Set<String>? searchMatchedFiles, Unp4kSortType sortType, bool isMultiSelectMode, Set<String> selectedItems
});




}
/// @nodoc
class _$Unp4kcStateCopyWithImpl<$Res>
    implements $Unp4kcStateCopyWith<$Res> {
  _$Unp4kcStateCopyWithImpl(this._self, this._then);

  final Unp4kcState _self;
  final $Res Function(Unp4kcState) _then;

/// Create a copy of Unp4kcState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startUp = null,Object? files = freezed,Object? fs = freezed,Object? curPath = null,Object? endMessage = freezed,Object? tempOpenFile = freezed,Object? errorMessage = null,Object? searchQuery = null,Object? isSearching = null,Object? searchFs = freezed,Object? searchMatchedFiles = freezed,Object? sortType = null,Object? isMultiSelectMode = null,Object? selectedItems = null,}) {
  return _then(_self.copyWith(
startUp: null == startUp ? _self.startUp : startUp // ignore: cast_nullable_to_non_nullable
as bool,files: freezed == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as Map<String, AppUnp4kP4kItemData>?,fs: freezed == fs ? _self.fs : fs // ignore: cast_nullable_to_non_nullable
as MemoryFileSystem?,curPath: null == curPath ? _self.curPath : curPath // ignore: cast_nullable_to_non_nullable
as String,endMessage: freezed == endMessage ? _self.endMessage : endMessage // ignore: cast_nullable_to_non_nullable
as String?,tempOpenFile: freezed == tempOpenFile ? _self.tempOpenFile : tempOpenFile // ignore: cast_nullable_to_non_nullable
as MapEntry<String, String>?,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,isSearching: null == isSearching ? _self.isSearching : isSearching // ignore: cast_nullable_to_non_nullable
as bool,searchFs: freezed == searchFs ? _self.searchFs : searchFs // ignore: cast_nullable_to_non_nullable
as MemoryFileSystem?,searchMatchedFiles: freezed == searchMatchedFiles ? _self.searchMatchedFiles : searchMatchedFiles // ignore: cast_nullable_to_non_nullable
as Set<String>?,sortType: null == sortType ? _self.sortType : sortType // ignore: cast_nullable_to_non_nullable
as Unp4kSortType,isMultiSelectMode: null == isMultiSelectMode ? _self.isMultiSelectMode : isMultiSelectMode // ignore: cast_nullable_to_non_nullable
as bool,selectedItems: null == selectedItems ? _self.selectedItems : selectedItems // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Unp4kcState].
extension Unp4kcStatePatterns on Unp4kcState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Unp4kcState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Unp4kcState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Unp4kcState value)  $default,){
final _that = this;
switch (_that) {
case _Unp4kcState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Unp4kcState value)?  $default,){
final _that = this;
switch (_that) {
case _Unp4kcState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool startUp,  Map<String, AppUnp4kP4kItemData>? files,  MemoryFileSystem? fs,  String curPath,  String? endMessage,  MapEntry<String, String>? tempOpenFile,  String errorMessage,  String searchQuery,  bool isSearching,  MemoryFileSystem? searchFs,  Set<String>? searchMatchedFiles,  Unp4kSortType sortType,  bool isMultiSelectMode,  Set<String> selectedItems)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Unp4kcState() when $default != null:
return $default(_that.startUp,_that.files,_that.fs,_that.curPath,_that.endMessage,_that.tempOpenFile,_that.errorMessage,_that.searchQuery,_that.isSearching,_that.searchFs,_that.searchMatchedFiles,_that.sortType,_that.isMultiSelectMode,_that.selectedItems);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool startUp,  Map<String, AppUnp4kP4kItemData>? files,  MemoryFileSystem? fs,  String curPath,  String? endMessage,  MapEntry<String, String>? tempOpenFile,  String errorMessage,  String searchQuery,  bool isSearching,  MemoryFileSystem? searchFs,  Set<String>? searchMatchedFiles,  Unp4kSortType sortType,  bool isMultiSelectMode,  Set<String> selectedItems)  $default,) {final _that = this;
switch (_that) {
case _Unp4kcState():
return $default(_that.startUp,_that.files,_that.fs,_that.curPath,_that.endMessage,_that.tempOpenFile,_that.errorMessage,_that.searchQuery,_that.isSearching,_that.searchFs,_that.searchMatchedFiles,_that.sortType,_that.isMultiSelectMode,_that.selectedItems);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool startUp,  Map<String, AppUnp4kP4kItemData>? files,  MemoryFileSystem? fs,  String curPath,  String? endMessage,  MapEntry<String, String>? tempOpenFile,  String errorMessage,  String searchQuery,  bool isSearching,  MemoryFileSystem? searchFs,  Set<String>? searchMatchedFiles,  Unp4kSortType sortType,  bool isMultiSelectMode,  Set<String> selectedItems)?  $default,) {final _that = this;
switch (_that) {
case _Unp4kcState() when $default != null:
return $default(_that.startUp,_that.files,_that.fs,_that.curPath,_that.endMessage,_that.tempOpenFile,_that.errorMessage,_that.searchQuery,_that.isSearching,_that.searchFs,_that.searchMatchedFiles,_that.sortType,_that.isMultiSelectMode,_that.selectedItems);case _:
  return null;

}
}

}

/// @nodoc


class _Unp4kcState with DiagnosticableTreeMixin implements Unp4kcState {
  const _Unp4kcState({required this.startUp, final  Map<String, AppUnp4kP4kItemData>? files, this.fs, required this.curPath, this.endMessage, this.tempOpenFile, this.errorMessage = "", this.searchQuery = "", this.isSearching = false, this.searchFs, final  Set<String>? searchMatchedFiles, this.sortType = Unp4kSortType.defaultSort, this.isMultiSelectMode = false, final  Set<String> selectedItems = const {}}): _files = files,_searchMatchedFiles = searchMatchedFiles,_selectedItems = selectedItems;
  

@override final  bool startUp;
 final  Map<String, AppUnp4kP4kItemData>? _files;
@override Map<String, AppUnp4kP4kItemData>? get files {
  final value = _files;
  if (value == null) return null;
  if (_files is EqualUnmodifiableMapView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  MemoryFileSystem? fs;
@override final  String curPath;
@override final  String? endMessage;
@override final  MapEntry<String, String>? tempOpenFile;
@override@JsonKey() final  String errorMessage;
@override@JsonKey() final  String searchQuery;
@override@JsonKey() final  bool isSearching;
/// 搜索结果的虚拟文件系统（支持分级展示）
@override final  MemoryFileSystem? searchFs;
/// 搜索匹配的文件路径集合
 final  Set<String>? _searchMatchedFiles;
/// 搜索匹配的文件路径集合
@override Set<String>? get searchMatchedFiles {
  final value = _searchMatchedFiles;
  if (value == null) return null;
  if (_searchMatchedFiles is EqualUnmodifiableSetView) return _searchMatchedFiles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(value);
}

@override@JsonKey() final  Unp4kSortType sortType;
/// 是否处于多选模式
@override@JsonKey() final  bool isMultiSelectMode;
/// 多选模式下选中的文件路径集合
 final  Set<String> _selectedItems;
/// 多选模式下选中的文件路径集合
@override@JsonKey() Set<String> get selectedItems {
  if (_selectedItems is EqualUnmodifiableSetView) return _selectedItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_selectedItems);
}


/// Create a copy of Unp4kcState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$Unp4kcStateCopyWith<_Unp4kcState> get copyWith => __$Unp4kcStateCopyWithImpl<_Unp4kcState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Unp4kcState'))
    ..add(DiagnosticsProperty('startUp', startUp))..add(DiagnosticsProperty('files', files))..add(DiagnosticsProperty('fs', fs))..add(DiagnosticsProperty('curPath', curPath))..add(DiagnosticsProperty('endMessage', endMessage))..add(DiagnosticsProperty('tempOpenFile', tempOpenFile))..add(DiagnosticsProperty('errorMessage', errorMessage))..add(DiagnosticsProperty('searchQuery', searchQuery))..add(DiagnosticsProperty('isSearching', isSearching))..add(DiagnosticsProperty('searchFs', searchFs))..add(DiagnosticsProperty('searchMatchedFiles', searchMatchedFiles))..add(DiagnosticsProperty('sortType', sortType))..add(DiagnosticsProperty('isMultiSelectMode', isMultiSelectMode))..add(DiagnosticsProperty('selectedItems', selectedItems));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Unp4kcState&&(identical(other.startUp, startUp) || other.startUp == startUp)&&const DeepCollectionEquality().equals(other._files, _files)&&(identical(other.fs, fs) || other.fs == fs)&&(identical(other.curPath, curPath) || other.curPath == curPath)&&(identical(other.endMessage, endMessage) || other.endMessage == endMessage)&&(identical(other.tempOpenFile, tempOpenFile) || other.tempOpenFile == tempOpenFile)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.isSearching, isSearching) || other.isSearching == isSearching)&&(identical(other.searchFs, searchFs) || other.searchFs == searchFs)&&const DeepCollectionEquality().equals(other._searchMatchedFiles, _searchMatchedFiles)&&(identical(other.sortType, sortType) || other.sortType == sortType)&&(identical(other.isMultiSelectMode, isMultiSelectMode) || other.isMultiSelectMode == isMultiSelectMode)&&const DeepCollectionEquality().equals(other._selectedItems, _selectedItems));
}


@override
int get hashCode => Object.hash(runtimeType,startUp,const DeepCollectionEquality().hash(_files),fs,curPath,endMessage,tempOpenFile,errorMessage,searchQuery,isSearching,searchFs,const DeepCollectionEquality().hash(_searchMatchedFiles),sortType,isMultiSelectMode,const DeepCollectionEquality().hash(_selectedItems));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Unp4kcState(startUp: $startUp, files: $files, fs: $fs, curPath: $curPath, endMessage: $endMessage, tempOpenFile: $tempOpenFile, errorMessage: $errorMessage, searchQuery: $searchQuery, isSearching: $isSearching, searchFs: $searchFs, searchMatchedFiles: $searchMatchedFiles, sortType: $sortType, isMultiSelectMode: $isMultiSelectMode, selectedItems: $selectedItems)';
}


}

/// @nodoc
abstract mixin class _$Unp4kcStateCopyWith<$Res> implements $Unp4kcStateCopyWith<$Res> {
  factory _$Unp4kcStateCopyWith(_Unp4kcState value, $Res Function(_Unp4kcState) _then) = __$Unp4kcStateCopyWithImpl;
@override @useResult
$Res call({
 bool startUp, Map<String, AppUnp4kP4kItemData>? files, MemoryFileSystem? fs, String curPath, String? endMessage, MapEntry<String, String>? tempOpenFile, String errorMessage, String searchQuery, bool isSearching, MemoryFileSystem? searchFs, Set<String>? searchMatchedFiles, Unp4kSortType sortType, bool isMultiSelectMode, Set<String> selectedItems
});




}
/// @nodoc
class __$Unp4kcStateCopyWithImpl<$Res>
    implements _$Unp4kcStateCopyWith<$Res> {
  __$Unp4kcStateCopyWithImpl(this._self, this._then);

  final _Unp4kcState _self;
  final $Res Function(_Unp4kcState) _then;

/// Create a copy of Unp4kcState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startUp = null,Object? files = freezed,Object? fs = freezed,Object? curPath = null,Object? endMessage = freezed,Object? tempOpenFile = freezed,Object? errorMessage = null,Object? searchQuery = null,Object? isSearching = null,Object? searchFs = freezed,Object? searchMatchedFiles = freezed,Object? sortType = null,Object? isMultiSelectMode = null,Object? selectedItems = null,}) {
  return _then(_Unp4kcState(
startUp: null == startUp ? _self.startUp : startUp // ignore: cast_nullable_to_non_nullable
as bool,files: freezed == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as Map<String, AppUnp4kP4kItemData>?,fs: freezed == fs ? _self.fs : fs // ignore: cast_nullable_to_non_nullable
as MemoryFileSystem?,curPath: null == curPath ? _self.curPath : curPath // ignore: cast_nullable_to_non_nullable
as String,endMessage: freezed == endMessage ? _self.endMessage : endMessage // ignore: cast_nullable_to_non_nullable
as String?,tempOpenFile: freezed == tempOpenFile ? _self.tempOpenFile : tempOpenFile // ignore: cast_nullable_to_non_nullable
as MapEntry<String, String>?,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,isSearching: null == isSearching ? _self.isSearching : isSearching // ignore: cast_nullable_to_non_nullable
as bool,searchFs: freezed == searchFs ? _self.searchFs : searchFs // ignore: cast_nullable_to_non_nullable
as MemoryFileSystem?,searchMatchedFiles: freezed == searchMatchedFiles ? _self._searchMatchedFiles : searchMatchedFiles // ignore: cast_nullable_to_non_nullable
as Set<String>?,sortType: null == sortType ? _self.sortType : sortType // ignore: cast_nullable_to_non_nullable
as Unp4kSortType,isMultiSelectMode: null == isMultiSelectMode ? _self.isMultiSelectMode : isMultiSelectMode // ignore: cast_nullable_to_non_nullable
as bool,selectedItems: null == selectedItems ? _self._selectedItems : selectedItems // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}


}

// dart format on
