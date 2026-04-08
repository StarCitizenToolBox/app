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
mixin _$Unp4kcState {

 bool get startUp; Map<String, AppUnp4kP4kItemData>? get files; MemoryFileSystem? get fs; String get curPath; String? get endMessage; MapEntry<String, String>? get tempOpenFile; String? get currentPreviewPath; String get errorMessage; int get loadingCurrent; int get loadingTotal; String get searchQuery; List<String> get availableSuffixes; bool get isSearching;/// 搜索结果的虚拟文件系统（支持分级展示）
 MemoryFileSystem? get searchFs;/// 搜索匹配的文件路径集合
 Set<String>? get searchMatchedFiles;/// 搜索时保留的文件夹（当前目录模式下置顶显示）
 Set<String>? get searchKeptDirectories;/// 搜索范围：true=全局搜索，false=当前目录
 bool get isGlobalSearchScope;/// 搜索时的目录路径（当前目录模式时保存）
 String? get searchPath; Unp4kSortType get sortType;/// 是否处于多选模式
 bool get isMultiSelectMode;/// 多选模式下选中的文件路径集合
 Set<String> get selectedItems;/// 大小筛选模式
 Unp4kFilterMode get sizeFilterMode;/// 大小筛选单位
 Unp4kSizeUnit get sizeFilterUnit;/// 大小筛选单值（用于前/后）
 double? get sizeFilterSingleValue;/// 大小筛选范围起点
 double? get sizeFilterRangeStart;/// 大小筛选范围终点
 double? get sizeFilterRangeEnd;/// 日期筛选模式
 Unp4kFilterMode get dateFilterMode;/// 日期筛选单值（用于前/后）
 DateTime? get dateFilterSingleDate;/// 日期筛选范围起点
 DateTime? get dateFilterRangeStart;/// 日期筛选范围终点
 DateTime? get dateFilterRangeEnd;
/// Create a copy of Unp4kcState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Unp4kcStateCopyWith<Unp4kcState> get copyWith => _$Unp4kcStateCopyWithImpl<Unp4kcState>(this as Unp4kcState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Unp4kcState&&(identical(other.startUp, startUp) || other.startUp == startUp)&&const DeepCollectionEquality().equals(other.files, files)&&(identical(other.fs, fs) || other.fs == fs)&&(identical(other.curPath, curPath) || other.curPath == curPath)&&(identical(other.endMessage, endMessage) || other.endMessage == endMessage)&&(identical(other.tempOpenFile, tempOpenFile) || other.tempOpenFile == tempOpenFile)&&(identical(other.currentPreviewPath, currentPreviewPath) || other.currentPreviewPath == currentPreviewPath)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.loadingCurrent, loadingCurrent) || other.loadingCurrent == loadingCurrent)&&(identical(other.loadingTotal, loadingTotal) || other.loadingTotal == loadingTotal)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&const DeepCollectionEquality().equals(other.availableSuffixes, availableSuffixes)&&(identical(other.isSearching, isSearching) || other.isSearching == isSearching)&&(identical(other.searchFs, searchFs) || other.searchFs == searchFs)&&const DeepCollectionEquality().equals(other.searchMatchedFiles, searchMatchedFiles)&&const DeepCollectionEquality().equals(other.searchKeptDirectories, searchKeptDirectories)&&(identical(other.isGlobalSearchScope, isGlobalSearchScope) || other.isGlobalSearchScope == isGlobalSearchScope)&&(identical(other.searchPath, searchPath) || other.searchPath == searchPath)&&(identical(other.sortType, sortType) || other.sortType == sortType)&&(identical(other.isMultiSelectMode, isMultiSelectMode) || other.isMultiSelectMode == isMultiSelectMode)&&const DeepCollectionEquality().equals(other.selectedItems, selectedItems)&&(identical(other.sizeFilterMode, sizeFilterMode) || other.sizeFilterMode == sizeFilterMode)&&(identical(other.sizeFilterUnit, sizeFilterUnit) || other.sizeFilterUnit == sizeFilterUnit)&&(identical(other.sizeFilterSingleValue, sizeFilterSingleValue) || other.sizeFilterSingleValue == sizeFilterSingleValue)&&(identical(other.sizeFilterRangeStart, sizeFilterRangeStart) || other.sizeFilterRangeStart == sizeFilterRangeStart)&&(identical(other.sizeFilterRangeEnd, sizeFilterRangeEnd) || other.sizeFilterRangeEnd == sizeFilterRangeEnd)&&(identical(other.dateFilterMode, dateFilterMode) || other.dateFilterMode == dateFilterMode)&&(identical(other.dateFilterSingleDate, dateFilterSingleDate) || other.dateFilterSingleDate == dateFilterSingleDate)&&(identical(other.dateFilterRangeStart, dateFilterRangeStart) || other.dateFilterRangeStart == dateFilterRangeStart)&&(identical(other.dateFilterRangeEnd, dateFilterRangeEnd) || other.dateFilterRangeEnd == dateFilterRangeEnd));
}


