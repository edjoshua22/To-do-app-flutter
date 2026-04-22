import '../models/task_model.dart';

class TaskService {
  // In-memory list to simulate a database for now, maintaining original functionality
  final List<Task> _tasks = List.from(sampleTasks);

  // Simulate fetching tasks from a database
  Future<List<Task>> getTasks() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_tasks);
  }

  // Add a new task
  Future<void> addTask(Task task) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _tasks.insert(0, task);
  }

  // Update an existing task
  Future<void> updateTask(Task task) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
    }
  }

  // Delete a task
  Future<void> deleteTask(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _tasks.removeWhere((t) => t.id == id);
  }
}
