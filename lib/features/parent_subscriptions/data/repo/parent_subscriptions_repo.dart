import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/egyptian_renewal_request.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/gulf_renewal_request.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/parent_subscriptions_response.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/renewal_status_response.dart';
import 'package:dartz/dartz.dart';

abstract class ParentSubscriptionsRepo {
  Future<Either<Failure, ParentSubscriptionsResponse>> getSubscriptions();
  Future<Either<Failure, RenewalStatusResponse>> renewEgyptian(
    EgyptianRenewalRequest request,
  );
  Future<Either<Failure, RenewalStatusResponse>> egyptianStatus(
    String paymentId,
  );
  Future<Either<Failure, RenewalStatusResponse>> renewGulf({
    required GulfRenewalRequest request,
    required String idempotencyKey,
  });
  Future<Either<Failure, RenewalStatusResponse>> gulfStatus(String paymentId);
  Future<Either<Failure, RenewalStatusResponse>> gulfReconcile(
    String paymentId,
  );
}
