// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dcb_viewer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DcbViewerState {

/// 是否正在加载
 bool get isLoading;/// 加载/错误消息
 String get message;/// 错误消息
 String? get errorMessage;/// DCB 文件路径（用于显示标题）
 String get dcbFilePath;/// 数据源类型
 DcbSourceType get sourceType;/// 所有记录列表
 List<DcbRecordData> get allRecords;/// 当前过滤后的记录列表（用于列表搜索）
 List<DcbRecordData> get filteredRecords;/// 当前选中的记录路径
 String? get selectedRecordPath;/// 当前显示的 XML 内容
 String get currentXml;/// 列表搜索查询
 String get listSearchQuery;/// 全文搜索查询
 String get fullTextSearchQuery;/// 当前视图模式
 DcbViewMode get viewMode;/// 全文搜索结果
 List<DcbSearchResultData> get searchResults;/// 是否正在搜索
 bool get isSearching;/// 是否正在加载 XML
 bool get isLoadingXml;/// 是否正在导出
 bool get isExporting;/// 是否需要选择文件
 bool get needSelectFile;
/// Create a copy of DcbViewerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DcbViewerStateCopyWith<DcbViewerState> get copyWith => _$DcbViewerStateCopyWithImpl<DcbViewerState>(this as DcbViewerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DcbViewerState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.message, message) || other.message == message)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.dcbFilePath, dcbFilePath) || other.dcbFilePath == dcbFilePath)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&const DeepCollectionEquality().equals(other.allRecords, allRecords)&&const DeepCollectionEquality().equals(other.filteredRecords, filteredRecords)&&(identical(other.selectedRecordPath, selectedRecordPath) || other.selectedRecordPath == selectedRecordPath)&&(identical(other.currentXml, currentXml) || other.currentXml == currentXml)&&(identical(other.listSearchQuery, listSearchQuery) || other.listSearchQuery == listSearchQuery)&&(identical(other.fullTextSearchQuery, fullTextSearchQuery) || other.fullTextSearchQuery == fullTextSearchQuery)&&(identical(other.viewMode, viewMode) || other.viewMode == viewMode)&&const DeepCollectionEquality().equals(other.searchResults, searchResults)&&(identical(other.isSearching, isSearching) || other.isSearching == isSearching)&&(identical(other.isLoadingXml, isLoadingXml) || other.isLoadingXml == isLoadingXml)&&(identical(other.isExporting, isExporting) || other.isExporting == isExporting)&&(identical(other.needSelectFile, needSelectFile) || other.needSelectFile == needSelectFile));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,message,errorMessage,dcbFilePath,sourceType,const DeepCollectionEquality().hash(allRecords),const DeepCollectionEquality().hash(filteredRecords),selectedRecordPath,currentXml,listSearchQuery,fullTextSearchQuery,viewMode,const DeepCollectionEquality().hash(searchResults),isSearching,isLoadingXml,isExporting,needSelectFile);

@override
String toString() {
  return 'DcbViewerState(isLoading: $isLoading, message: $message, errorMessage: $errorMessage, dcbFilePath: $dcbFilePath, sourceType: $sourceType, allRecords: $allRecords, filteredRecords: $filteredRecords, selectedRecordPath: $selectedRecordPath, currentXml: $currentXml, listSearchQuery: $listSearchQuery, fullTextSearchQuery: $fullTextSearchQuery, viewMode: $viewMode, searchResults: $searchResults, isSearching: $isSearching, isLoadingXml: $isLoadingXml, isExporting: $isExporting, needSelectFile: $needSelectFile)';
}


}

