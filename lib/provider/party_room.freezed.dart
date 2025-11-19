// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'party_room.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PartyRoomAuthState {

 String get uuid; String get secretKey; bool get isLoggedIn; auth.GameUserInfo? get userInfo; DateTime? get lastLoginTime;
/// Create a copy of PartyRoomAuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartyRoomAuthStateCopyWith<PartyRoomAuthState> get copyWith => _$PartyRoomAuthStateCopyWithImpl<PartyRoomAuthState>(this as PartyRoomAuthState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PartyRoomAuthState&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.secretKey, secretKey) || other.secretKey == secretKey)&&(identical(other.isLoggedIn, isLoggedIn) || other.isLoggedIn == isLoggedIn)&&(identical(other.userInfo, userInfo) || other.userInfo == userInfo)&&(identical(other.lastLoginTime, lastLoginTime) || other.lastLoginTime == lastLoginTime));
}


@override
int get hashCode => Object.hash(runtimeType,uuid,secretKey,isLoggedIn,userInfo,lastLoginTime);

@override
String toString() {
  return 'PartyRoomAuthState(uuid: $uuid, secretKey: $secretKey, isLoggedIn: $isLoggedIn, userInfo: $userInfo, lastLoginTime: $lastLoginTime)';
}


}

/// @nodoc
abstract mixin class $PartyRoomAuthStateCopyWith<$Res>  {
  factory $PartyRoomAuthStateCopyWith(PartyRoomAuthState value, $Res Function(PartyRoomAuthState) _then) = _$PartyRoomAuthStateCopyWithImpl;
@useResult
$Res call({
 String uuid, String secretKey, bool isLoggedIn, auth.GameUserInfo? userInfo, DateTime? lastLoginTime
});




}
/// @nodoc
class _$PartyRoomAuthStateCopyWithImpl<$Res>
    implements $PartyRoomAuthStateCopyWith<$Res> {
  _$PartyRoomAuthStateCopyWithImpl(this._self, this._then);

  final PartyRoomAuthState _self;
  final $Res Function(PartyRoomAuthState) _then;

/// Create a copy of PartyRoomAuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uuid = null,Object? secretKey = null,Object? isLoggedIn = null,Object? userInfo = freezed,Object? lastLoginTime = freezed,}) {
  return _then(_self.copyWith(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,secretKey: null == secretKey ? _self.secretKey : secretKey // ignore: cast_nullable_to_non_nullable
as String,isLoggedIn: null == isLoggedIn ? _self.isLoggedIn : isLoggedIn // ignore: cast_nullable_to_non_nullable
as bool,userInfo: freezed == userInfo ? _self.userInfo : userInfo // ignore: cast_nullable_to_non_nullable
as auth.GameUserInfo?,lastLoginTime: freezed == lastLoginTime ? _self.lastLoginTime : lastLoginTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PartyRoomAuthState].
extension PartyRoomAuthStatePatterns on PartyRoomAuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PartyRoomAuthState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PartyRoomAuthState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PartyRoomAuthState value)  $default,){
final _that = this;
switch (_that) {
case _PartyRoomAuthState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PartyRoomAuthState value)?  $default,){
final _that = this;
switch (_that) {
case _PartyRoomAuthState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uuid,  String secretKey,  bool isLoggedIn,  auth.GameUserInfo? userInfo,  DateTime? lastLoginTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PartyRoomAuthState() when $default != null:
return $default(_that.uuid,_that.secretKey,_that.isLoggedIn,_that.userInfo,_that.lastLoginTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uuid,  String secretKey,  bool isLoggedIn,  auth.GameUserInfo? userInfo,  DateTime? lastLoginTime)  $default,) {final _that = this;
switch (_that) {
case _PartyRoomAuthState():
return $default(_that.uuid,_that.secretKey,_that.isLoggedIn,_that.userInfo,_that.lastLoginTime);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uuid,  String secretKey,  bool isLoggedIn,  auth.GameUserInfo? userInfo,  DateTime? lastLoginTime)?  $default,) {final _that = this;
switch (_that) {
case _PartyRoomAuthState() when $default != null:
return $default(_that.uuid,_that.secretKey,_that.isLoggedIn,_that.userInfo,_that.lastLoginTime);case _:
  return null;

}
}

}

