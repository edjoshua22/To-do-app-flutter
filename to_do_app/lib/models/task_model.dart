class Task {
  final String id;
  final String title;
  final String subtitle; // maps to 'description' in the API
  final DateTime date;
  bool isCompleted;
  bool hasAlarm;
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

  /// Create a Task from the Laravel API JSON response.
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'].toString(),
      title: json['title'] as String,
      subtitle: (json['description'] as String?) ?? '',
      date: DateTime.parse(json['created_at'] as String),
      isCompleted: (json['is_completed'] as bool?) ?? false,
    );
  }

  /// Convert a Task to JSON for the Laravel API.
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': subtitle.isEmpty ? null : subtitle,
      'is_completed': isCompleted,
    };
  }
}

List<Task> sampleTasks = [];
