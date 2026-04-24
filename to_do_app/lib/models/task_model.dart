import 'package:json_annotation/json_annotation.dart';

part 'task_model.g.dart';

String _idToString(dynamic id) => id.toString();

@JsonSerializable()
class Task {
  @JsonKey(fromJson: _idToString, includeToJson: false)
  final String id;
  
  final String title;
  
  @JsonKey(name: 'description', defaultValue: '')
  final String subtitle;
  
  @JsonKey(name: 'created_at', includeToJson: false)
  final DateTime date;
  
  @JsonKey(name: 'is_completed', defaultValue: false)
  bool isCompleted;
  
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool hasAlarm;
  
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool hasPriority;

  Task({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    this.isCompleted = false,
    this.hasAlarm = false,
    this.hasPriority = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() {
    final json = _$TaskToJson(this);
    if (subtitle.isEmpty) {
      json['description'] = null;
    }
    return json;
  }
}

List<Task> sampleTasks = [];
