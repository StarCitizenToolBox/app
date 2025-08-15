// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multi_window_manager.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MultiWindowAppState _$MultiWindowAppStateFromJson(Map<String, dynamic> json) =>
    _MultiWindowAppState(
      backgroundColor: json['backgroundColor'] as String,
      menuColor: json['menuColor'] as String,
      micaColor: json['micaColor'] as String,
      gameInstallPaths: (json['gameInstallPaths'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      languageCode: json['languageCode'] as String?,
      countryCode: json['countryCode'] as String?,
    );

Map<String, dynamic> _$MultiWindowAppStateToJson(
  _MultiWindowAppState instance,
) => <String, dynamic>{
  'backgroundColor': instance.backgroundColor,
  'menuColor': instance.menuColor,
  'micaColor': instance.micaColor,
  'gameInstallPaths': instance.gameInstallPaths,
  'languageCode': instance.languageCode,
  'countryCode': instance.countryCode,
};
