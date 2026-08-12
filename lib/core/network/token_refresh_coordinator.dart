import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/token_refresh_exception.dart';
import 'package:bnan_app/core/network/token_store.dart';
import 'package:dio/dio.dart';

class TokenRefreshCoordinator {
  TokenRefreshCoordinator({required this.dio, required this.tokens});
  final Dio dio;
  final TokenStore tokens;
  Future<String>? _refreshFuture;

  Future<String> refresh() {
    final active = _refreshFuture;
    if (active != null) return active;
    final operation = _performRefresh();
    _refreshFuture = operation;
    return operation.whenComplete(() {
      if (identical(_refreshFuture, operation)) _refreshFuture = null;
    });
  }

  Future<String> _performRefresh() async {
    final stored = await tokens.getRefreshToken();
    if (stored == null || stored.isEmpty) {
      throw const TokenRefreshException('Missing refresh token');
    }
    try {
      final response = await dio.post<Map<String, dynamic>>(
        EndPoints.refreshToken,
        data: {'refreshToken': stored},
        options: Options(extra: {'sensitive': true}),
      );
      final data = response.data ?? const <String, dynamic>{};
      final access = data['token']?.toString().trim() ?? '';
      final refresh = data['refreshToken']?.toString().trim() ?? '';
      if (access.isEmpty || refresh.isEmpty) {
        throw const TokenRefreshException('Invalid refresh response');
      }
      await tokens.saveTokens(accessToken: access, refreshToken: refresh);
      return access;
    } on DioException catch (error) {
      throw TokenRefreshException(
        'Refresh request failed',
        code: _backendCode(error.response?.data),
      );
    }
  }

  String? _backendCode(Object? data) {
    if (data is! Map) return null;
    return (data['code'] ?? data['errorCode'] ?? data['error']?['code'])
        ?.toString();
  }
}