/// @nodoc
abstract mixin class $DcbViewerStateCopyWith<$Res>  {
  factory $DcbViewerStateCopyWith(DcbViewerState value, $Res Function(DcbViewerState) _then) = _$DcbViewerStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, String message, String? errorMessage, String dcbFilePath, DcbSourceType sourceType, List<DcbRecordData> allRecords, List<DcbRecordData> filteredRecords, String? selectedRecordPath, String currentXml, String listSearchQuery, String fullTextSearchQuery, DcbViewMode viewMode, List<DcbSearchResultData> searchResults, bool isSearching, bool isLoadingXml, bool isExporting, bool needSelectFile
});




}
/// @nodoc
class _$DcbViewerStateCopyWithImpl<$Res>
    implements $DcbViewerStateCopyWith<$Res> {
  _$DcbViewerStateCopyWithImpl(this._self, this._then);

  final DcbViewerState _self;
  final $Res Function(DcbViewerState) _then;

/// Create a copy of DcbViewerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? message = null,Object? errorMessage = freezed,Object? dcbFilePath = null,Object? sourceType = null,Object? allRecords = null,Object? filteredRecords = null,Object? selectedRecordPath = freezed,Object? currentXml = null,Object? listSearchQuery = null,Object? fullTextSearchQuery = null,Object? viewMode = null,Object? searchResults = null,Object? isSearching = null,Object? isLoadingXml = null,Object? isExporting = null,Object? needSelectFile = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,dcbFilePath: null == dcbFilePath ? _self.dcbFilePath : dcbFilePath // ignore: cast_nullable_to_non_nullable
as String,sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as DcbSourceType,allRecords: null == allRecords ? _self.allRecords : allRecords // ignore: cast_nullable_to_non_nullable
as List<DcbRecordData>,filteredRecords: null == filteredRecords ? _self.filteredRecords : filteredRecords // ignore: cast_nullable_to_non_nullable
as List<DcbRecordData>,selectedRecordPath: freezed == selectedRecordPath ? _self.selectedRecordPath : selectedRecordPath // ignore: cast_nullable_to_non_nullable
as String?,currentXml: null == currentXml ? _self.currentXml : currentXml // ignore: cast_nullable_to_non_nullable
as String,listSearchQuery: null == listSearchQuery ? _self.listSearchQuery : listSearchQuery // ignore: cast_nullable_to_non_nullable
as String,fullTextSearchQuery: null == fullTextSearchQuery ? _self.fullTextSearchQuery : fullTextSearchQuery // ignore: cast_nullable_to_non_nullable
as String,viewMode: null == viewMode ? _self.viewMode : viewMode // ignore: cast_nullable_to_non_nullable
as DcbViewMode,searchResults: null == searchResults ? _self.searchResults : searchResults // ignore: cast_nullable_to_non_nullable
as List<DcbSearchResultData>,isSearching: null == isSearching ? _self.isSearching : isSearching // ignore: cast_nullable_to_non_nullable
as bool,isLoadingXml: null == isLoadingXml ? _self.isLoadingXml : isLoadingXml // ignore: cast_nullable_to_non_nullable
as bool,isExporting: null == isExporting ? _self.isExporting : isExporting // ignore: cast_nullable_to_non_nullable
as bool,needSelectFile: null == needSelectFile ? _self.needSelectFile : needSelectFile // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DcbViewerState].
extension DcbViewerStatePatterns on DcbViewerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DcbViewerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DcbViewerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DcbViewerState value)  $default,){
final _that = this;
switch (_that) {
case _DcbViewerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DcbViewerState value)?  $default,){
final _that = this;
switch (_that) {
case _DcbViewerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  String message,  String? errorMessage,  String dcbFilePath,  DcbSourceType sourceType,  List<DcbRecordData> allRecords,  List<DcbRecordData> filteredRecords,  String? selectedRecordPath,  String currentXml,  String listSearchQuery,  String fullTextSearchQuery,  DcbViewMode viewMode,  List<DcbSearchResultData> searchResults,  bool isSearching,  bool isLoadingXml,  bool isExporting,  bool needSelectFile)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DcbViewerState() when $default != null:
return $default(_that.isLoading,_that.message,_that.errorMessage,_that.dcbFilePath,_that.sourceType,_that.allRecords,_that.filteredRecords,_that.selectedRecordPath,_that.currentXml,_that.listSearchQuery,_that.fullTextSearchQuery,_that.viewMode,_that.searchResults,_that.isSearching,_that.isLoadingXml,_that.isExporting,_that.needSelectFile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  String message,  String? errorMessage,  String dcbFilePath,  DcbSourceType sourceType,  List<DcbRecordData> allRecords,  List<DcbRecordData> filteredRecords,  String? selectedRecordPath,  String currentXml,  String listSearchQuery,  String fullTextSearchQuery,  DcbViewMode viewMode,  List<DcbSearchResultData> searchResults,  bool isSearching,  bool isLoadingXml,  bool isExporting,  bool needSelectFile)  $default,) {final _that = this;
switch (_that) {
case _DcbViewerState():
return $default(_that.isLoading,_that.message,_that.errorMessage,_that.dcbFilePath,_that.sourceType,_that.allRecords,_that.filteredRecords,_that.selectedRecordPath,_that.currentXml,_that.listSearchQuery,_that.fullTextSearchQuery,_that.viewMode,_that.searchResults,_that.isSearching,_that.isLoadingXml,_that.isExporting,_that.needSelectFile);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  String message,  String? errorMessage,  String dcbFilePath,  DcbSourceType sourceType,  List<DcbRecordData> allRecords,  List<DcbRecordData> filteredRecords,  String? selectedRecordPath,  String currentXml,  String listSearchQuery,  String fullTextSearchQuery,  DcbViewMode viewMode,  List<DcbSearchResultData> searchResults,  bool isSearching,  bool isLoadingXml,  bool isExporting,  bool needSelectFile)?  $default,) {final _that = this;
switch (_that) {
case _DcbViewerState() when $default != null:
return $default(_that.isLoading,_that.message,_that.errorMessage,_that.dcbFilePath,_that.sourceType,_that.allRecords,_that.filteredRecords,_that.selectedRecordPath,_that.currentXml,_that.listSearchQuery,_that.fullTextSearchQuery,_that.viewMode,_that.searchResults,_that.isSearching,_that.isLoadingXml,_that.isExporting,_that.needSelectFile);case _:
  return null;

}
}

}

