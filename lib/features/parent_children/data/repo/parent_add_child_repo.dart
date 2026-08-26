import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/parent_children/data/models/parent_add_child_egyptian_request.dart';
import 'package:bnan_app/features/parent_children/data/models/parent_add_child_gulf_request.dart';
import 'package:bnan_app/features/parent_children/data/models/parent_add_child_submission.dart';
import 'package:bnan_app/features/payments/data/models/tamara_checkout_response.dart';
import 'package:bnan_app/features/payments/data/models/gulf_payment_provider.dart';
import 'package:bnan_app/features/payments/data/models/tamara_status_response.dart';
import 'package:dartz/dartz.dart';

abstract class ParentAddChildRepo {
  Future<Either<Failure, ParentAddChildSubmission>> registerEgyptian(
    ParentAddChildEgyptianRequest request,
  );

  Future<Either<Failure, TamaraCheckoutResponse>> checkoutGulf({
    required ParentAddChildGulfRequest request,
    required String idempotencyKey,
  });

  Future<Either<Failure, TamaraStatusResponse>> reconcile(String paymentId);

  Future<Either<Failure, TamaraStatusResponse>> status(
    String paymentId, {
    GulfPaymentProvider provider = GulfPaymentProvider.tamara,
  });
}
