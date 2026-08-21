import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/admin_subscription_renewals/data/models/admin_renewal_status.dart';
import 'package:bnan_app/features/admin_subscription_renewals/data/models/admin_subscription_renewals_page.dart';
import 'package:bnan_app/features/admin_subscription_renewals/data/repo/admin_subscription_renewals_repo.dart';
import 'package:dartz/dartz.dart';

class AdminSubscriptionRenewalsRepoImpl
    implements AdminSubscriptionRenewalsRepo {
  const AdminSubscriptionRenewalsRepoImpl(this._api);
  final ApiConsumer _api;

  @override
  Future<Either<Failure, AdminSubscriptionRenewalsPage>> getRenewals({
    required AdminRenewalStatus status,
    int page = 1,
    int limit = 20,
  }) => repoGuard(() async {
    final response = await _api.get(
      EndPoints.adminEgyptianSubscriptionRenewals,
      queryParameter: {'status': status.apiValue, 'page': page, 'limit': limit},
      isProtected: true,
    );
    return AdminSubscriptionRenewalsPage.fromJson(asMap(response));
  });

  @override
  Future<Either<Failure, void>> confirm(String paymentId) =>
      _patch(EndPoints.confirmEgyptianSubscriptionRenewal(paymentId));

  @override
  Future<Either<Failure, void>> approve(String paymentId) =>
      _patch(EndPoints.approveEgyptianSubscriptionRenewal(paymentId));

  @override
  Future<Either<Failure, void>> reject(
    String paymentId, {
    String? rejectionReason,
  }) {
    final reason = rejectionReason?.trim() ?? '';
    return _patch(
      EndPoints.rejectEgyptianSubscriptionRenewal(paymentId),
      data: reason.isEmpty ? null : {'rejectionReason': reason},
    );
  }

  Future<Either<Failure, void>> _patch(String path, {Object? data}) =>
      repoGuard(() async {
        await _api.patch(path, data: data, isProtected: true);
      });
}
