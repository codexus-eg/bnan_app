import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/payments/data/models/discount_preview_request.dart';
import 'package:bnan_app/features/payments/data/models/payment_amount_summary.dart';
import 'package:bnan_app/features/payments/data/repo/discount_preview_repo.dart';

class DiscountPreviewRepoImpl implements DiscountPreviewRepo {
  const DiscountPreviewRepoImpl(this.api);
  final ApiConsumer api;

  @override
  preview(DiscountPreviewRequest request) => repoGuard(() async {
    final response = asMap(
      await api.post(
        EndPoints.discountPreview,
        data: request.toJson(),
        isProtected: request.isProtected,
      ),
    );
    return PaymentAmountSummary.fromJson(asMap(response['data']));
  });
}
