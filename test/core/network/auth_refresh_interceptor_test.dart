import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:bnan_app/core/network/authenticated_interceptor.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/token_refresh_coordinator.dart';
import 'package:bnan_app/core/network/token_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('valid authenticated request succeeds without refresh', () async {
    final rig = _Rig((options) => _json(200, {'ok': true}));
    final response = await rig.dio.get('/resource', options: _protected());
    expect(response.data['ok'], isTrue);
    expect(rig.refreshRequests, 0);
    expect(rig.lastAuthorization, 'Bearer old-access');
  });

  test('401 refreshes, rotates both tokens, and retries once', () async {
    final rig = _successRig();
    final response = await rig.dio.get('/resource', options: _protected());
    expect(response.data['ok'], isTrue);
    expect(rig.refreshRequests, 1);
    expect(rig.resourceRequests, 2);
    expect(rig.store.accessToken, 'new-access');
    expect(rig.store.refreshToken, 'new-refresh');
    expect(rig.lastAuthorization, 'Bearer new-access');
  });

  for (final scenario in const {
    'required refresh': (400, 'REFRESH_TOKEN_REQUIRED'),
    'invalid refresh': (401, 'INVALID_REFRESH_TOKEN'),
    'expired refresh': (401, 'REFRESH_TOKEN_EXPIRED'),
    'missing user': (401, 'USER_DOES_NOT_EXIST'),
    'password changed': (401, 'PASSWORD_HAS_CHANGED'),
    'account deactivated': (403, 'ACCOUNT_DEACTIVATED'),
  }.entries) {
    test('${scenario.key} invalidates session without retry', () async {
      final rig = _Rig((options) {
        if (options.path == EndPoints.refreshToken) {
          return _json(scenario.value.$1, {'code': scenario.value.$2});
        }
        return _json(401, {'code': 'ACCESS_TOKEN_EXPIRED'});
      });
      await expectLater(
        rig.dio.get('/resource', options: _protected()),
        throwsA(isA<DioException>()),
      );
      expect(rig.refreshRequests, 1);
      expect(rig.resourceRequests, 1);
      expect(rig.invalidation.count, 1);
      expect(rig.store.accessToken, isNull);
      expect(rig.store.refreshToken, isNull);
    });
  }

  test('missing refresh token invalidates without refresh request', () async {
    final rig = _Rig((_) => _json(401, {}));
    rig.store.refreshToken = null;
    await expectLater(
      rig.dio.get('/resource', options: _protected()),
      throwsA(isA<DioException>()),
    );
    expect(rig.refreshRequests, 0);
    expect(rig.invalidation.count, 1);
  });

  test('concurrent 401 responses share one refresh request', () async {
    final rig = _successRig(refreshDelay: const Duration(milliseconds: 30));
    final responses = await Future.wait([
      rig.dio.get('/a', options: _protected()),
      rig.dio.get('/b', options: _protected()),
      rig.dio.get('/c', options: _protected()),
    ]);
    expect(responses.every((response) => response.data['ok'] == true), isTrue);
    expect(rig.refreshRequests, 1);
  });

  test('JSON and FormData bodies survive retry', () async {
    final seen = <Object?>[];
    final attempts = <String, int>{};
    final rig = _Rig((options) {
      if (options.path == EndPoints.refreshToken) return _rotatedTokens();
      seen.add(options.data);
      final attempt = attempts.update(
        options.path,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
      return attempt > 1 ? _json(200, {'ok': true}) : _json(401, {});
    });
    await rig.dio.post('/json', data: {'name': 'value'}, options: _protected());
    await rig.dio.post(
      '/form',
      data: FormData.fromMap({'name': 'value'}),
      options: _protected(),
    );
    expect(seen[0], {'name': 'value'});
    expect(seen[1], {'name': 'value'});
    expect((seen[2] as FormData).fields.single.key, 'name');
    expect((seen[2] as FormData).fields.single.value, 'value');
    expect((seen[3] as FormData).fields.single.key, 'name');
    expect((seen[3] as FormData).fields.single.value, 'value');
  });

  test('retried 401 does not start a second refresh', () async {
    final rig = _Rig((options) {
      if (options.path == EndPoints.refreshToken) return _rotatedTokens();
      return _json(401, {});
    });
    await expectLater(
      rig.dio.get('/resource', options: _protected()),
      throwsA(isA<DioException>()),
    );
    expect(rig.refreshRequests, 1);
    expect(rig.resourceRequests, 2);
    expect(rig.invalidation.count, 1);
  });

  test('refresh endpoint 401 never recurses through interceptor', () async {
    final rig = _Rig((_) => _json(401, {}));
    await expectLater(
      rig.dio.post(EndPoints.refreshToken, options: _protected()),
      throwsA(isA<DioException>()),
    );
    expect(rig.totalRequests, 1);
    expect(rig.invalidation.count, 0);
  });
}

Options _protected() => Options(extra: {'isProtected': true});

_Rig _successRig({Duration refreshDelay = Duration.zero}) => _Rig((
  options,
) async {
  if (options.path == EndPoints.refreshToken) {
    if (refreshDelay != Duration.zero) await Future<void>.delayed(refreshDelay);
    return _rotatedTokens();
  }
  return options.headers['Authorization'] == 'Bearer new-access'
      ? _json(200, {'ok': true})
      : _json(401, {'code': 'ACCESS_TOKEN_EXPIRED'});
});

ResponseBody _rotatedTokens() => _json(200, {
  'success': true,
  'token': 'new-access',
  'refreshToken': 'new-refresh',
});

ResponseBody _json(int status, Map<String, dynamic> body) =>
    ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );

class _Rig {
  _Rig(FutureOr<ResponseBody> Function(RequestOptions) handler) {
    final adapter = _Adapter((options) async {
      totalRequests++;
      if (options.path == EndPoints.refreshToken) refreshRequests++;
      if (options.path != EndPoints.refreshToken) resourceRequests++;
      lastAuthorization = options.headers['Authorization']?.toString();
      return handler(options);
    });
    dio = Dio(BaseOptions(baseUrl: 'https://test.invalid'))
      ..httpClientAdapter = adapter;
    final refreshDio = Dio(BaseOptions(baseUrl: 'https://test.invalid'))
      ..httpClientAdapter = adapter;
    dio.interceptors.add(
      AuthenticatedInterceptor(
        dio: dio,
        tokens: store,
        refresh: TokenRefreshCoordinator(dio: refreshDio, tokens: store),
        invalidate: invalidation.call,
      ),
    );
  }

  final store = _TokenStore();
  late final _Invalidation invalidation = _Invalidation(store);
  late final Dio dio;
  int totalRequests = 0, refreshRequests = 0, resourceRequests = 0;
  String? lastAuthorization;
}

class _TokenStore implements TokenStore {
  String? accessToken = 'old-access';
  String? refreshToken = 'old-refresh';
  @override
  Future<String?> getAccessToken() async => accessToken;
  @override
  Future<String?> getRefreshToken() async => refreshToken;
  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }
}

class _Invalidation {
  _Invalidation(this.store);
  final _TokenStore store;
  int count = 0;
  bool _done = false;
  Future<void> call() async {
    if (_done) return;
    _done = true;
    count++;
    store.accessToken = null;
    store.refreshToken = null;
  }
}

class _Adapter implements HttpClientAdapter {
  _Adapter(this.handler);
  final FutureOr<ResponseBody> Function(RequestOptions) handler;
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => handler(options);
  @override
  void close({bool force = false}) {}
}
