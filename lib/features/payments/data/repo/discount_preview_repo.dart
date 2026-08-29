import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/payments/data/models/discount_preview_request.dart';
import 'package:bnan_app/features/payments/data/models/payment_amount_summary.dart';
import 'package:dartz/dartz.dart';

abstract class DiscountPreviewRepo {
  Future<Either<Failure, PaymentAmountSummary>> preview(
    DiscountPreviewRequest request,
  );
}