@override
int get hashCode => Object.hashAll([runtimeType,startUp,const DeepCollectionEquality().hash(files),fs,curPath,endMessage,tempOpenFile,currentPreviewPath,errorMessage,loadingCurrent,loadingTotal,searchQuery,const DeepCollectionEquality().hash(availableSuffixes),isSearching,searchFs,const DeepCollectionEquality().hash(searchMatchedFiles),const DeepCollectionEquality().hash(searchKeptDirectories),isGlobalSearchScope,searchPath,sortType,isMultiSelectMode,const DeepCollectionEquality().hash(selectedItems),sizeFilterMode,sizeFilterUnit,sizeFilterSingleValue,sizeFilterRangeStart,sizeFilterRangeEnd,dateFilterMode,dateFilterSingleDate,dateFilterRangeStart,dateFilterRangeEnd]);

@override
String toString() {
  return 'Unp4kcState(startUp: $startUp, files: $files, fs: $fs, curPath: $curPath, endMessage: $endMessage, tempOpenFile: $tempOpenFile, currentPreviewPath: $currentPreviewPath, errorMessage: $errorMessage, loadingCurrent: $loadingCurrent, loadingTotal: $loadingTotal, searchQuery: $searchQuery, availableSuffixes: $availableSuffixes, isSearching: $isSearching, searchFs: $searchFs, searchMatchedFiles: $searchMatchedFiles, searchKeptDirectories: $searchKeptDirectories, isGlobalSearchScope: $isGlobalSearchScope, searchPath: $searchPath, sortType: $sortType, isMultiSelectMode: $isMultiSelectMode, selectedItems: $selectedItems, sizeFilterMode: $sizeFilterMode, sizeFilterUnit: $sizeFilterUnit, sizeFilterSingleValue: $sizeFilterSingleValue, sizeFilterRangeStart: $sizeFilterRangeStart, sizeFilterRangeEnd: $sizeFilterRangeEnd, dateFilterMode: $dateFilterMode, dateFilterSingleDate: $dateFilterSingleDate, dateFilterRangeStart: $dateFilterRangeStart, dateFilterRangeEnd: $dateFilterRangeEnd)';
}


}

