import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/payments/data/models/tamara_checkout_response.dart';
import 'package:bnan_app/features/payments/data/models/tamara_status_response.dart';
import 'package:bnan_app/features/payments/data/repo/tamara_payment_repo.dart';
import 'package:bnan_app/features/student_auth/data/debug/gulf_registration_diagnostics.dart';
import 'package:dio/dio.dart';

class TamaraPaymentRepoImpl implements TamaraPaymentRepo {
  const TamaraPaymentRepoImpl(this.dio);

  final Dio dio;

  @override
  checkout({required request, required idempotencyKey}) async {
    final result = await repoGuard(() async {
      final response = await _post(
        EndPoints.tamaraCheckout,
        data: request.toJson(),
        headers: {'Idempotency-Key': idempotencyKey, 'lang': 'ar'},
      );
      return TamaraCheckoutResponse.fromJson(asMap(response));
    });
    result.fold(
      (failure) =>
          GulfRegistrationDiagnostics.failed(EndPoints.tamaraCheckout, failure),
      (_) {},
    );
    return result;
  }

  @override
  reconcile(String paymentId) {
    return repoGuard(() async {
      final response = await _post(
        EndPoints.tamaraReconcile(paymentId),
        isProtected: true,
      );
      return TamaraStatusResponse.fromJson(asMap(response));
    });
  }

  @override
  status(String paymentId) {
    return repoGuard(() async {
      final endpoint = EndPoints.tamaraStatus(paymentId);
      GulfRegistrationDiagnostics.started(endpoint);
      try {
        final response = await dio.get(
          endpoint,
          options: Options(extra: {'isProtected': true}),
        );
        GulfRegistrationDiagnostics.succeeded(
          endpoint,
          statusCode: response.statusCode,
        );
        return TamaraStatusResponse.fromJson(asMap(response.data));
      } on DioException catch (error) {
        final exception = AppException.fromDio(error);
        GulfRegistrationDiagnostics.failed(
          endpoint,
          exception,
          statusCode: error.response?.statusCode,
        );
        throw exception;
      }
    });
  }

  Future<dynamic> _post(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
    bool isProtected = false,
  }) async {
    GulfRegistrationDiagnostics.started(path);
    try {
      final response = await dio.post(
        path,
        data: data,
        options: Options(
          headers: headers,
          extra: {
            'isProtected': isProtected,
            if (path == EndPoints.tamaraCheckout) 'sensitive': true,
          },
        ),
      );
      GulfRegistrationDiagnostics.succeeded(
        path,
        statusCode: response.statusCode,
      );
      return response.data;
    } on DioException catch (error) {
      final exception = AppException.fromDio(error);
      GulfRegistrationDiagnostics.failed(
        path,
        exception,
        statusCode: error.response?.statusCode,
      );
      throw exception;
    }
  }
}
