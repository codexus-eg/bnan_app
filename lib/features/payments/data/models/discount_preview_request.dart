import 'package:bnan_app/features/payments/data/checkout_payload_fingerprint.dart';

class DiscountPreviewRequest {
  const DiscountPreviewRequest({
    required this.purchaseType,
    required this.payload,
    required this.isProtected,
  });

  final String purchaseType;
  final Map<String, dynamic> payload;
  final bool isProtected;

  Map<String, dynamic> toJson() => {'purchaseType': purchaseType, ...payload};

  String get fingerprint => checkoutMapFingerprint(toJson());

  String get discountCode => payload['discountCode']?.toString().trim() ?? '';
}