/// @nodoc


class _PartyRoomAuthState implements PartyRoomAuthState {
  const _PartyRoomAuthState({this.uuid = '', this.secretKey = '', this.isLoggedIn = false, this.userInfo, this.lastLoginTime});
  

@override@JsonKey() final  String uuid;
@override@JsonKey() final  String secretKey;
@override@JsonKey() final  bool isLoggedIn;
@override final  auth.GameUserInfo? userInfo;
@override final  DateTime? lastLoginTime;

/// Create a copy of PartyRoomAuthState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartyRoomAuthStateCopyWith<_PartyRoomAuthState> get copyWith => __$PartyRoomAuthStateCopyWithImpl<_PartyRoomAuthState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PartyRoomAuthState&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.secretKey, secretKey) || other.secretKey == secretKey)&&(identical(other.isLoggedIn, isLoggedIn) || other.isLoggedIn == isLoggedIn)&&(identical(other.userInfo, userInfo) || other.userInfo == userInfo)&&(identical(other.lastLoginTime, lastLoginTime) || other.lastLoginTime == lastLoginTime));
}


@override
int get hashCode => Object.hash(runtimeType,uuid,secretKey,isLoggedIn,userInfo,lastLoginTime);

@override
String toString() {
  return 'PartyRoomAuthState(uuid: $uuid, secretKey: $secretKey, isLoggedIn: $isLoggedIn, userInfo: $userInfo, lastLoginTime: $lastLoginTime)';
}


}

