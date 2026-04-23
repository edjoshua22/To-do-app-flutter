import '../models/task_model.dart';
import 'api_service.dart';

class TaskService {
  final ApiService _api = ApiService();

  
  Future<List<Task>> getTasks() => _api.getTasks();

  
  Future<Task> addTask(Task task) => _api.addTask(task);

 
  Future<Task> updateTask(Task task) => _api.updateTask(task);

  
  Future<void> deleteTask(String id) => _api.deleteTask(id);
}
