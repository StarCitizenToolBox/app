// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'party_room_ui_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PartyRoomUIState {

 bool get isConnecting; bool get showRoomList; List<RoomListItem> get roomListItems; int get currentPage; int get pageSize; int get totalRooms; String? get selectedMainTagId; String? get selectedSubTagId; String get searchOwnerName; bool get isLoading; String? get errorMessage; String get preRegisterCode; String get registerGameUserId; bool get isReconnecting; int get reconnectAttempts; bool get isMinimized; bool get isLoggingIn; bool get isGuestMode; bool get isRefreshingProfile;
/// Create a copy of PartyRoomUIState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartyRoomUIStateCopyWith<PartyRoomUIState> get copyWith => _$PartyRoomUIStateCopyWithImpl<PartyRoomUIState>(this as PartyRoomUIState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PartyRoomUIState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PartyRoomUIState&&(identical(other.isConnecting, _this.isConnecting) || other.isConnecting == _this.isConnecting)&&(identical(other.showRoomList, _this.showRoomList) || other.showRoomList == _this.showRoomList)&&const DeepCollectionEquality().equals(other.roomListItems, _this.roomListItems)&&(identical(other.currentPage, _this.currentPage) || other.currentPage == _this.currentPage)&&(identical(other.pageSize, _this.pageSize) || other.pageSize == _this.pageSize)&&(identical(other.totalRooms, _this.totalRooms) || other.totalRooms == _this.totalRooms)&&(identical(other.selectedMainTagId, _this.selectedMainTagId) || other.selectedMainTagId == _this.selectedMainTagId)&&(identical(other.selectedSubTagId, _this.selectedSubTagId) || other.selectedSubTagId == _this.selectedSubTagId)&&(identical(other.searchOwnerName, _this.searchOwnerName) || other.searchOwnerName == _this.searchOwnerName)&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.errorMessage, _this.errorMessage) || other.errorMessage == _this.errorMessage)&&(identical(other.preRegisterCode, _this.preRegisterCode) || other.preRegisterCode == _this.preRegisterCode)&&(identical(other.registerGameUserId, _this.registerGameUserId) || other.registerGameUserId == _this.registerGameUserId)&&(identical(other.isReconnecting, _this.isReconnecting) || other.isReconnecting == _this.isReconnecting)&&(identical(other.reconnectAttempts, _this.reconnectAttempts) || other.reconnectAttempts == _this.reconnectAttempts)&&(identical(other.isMinimized, _this.isMinimized) || other.isMinimized == _this.isMinimized)&&(identical(other.isLoggingIn, _this.isLoggingIn) || other.isLoggingIn == _this.isLoggingIn)&&(identical(other.isGuestMode, _this.isGuestMode) || other.isGuestMode == _this.isGuestMode)&&(identical(other.isRefreshingProfile, _this.isRefreshingProfile) || other.isRefreshingProfile == _this.isRefreshingProfile));
}


@override
int get hashCode {
  final _this = this as PartyRoomUIState;
  return Object.hashAll([runtimeType,_this.isConnecting,_this.showRoomList,const DeepCollectionEquality().hash(_this.roomListItems),_this.currentPage,_this.pageSize,_this.totalRooms,_this.selectedMainTagId,_this.selectedSubTagId,_this.searchOwnerName,_this.isLoading,_this.errorMessage,_this.preRegisterCode,_this.registerGameUserId,_this.isReconnecting,_this.reconnectAttempts,_this.isMinimized,_this.isLoggingIn,_this.isGuestMode,_this.isRefreshingProfile]);
}

@override
String toString() {
  final _this = this as PartyRoomUIState;
  return 'PartyRoomUIState(isConnecting: ${_this.isConnecting}, showRoomList: ${_this.showRoomList}, roomListItems: ${_this.roomListItems}, currentPage: ${_this.currentPage}, pageSize: ${_this.pageSize}, totalRooms: ${_this.totalRooms}, selectedMainTagId: ${_this.selectedMainTagId}, selectedSubTagId: ${_this.selectedSubTagId}, searchOwnerName: ${_this.searchOwnerName}, isLoading: ${_this.isLoading}, errorMessage: ${_this.errorMessage}, preRegisterCode: ${_this.preRegisterCode}, registerGameUserId: ${_this.registerGameUserId}, isReconnecting: ${_this.isReconnecting}, reconnectAttempts: ${_this.reconnectAttempts}, isMinimized: ${_this.isMinimized}, isLoggingIn: ${_this.isLoggingIn}, isGuestMode: ${_this.isGuestMode}, isRefreshingProfile: ${_this.isRefreshingProfile})';
}


}