/// @nodoc


class _DcbViewerState implements DcbViewerState {
  const _DcbViewerState({this.isLoading = true, this.message = '', this.errorMessage, this.dcbFilePath = '', this.sourceType = DcbSourceType.none, final  List<DcbRecordData> allRecords = const [], final  List<DcbRecordData> filteredRecords = const [], this.selectedRecordPath, this.currentXml = '', this.listSearchQuery = '', this.fullTextSearchQuery = '', this.viewMode = DcbViewMode.browse, final  List<DcbSearchResultData> searchResults = const [], this.isSearching = false, this.isLoadingXml = false, this.isExporting = false, this.needSelectFile = false}): _allRecords = allRecords,_filteredRecords = filteredRecords,_searchResults = searchResults;
  

/// 是否正在加载
@override@JsonKey() final  bool isLoading;
/// 加载/错误消息
@override@JsonKey() final  String message;
/// 错误消息
@override final  String? errorMessage;
/// DCB 文件路径（用于显示标题）
@override@JsonKey() final  String dcbFilePath;
/// 数据源类型
@override@JsonKey() final  DcbSourceType sourceType;
/// 所有记录列表
 final  List<DcbRecordData> _allRecords;
/// 所有记录列表
@override@JsonKey() List<DcbRecordData> get allRecords {
  if (_allRecords is EqualUnmodifiableListView) return _allRecords;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allRecords);
}

/// 当前过滤后的记录列表（用于列表搜索）
 final  List<DcbRecordData> _filteredRecords;
/// 当前过滤后的记录列表（用于列表搜索）
@override@JsonKey() List<DcbRecordData> get filteredRecords {
  if (_filteredRecords is EqualUnmodifiableListView) return _filteredRecords;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filteredRecords);
}

/// 当前选中的记录路径
@override final  String? selectedRecordPath;
/// 当前显示的 XML 内容
@override@JsonKey() final  String currentXml;
/// 列表搜索查询
@override@JsonKey() final  String listSearchQuery;
/// 全文搜索查询
@override@JsonKey() final  String fullTextSearchQuery;
/// 当前视图模式
@override@JsonKey() final  DcbViewMode viewMode;
/// 全文搜索结果
 final  List<DcbSearchResultData> _searchResults;
/// 全文搜索结果
@override@JsonKey() List<DcbSearchResultData> get searchResults {
  if (_searchResults is EqualUnmodifiableListView) return _searchResults;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_searchResults);
}

/// 是否正在搜索
@override@JsonKey() final  bool isSearching;
/// 是否正在加载 XML
@override@JsonKey() final  bool isLoadingXml;
/// 是否正在导出
@override@JsonKey() final  bool isExporting;
/// 是否需要选择文件
@override@JsonKey() final  bool needSelectFile;

/// Create a copy of DcbViewerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DcbViewerStateCopyWith<_DcbViewerState> get copyWith => __$DcbViewerStateCopyWithImpl<_DcbViewerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DcbViewerState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.message, message) || other.message == message)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.dcbFilePath, dcbFilePath) || other.dcbFilePath == dcbFilePath)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&const DeepCollectionEquality().equals(other._allRecords, _allRecords)&&const DeepCollectionEquality().equals(other._filteredRecords, _filteredRecords)&&(identical(other.selectedRecordPath, selectedRecordPath) || other.selectedRecordPath == selectedRecordPath)&&(identical(other.currentXml, currentXml) || other.currentXml == currentXml)&&(identical(other.listSearchQuery, listSearchQuery) || other.listSearchQuery == listSearchQuery)&&(identical(other.fullTextSearchQuery, fullTextSearchQuery) || other.fullTextSearchQuery == fullTextSearchQuery)&&(identical(other.viewMode, viewMode) || other.viewMode == viewMode)&&const DeepCollectionEquality().equals(other._searchResults, _searchResults)&&(identical(other.isSearching, isSearching) || other.isSearching == isSearching)&&(identical(other.isLoadingXml, isLoadingXml) || other.isLoadingXml == isLoadingXml)&&(identical(other.isExporting, isExporting) || other.isExporting == isExporting)&&(identical(other.needSelectFile, needSelectFile) || other.needSelectFile == needSelectFile));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,message,errorMessage,dcbFilePath,sourceType,const DeepCollectionEquality().hash(_allRecords),const DeepCollectionEquality().hash(_filteredRecords),selectedRecordPath,currentXml,listSearchQuery,fullTextSearchQuery,viewMode,const DeepCollectionEquality().hash(_searchResults),isSearching,isLoadingXml,isExporting,needSelectFile);