/// @nodoc
abstract mixin class $Unp4kcStateCopyWith<$Res>  {
  factory $Unp4kcStateCopyWith(Unp4kcState value, $Res Function(Unp4kcState) _then) = _$Unp4kcStateCopyWithImpl;
@useResult
$Res call({
 bool startUp, Map<String, AppUnp4kP4kItemData>? files, MemoryFileSystem? fs, String curPath, String? endMessage, MapEntry<String, String>? tempOpenFile, String? currentPreviewPath, String errorMessage, int loadingCurrent, int loadingTotal, String searchQuery, List<String> availableSuffixes, bool isSearching, MemoryFileSystem? searchFs, Set<String>? searchMatchedFiles, Set<String>? searchKeptDirectories, bool isGlobalSearchScope, String? searchPath, Unp4kSortType sortType, bool isMultiSelectMode, Set<String> selectedItems, Unp4kFilterMode sizeFilterMode, Unp4kSizeUnit sizeFilterUnit, double? sizeFilterSingleValue, double? sizeFilterRangeStart, double? sizeFilterRangeEnd, Unp4kFilterMode dateFilterMode, DateTime? dateFilterSingleDate, DateTime? dateFilterRangeStart, DateTime? dateFilterRangeEnd
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
@pragma('vm:prefer-inline') @override $Res call({Object? startUp = null,Object? files = freezed,Object? fs = freezed,Object? curPath = null,Object? endMessage = freezed,Object? tempOpenFile = freezed,Object? currentPreviewPath = freezed,Object? errorMessage = null,Object? loadingCurrent = null,Object? loadingTotal = null,Object? searchQuery = null,Object? availableSuffixes = null,Object? isSearching = null,Object? searchFs = freezed,Object? searchMatchedFiles = freezed,Object? searchKeptDirectories = freezed,Object? isGlobalSearchScope = null,Object? searchPath = freezed,Object? sortType = null,Object? isMultiSelectMode = null,Object? selectedItems = null,Object? sizeFilterMode = null,Object? sizeFilterUnit = null,Object? sizeFilterSingleValue = freezed,Object? sizeFilterRangeStart = freezed,Object? sizeFilterRangeEnd = freezed,Object? dateFilterMode = null,Object? dateFilterSingleDate = freezed,Object? dateFilterRangeStart = freezed,Object? dateFilterRangeEnd = freezed,}) {
  return _then(_self.copyWith(
startUp: null == startUp ? _self.startUp : startUp // ignore: cast_nullable_to_non_nullable
as bool,files: freezed == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as Map<String, AppUnp4kP4kItemData>?,fs: freezed == fs ? _self.fs : fs // ignore: cast_nullable_to_non_nullable
as MemoryFileSystem?,curPath: null == curPath ? _self.curPath : curPath // ignore: cast_nullable_to_non_nullable
as String,endMessage: freezed == endMessage ? _self.endMessage : endMessage // ignore: cast_nullable_to_non_nullable
as String?,tempOpenFile: freezed == tempOpenFile ? _self.tempOpenFile : tempOpenFile // ignore: cast_nullable_to_non_nullable
as MapEntry<String, String>?,currentPreviewPath: freezed == currentPreviewPath ? _self.currentPreviewPath : currentPreviewPath // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,loadingCurrent: null == loadingCurrent ? _self.loadingCurrent : loadingCurrent // ignore: cast_nullable_to_non_nullable
as int,loadingTotal: null == loadingTotal ? _self.loadingTotal : loadingTotal // ignore: cast_nullable_to_non_nullable
as int,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,availableSuffixes: null == availableSuffixes ? _self.availableSuffixes : availableSuffixes // ignore: cast_nullable_to_non_nullable
as List<String>,isSearching: null == isSearching ? _self.isSearching : isSearching // ignore: cast_nullable_to_non_nullable
as bool,searchFs: freezed == searchFs ? _self.searchFs : searchFs // ignore: cast_nullable_to_non_nullable
as MemoryFileSystem?,searchMatchedFiles: freezed == searchMatchedFiles ? _self.searchMatchedFiles : searchMatchedFiles // ignore: cast_nullable_to_non_nullable
as Set<String>?,searchKeptDirectories: freezed == searchKeptDirectories ? _self.searchKeptDirectories : searchKeptDirectories // ignore: cast_nullable_to_non_nullable
as Set<String>?,isGlobalSearchScope: null == isGlobalSearchScope ? _self.isGlobalSearchScope : isGlobalSearchScope // ignore: cast_nullable_to_non_nullable
as bool,searchPath: freezed == searchPath ? _self.searchPath : searchPath // ignore: cast_nullable_to_non_nullable
as String?,sortType: null == sortType ? _self.sortType : sortType // ignore: cast_nullable_to_non_nullable
as Unp4kSortType,isMultiSelectMode: null == isMultiSelectMode ? _self.isMultiSelectMode : isMultiSelectMode // ignore: cast_nullable_to_non_nullable
as bool,selectedItems: null == selectedItems ? _self.selectedItems : selectedItems // ignore: cast_nullable_to_non_nullable
as Set<String>,sizeFilterMode: null == sizeFilterMode ? _self.sizeFilterMode : sizeFilterMode // ignore: cast_nullable_to_non_nullable
as Unp4kFilterMode,sizeFilterUnit: null == sizeFilterUnit ? _self.sizeFilterUnit : sizeFilterUnit // ignore: cast_nullable_to_non_nullable
as Unp4kSizeUnit,sizeFilterSingleValue: freezed == sizeFilterSingleValue ? _self.sizeFilterSingleValue : sizeFilterSingleValue // ignore: cast_nullable_to_non_nullable
as double?,sizeFilterRangeStart: freezed == sizeFilterRangeStart ? _self.sizeFilterRangeStart : sizeFilterRangeStart // ignore: cast_nullable_to_non_nullable
as double?,sizeFilterRangeEnd: freezed == sizeFilterRangeEnd ? _self.sizeFilterRangeEnd : sizeFilterRangeEnd // ignore: cast_nullable_to_non_nullable
as double?,dateFilterMode: null == dateFilterMode ? _self.dateFilterMode : dateFilterMode // ignore: cast_nullable_to_non_nullable
as Unp4kFilterMode,dateFilterSingleDate: freezed == dateFilterSingleDate ? _self.dateFilterSingleDate : dateFilterSingleDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dateFilterRangeStart: freezed == dateFilterRangeStart ? _self.dateFilterRangeStart : dateFilterRangeStart // ignore: cast_nullable_to_non_nullable
as DateTime?,dateFilterRangeEnd: freezed == dateFilterRangeEnd ? _self.dateFilterRangeEnd : dateFilterRangeEnd // ignore: cast_nullable_to_non_nullable
as DateTime?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool startUp,  Map<String, AppUnp4kP4kItemData>? files,  MemoryFileSystem? fs,  String curPath,  String? endMessage,  MapEntry<String, String>? tempOpenFile,  String? currentPreviewPath,  String errorMessage,  int loadingCurrent,  int loadingTotal,  String searchQuery,  List<String> availableSuffixes,  bool isSearching,  MemoryFileSystem? searchFs,  Set<String>? searchMatchedFiles,  Set<String>? searchKeptDirectories,  bool isGlobalSearchScope,  String? searchPath,  Unp4kSortType sortType,  bool isMultiSelectMode,  Set<String> selectedItems,  Unp4kFilterMode sizeFilterMode,  Unp4kSizeUnit sizeFilterUnit,  double? sizeFilterSingleValue,  double? sizeFilterRangeStart,  double? sizeFilterRangeEnd,  Unp4kFilterMode dateFilterMode,  DateTime? dateFilterSingleDate,  DateTime? dateFilterRangeStart,  DateTime? dateFilterRangeEnd)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Unp4kcState() when $default != null:
return $default(_that.startUp,_that.files,_that.fs,_that.curPath,_that.endMessage,_that.tempOpenFile,_that.currentPreviewPath,_that.errorMessage,_that.loadingCurrent,_that.loadingTotal,_that.searchQuery,_that.availableSuffixes,_that.isSearching,_that.searchFs,_that.searchMatchedFiles,_that.searchKeptDirectories,_that.isGlobalSearchScope,_that.searchPath,_that.sortType,_that.isMultiSelectMode,_that.selectedItems,_that.sizeFilterMode,_that.sizeFilterUnit,_that.sizeFilterSingleValue,_that.sizeFilterRangeStart,_that.sizeFilterRangeEnd,_that.dateFilterMode,_that.dateFilterSingleDate,_that.dateFilterRangeStart,_that.dateFilterRangeEnd);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool startUp,  Map<String, AppUnp4kP4kItemData>? files,  MemoryFileSystem? fs,  String curPath,  String? endMessage,  MapEntry<String, String>? tempOpenFile,  String? currentPreviewPath,  String errorMessage,  int loadingCurrent,  int loadingTotal,  String searchQuery,  List<String> availableSuffixes,  bool isSearching,  MemoryFileSystem? searchFs,  Set<String>? searchMatchedFiles,  Set<String>? searchKeptDirectories,  bool isGlobalSearchScope,  String? searchPath,  Unp4kSortType sortType,  bool isMultiSelectMode,  Set<String> selectedItems,  Unp4kFilterMode sizeFilterMode,  Unp4kSizeUnit sizeFilterUnit,  double? sizeFilterSingleValue,  double? sizeFilterRangeStart,  double? sizeFilterRangeEnd,  Unp4kFilterMode dateFilterMode,  DateTime? dateFilterSingleDate,  DateTime? dateFilterRangeStart,  DateTime? dateFilterRangeEnd)  $default,) {final _that = this;
switch (_that) {
case _Unp4kcState():
return $default(_that.startUp,_that.files,_that.fs,_that.curPath,_that.endMessage,_that.tempOpenFile,_that.currentPreviewPath,_that.errorMessage,_that.loadingCurrent,_that.loadingTotal,_that.searchQuery,_that.availableSuffixes,_that.isSearching,_that.searchFs,_that.searchMatchedFiles,_that.searchKeptDirectories,_that.isGlobalSearchScope,_that.searchPath,_that.sortType,_that.isMultiSelectMode,_that.selectedItems,_that.sizeFilterMode,_that.sizeFilterUnit,_that.sizeFilterSingleValue,_that.sizeFilterRangeStart,_that.sizeFilterRangeEnd,_that.dateFilterMode,_that.dateFilterSingleDate,_that.dateFilterRangeStart,_that.dateFilterRangeEnd);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool startUp,  Map<String, AppUnp4kP4kItemData>? files,  MemoryFileSystem? fs,  String curPath,  String? endMessage,  MapEntry<String, String>? tempOpenFile,  String? currentPreviewPath,  String errorMessage,  int loadingCurrent,  int loadingTotal,  String searchQuery,  List<String> availableSuffixes,  bool isSearching,  MemoryFileSystem? searchFs,  Set<String>? searchMatchedFiles,  Set<String>? searchKeptDirectories,  bool isGlobalSearchScope,  String? searchPath,  Unp4kSortType sortType,  bool isMultiSelectMode,  Set<String> selectedItems,  Unp4kFilterMode sizeFilterMode,  Unp4kSizeUnit sizeFilterUnit,  double? sizeFilterSingleValue,  double? sizeFilterRangeStart,  double? sizeFilterRangeEnd,  Unp4kFilterMode dateFilterMode,  DateTime? dateFilterSingleDate,  DateTime? dateFilterRangeStart,  DateTime? dateFilterRangeEnd)?  $default,) {final _that = this;
switch (_that) {
case _Unp4kcState() when $default != null:
return $default(_that.startUp,_that.files,_that.fs,_that.curPath,_that.endMessage,_that.tempOpenFile,_that.currentPreviewPath,_that.errorMessage,_that.loadingCurrent,_that.loadingTotal,_that.searchQuery,_that.availableSuffixes,_that.isSearching,_that.searchFs,_that.searchMatchedFiles,_that.searchKeptDirectories,_that.isGlobalSearchScope,_that.searchPath,_that.sortType,_that.isMultiSelectMode,_that.selectedItems,_that.sizeFilterMode,_that.sizeFilterUnit,_that.sizeFilterSingleValue,_that.sizeFilterRangeStart,_that.sizeFilterRangeEnd,_that.dateFilterMode,_that.dateFilterSingleDate,_that.dateFilterRangeStart,_that.dateFilterRangeEnd);case _:
  return null;

}
}

}

/// @nodoc


class _Unp4kcState implements Unp4kcState {
  const _Unp4kcState({required this.startUp, final  Map<String, AppUnp4kP4kItemData>? files, this.fs, required this.curPath, this.endMessage, this.tempOpenFile, this.currentPreviewPath, this.errorMessage = "", this.loadingCurrent = 0, this.loadingTotal = 0, this.searchQuery = "", final  List<String> availableSuffixes = const <String>[], this.isSearching = false, this.searchFs, final  Set<String>? searchMatchedFiles, final  Set<String>? searchKeptDirectories, this.isGlobalSearchScope = false, this.searchPath, this.sortType = Unp4kSortType.defaultSort, this.isMultiSelectMode = false, final  Set<String> selectedItems = const {}, this.sizeFilterMode = Unp4kFilterMode.none, this.sizeFilterUnit = Unp4kSizeUnit.mb, this.sizeFilterSingleValue, this.sizeFilterRangeStart, this.sizeFilterRangeEnd, this.dateFilterMode = Unp4kFilterMode.none, this.dateFilterSingleDate, this.dateFilterRangeStart, this.dateFilterRangeEnd}): _files = files,_availableSuffixes = availableSuffixes,_searchMatchedFiles = searchMatchedFiles,_searchKeptDirectories = searchKeptDirectories,_selectedItems = selectedItems;
  

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
@override final  String? currentPreviewPath;
@override@JsonKey() final  String errorMessage;
@override@JsonKey() final  int loadingCurrent;
@override@JsonKey() final  int loadingTotal;
@override@JsonKey() final  String searchQuery;
 final  List<String> _availableSuffixes;
@override@JsonKey() List<String> get availableSuffixes {
  if (_availableSuffixes is EqualUnmodifiableListView) return _availableSuffixes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableSuffixes);
}

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

/// 搜索时保留的文件夹（当前目录模式下置顶显示）
 final  Set<String>? _searchKeptDirectories;
/// 搜索时保留的文件夹（当前目录模式下置顶显示）
@override Set<String>? get searchKeptDirectories {
  final value = _searchKeptDirectories;
  if (value == null) return null;
  if (_searchKeptDirectories is EqualUnmodifiableSetView) return _searchKeptDirectories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(value);
}

/// 搜索范围：true=全局搜索，false=当前目录
@override@JsonKey() final  bool isGlobalSearchScope;
/// 搜索时的目录路径（当前目录模式时保存）
@override final  String? searchPath;
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

/// 大小筛选模式
@override@JsonKey() final  Unp4kFilterMode sizeFilterMode;
/// 大小筛选单位
@override@JsonKey() final  Unp4kSizeUnit sizeFilterUnit;
/// 大小筛选单值（用于前/后）
@override final  double? sizeFilterSingleValue;
/// 大小筛选范围起点
@override final  double? sizeFilterRangeStart;
/// 大小筛选范围终点
@override final  double? sizeFilterRangeEnd;
/// 日期筛选模式
@override@JsonKey() final  Unp4kFilterMode dateFilterMode;
/// 日期筛选单值（用于前/后）
@override final  DateTime? dateFilterSingleDate;
/// 日期筛选范围起点
@override final  DateTime? dateFilterRangeStart;
/// 日期筛选范围终点
@override final  DateTime? dateFilterRangeEnd;

/// Create a copy of Unp4kcState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$Unp4kcStateCopyWith<_Unp4kcState> get copyWith => __$Unp4kcStateCopyWithImpl<_Unp4kcState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Unp4kcState&&(identical(other.startUp, startUp) || other.startUp == startUp)&&const DeepCollectionEquality().equals(other._files, _files)&&(identical(other.fs, fs) || other.fs == fs)&&(identical(other.curPath, curPath) || other.curPath == curPath)&&(identical(other.endMessage, endMessage) || other.endMessage == endMessage)&&(identical(other.tempOpenFile, tempOpenFile) || other.tempOpenFile == tempOpenFile)&&(identical(other.currentPreviewPath, currentPreviewPath) || other.currentPreviewPath == currentPreviewPath)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.loadingCurrent, loadingCurrent) || other.loadingCurrent == loadingCurrent)&&(identical(other.loadingTotal, loadingTotal) || other.loadingTotal == loadingTotal)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&const DeepCollectionEquality().equals(other._availableSuffixes, _availableSuffixes)&&(identical(other.isSearching, isSearching) || other.isSearching == isSearching)&&(identical(other.searchFs, searchFs) || other.searchFs == searchFs)&&const DeepCollectionEquality().equals(other._searchMatchedFiles, _searchMatchedFiles)&&const DeepCollectionEquality().equals(other._searchKeptDirectories, _searchKeptDirectories)&&(identical(other.isGlobalSearchScope, isGlobalSearchScope) || other.isGlobalSearchScope == isGlobalSearchScope)&&(identical(other.searchPath, searchPath) || other.searchPath == searchPath)&&(identical(other.sortType, sortType) || other.sortType == sortType)&&(identical(other.isMultiSelectMode, isMultiSelectMode) || other.isMultiSelectMode == isMultiSelectMode)&&const DeepCollectionEquality().equals(other._selectedItems, _selectedItems)&&(identical(other.sizeFilterMode, sizeFilterMode) || other.sizeFilterMode == sizeFilterMode)&&(identical(other.sizeFilterUnit, sizeFilterUnit) || other.sizeFilterUnit == sizeFilterUnit)&&(identical(other.sizeFilterSingleValue, sizeFilterSingleValue) || other.sizeFilterSingleValue == sizeFilterSingleValue)&&(identical(other.sizeFilterRangeStart, sizeFilterRangeStart) || other.sizeFilterRangeStart == sizeFilterRangeStart)&&(identical(other.sizeFilterRangeEnd, sizeFilterRangeEnd) || other.sizeFilterRangeEnd == sizeFilterRangeEnd)&&(identical(other.dateFilterMode, dateFilterMode) || other.dateFilterMode == dateFilterMode)&&(identical(other.dateFilterSingleDate, dateFilterSingleDate) || other.dateFilterSingleDate == dateFilterSingleDate)&&(identical(other.dateFilterRangeStart, dateFilterRangeStart) || other.dateFilterRangeStart == dateFilterRangeStart)&&(identical(other.dateFilterRangeEnd, dateFilterRangeEnd) || other.dateFilterRangeEnd == dateFilterRangeEnd));
}


@override
int get hashCode => Object.hashAll([runtimeType,startUp,const DeepCollectionEquality().hash(_files),fs,curPath,endMessage,tempOpenFile,currentPreviewPath,errorMessage,loadingCurrent,loadingTotal,searchQuery,const DeepCollectionEquality().hash(_availableSuffixes),isSearching,searchFs,const DeepCollectionEquality().hash(_searchMatchedFiles),const DeepCollectionEquality().hash(_searchKeptDirectories),isGlobalSearchScope,searchPath,sortType,isMultiSelectMode,const DeepCollectionEquality().hash(_selectedItems),sizeFilterMode,sizeFilterUnit,sizeFilterSingleValue,sizeFilterRangeStart,sizeFilterRangeEnd,dateFilterMode,dateFilterSingleDate,dateFilterRangeStart,dateFilterRangeEnd]);

@override
String toString() {
  return 'Unp4kcState(startUp: $startUp, files: $files, fs: $fs, curPath: $curPath, endMessage: $endMessage, tempOpenFile: $tempOpenFile, currentPreviewPath: $currentPreviewPath, errorMessage: $errorMessage, loadingCurrent: $loadingCurrent, loadingTotal: $loadingTotal, searchQuery: $searchQuery, availableSuffixes: $availableSuffixes, isSearching: $isSearching, searchFs: $searchFs, searchMatchedFiles: $searchMatchedFiles, searchKeptDirectories: $searchKeptDirectories, isGlobalSearchScope: $isGlobalSearchScope, searchPath: $searchPath, sortType: $sortType, isMultiSelectMode: $isMultiSelectMode, selectedItems: $selectedItems, sizeFilterMode: $sizeFilterMode, sizeFilterUnit: $sizeFilterUnit, sizeFilterSingleValue: $sizeFilterSingleValue, sizeFilterRangeStart: $sizeFilterRangeStart, sizeFilterRangeEnd: $sizeFilterRangeEnd, dateFilterMode: $dateFilterMode, dateFilterSingleDate: $dateFilterSingleDate, dateFilterRangeStart: $dateFilterRangeStart, dateFilterRangeEnd: $dateFilterRangeEnd)';
}


}

