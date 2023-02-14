// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages

import 'package:freezed_annotation/freezed_annotation.dart';

part 'notificationsmodel.freezed.dart';
part 'notificationsmodel.g.dart';

@freezed
class NotificationsModel with _$NotificationsModel {
  const factory NotificationsModel({
    int? id,
    int? user_id,
    String? data,
    String? data2,
    String? type,
    String? related_data,
    String? created_at,
    String? updated_at,
    String? deleted_at,
  }) = _NotificationsModel;
  factory NotificationsModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationsModelFromJson(json);
}
