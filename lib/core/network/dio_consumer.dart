import 'package:bnan_app/core/cache/cache_data.dart';
import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';


class DioConsumer extends ApiConsumer {
  final Dio dio;

  DioConsumer({required this.dio}) {
    dio.options.baseUrl = EndPoints.baseUrl;

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final isProtected = options.extra['isProtected'] ?? false;
          final token = CacheData.token;
          final isGuest = token == null || token.isEmpty;

          if (isProtected && isGuest) {
            return handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.cancel,
                error: 'Guest cannot access protected endpoints',
              ),
            );
          }

          if (isProtected && !isGuest) {
            options.headers['token'] = 'flora $token';
            options.headers['token'] = 'flora $token';
            print('✅ Header Token: flora $token');
          }

          handler.next(options);
        },
      ),
    );
  }

  Map<String, dynamic>? _headers(bool isProtected) {
    if (!isProtected) return null;
    final token = CacheData.token;
    return {if (token != null && token.isNotEmpty) 'token': 'flora $token'};
  }

  @override
  Future delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    required bool isProtected,
  }) async {
    try {
      final res = await dio.delete(
        path,
        data: data,
        queryParameters: queryParameter,
        options: Options(
          headers: _headers(isProtected),
          extra: {'isProtected': isProtected},
        ),
      );
      return res.data;
    } on DioException catch (e) {
      handleDioExceptions(e);
    }
  }

  @override
  Future get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
  }) async {
    try {
      final res = await dio.get(
        path,
        data: data,
        queryParameters: queryParameter,
        options: Options(
          headers: _headers(isProtected),
          extra: {'isProtected': isProtected},
        ),
      );
      return res.data;
    } on DioException catch (e) {
      handleDioExceptions(e);
    }
  }

  @override
  Future patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    try {
      final body = (isFormData && data is! FormData)
          ? FormData.fromMap(data as Map<String, dynamic>)
          : data;

      final res = await dio.patch(
        path,
        data: body,
        queryParameters: queryParameter,
        options: Options(
          headers: _headers(isProtected),
          extra: {'isProtected': isProtected},
        ),
      );
      return res.data;
    } on DioException catch (e) {
      handleDioExceptions(e);
    }
  }

  @override
  Future post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    try {
      final body = (isFormData && data is! FormData)
          ? FormData.fromMap(data as Map<String, dynamic>)
          : data;

      final res = await dio.post(
        path,
        data: body,
        queryParameters: queryParameter,
        options: Options(
          headers: _headers(isProtected),
          extra: {'isProtected': isProtected},
        ),
      );
      return res.data;
    } on DioException catch (e) {
      handleDioExceptions(e);
    }
  }

  @override
  Future put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    try {
      final body = (isFormData && data is! FormData)
          ? FormData.fromMap(data as Map<String, dynamic>)
          : data;

      final res = await dio.put(
        path,
        data: body,
        queryParameters: queryParameter,
        options: Options(
          headers: _headers(isProtected),
          extra: {'isProtected': isProtected},
        ),
      );
      return res.data;
    } on DioException catch (e) {
      handleDioExceptions(e);
    }
  }

  void handleDioExceptions(DioException e) {
    final error = AppException.fromDio(e);
    throw error;
  }
}
