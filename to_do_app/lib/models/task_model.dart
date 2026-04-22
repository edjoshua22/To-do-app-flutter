class Task {
  final String id;
  final String title;
  final String subtitle;
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
}

List<Task> sampleTasks = [];
