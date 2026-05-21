import 'package:dio/dio.dart';

import '../helpers/app.config.dart';
import 'interceptors/auth.interceptor.dart';

class AppClient {
  factory AppClient() => _instance;

  AppClient._internal() : _dio = Dio(_defaultOptions()) {
    _dio.interceptors.add(AuthInterceptor());
  }

  static final AppClient _instance = AppClient._internal();
  final Dio _dio;

  Dio get dio => _dio;

  static BaseOptions _defaultOptions() {
    return BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    );
  }
}
