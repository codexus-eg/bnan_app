import 'dart:async';

import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/token_refresh_coordinator.dart';
import 'package:bnan_app/core/network/token_store.dart';
import 'package:dio/dio.dart';

class AuthenticatedInterceptor extends Interceptor {
  AuthenticatedInterceptor({
    required this.dio,
    required this.tokens,
    required this.refresh,
    required this.invalidate,
    this.isInvalidating = _neverInvalidating,
  });
  final Dio dio;
  final TokenStore tokens;
  final TokenRefreshCoordinator refresh;
  final Future<void> Function() invalidate;
  final bool Function() isInvalidating;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.path.startsWith('/auth/')) options.extra['sensitive'] = true;
    if (options.extra['isProtected'] != true) return handler.next(options);
    final token = await tokens.getAccessToken();
    if (token == null || token.isEmpty) {
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.cancel,
          error: 'Unauthorized request',
        ),
      );
    }
    options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    if (!_canRefresh(err)) return handler.next(err);
    if (options.extra['retriedAfterRefresh'] == true) {
      await invalidate();
      return handler.next(err);
    }
    late final String accessToken;
    try {
      accessToken = await refresh.refresh();
    } catch (_) {
      await invalidate();
      return handler.next(err);
    }
    if (options.data is Stream) return handler.next(err);
    options.extra['retriedAfterRefresh'] = true;
    options.headers['Authorization'] = 'Bearer $accessToken';
    if (options.data is FormData) {
      options.data = (options.data as FormData).clone();
    }
    try {
      handler.resolve(await dio.fetch<dynamic>(options));
    } on DioException catch (retryError) {
      if (retryError.response?.statusCode == 401) await invalidate();
      handler.next(retryError);
    }
  }

  bool _canRefresh(DioException error) {
    final options = error.requestOptions;
    if (isInvalidating() ||
        error.response?.statusCode != 401 ||
        options.extra['isProtected'] != true) {
      return false;
    }
    return options.path != EndPoints.login &&
        options.path != EndPoints.refreshToken;
  }

  static bool _neverInvalidating() => false;
}