/// @nodoc
abstract mixin class _$PartyRoomAuthStateCopyWith<$Res> implements $PartyRoomAuthStateCopyWith<$Res> {
  factory _$PartyRoomAuthStateCopyWith(_PartyRoomAuthState value, $Res Function(_PartyRoomAuthState) _then) = __$PartyRoomAuthStateCopyWithImpl;
@override @useResult
$Res call({
 String uuid, String secretKey, bool isLoggedIn, auth.GameUserInfo? userInfo, DateTime? lastLoginTime
});




}
/// @nodoc
class __$PartyRoomAuthStateCopyWithImpl<$Res>
    implements _$PartyRoomAuthStateCopyWith<$Res> {
  __$PartyRoomAuthStateCopyWithImpl(this._self, this._then);

  final _PartyRoomAuthState _self;
  final $Res Function(_PartyRoomAuthState) _then;

/// Create a copy of PartyRoomAuthState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uuid = null,Object? secretKey = null,Object? isLoggedIn = null,Object? userInfo = freezed,Object? lastLoginTime = freezed,}) {
  return _then(_PartyRoomAuthState(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,secretKey: null == secretKey ? _self.secretKey : secretKey // ignore: cast_nullable_to_non_nullable
as String,isLoggedIn: null == isLoggedIn ? _self.isLoggedIn : isLoggedIn // ignore: cast_nullable_to_non_nullable
as bool,userInfo: freezed == userInfo ? _self.userInfo : userInfo // ignore: cast_nullable_to_non_nullable
as auth.GameUserInfo?,lastLoginTime: freezed == lastLoginTime ? _self.lastLoginTime : lastLoginTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$PartyRoomState {

 partroom.RoomInfo? get currentRoom; List<partroom.RoomMember> get members; Map<String, common.Tag> get tags; Map<String, common.SignalType> get signalTypes; bool get isInRoom; bool get isOwner; String? get roomUuid; List<partroom.RoomEvent> get recentEvents;
/// Create a copy of PartyRoomState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartyRoomStateCopyWith<PartyRoomState> get copyWith => _$PartyRoomStateCopyWithImpl<PartyRoomState>(this as PartyRoomState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PartyRoomState&&(identical(other.currentRoom, currentRoom) || other.currentRoom == currentRoom)&&const DeepCollectionEquality().equals(other.members, members)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.signalTypes, signalTypes)&&(identical(other.isInRoom, isInRoom) || other.isInRoom == isInRoom)&&(identical(other.isOwner, isOwner) || other.isOwner == isOwner)&&(identical(other.roomUuid, roomUuid) || other.roomUuid == roomUuid)&&const DeepCollectionEquality().equals(other.recentEvents, recentEvents));
}


@override
int get hashCode => Object.hash(runtimeType,currentRoom,const DeepCollectionEquality().hash(members),const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(signalTypes),isInRoom,isOwner,roomUuid,const DeepCollectionEquality().hash(recentEvents));

@override
String toString() {
  return 'PartyRoomState(currentRoom: $currentRoom, members: $members, tags: $tags, signalTypes: $signalTypes, isInRoom: $isInRoom, isOwner: $isOwner, roomUuid: $roomUuid, recentEvents: $recentEvents)';
}


}

/// @nodoc
abstract mixin class $PartyRoomStateCopyWith<$Res>  {
  factory $PartyRoomStateCopyWith(PartyRoomState value, $Res Function(PartyRoomState) _then) = _$PartyRoomStateCopyWithImpl;
@useResult
$Res call({
 partroom.RoomInfo? currentRoom, List<partroom.RoomMember> members, Map<String, common.Tag> tags, Map<String, common.SignalType> signalTypes, bool isInRoom, bool isOwner, String? roomUuid, List<partroom.RoomEvent> recentEvents
});




}
/// @nodoc
class _$PartyRoomStateCopyWithImpl<$Res>
    implements $PartyRoomStateCopyWith<$Res> {
  _$PartyRoomStateCopyWithImpl(this._self, this._then);

  final PartyRoomState _self;
  final $Res Function(PartyRoomState) _then;

/// Create a copy of PartyRoomState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentRoom = freezed,Object? members = null,Object? tags = null,Object? signalTypes = null,Object? isInRoom = null,Object? isOwner = null,Object? roomUuid = freezed,Object? recentEvents = null,}) {
  return _then(_self.copyWith(
currentRoom: freezed == currentRoom ? _self.currentRoom : currentRoom // ignore: cast_nullable_to_non_nullable
as partroom.RoomInfo?,members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<partroom.RoomMember>,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as Map<String, common.Tag>,signalTypes: null == signalTypes ? _self.signalTypes : signalTypes // ignore: cast_nullable_to_non_nullable
as Map<String, common.SignalType>,isInRoom: null == isInRoom ? _self.isInRoom : isInRoom // ignore: cast_nullable_to_non_nullable
as bool,isOwner: null == isOwner ? _self.isOwner : isOwner // ignore: cast_nullable_to_non_nullable
as bool,roomUuid: freezed == roomUuid ? _self.roomUuid : roomUuid // ignore: cast_nullable_to_non_nullable
as String?,recentEvents: null == recentEvents ? _self.recentEvents : recentEvents // ignore: cast_nullable_to_non_nullable
as List<partroom.RoomEvent>,
  ));
}

}


/// Adds pattern-matching-related methods to [PartyRoomState].
extension PartyRoomStatePatterns on PartyRoomState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PartyRoomState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PartyRoomState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PartyRoomState value)  $default,){
final _that = this;
switch (_that) {
case _PartyRoomState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PartyRoomState value)?  $default,){
final _that = this;
switch (_that) {
case _PartyRoomState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( partroom.RoomInfo? currentRoom,  List<partroom.RoomMember> members,  Map<String, common.Tag> tags,  Map<String, common.SignalType> signalTypes,  bool isInRoom,  bool isOwner,  String? roomUuid,  List<partroom.RoomEvent> recentEvents)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PartyRoomState() when $default != null:
return $default(_that.currentRoom,_that.members,_that.tags,_that.signalTypes,_that.isInRoom,_that.isOwner,_that.roomUuid,_that.recentEvents);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( partroom.RoomInfo? currentRoom,  List<partroom.RoomMember> members,  Map<String, common.Tag> tags,  Map<String, common.SignalType> signalTypes,  bool isInRoom,  bool isOwner,  String? roomUuid,  List<partroom.RoomEvent> recentEvents)  $default,) {final _that = this;
switch (_that) {
case _PartyRoomState():
return $default(_that.currentRoom,_that.members,_that.tags,_that.signalTypes,_that.isInRoom,_that.isOwner,_that.roomUuid,_that.recentEvents);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( partroom.RoomInfo? currentRoom,  List<partroom.RoomMember> members,  Map<String, common.Tag> tags,  Map<String, common.SignalType> signalTypes,  bool isInRoom,  bool isOwner,  String? roomUuid,  List<partroom.RoomEvent> recentEvents)?  $default,) {final _that = this;
switch (_that) {
case _PartyRoomState() when $default != null:
return $default(_that.currentRoom,_that.members,_that.tags,_that.signalTypes,_that.isInRoom,_that.isOwner,_that.roomUuid,_that.recentEvents);case _:
  return null;

}
}

}

/// @nodoc


class _PartyRoomState implements PartyRoomState {
  const _PartyRoomState({this.currentRoom, final  List<partroom.RoomMember> members = const [], final  Map<String, common.Tag> tags = const {}, final  Map<String, common.SignalType> signalTypes = const {}, this.isInRoom = false, this.isOwner = false, this.roomUuid, final  List<partroom.RoomEvent> recentEvents = const []}): _members = members,_tags = tags,_signalTypes = signalTypes,_recentEvents = recentEvents;
  

@override final  partroom.RoomInfo? currentRoom;
 final  List<partroom.RoomMember> _members;
@override@JsonKey() List<partroom.RoomMember> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}

 final  Map<String, common.Tag> _tags;
@override@JsonKey() Map<String, common.Tag> get tags {
  if (_tags is EqualUnmodifiableMapView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_tags);
}

 final  Map<String, common.SignalType> _signalTypes;
@override@JsonKey() Map<String, common.SignalType> get signalTypes {
  if (_signalTypes is EqualUnmodifiableMapView) return _signalTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_signalTypes);
}