/// @nodoc
abstract mixin class $PartyRoomUIStateCopyWith<$Res>  {
  factory $PartyRoomUIStateCopyWith(PartyRoomUIState value, $Res Function(PartyRoomUIState) _then) = _$PartyRoomUIStateCopyWithImpl;
@useResult
$Res call({
 bool isConnecting, bool showRoomList, List<RoomListItem> roomListItems, int currentPage, int pageSize, int totalRooms, String? selectedMainTagId, String? selectedSubTagId, String searchOwnerName, bool isLoading, String? errorMessage, String preRegisterCode, String registerGameUserId, bool isReconnecting, int reconnectAttempts, bool isMinimized, bool isLoggingIn, bool isGuestMode, bool isRefreshingProfile
});




}
/// @nodoc
class _$PartyRoomUIStateCopyWithImpl<$Res>
    implements $PartyRoomUIStateCopyWith<$Res> {
  _$PartyRoomUIStateCopyWithImpl(this._self, this._then);

  final PartyRoomUIState _self;
  final $Res Function(PartyRoomUIState) _then;

/// Create a copy of PartyRoomUIState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isConnecting = null,Object? showRoomList = null,Object? roomListItems = null,Object? currentPage = null,Object? pageSize = null,Object? totalRooms = null,Object? selectedMainTagId = freezed,Object? selectedSubTagId = freezed,Object? searchOwnerName = null,Object? isLoading = null,Object? errorMessage = freezed,Object? preRegisterCode = null,Object? registerGameUserId = null,Object? isReconnecting = null,Object? reconnectAttempts = null,Object? isMinimized = null,Object? isLoggingIn = null,Object? isGuestMode = null,Object? isRefreshingProfile = null,}) {
  return _then(PartyRoomUIState(
isConnecting: null == isConnecting ? _self.isConnecting : isConnecting // ignore: cast_nullable_to_non_nullable
as bool,showRoomList: null == showRoomList ? _self.showRoomList : showRoomList // ignore: cast_nullable_to_non_nullable
as bool,roomListItems: null == roomListItems ? _self.roomListItems : roomListItems // ignore: cast_nullable_to_non_nullable
as List<RoomListItem>,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,totalRooms: null == totalRooms ? _self.totalRooms : totalRooms // ignore: cast_nullable_to_non_nullable
as int,selectedMainTagId: freezed == selectedMainTagId ? _self.selectedMainTagId : selectedMainTagId // ignore: cast_nullable_to_non_nullable
as String?,selectedSubTagId: freezed == selectedSubTagId ? _self.selectedSubTagId : selectedSubTagId // ignore: cast_nullable_to_non_nullable
as String?,searchOwnerName: null == searchOwnerName ? _self.searchOwnerName : searchOwnerName // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,preRegisterCode: null == preRegisterCode ? _self.preRegisterCode : preRegisterCode // ignore: cast_nullable_to_non_nullable
as String,registerGameUserId: null == registerGameUserId ? _self.registerGameUserId : registerGameUserId // ignore: cast_nullable_to_non_nullable
as String,isReconnecting: null == isReconnecting ? _self.isReconnecting : isReconnecting // ignore: cast_nullable_to_non_nullable
as bool,reconnectAttempts: null == reconnectAttempts ? _self.reconnectAttempts : reconnectAttempts // ignore: cast_nullable_to_non_nullable
as int,isMinimized: null == isMinimized ? _self.isMinimized : isMinimized // ignore: cast_nullable_to_non_nullable
as bool,isLoggingIn: null == isLoggingIn ? _self.isLoggingIn : isLoggingIn // ignore: cast_nullable_to_non_nullable
as bool,isGuestMode: null == isGuestMode ? _self.isGuestMode : isGuestMode // ignore: cast_nullable_to_non_nullable
as bool,isRefreshingProfile: null == isRefreshingProfile ? _self.isRefreshingProfile : isRefreshingProfile // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PartyRoomUIState].
extension PartyRoomUIStatePatterns on PartyRoomUIState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PartyRoomUIState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PartyRoomUIState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PartyRoomUIState value)  $default,){
final _that = this;
switch (_that) {
case _PartyRoomUIState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PartyRoomUIState value)?  $default,){
final _that = this;
switch (_that) {
case _PartyRoomUIState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isConnecting,  bool showRoomList,  List<RoomListItem> roomListItems,  int currentPage,  int pageSize,  int totalRooms,  String? selectedMainTagId,  String? selectedSubTagId,  String searchOwnerName,  bool isLoading,  String? errorMessage,  String preRegisterCode,  String registerGameUserId,  bool isReconnecting,  int reconnectAttempts,  bool isMinimized,  bool isLoggingIn,  bool isGuestMode,  bool isRefreshingProfile)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PartyRoomUIState() when $default != null:
return $default(_that.isConnecting,_that.showRoomList,_that.roomListItems,_that.currentPage,_that.pageSize,_that.totalRooms,_that.selectedMainTagId,_that.selectedSubTagId,_that.searchOwnerName,_that.isLoading,_that.errorMessage,_that.preRegisterCode,_that.registerGameUserId,_that.isReconnecting,_that.reconnectAttempts,_that.isMinimized,_that.isLoggingIn,_that.isGuestMode,_that.isRefreshingProfile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isConnecting,  bool showRoomList,  List<RoomListItem> roomListItems,  int currentPage,  int pageSize,  int totalRooms,  String? selectedMainTagId,  String? selectedSubTagId,  String searchOwnerName,  bool isLoading,  String? errorMessage,  String preRegisterCode,  String registerGameUserId,  bool isReconnecting,  int reconnectAttempts,  bool isMinimized,  bool isLoggingIn,  bool isGuestMode,  bool isRefreshingProfile)  $default,) {final _that = this;
switch (_that) {
case _PartyRoomUIState():
return $default(_that.isConnecting,_that.showRoomList,_that.roomListItems,_that.currentPage,_that.pageSize,_that.totalRooms,_that.selectedMainTagId,_that.selectedSubTagId,_that.searchOwnerName,_that.isLoading,_that.errorMessage,_that.preRegisterCode,_that.registerGameUserId,_that.isReconnecting,_that.reconnectAttempts,_that.isMinimized,_that.isLoggingIn,_that.isGuestMode,_that.isRefreshingProfile);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isConnecting,  bool showRoomList,  List<RoomListItem> roomListItems,  int currentPage,  int pageSize,  int totalRooms,  String? selectedMainTagId,  String? selectedSubTagId,  String searchOwnerName,  bool isLoading,  String? errorMessage,  String preRegisterCode,  String registerGameUserId,  bool isReconnecting,  int reconnectAttempts,  bool isMinimized,  bool isLoggingIn,  bool isGuestMode,  bool isRefreshingProfile)?  $default,) {final _that = this;
switch (_that) {
case _PartyRoomUIState() when $default != null:
return $default(_that.isConnecting,_that.showRoomList,_that.roomListItems,_that.currentPage,_that.pageSize,_that.totalRooms,_that.selectedMainTagId,_that.selectedSubTagId,_that.searchOwnerName,_that.isLoading,_that.errorMessage,_that.preRegisterCode,_that.registerGameUserId,_that.isReconnecting,_that.reconnectAttempts,_that.isMinimized,_that.isLoggingIn,_that.isGuestMode,_that.isRefreshingProfile);case _:
  return null;

}
}

}

