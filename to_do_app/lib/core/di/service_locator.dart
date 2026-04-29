
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../services/api_service.dart';
import '../../services/task_service.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Use the computer's Wi-Fi IP address so the physical phone can connect
  String baseUrl = 'http://192.168.201.151:8000/api';

  // 1. External packages
  getIt.registerLazySingleton<Dio>(() => Dio(BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      )));

  // 2. Data Sources (API layer)
  getIt.registerLazySingleton<ApiService>(() => ApiService(getIt<Dio>()));

  // 3. Domain layer / Services
  getIt.registerLazySingleton<TaskService>(() => TaskService(getIt<ApiService>()));
}
