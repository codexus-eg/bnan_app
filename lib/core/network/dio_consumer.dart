import 'package:bnan_app/core/cache/cache_data.dart';
import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/network/authenticated_interceptor.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/token_refresh_coordinator.dart';
import 'package:bnan_app/core/network/token_store.dart';
import 'package:bnan_app/core/session/session_invalidator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioConsumer extends ApiConsumer {
  DioConsumer({required this.dio}) {
    dio.options = _baseOptions();

    _addAuthInterceptor();
    _addDebugLogger();
  }

  final Dio dio;

  BaseOptions _baseOptions() {
    return BaseOptions(
      baseUrl: EndPoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(minutes: 2),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
  }

  void _addAuthInterceptor() {
    final tokens = const SessionTokenStore();
    final refreshDio = Dio(_baseOptions());
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['lang'] = CacheData.language ?? 'ar';
          handler.next(options);
        },
      ),
    );
    dio.interceptors.add(
      AuthenticatedInterceptor(
        dio: dio,
        tokens: tokens,
        refresh: TokenRefreshCoordinator(dio: refreshDio, tokens: tokens),
        invalidate: SessionInvalidator.instance.invalidate,
        invalidateAccess:
            SessionInvalidator.instance.invalidateSubscriptionAccess,
        isInvalidating: () => SessionInvalidator.instance.isInvalidating,
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
        filter: (options, _) => options.extra['sensitive'] != true,
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
    return Options(extra: {'isProtected': isProtected});
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