@override@JsonKey() final  bool isInRoom;
@override@JsonKey() final  bool isOwner;
@override final  String? roomUuid;
 final  List<partroom.RoomEvent> _recentEvents;
@override@JsonKey() List<partroom.RoomEvent> get recentEvents {
  if (_recentEvents is EqualUnmodifiableListView) return _recentEvents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentEvents);
}


/// Create a copy of PartyRoomState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartyRoomStateCopyWith<_PartyRoomState> get copyWith => __$PartyRoomStateCopyWithImpl<_PartyRoomState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PartyRoomState&&(identical(other.currentRoom, currentRoom) || other.currentRoom == currentRoom)&&const DeepCollectionEquality().equals(other._members, _members)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._signalTypes, _signalTypes)&&(identical(other.isInRoom, isInRoom) || other.isInRoom == isInRoom)&&(identical(other.isOwner, isOwner) || other.isOwner == isOwner)&&(identical(other.roomUuid, roomUuid) || other.roomUuid == roomUuid)&&const DeepCollectionEquality().equals(other._recentEvents, _recentEvents));
}


@override
int get hashCode => Object.hash(runtimeType,currentRoom,const DeepCollectionEquality().hash(_members),const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_signalTypes),isInRoom,isOwner,roomUuid,const DeepCollectionEquality().hash(_recentEvents));

@override
String toString() {
  return 'PartyRoomState(currentRoom: $currentRoom, members: $members, tags: $tags, signalTypes: $signalTypes, isInRoom: $isInRoom, isOwner: $isOwner, roomUuid: $roomUuid, recentEvents: $recentEvents)';
}


}

