import 'package:dio/dio.dart';
import '../models/task_model.dart';


class ApiService {
  
  static const String _baseUrl = 'http://192.168.137.1:8080/api';

  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ));
  }

  
  Future<List<Task>> getTasks() async {
    try {
      final response = await _dio.get('/todos');
      final List<dynamic> data = response.data['data'] as List<dynamic>;
      return data
          .map((json) => Task.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  
  Future<Task> addTask(Task task) async {
    try {
      final response = await _dio.post('/todos', data: task.toJson());
      return Task.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

 
  Future<Task> updateTask(Task task) async {
    try {
      final response = await _dio.put('/todos/${task.id}', data: task.toJson());
      return Task.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _dio.delete('/todos/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  
  Exception _handleError(DioException e) {
    final message = e.response?.data?['message'] ?? e.message ?? 'Unknown error';
    return Exception(message);
  }
}