/// @nodoc


class _PartyRoomUIState implements PartyRoomUIState {
  const _PartyRoomUIState({this.isConnecting = false, this.showRoomList = false,  List<RoomListItem> roomListItems = const [], this.currentPage = 1, this.pageSize = 20, this.totalRooms = 0, this.selectedMainTagId, this.selectedSubTagId, this.searchOwnerName = '', this.isLoading = false, this.errorMessage, this.preRegisterCode = '', this.registerGameUserId = '', this.isReconnecting = false, this.reconnectAttempts = 0, this.isMinimized = false, this.isLoggingIn = false, this.isGuestMode = true, this.isRefreshingProfile = false}): _roomListItems = roomListItems;
  

@override@JsonKey() final  bool isConnecting;
@override@JsonKey() final  bool showRoomList;
 final  List<RoomListItem> _roomListItems;
@override@JsonKey() List<RoomListItem> get roomListItems {
  if (_roomListItems is EqualUnmodifiableListView) return _roomListItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_roomListItems);
}

@override@JsonKey() final  int currentPage;
@override@JsonKey() final  int pageSize;
@override@JsonKey() final  int totalRooms;
@override final  String? selectedMainTagId;
@override final  String? selectedSubTagId;
@override@JsonKey() final  String searchOwnerName;
@override@JsonKey() final  bool isLoading;
@override final  String? errorMessage;
@override@JsonKey() final  String preRegisterCode;
@override@JsonKey() final  String registerGameUserId;
@override@JsonKey() final  bool isReconnecting;
@override@JsonKey() final  int reconnectAttempts;
@override@JsonKey() final  bool isMinimized;
@override@JsonKey() final  bool isLoggingIn;
@override@JsonKey() final  bool isGuestMode;
@override@JsonKey() final  bool isRefreshingProfile;