/// @nodoc
abstract mixin class _$PartyRoomStateCopyWith<$Res> implements $PartyRoomStateCopyWith<$Res> {
  factory _$PartyRoomStateCopyWith(_PartyRoomState value, $Res Function(_PartyRoomState) _then) = __$PartyRoomStateCopyWithImpl;
@override @useResult
$Res call({
 partroom.RoomInfo? currentRoom, List<partroom.RoomMember> members, Map<String, common.Tag> tags, Map<String, common.SignalType> signalTypes, bool isInRoom, bool isOwner, String? roomUuid, List<partroom.RoomEvent> recentEvents
});




}
/// @nodoc
class __$PartyRoomStateCopyWithImpl<$Res>
    implements _$PartyRoomStateCopyWith<$Res> {
  __$PartyRoomStateCopyWithImpl(this._self, this._then);

  final _PartyRoomState _self;
  final $Res Function(_PartyRoomState) _then;

/// Create a copy of PartyRoomState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentRoom = freezed,Object? members = null,Object? tags = null,Object? signalTypes = null,Object? isInRoom = null,Object? isOwner = null,Object? roomUuid = freezed,Object? recentEvents = null,}) {
  return _then(_PartyRoomState(
currentRoom: freezed == currentRoom ? _self.currentRoom : currentRoom // ignore: cast_nullable_to_non_nullable
as partroom.RoomInfo?,members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<partroom.RoomMember>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as Map<String, common.Tag>,signalTypes: null == signalTypes ? _self._signalTypes : signalTypes // ignore: cast_nullable_to_non_nullable
as Map<String, common.SignalType>,isInRoom: null == isInRoom ? _self.isInRoom : isInRoom // ignore: cast_nullable_to_non_nullable
as bool,isOwner: null == isOwner ? _self.isOwner : isOwner // ignore: cast_nullable_to_non_nullable
as bool,roomUuid: freezed == roomUuid ? _self.roomUuid : roomUuid // ignore: cast_nullable_to_non_nullable
as String?,recentEvents: null == recentEvents ? _self._recentEvents : recentEvents // ignore: cast_nullable_to_non_nullable
as List<partroom.RoomEvent>,
  ));
}


}

/// @nodoc
mixin _$PartyRoomClientState {

 ClientChannel? get channel; auth.AuthServiceClient? get authClient; partroom.PartRoomServiceClient? get roomClient; common.CommonServiceClient? get commonClient; bool get isConnected; String get serverAddress; int get serverPort;
/// Create a copy of PartyRoomClientState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartyRoomClientStateCopyWith<PartyRoomClientState> get copyWith => _$PartyRoomClientStateCopyWithImpl<PartyRoomClientState>(this as PartyRoomClientState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PartyRoomClientState&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.authClient, authClient) || other.authClient == authClient)&&(identical(other.roomClient, roomClient) || other.roomClient == roomClient)&&(identical(other.commonClient, commonClient) || other.commonClient == commonClient)&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected)&&(identical(other.serverAddress, serverAddress) || other.serverAddress == serverAddress)&&(identical(other.serverPort, serverPort) || other.serverPort == serverPort));
}


@override
int get hashCode => Object.hash(runtimeType,channel,authClient,roomClient,commonClient,isConnected,serverAddress,serverPort);

@override
String toString() {
  return 'PartyRoomClientState(channel: $channel, authClient: $authClient, roomClient: $roomClient, commonClient: $commonClient, isConnected: $isConnected, serverAddress: $serverAddress, serverPort: $serverPort)';
}


}

