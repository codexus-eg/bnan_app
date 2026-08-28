import 'package:bnan_app/features/payments/data/models/payment_amount_summary.dart';

class SubjectRequestPayment {
  const SubjectRequestPayment({
    required this.paymentId,
    required this.status,
    this.checkoutUrl,
    this.subjectRequestId,
    this.orderId,
    this.providerStatus,
    this.originalAmount,
    this.discountAmount,
    this.finalAmount,
    this.currency,
    this.discount,
  });

  final String paymentId;
  final SubjectRequestPaymentStatus status;
  final String? checkoutUrl;
  final String? subjectRequestId;
  final String? orderId;
  final String? providerStatus;
  final num? originalAmount;
  final num? discountAmount;
  final num? finalAmount;
  final String? currency;
  final Map<String, dynamic>? discount;

  PaymentAmountSummary get paymentSummary => PaymentAmountSummary(
    originalAmount: originalAmount,
    discountAmount: discountAmount,
    finalAmount: finalAmount,
    currency: currency,
  );

  factory SubjectRequestPayment.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    final data = raw is Map ? Map<String, dynamic>.from(raw) : json;
    return SubjectRequestPayment(
      paymentId: (data['paymentId'] ?? '').toString(),
      status: SubjectRequestPaymentStatus.fromValue(data['status']),
      checkoutUrl: _text(data['checkoutUrl']),
      subjectRequestId: _text(data['subjectRequestId']),
      orderId: _text(data['orderId']),
      providerStatus: _text(data['providerStatus']),
      originalAmount: _number(data['originalAmount']),
      discountAmount: _number(data['discountAmount']),
      finalAmount: _number(data['finalAmount']),
      currency: _text(data['currency']),
      discount: data['discount'] is Map
          ? Map<String, dynamic>.from(data['discount'] as Map)
          : null,
    );
  }
}

enum SubjectRequestPaymentStatus {
  pending,
  authorized,
  captured,
  completed,
  failed,
  cancelled,
  expired,
  refunded,
  unknown;

  factory SubjectRequestPaymentStatus.fromValue(dynamic value) =>
      values.firstWhere(
        (item) => item.name == value?.toString().trim().toLowerCase(),
        orElse: () => unknown,
      );

  bool get isProcessing =>
      this == pending || this == authorized || this == captured;
  bool get allowsNewAttempt =>
      this == failed || this == cancelled || this == expired;
  bool get isTerminal => !isProcessing && this != unknown;
}

String? _text(dynamic value) =>
    value?.toString().trim().isEmpty == false ? value.toString().trim() : null;
num? _number(dynamic value) =>
    value is num ? value : num.tryParse(value?.toString() ?? '');
