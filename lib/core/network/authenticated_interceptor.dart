import 'dart:async';

import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/token_refresh_coordinator.dart';
import 'package:bnan_app/core/network/token_store.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:dio/dio.dart';

class AuthenticatedInterceptor extends Interceptor {
  AuthenticatedInterceptor({
    required this.dio,
    required this.tokens,
    required this.refresh,
    required this.invalidate,
    this.invalidateAccess,
    this.isInvalidating = _neverInvalidating,
  });
  final Dio dio;
  final TokenStore tokens;
  final TokenRefreshCoordinator refresh;
  final Future<void> Function() invalidate;
  final Future<void> Function(String code)? invalidateAccess;
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
    final accessCode = _subscriptionAccessCode(err.response?.data);
    if (options.extra['isProtected'] == true &&
        accessCode != null &&
        !_isStudentJoinSession(options.path)) {
      await (invalidateAccess?.call(accessCode) ?? invalidate());
      return handler.next(err);
    }
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

  bool _isStudentJoinSession(String path) =>
      SessionManager.instance.role == UserRole.student &&
      path.startsWith('${EndPoints.classrooms}/') &&
      path.endsWith('/sessions/active/join');

  String? _subscriptionAccessCode(dynamic data) {
    if (data is! Map) return null;
    final code = _findCode(data)?.toUpperCase();
    const denied = {
      'SUBSCRIPTION_SUSPENDED',
      'SUBSCRIPTION_EXPIRED',
      'SUBSCRIPTION_CANCELLED',
      'SUBSCRIPTION_ACCESS_DENIED',
      'NO_VALID_SUBSCRIPTION',
    };
    return denied.contains(code) ? code : null;
  }

  String? _findCode(Map data, [int depth = 0]) {
    if (depth > 3) return null;
    for (final key in const ['code', 'errorCode', 'error_code']) {
      final value = data[key]?.toString().trim();
      if (value?.isNotEmpty == true) return value;
    }
    for (final key in const ['error', 'data', 'response']) {
      final nested = data[key];
      if (nested is Map) {
        final value = _findCode(nested, depth + 1);
        if (value != null) return value;
      }
    }
    return null;
  }
}