/// @nodoc
abstract mixin class $PartyRoomClientStateCopyWith<$Res>  {
  factory $PartyRoomClientStateCopyWith(PartyRoomClientState value, $Res Function(PartyRoomClientState) _then) = _$PartyRoomClientStateCopyWithImpl;
@useResult
$Res call({
 ClientChannel? channel, auth.AuthServiceClient? authClient, partroom.PartRoomServiceClient? roomClient, common.CommonServiceClient? commonClient, bool isConnected, String serverAddress, int serverPort
});




}
/// @nodoc
class _$PartyRoomClientStateCopyWithImpl<$Res>
    implements $PartyRoomClientStateCopyWith<$Res> {
  _$PartyRoomClientStateCopyWithImpl(this._self, this._then);

  final PartyRoomClientState _self;
  final $Res Function(PartyRoomClientState) _then;

/// Create a copy of PartyRoomClientState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? channel = freezed,Object? authClient = freezed,Object? roomClient = freezed,Object? commonClient = freezed,Object? isConnected = null,Object? serverAddress = null,Object? serverPort = null,}) {
  return _then(_self.copyWith(
channel: freezed == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as ClientChannel?,authClient: freezed == authClient ? _self.authClient : authClient // ignore: cast_nullable_to_non_nullable
as auth.AuthServiceClient?,roomClient: freezed == roomClient ? _self.roomClient : roomClient // ignore: cast_nullable_to_non_nullable
as partroom.PartRoomServiceClient?,commonClient: freezed == commonClient ? _self.commonClient : commonClient // ignore: cast_nullable_to_non_nullable
as common.CommonServiceClient?,isConnected: null == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool,serverAddress: null == serverAddress ? _self.serverAddress : serverAddress // ignore: cast_nullable_to_non_nullable
as String,serverPort: null == serverPort ? _self.serverPort : serverPort // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PartyRoomClientState].
extension PartyRoomClientStatePatterns on PartyRoomClientState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PartyRoomClientState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PartyRoomClientState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PartyRoomClientState value)  $default,){
final _that = this;
switch (_that) {
case _PartyRoomClientState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PartyRoomClientState value)?  $default,){
final _that = this;
switch (_that) {
case _PartyRoomClientState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ClientChannel? channel,  auth.AuthServiceClient? authClient,  partroom.PartRoomServiceClient? roomClient,  common.CommonServiceClient? commonClient,  bool isConnected,  String serverAddress,  int serverPort)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PartyRoomClientState() when $default != null:
return $default(_that.channel,_that.authClient,_that.roomClient,_that.commonClient,_that.isConnected,_that.serverAddress,_that.serverPort);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ClientChannel? channel,  auth.AuthServiceClient? authClient,  partroom.PartRoomServiceClient? roomClient,  common.CommonServiceClient? commonClient,  bool isConnected,  String serverAddress,  int serverPort)  $default,) {final _that = this;
switch (_that) {
case _PartyRoomClientState():
return $default(_that.channel,_that.authClient,_that.roomClient,_that.commonClient,_that.isConnected,_that.serverAddress,_that.serverPort);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ClientChannel? channel,  auth.AuthServiceClient? authClient,  partroom.PartRoomServiceClient? roomClient,  common.CommonServiceClient? commonClient,  bool isConnected,  String serverAddress,  int serverPort)?  $default,) {final _that = this;
switch (_that) {
case _PartyRoomClientState() when $default != null:
return $default(_that.channel,_that.authClient,_that.roomClient,_that.commonClient,_that.isConnected,_that.serverAddress,_that.serverPort);case _:
  return null;

}
}

}

/// @nodoc


class _PartyRoomClientState implements PartyRoomClientState {
  const _PartyRoomClientState({this.channel, this.authClient, this.roomClient, this.commonClient, this.isConnected = false, this.serverAddress = '', this.serverPort = 0});
  

@override final  ClientChannel? channel;
@override final  auth.AuthServiceClient? authClient;
@override final  partroom.PartRoomServiceClient? roomClient;
@override final  common.CommonServiceClient? commonClient;
@override@JsonKey() final  bool isConnected;
@override@JsonKey() final  String serverAddress;
@override@JsonKey() final  int serverPort;

/// Create a copy of PartyRoomClientState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartyRoomClientStateCopyWith<_PartyRoomClientState> get copyWith => __$PartyRoomClientStateCopyWithImpl<_PartyRoomClientState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PartyRoomClientState&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.authClient, authClient) || other.authClient == authClient)&&(identical(other.roomClient, roomClient) || other.roomClient == roomClient)&&(identical(other.commonClient, commonClient) || other.commonClient == commonClient)&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected)&&(identical(other.serverAddress, serverAddress) || other.serverAddress == serverAddress)&&(identical(other.serverPort, serverPort) || other.serverPort == serverPort));
}


@override
int get hashCode => Object.hash(runtimeType,channel,authClient,roomClient,commonClient,isConnected,serverAddress,serverPort);

@override
String toString() {
  return 'PartyRoomClientState(channel: $channel, authClient: $authClient, roomClient: $roomClient, commonClient: $commonClient, isConnected: $isConnected, serverAddress: $serverAddress, serverPort: $serverPort)';
}


}

