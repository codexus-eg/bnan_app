import 'package:bnan_app/core/cache/cache_data.dart';
import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioConsumer extends ApiConsumer {
  DioConsumer({required this.dio}) {
    dio.options = BaseOptions(
      baseUrl: EndPoints.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    _addHeadersInterceptor();
    _addDebugLogger();
  }

  final Dio dio;

  void _addHeadersInterceptor() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final isProtected = options.extra['isProtected'] == true;

          options.headers['lang'] = CacheData.language ?? 'ar';

          if (!isProtected) {
            return handler.next(options);
          }

          final token = await SessionManager.instance.getAccessToken();

          if (token == null || token.isEmpty) {
            return handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.cancel,
                error: 'Unauthorized request',
              ),
            );
          }

          options.headers['token'] = 'Bearer $token';

          return handler.next(options);
        },
      ),
    );
  }

  void _addDebugLogger() {
    if (!kDebugMode) return;

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: false,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        compact: true,
      ),
    );
  }

  @override
  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
  }) async {
    try {
      final response = await dio.get(
        path,
        data: data,
        queryParameters: queryParameter,
        options: _options(isProtected),
      );

      return response.data;
    } on DioException catch (error) {
      _handleDioException(error);
    }
  }

  @override
  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: _body(data, isFormData),
        queryParameters: queryParameter,
        options: _options(isProtected),
      );

      return response.data;
    } on DioException catch (error) {
      _handleDioException(error);
    }
  }

  @override
  Future<dynamic> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    try {
      final response = await dio.put(
        path,
        data: _body(data, isFormData),
        queryParameters: queryParameter,
        options: _options(isProtected),
      );

      return response.data;
    } on DioException catch (error) {
      _handleDioException(error);
    }
  }

  @override
  Future<dynamic> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    try {
      final response = await dio.patch(
        path,
        data: _body(data, isFormData),
        queryParameters: queryParameter,
        options: _options(isProtected),
      );

      return response.data;
    } on DioException catch (error) {
      _handleDioException(error);
    }
  }

  @override
  Future<dynamic> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    try {
      final response = await dio.delete(
        path,
        data: _body(data, isFormData),
        queryParameters: queryParameter,
        options: _options(isProtected),
      );

      return response.data;
    } on DioException catch (error) {
      _handleDioException(error);
    }
  }

  Options _options(bool isProtected) {
    return Options(
      extra: {
        'isProtected': isProtected,
      },
    );
  }

  Object? _body(Object? data, bool isFormData) {
    if (!isFormData || data == null || data is FormData) {
      return data;
    }

    if (data is Map<String, dynamic>) {
      return FormData.fromMap(data);
    }

    throw ArgumentError('FormData body must be Map<String, dynamic>');
  }

  Never _handleDioException(DioException error) {
    throw AppException.fromDio(error);
  }
}