@override
String toString() {
  return 'DcbViewerState(isLoading: $isLoading, message: $message, errorMessage: $errorMessage, dcbFilePath: $dcbFilePath, sourceType: $sourceType, allRecords: $allRecords, filteredRecords: $filteredRecords, selectedRecordPath: $selectedRecordPath, currentXml: $currentXml, listSearchQuery: $listSearchQuery, fullTextSearchQuery: $fullTextSearchQuery, viewMode: $viewMode, searchResults: $searchResults, isSearching: $isSearching, isLoadingXml: $isLoadingXml, isExporting: $isExporting, needSelectFile: $needSelectFile)';
}


}

/// @nodoc
abstract mixin class _$DcbViewerStateCopyWith<$Res> implements $DcbViewerStateCopyWith<$Res> {
  factory _$DcbViewerStateCopyWith(_DcbViewerState value, $Res Function(_DcbViewerState) _then) = __$DcbViewerStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String message, String? errorMessage, String dcbFilePath, DcbSourceType sourceType, List<DcbRecordData> allRecords, List<DcbRecordData> filteredRecords, String? selectedRecordPath, String currentXml, String listSearchQuery, String fullTextSearchQuery, DcbViewMode viewMode, List<DcbSearchResultData> searchResults, bool isSearching, bool isLoadingXml, bool isExporting, bool needSelectFile
});




}
/// @nodoc
class __$DcbViewerStateCopyWithImpl<$Res>
    implements _$DcbViewerStateCopyWith<$Res> {
  __$DcbViewerStateCopyWithImpl(this._self, this._then);

  final _DcbViewerState _self;
  final $Res Function(_DcbViewerState) _then;

/// Create a copy of DcbViewerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? message = null,Object? errorMessage = freezed,Object? dcbFilePath = null,Object? sourceType = null,Object? allRecords = null,Object? filteredRecords = null,Object? selectedRecordPath = freezed,Object? currentXml = null,Object? listSearchQuery = null,Object? fullTextSearchQuery = null,Object? viewMode = null,Object? searchResults = null,Object? isSearching = null,Object? isLoadingXml = null,Object? isExporting = null,Object? needSelectFile = null,}) {
  return _then(_DcbViewerState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,dcbFilePath: null == dcbFilePath ? _self.dcbFilePath : dcbFilePath // ignore: cast_nullable_to_non_nullable
as String,sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as DcbSourceType,allRecords: null == allRecords ? _self._allRecords : allRecords // ignore: cast_nullable_to_non_nullable
as List<DcbRecordData>,filteredRecords: null == filteredRecords ? _self._filteredRecords : filteredRecords // ignore: cast_nullable_to_non_nullable
as List<DcbRecordData>,selectedRecordPath: freezed == selectedRecordPath ? _self.selectedRecordPath : selectedRecordPath // ignore: cast_nullable_to_non_nullable
as String?,currentXml: null == currentXml ? _self.currentXml : currentXml // ignore: cast_nullable_to_non_nullable
as String,listSearchQuery: null == listSearchQuery ? _self.listSearchQuery : listSearchQuery // ignore: cast_nullable_to_non_nullable
as String,fullTextSearchQuery: null == fullTextSearchQuery ? _self.fullTextSearchQuery : fullTextSearchQuery // ignore: cast_nullable_to_non_nullable
as String,viewMode: null == viewMode ? _self.viewMode : viewMode // ignore: cast_nullable_to_non_nullable
as DcbViewMode,searchResults: null == searchResults ? _self._searchResults : searchResults // ignore: cast_nullable_to_non_nullable
as List<DcbSearchResultData>,isSearching: null == isSearching ? _self.isSearching : isSearching // ignore: cast_nullable_to_non_nullable
as bool,isLoadingXml: null == isLoadingXml ? _self.isLoadingXml : isLoadingXml // ignore: cast_nullable_to_non_nullable
as bool,isExporting: null == isExporting ? _self.isExporting : isExporting // ignore: cast_nullable_to_non_nullable
as bool,needSelectFile: null == needSelectFile ? _self.needSelectFile : needSelectFile // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