/// @nodoc
abstract mixin class _$PartyRoomClientStateCopyWith<$Res> implements $PartyRoomClientStateCopyWith<$Res> {
  factory _$PartyRoomClientStateCopyWith(_PartyRoomClientState value, $Res Function(_PartyRoomClientState) _then) = __$PartyRoomClientStateCopyWithImpl;
@override @useResult
$Res call({
 ClientChannel? channel, auth.AuthServiceClient? authClient, partroom.PartRoomServiceClient? roomClient, common.CommonServiceClient? commonClient, bool isConnected, String serverAddress, int serverPort
});




}
/// @nodoc
class __$PartyRoomClientStateCopyWithImpl<$Res>
    implements _$PartyRoomClientStateCopyWith<$Res> {
  __$PartyRoomClientStateCopyWithImpl(this._self, this._then);

  final _PartyRoomClientState _self;
  final $Res Function(_PartyRoomClientState) _then;

/// Create a copy of PartyRoomClientState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? channel = freezed,Object? authClient = freezed,Object? roomClient = freezed,Object? commonClient = freezed,Object? isConnected = null,Object? serverAddress = null,Object? serverPort = null,}) {
  return _then(_PartyRoomClientState(
channel: freezed == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as ClientChannel?,authClient: freezed == authClient ? _self.authClient : authClient // ignore: cast_nullable_to_non_nullable
as auth.AuthServiceClient?,roomClient: freezed == roomClient ? _self.roomClient : roomClient // ignore: cast_nullable_to_non_nullable
as partroom.PartRoomServiceClient?,commonClient: freezed == commonClient ? _self.commonClient : commonClient // ignore: cast_nullable_to_non_nullable
as common.CommonServiceClient?,isConnected: null == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool,serverAddress: null == serverAddress ? _self.serverAddress : serverAddress // ignore: cast_nullable_to_non_nullable
as String,serverPort: null == serverPort ? _self.serverPort : serverPort // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$PartyRoomFullState {

 PartyRoomAuthState get auth; PartyRoomState get room; PartyRoomClientState get client;
/// Create a copy of PartyRoomFullState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartyRoomFullStateCopyWith<PartyRoomFullState> get copyWith => _$PartyRoomFullStateCopyWithImpl<PartyRoomFullState>(this as PartyRoomFullState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PartyRoomFullState&&(identical(other.auth, auth) || other.auth == auth)&&(identical(other.room, room) || other.room == room)&&(identical(other.client, client) || other.client == client));
}


@override
int get hashCode => Object.hash(runtimeType,auth,room,client);

@override
String toString() {
  return 'PartyRoomFullState(auth: $auth, room: $room, client: $client)';
}


}

/// @nodoc
abstract mixin class $PartyRoomFullStateCopyWith<$Res>  {
  factory $PartyRoomFullStateCopyWith(PartyRoomFullState value, $Res Function(PartyRoomFullState) _then) = _$PartyRoomFullStateCopyWithImpl;
@useResult
$Res call({
 PartyRoomAuthState auth, PartyRoomState room, PartyRoomClientState client
});


$PartyRoomAuthStateCopyWith<$Res> get auth;$PartyRoomStateCopyWith<$Res> get room;$PartyRoomClientStateCopyWith<$Res> get client;

}
/// @nodoc
class _$PartyRoomFullStateCopyWithImpl<$Res>
    implements $PartyRoomFullStateCopyWith<$Res> {
  _$PartyRoomFullStateCopyWithImpl(this._self, this._then);

  final PartyRoomFullState _self;
  final $Res Function(PartyRoomFullState) _then;

/// Create a copy of PartyRoomFullState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? auth = null,Object? room = null,Object? client = null,}) {
  return _then(_self.copyWith(
auth: null == auth ? _self.auth : auth // ignore: cast_nullable_to_non_nullable
as PartyRoomAuthState,room: null == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as PartyRoomState,client: null == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as PartyRoomClientState,
  ));
}
/// Create a copy of PartyRoomFullState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PartyRoomAuthStateCopyWith<$Res> get auth {
  
  return $PartyRoomAuthStateCopyWith<$Res>(_self.auth, (value) {
    return _then(_self.copyWith(auth: value));
  });
}/// Create a copy of PartyRoomFullState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PartyRoomStateCopyWith<$Res> get room {
  
  return $PartyRoomStateCopyWith<$Res>(_self.room, (value) {
    return _then(_self.copyWith(room: value));
  });
}/// Create a copy of PartyRoomFullState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PartyRoomClientStateCopyWith<$Res> get client {
  
  return $PartyRoomClientStateCopyWith<$Res>(_self.client, (value) {
    return _then(_self.copyWith(client: value));
  });
}
}