/// Create a copy of PartyRoomUIState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartyRoomUIStateCopyWith<_PartyRoomUIState> get copyWith => __$PartyRoomUIStateCopyWithImpl<_PartyRoomUIState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PartyRoomUIState&&(identical(other.isConnecting, isConnecting) || other.isConnecting == isConnecting)&&(identical(other.showRoomList, showRoomList) || other.showRoomList == showRoomList)&&const DeepCollectionEquality().equals(other.roomListItems, _roomListItems)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.totalRooms, totalRooms) || other.totalRooms == totalRooms)&&(identical(other.selectedMainTagId, selectedMainTagId) || other.selectedMainTagId == selectedMainTagId)&&(identical(other.selectedSubTagId, selectedSubTagId) || other.selectedSubTagId == selectedSubTagId)&&(identical(other.searchOwnerName, searchOwnerName) || other.searchOwnerName == searchOwnerName)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.preRegisterCode, preRegisterCode) || other.preRegisterCode == preRegisterCode)&&(identical(other.registerGameUserId, registerGameUserId) || other.registerGameUserId == registerGameUserId)&&(identical(other.isReconnecting, isReconnecting) || other.isReconnecting == isReconnecting)&&(identical(other.reconnectAttempts, reconnectAttempts) || other.reconnectAttempts == reconnectAttempts)&&(identical(other.isMinimized, isMinimized) || other.isMinimized == isMinimized)&&(identical(other.isLoggingIn, isLoggingIn) || other.isLoggingIn == isLoggingIn)&&(identical(other.isGuestMode, isGuestMode) || other.isGuestMode == isGuestMode)&&(identical(other.isRefreshingProfile, isRefreshingProfile) || other.isRefreshingProfile == isRefreshingProfile));
}


@override
int get hashCode {
    return Object.hashAll([runtimeType,isConnecting,showRoomList,const DeepCollectionEquality().hash(_roomListItems),currentPage,pageSize,totalRooms,selectedMainTagId,selectedSubTagId,searchOwnerName,isLoading,errorMessage,preRegisterCode,registerGameUserId,isReconnecting,reconnectAttempts,isMinimized,isLoggingIn,isGuestMode,isRefreshingProfile]);
}

@override
String toString() {
    return 'PartyRoomUIState(isConnecting: $isConnecting, showRoomList: $showRoomList, roomListItems: $roomListItems, currentPage: $currentPage, pageSize: $pageSize, totalRooms: $totalRooms, selectedMainTagId: $selectedMainTagId, selectedSubTagId: $selectedSubTagId, searchOwnerName: $searchOwnerName, isLoading: $isLoading, errorMessage: $errorMessage, preRegisterCode: $preRegisterCode, registerGameUserId: $registerGameUserId, isReconnecting: $isReconnecting, reconnectAttempts: $reconnectAttempts, isMinimized: $isMinimized, isLoggingIn: $isLoggingIn, isGuestMode: $isGuestMode, isRefreshingProfile: $isRefreshingProfile)';
}


}

