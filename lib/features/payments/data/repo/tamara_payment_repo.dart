import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/payments/data/models/tamara_checkout_request.dart';
import 'package:bnan_app/features/payments/data/models/gulf_payment_provider.dart';
import 'package:bnan_app/features/payments/data/models/tamara_checkout_response.dart';
import 'package:bnan_app/features/payments/data/models/tamara_status_response.dart';
import 'package:dartz/dartz.dart';

abstract class TamaraPaymentRepo {
  Future<Either<Failure, TamaraCheckoutResponse>> checkout({
    required TamaraCheckoutRequest request,
    required String idempotencyKey,
  });

  Future<Either<Failure, TamaraStatusResponse>> reconcile(String paymentId);

  Future<Either<Failure, TamaraStatusResponse>> status(
    String paymentId, {
    GulfPaymentProvider provider = GulfPaymentProvider.tamara,
  });
}