/// Adds pattern-matching-related methods to [PartyRoomFullState].
extension PartyRoomFullStatePatterns on PartyRoomFullState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PartyRoomFullState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PartyRoomFullState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PartyRoomFullState value)  $default,){
final _that = this;
switch (_that) {
case _PartyRoomFullState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PartyRoomFullState value)?  $default,){
final _that = this;
switch (_that) {
case _PartyRoomFullState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PartyRoomAuthState auth,  PartyRoomState room,  PartyRoomClientState client)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PartyRoomFullState() when $default != null:
return $default(_that.auth,_that.room,_that.client);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PartyRoomAuthState auth,  PartyRoomState room,  PartyRoomClientState client)  $default,) {final _that = this;
switch (_that) {
case _PartyRoomFullState():
return $default(_that.auth,_that.room,_that.client);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PartyRoomAuthState auth,  PartyRoomState room,  PartyRoomClientState client)?  $default,) {final _that = this;
switch (_that) {
case _PartyRoomFullState() when $default != null:
return $default(_that.auth,_that.room,_that.client);case _:
  return null;

}
}

}

/// @nodoc


class _PartyRoomFullState implements PartyRoomFullState {
  const _PartyRoomFullState({required this.auth, required this.room, required this.client});
  

@override final  PartyRoomAuthState auth;
@override final  PartyRoomState room;
@override final  PartyRoomClientState client;

/// Create a copy of PartyRoomFullState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartyRoomFullStateCopyWith<_PartyRoomFullState> get copyWith => __$PartyRoomFullStateCopyWithImpl<_PartyRoomFullState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PartyRoomFullState&&(identical(other.auth, auth) || other.auth == auth)&&(identical(other.room, room) || other.room == room)&&(identical(other.client, client) || other.client == client));
}


@override
int get hashCode => Object.hash(runtimeType,auth,room,client);

@override
String toString() {
  return 'PartyRoomFullState(auth: $auth, room: $room, client: $client)';
}


}

/// @nodoc
abstract mixin class _$PartyRoomFullStateCopyWith<$Res> implements $PartyRoomFullStateCopyWith<$Res> {
  factory _$PartyRoomFullStateCopyWith(_PartyRoomFullState value, $Res Function(_PartyRoomFullState) _then) = __$PartyRoomFullStateCopyWithImpl;
@override @useResult
$Res call({
 PartyRoomAuthState auth, PartyRoomState room, PartyRoomClientState client
});


@override $PartyRoomAuthStateCopyWith<$Res> get auth;@override $PartyRoomStateCopyWith<$Res> get room;@override $PartyRoomClientStateCopyWith<$Res> get client;

}
/// @nodoc
class __$PartyRoomFullStateCopyWithImpl<$Res>
    implements _$PartyRoomFullStateCopyWith<$Res> {
  __$PartyRoomFullStateCopyWithImpl(this._self, this._then);

  final _PartyRoomFullState _self;
  final $Res Function(_PartyRoomFullState) _then;

/// Create a copy of PartyRoomFullState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? auth = null,Object? room = null,Object? client = null,}) {
  return _then(_PartyRoomFullState(
auth: null == auth ? _self.auth : auth // ignore: cast_nullable_to_non_nullable
as PartyRoomAuthState,room: null == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as PartyRoomState,client: null == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as PartyRoomClientState,
  ));
}

/// Create a copy of PartyRoomFullState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PartyRoomAuthStateCopyWith<$Res> get auth {
  
  return $PartyRoomAuthStateCopyWith<$Res>(_self.auth, (value) {
    return _then(_self.copyWith(auth: value));
  });
}/// Create a copy of PartyRoomFullState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PartyRoomStateCopyWith<$Res> get room {
  
  return $PartyRoomStateCopyWith<$Res>(_self.room, (value) {
    return _then(_self.copyWith(room: value));
  });
}/// Create a copy of PartyRoomFullState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PartyRoomClientStateCopyWith<$Res> get client {
  
  return $PartyRoomClientStateCopyWith<$Res>(_self.client, (value) {
    return _then(_self.copyWith(client: value));
  });
}
}

// dart format on
