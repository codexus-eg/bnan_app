import 'package:bnan_app/features/payments/data/models/payment_discount_model.dart';

class PaymentAmountSummary {
  const PaymentAmountSummary({
    this.originalAmount,
    this.discountAmount,
    this.finalAmount,
    this.currency,
    this.discount,
  });

  final num? originalAmount;
  final num? discountAmount;
  final num? finalAmount;
  final String? currency;
  final PaymentDiscountModel? discount;

  factory PaymentAmountSummary.fromJson(Map<String, dynamic> json) {
    final amounts = _map(json['amounts']);
    final discountJson = _map(json['discount']);
    return PaymentAmountSummary(
      originalAmount: _number(
        json['originalAmount'] ?? amounts['originalAmount'],
      ),
      discountAmount: _number(
        json['discountAmount'] ?? amounts['discountAmount'],
      ),
      finalAmount: _number(json['finalAmount'] ?? amounts['finalAmount']),
      currency: _optionalText(json['currency'] ?? amounts['currency']),
      discount: discountJson.isEmpty
          ? null
          : PaymentDiscountModel.fromJson(discountJson),
    );
  }

  bool get hasDiscount => discount != null;
  bool get hasAmounts =>
      originalAmount != null || discountAmount != null || finalAmount != null;
}

Map<String, dynamic> _map(dynamic value) =>
    value is Map ? Map<String, dynamic>.from(value) : {};
String? _optionalText(dynamic value) {
  final text = value?.toString().trim() ?? '';
  return text.isEmpty ? null : text;
}

num? _number(dynamic value) =>
    value is num ? value : num.tryParse(value?.toString() ?? '');
