import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/dio_consumer.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/egyptian_renewal_request.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/parent_subscriptions_response.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/renewal_status_response.dart';
import 'package:bnan_app/features/parent_subscriptions/data/repo/parent_subscriptions_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ParentSubscriptionsRepoImpl implements ParentSubscriptionsRepo {
  ParentSubscriptionsRepoImpl(DioConsumer consumer) : dio = consumer.dio;
  final Dio dio;

  @override
  getSubscriptions() => repoGuard(() async {
    _log('request started');
    late final Response<dynamic> response;
    try {
      response = await dio.get(
        EndPoints.parentChildrenSubscriptions,
        options: _options(),
      );
    } on DioException catch (error) {
      _log('HTTP status=${error.response?.statusCode ?? 'not received'}');
      throw AppException.fromDio(error);
    }
    _log('HTTP status=${response.statusCode}');
    final payload = _map(response.data);
    final rawChildren = ParentSubscriptionsResponse.rawChildren(payload);
    final rawSubscriptions = _subscriptionCount(rawChildren);
    _log(
      'children count=${rawChildren.length}; '
      'subscriptions count=$rawSubscriptions',
    );
    final parsed = ParentSubscriptionsResponse.fromJson(payload);
    final parsedSubscriptions = parsed.children.fold<int>(
      0,
      (count, child) => count + child.subscriptions.length,
    );
    _log(
      'parsed children count=${parsed.children.length}; '
      'parsed subscriptions count=$parsedSubscriptions',
    );
    return parsed;
  });
  @override
  renewEgyptian(EgyptianRenewalRequest request) => repoGuard(
    () async => RenewalStatusResponse.fromJson(
      _map(
        await _post(
          EndPoints.egyptianSubscriptionRenewal,
          data: await request.toFormData(),
        ),
      ),
    ),
  );
  @override
  egyptianStatus(String id) => repoGuard(
    () async => RenewalStatusResponse.fromJson(
      _map(await _get(EndPoints.egyptianRenewalStatus(id))),
    ),
  );
  @override
  renewGulf({required request, required idempotencyKey}) => repoGuard(
    () async => RenewalStatusResponse.fromJson(
      _map(
        await _post(
          EndPoints.gulfSubscriptionRenewal,
          data: request.toJson(),
          headers: {'Idempotency-Key': idempotencyKey},
        ),
      ),
    ),
  );
  @override
  gulfStatus(String id) => repoGuard(
    () async => RenewalStatusResponse.fromJson(
      _map(await _get(EndPoints.gulfRenewalStatus(id))),
    ),
  );
  @override
  gulfReconcile(String id) => repoGuard(
    () async => RenewalStatusResponse.fromJson(
      _map(await _post(EndPoints.gulfRenewalReconcile(id))),
    ),
  );

  Future<dynamic> _get(String path) async {
    try {
      return (await dio.get(path, options: _options())).data;
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    }
  }

  Future<dynamic> _post(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return (await dio.post(
        path,
        data: data,
        options: _options(headers),
      )).data;
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    }
  }

  Options _options([Map<String, dynamic>? headers]) => Options(
    headers: headers,
    extra: {'isProtected': true, 'sensitive': true},
  );
  Map<String, dynamic> _map(dynamic value) =>
      value is Map ? Map<String, dynamic>.from(value) : {};

  int _subscriptionCount(List<dynamic> children) =>
      children.fold(0, (count, child) {
        if (child is! Map) return count;
        final subscriptions = child['subscriptions'];
        if (subscriptions is List && subscriptions.isNotEmpty) {
          return count + subscriptions.length;
        }
        return count + (child['subscription'] is Map ? 1 : 0);
      });

  void _log(String message) {
    if (kDebugMode) debugPrint('[ParentSubscriptionsRepo] $message');
  }
}
