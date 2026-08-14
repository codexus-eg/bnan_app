import 'package:bnan_app/features/payments/data/models/payment_amount_summary.dart';

enum RenewalPaymentStatus {
  pending,
  authorized,
  captured,
  confirmed,
  completed,
  rejected,
  failed,
  cancelled,
  expired,
  unknown;

  factory RenewalPaymentStatus.fromValue(dynamic value) => values.firstWhere(
    (item) => item.name == value?.toString().trim().toLowerCase(),
    orElse: () => unknown,
  );
  bool get isTerminal =>
      const {completed, rejected, failed, cancelled, expired}.contains(this);
}

class RenewalStatusResponse {
  const RenewalStatusResponse({
    required this.paymentId,
    required this.status,
    this.checkoutUrl,
    this.paymentSummary,
    this.message,
  });
  final String paymentId;
  final RenewalPaymentStatus status;
  final String? checkoutUrl;
  final PaymentAmountSummary? paymentSummary;
  final String? message;

  factory RenewalStatusResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    final data = raw is Map ? Map<String, dynamic>.from(raw) : json;
    final summary = PaymentAmountSummary.fromJson(data);
    return RenewalStatusResponse(
      paymentId: data['paymentId']?.toString() ?? '',
      status: RenewalPaymentStatus.fromValue(data['status']),
      checkoutUrl: data['checkoutUrl']?.toString(),
      paymentSummary: summary.hasAmounts || summary.hasDiscount
          ? summary
          : null,
      message: _optionalText(data['message'] ?? json['message']),
    );
  }
}

String? _optionalText(dynamic value) {
  final text = value?.toString().trim();
  return text?.isNotEmpty == true ? text : null;
}
