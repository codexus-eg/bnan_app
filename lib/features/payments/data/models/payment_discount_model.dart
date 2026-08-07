class PaymentDiscountModel {
  const PaymentDiscountModel({
    required this.code,
    required this.type,
    this.percentage,
    this.childrenCount,
  });

  final String code;
  final String type;
  final num? percentage;
  final int? childrenCount;

  factory PaymentDiscountModel.fromJson(Map<String, dynamic> json) {
    return PaymentDiscountModel(
      code: _text(json['code']),
      type: _text(json['type']),
      percentage: _number(json['percentage']),
      childrenCount: _number(json['childrenCount'])?.toInt(),
    );
  }
}

String _text(dynamic value) => value?.toString().trim() ?? '';
num? _number(dynamic value) =>
    value is num ? value : num.tryParse(_text(value));