/// @nodoc
abstract mixin class _$Unp4kcStateCopyWith<$Res> implements $Unp4kcStateCopyWith<$Res> {
  factory _$Unp4kcStateCopyWith(_Unp4kcState value, $Res Function(_Unp4kcState) _then) = __$Unp4kcStateCopyWithImpl;
@override @useResult
$Res call({
 bool startUp, Map<String, AppUnp4kP4kItemData>? files, MemoryFileSystem? fs, String curPath, String? endMessage, MapEntry<String, String>? tempOpenFile, String? currentPreviewPath, String errorMessage, int loadingCurrent, int loadingTotal, String searchQuery, List<String> availableSuffixes, bool isSearching, MemoryFileSystem? searchFs, Set<String>? searchMatchedFiles, Set<String>? searchKeptDirectories, bool isGlobalSearchScope, String? searchPath, Unp4kSortType sortType, bool isMultiSelectMode, Set<String> selectedItems, Unp4kFilterMode sizeFilterMode, Unp4kSizeUnit sizeFilterUnit, double? sizeFilterSingleValue, double? sizeFilterRangeStart, double? sizeFilterRangeEnd, Unp4kFilterMode dateFilterMode, DateTime? dateFilterSingleDate, DateTime? dateFilterRangeStart, DateTime? dateFilterRangeEnd
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
@override @pragma('vm:prefer-inline') $Res call({Object? startUp = null,Object? files = freezed,Object? fs = freezed,Object? curPath = null,Object? endMessage = freezed,Object? tempOpenFile = freezed,Object? currentPreviewPath = freezed,Object? errorMessage = null,Object? loadingCurrent = null,Object? loadingTotal = null,Object? searchQuery = null,Object? availableSuffixes = null,Object? isSearching = null,Object? searchFs = freezed,Object? searchMatchedFiles = freezed,Object? searchKeptDirectories = freezed,Object? isGlobalSearchScope = null,Object? searchPath = freezed,Object? sortType = null,Object? isMultiSelectMode = null,Object? selectedItems = null,Object? sizeFilterMode = null,Object? sizeFilterUnit = null,Object? sizeFilterSingleValue = freezed,Object? sizeFilterRangeStart = freezed,Object? sizeFilterRangeEnd = freezed,Object? dateFilterMode = null,Object? dateFilterSingleDate = freezed,Object? dateFilterRangeStart = freezed,Object? dateFilterRangeEnd = freezed,}) {
  return _then(_Unp4kcState(
startUp: null == startUp ? _self.startUp : startUp // ignore: cast_nullable_to_non_nullable
as bool,files: freezed == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as Map<String, AppUnp4kP4kItemData>?,fs: freezed == fs ? _self.fs : fs // ignore: cast_nullable_to_non_nullable
as MemoryFileSystem?,curPath: null == curPath ? _self.curPath : curPath // ignore: cast_nullable_to_non_nullable
as String,endMessage: freezed == endMessage ? _self.endMessage : endMessage // ignore: cast_nullable_to_non_nullable
as String?,tempOpenFile: freezed == tempOpenFile ? _self.tempOpenFile : tempOpenFile // ignore: cast_nullable_to_non_nullable
as MapEntry<String, String>?,currentPreviewPath: freezed == currentPreviewPath ? _self.currentPreviewPath : currentPreviewPath // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,loadingCurrent: null == loadingCurrent ? _self.loadingCurrent : loadingCurrent // ignore: cast_nullable_to_non_nullable
as int,loadingTotal: null == loadingTotal ? _self.loadingTotal : loadingTotal // ignore: cast_nullable_to_non_nullable
as int,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,availableSuffixes: null == availableSuffixes ? _self._availableSuffixes : availableSuffixes // ignore: cast_nullable_to_non_nullable
as List<String>,isSearching: null == isSearching ? _self.isSearching : isSearching // ignore: cast_nullable_to_non_nullable
as bool,searchFs: freezed == searchFs ? _self.searchFs : searchFs // ignore: cast_nullable_to_non_nullable
as MemoryFileSystem?,searchMatchedFiles: freezed == searchMatchedFiles ? _self._searchMatchedFiles : searchMatchedFiles // ignore: cast_nullable_to_non_nullable
as Set<String>?,searchKeptDirectories: freezed == searchKeptDirectories ? _self._searchKeptDirectories : searchKeptDirectories // ignore: cast_nullable_to_non_nullable
as Set<String>?,isGlobalSearchScope: null == isGlobalSearchScope ? _self.isGlobalSearchScope : isGlobalSearchScope // ignore: cast_nullable_to_non_nullable
as bool,searchPath: freezed == searchPath ? _self.searchPath : searchPath // ignore: cast_nullable_to_non_nullable
as String?,sortType: null == sortType ? _self.sortType : sortType // ignore: cast_nullable_to_non_nullable
as Unp4kSortType,isMultiSelectMode: null == isMultiSelectMode ? _self.isMultiSelectMode : isMultiSelectMode // ignore: cast_nullable_to_non_nullable
as bool,selectedItems: null == selectedItems ? _self._selectedItems : selectedItems // ignore: cast_nullable_to_non_nullable
as Set<String>,sizeFilterMode: null == sizeFilterMode ? _self.sizeFilterMode : sizeFilterMode // ignore: cast_nullable_to_non_nullable
as Unp4kFilterMode,sizeFilterUnit: null == sizeFilterUnit ? _self.sizeFilterUnit : sizeFilterUnit // ignore: cast_nullable_to_non_nullable
as Unp4kSizeUnit,sizeFilterSingleValue: freezed == sizeFilterSingleValue ? _self.sizeFilterSingleValue : sizeFilterSingleValue // ignore: cast_nullable_to_non_nullable
as double?,sizeFilterRangeStart: freezed == sizeFilterRangeStart ? _self.sizeFilterRangeStart : sizeFilterRangeStart // ignore: cast_nullable_to_non_nullable
as double?,sizeFilterRangeEnd: freezed == sizeFilterRangeEnd ? _self.sizeFilterRangeEnd : sizeFilterRangeEnd // ignore: cast_nullable_to_non_nullable
as double?,dateFilterMode: null == dateFilterMode ? _self.dateFilterMode : dateFilterMode // ignore: cast_nullable_to_non_nullable
as Unp4kFilterMode,dateFilterSingleDate: freezed == dateFilterSingleDate ? _self.dateFilterSingleDate : dateFilterSingleDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dateFilterRangeStart: freezed == dateFilterRangeStart ? _self.dateFilterRangeStart : dateFilterRangeStart // ignore: cast_nullable_to_non_nullable
as DateTime?,dateFilterRangeEnd: freezed == dateFilterRangeEnd ? _self.dateFilterRangeEnd : dateFilterRangeEnd // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
