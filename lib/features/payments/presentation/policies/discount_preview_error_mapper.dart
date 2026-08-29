import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/generated/l10n.dart';

String mapDiscountPreviewFailure(Failure failure) {
  return switch (failure.code?.trim().toUpperCase()) {
    'INVALID_DISCOUNT_CODE' => S.current.discountPreviewInvalidCode,
    'DISCOUNT_CODE_EXPIRED' => S.current.discountPreviewExpired,
    'DISCOUNT_CHILDREN_COUNT_MISMATCH' =>
      S.current.discountPreviewChildrenMismatch,
    'INVALID_PACKAGE_FOR_CURRICULUM' => S.current.invalidPackage,
    'INVALID_PURCHASE_TYPE' => S.current.discountPreviewInvalidPurchase,
    _ =>
      failure.responseReceived
          ? S.current.discountPreviewFailed
          : failure.message,
  };
}
