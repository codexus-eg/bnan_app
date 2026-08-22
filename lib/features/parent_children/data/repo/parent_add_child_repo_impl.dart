import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/dio_consumer.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/parent_children/data/models/parent_add_child_egyptian_request.dart';
import 'package:bnan_app/features/parent_children/data/models/parent_add_child_gulf_request.dart';
import 'package:bnan_app/features/parent_children/data/models/parent_add_child_submission.dart';
import 'package:bnan_app/features/parent_children/data/repo/parent_add_child_repo.dart';
import 'package:bnan_app/features/payments/data/models/tamara_checkout_response.dart';
import 'package:bnan_app/features/payments/data/models/tamara_status_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ParentAddChildRepoImpl implements ParentAddChildRepo {
  ParentAddChildRepoImpl(DioConsumer consumer) : dio = consumer.dio;

  final Dio dio;

  @override
  registerEgyptian(ParentAddChildEgyptianRequest request) async {
    _log('Egyptian repository entered');
    final result = await repoGuard(() async {
      final response = await _post(
        EndPoints.parentChildEgyptianRegistration,
        data: request.toJson(),
      );
      _log('Egyptian response parsing started');
      return ParentAddChildSubmission.fromJson(_map(response));
    });
    result.fold(
      (failure) => _log('Egyptian repository error: ${failure.message}'),
      (_) => _log('Egyptian repository success'),
    );
    return result;
  }

  @override
  checkoutGulf({
    required ParentAddChildGulfRequest request,
    required String idempotencyKey,
  }) => repoGuard(() async {
    _log('combined student/payment request started');
    _logRequestAudit(request, idempotencyKey);
    try {
      final json = _map(
        await _post(
          EndPoints.parentChildGulfCheckout,
          data: request.toJson(),
          headers: {'Idempotency-Key': idempotencyKey},
        ),
      );
      _log('combined response received; keys=${json.keys.join(',')}');
      final checkout = TamaraCheckoutResponse.fromJson(json);
      if (!_hasCheckoutContext(checkout)) {
        throw const FormatException('Incomplete Gulf checkout response');
      }
      _log('checkout response parsed');
      return checkout;
    } catch (error) {
      _log('checkout request/parsing error: ${error.runtimeType}');
      rethrow;
    }
  });

  @override
  reconcile(String paymentId) => repoGuard(
    () async => TamaraStatusResponse.fromJson(
      _map(await _post(EndPoints.tamaraReconcile(paymentId))),
    ),
  );

  @override
  status(String paymentId) => repoGuard(() async {
    try {
      final response = await dio.get(
        EndPoints.tamaraStatus(paymentId),
        options: _options(),
      );
      return TamaraStatusResponse.fromJson(_map(response.data));
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  });

  Future<dynamic> _post(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      if (path == EndPoints.parentChildEgyptianRegistration) {
        _log('Egyptian Dio POST started; endpoint=$path');
      }
      final response = await dio.post(
        path,
        data: data,
        options: _options(headers),
      );
      if (path == EndPoints.parentChildGulfCheckout) {
        _log('combined response HTTP ${response.statusCode}');
      }
      if (path == EndPoints.parentChildEgyptianRegistration) {
        _log('Egyptian Dio response received; status=${response.statusCode}');
      }
      return response.data;
    } on DioException catch (error) {
      final exception = AppException.fromDio(error);
      if (path == EndPoints.parentChildGulfCheckout) {
        _logBadResponse(error, exception);
      }
      if (path == EndPoints.parentChildEgyptianRegistration) {
        _log(
          'Egyptian Dio error: ${error.type}; status=${error.response?.statusCode}',
        );
      }
      throw exception;
    }
  }

  Options _options([Map<String, dynamic>? headers]) => Options(
    headers: headers,
    extra: {'isProtected': true, 'sensitive': true},
  );

  Map<String, dynamic> _map(dynamic value) =>
      value is Map ? Map<String, dynamic>.from(value) : {};

  bool _hasCheckoutContext(TamaraCheckoutResponse value) {
    final uri = Uri.tryParse(value.checkoutUrl ?? '');
    return value.paymentId.trim().isNotEmpty &&
        uri != null &&
        uri.hasScheme &&
        (uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host.isNotEmpty;
  }

  void _logRequestAudit(
    ParentAddChildGulfRequest request,
    String idempotencyKey,
  ) {
    final json = request.toJson();
    final student = _map(json['student']);
    final address = _map(json['paymentAddress']);
    _log(
      'request audit: curriculum=${_present(json['curriculum'])}, '
      'package=${_present(json['packageId'])}, '
      'grade=${_present(student['grade'])}, '
      'subjects=${student['subjects'] is List && student['subjects'].isNotEmpty}, '
      'city=${_present(address['city'])}, region=${_present(address['region'])}, '
      'line1=${_present(address['line1'])}, locale=${json['locale'] == 'ar_SA'}, '
      'isMobile=${json['isMobile'] == true}, idempotency=${idempotencyKey.trim().isNotEmpty}',
    );
  }

  void _logBadResponse(DioException error, AppException exception) {
    final data = error.response?.data;
    final root = _map(data);
    final nestedError = _map(root['error']);
    _log(
      'HTTP ${error.response?.statusCode}; backendCode=${exception.code}; '
      'backendMessage=${_mask(exception.message)}; '
      'responseKeys=${root.keys.join(',')}; '
      'errorKeys=${nestedError.keys.join(',')}',
    );
  }

  bool _present(dynamic value) => value?.toString().trim().isNotEmpty == true;

  String _mask(String value) => value
      .replaceAll(RegExp(r'[\w.%-]+@[\w.-]+\.[A-Za-z]{2,}'), '[email]')
      .replaceAll(RegExp(r'\+?\d[\d\s-]{7,}\d'), '[number]');

  void _log(String message) {
    if (kDebugMode) debugPrint('[ParentAddChildRepo] $message');
  }
}
