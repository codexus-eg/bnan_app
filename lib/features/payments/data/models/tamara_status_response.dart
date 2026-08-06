import 'package:bnan_app/features/payments/data/models/payment_status.dart';

class TamaraStatusResponse {
  const TamaraStatusResponse({
    required this.paymentId,
    required this.status,
    this.checkoutUrl,
    this.providerStatus,
    this.studentId,
    this.subscriptionId,
    this.completedAt,
  });

  final String paymentId;
  final PaymentStatus status;
  final String? checkoutUrl;
  final String? providerStatus;
  final String? studentId;
  final String? subscriptionId;
  final DateTime? completedAt;

  factory TamaraStatusResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    final data = raw is Map
        ? Map<String, dynamic>.from(raw)
        : <String, dynamic>{};
    return TamaraStatusResponse(
      paymentId: _text(data['paymentId']) ?? '',
      status: PaymentStatus.fromValue(data['status']),
      checkoutUrl: _text(data['checkoutUrl']),
      providerStatus: _text(data['providerStatus']),
      studentId: _text(data['studentId']),
      subscriptionId: _text(data['subscriptionId']),
      completedAt: DateTime.tryParse(_text(data['completedAt']) ?? ''),
    );
  }

  static String? _text(dynamic value) {
    if (value is! String) return null;
    final text = value.trim();
    return text.isEmpty ? null : text;
  }
}
