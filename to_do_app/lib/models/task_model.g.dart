// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
  id: _idToString(json['id']),
  title: json['title'] as String,
  subtitle: json['description'] as String? ?? '',
  date: DateTime.parse(json['created_at'] as String),
  isCompleted: json['is_completed'] as bool? ?? false,
);

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
  'title': instance.title,
  'description': instance.subtitle,
  'is_completed': instance.isCompleted,
};