/// @nodoc
abstract mixin class _$PartyRoomUIStateCopyWith<$Res> implements $PartyRoomUIStateCopyWith<$Res> {
  factory _$PartyRoomUIStateCopyWith(_PartyRoomUIState value, $Res Function(_PartyRoomUIState) _then) = __$PartyRoomUIStateCopyWithImpl;
@override @useResult
$Res call({
 bool isConnecting, bool showRoomList, List<RoomListItem> roomListItems, int currentPage, int pageSize, int totalRooms, String? selectedMainTagId, String? selectedSubTagId, String searchOwnerName, bool isLoading, String? errorMessage, String preRegisterCode, String registerGameUserId, bool isReconnecting, int reconnectAttempts, bool isMinimized, bool isLoggingIn, bool isGuestMode, bool isRefreshingProfile
});




}
/// @nodoc
class __$PartyRoomUIStateCopyWithImpl<$Res>
    implements _$PartyRoomUIStateCopyWith<$Res> {
  __$PartyRoomUIStateCopyWithImpl(this._self, this._then);

  final _PartyRoomUIState _self;
  final $Res Function(_PartyRoomUIState) _then;

/// Create a copy of PartyRoomUIState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isConnecting = null,Object? showRoomList = null,Object? roomListItems = null,Object? currentPage = null,Object? pageSize = null,Object? totalRooms = null,Object? selectedMainTagId = freezed,Object? selectedSubTagId = freezed,Object? searchOwnerName = null,Object? isLoading = null,Object? errorMessage = freezed,Object? preRegisterCode = null,Object? registerGameUserId = null,Object? isReconnecting = null,Object? reconnectAttempts = null,Object? isMinimized = null,Object? isLoggingIn = null,Object? isGuestMode = null,Object? isRefreshingProfile = null,}) {
  return _then(_PartyRoomUIState(
isConnecting: null == isConnecting ? _self.isConnecting : isConnecting // ignore: cast_nullable_to_non_nullable
as bool,showRoomList: null == showRoomList ? _self.showRoomList : showRoomList // ignore: cast_nullable_to_non_nullable
as bool,roomListItems: null == roomListItems ? _self._roomListItems : roomListItems // ignore: cast_nullable_to_non_nullable
as List<RoomListItem>,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,totalRooms: null == totalRooms ? _self.totalRooms : totalRooms // ignore: cast_nullable_to_non_nullable
as int,selectedMainTagId: freezed == selectedMainTagId ? _self.selectedMainTagId : selectedMainTagId // ignore: cast_nullable_to_non_nullable
as String?,selectedSubTagId: freezed == selectedSubTagId ? _self.selectedSubTagId : selectedSubTagId // ignore: cast_nullable_to_non_nullable
as String?,searchOwnerName: null == searchOwnerName ? _self.searchOwnerName : searchOwnerName // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,preRegisterCode: null == preRegisterCode ? _self.preRegisterCode : preRegisterCode // ignore: cast_nullable_to_non_nullable
as String,registerGameUserId: null == registerGameUserId ? _self.registerGameUserId : registerGameUserId // ignore: cast_nullable_to_non_nullable
as String,isReconnecting: null == isReconnecting ? _self.isReconnecting : isReconnecting // ignore: cast_nullable_to_non_nullable
as bool,reconnectAttempts: null == reconnectAttempts ? _self.reconnectAttempts : reconnectAttempts // ignore: cast_nullable_to_non_nullable
as int,isMinimized: null == isMinimized ? _self.isMinimized : isMinimized // ignore: cast_nullable_to_non_nullable
as bool,isLoggingIn: null == isLoggingIn ? _self.isLoggingIn : isLoggingIn // ignore: cast_nullable_to_non_nullable
as bool,isGuestMode: null == isGuestMode ? _self.isGuestMode : isGuestMode // ignore: cast_nullable_to_non_nullable
as bool,isRefreshingProfile: null == isRefreshingProfile ? _self.isRefreshingProfile : isRefreshingProfile // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
