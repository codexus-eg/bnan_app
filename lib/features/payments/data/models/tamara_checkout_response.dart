import 'package:bnan_app/features/payments/data/models/payment_amount_summary.dart';

class TamaraCheckoutResponse {
  const TamaraCheckoutResponse({
    required this.paymentId,
    required this.checkoutUrl,
    required this.orderId,
    required this.status,
    required this.providerStatus,
    this.paymentSummary,
  });

  final String paymentId;
  final String? checkoutUrl;
  final String orderId;
  final String status;
  final String providerStatus;
  final PaymentAmountSummary? paymentSummary;

  factory TamaraCheckoutResponse.fromJson(Map<String, dynamic> json) {
    final data = _map(json['data']);
    final summary = PaymentAmountSummary.fromJson(data);
    return TamaraCheckoutResponse(
      paymentId: _text(data['paymentId']) ?? '',
      checkoutUrl: _text(data['checkoutUrl']),
      orderId: _text(data['orderId']) ?? '',
      status: _text(data['status']) ?? 'unknown',
      providerStatus: _text(data['providerStatus']) ?? '',
      paymentSummary: summary.hasAmounts || summary.hasDiscount
          ? summary
          : null,
    );
  }
}

Map<String, dynamic> _map(dynamic value) {
  return value is Map ? Map<String, dynamic>.from(value) : {};
}

String? _text(dynamic value) {
  if (value is! String) return null;
  final text = value.trim();
  return text.isEmpty ? null : text;
}
