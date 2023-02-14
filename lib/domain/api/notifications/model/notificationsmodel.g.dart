// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificationsmodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_NotificationsModel _$$_NotificationsModelFromJson(
        Map<String, dynamic> json) =>
    _$_NotificationsModel(
      id: json['id'] as int?,
      user_id: json['user_id'] as int?,
      data: json['data'] as String?,
      data2: json['data2'] as String?,
      type: json['type'] as String?,
      related_data: json['related_data'] as String?,
      created_at: json['created_at'] as String?,
      updated_at: json['updated_at'] as String?,
      deleted_at: json['deleted_at'] as String?,
    );

Map<String, dynamic> _$$_NotificationsModelToJson(
        _$_NotificationsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'data': instance.data,
      'data2': instance.data2,
      'type': instance.type,
      'related_data': instance.related_data,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'deleted_at': instance.deleted_at,
    };
