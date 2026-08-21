import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/admin_subscription_renewals/data/models/admin_renewal_status.dart';
import 'package:bnan_app/features/admin_subscription_renewals/data/models/admin_subscription_renewals_page.dart';
import 'package:dartz/dartz.dart';

abstract interface class AdminSubscriptionRenewalsRepo {
  Future<Either<Failure, AdminSubscriptionRenewalsPage>> getRenewals({
    required AdminRenewalStatus status,
    int page = 1,
    int limit = 20,
  });
  Future<Either<Failure, void>> confirm(String paymentId);
  Future<Either<Failure, void>> approve(String paymentId);
  Future<Either<Failure, void>> reject(
    String paymentId, {
    String? rejectionReason,
  });
}
