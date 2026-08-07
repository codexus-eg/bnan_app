enum DiscountCodeType {
  dateRange('date_range'),
  children('children');

  const DiscountCodeType(this.apiValue);
  final String apiValue;

  static DiscountCodeType fromValue(dynamic value) =>
      value == children.apiValue ? children : dateRange;
}

class DiscountCodeModel {
  const DiscountCodeModel({
    required this.id,
    required this.code,
    required this.type,
    required this.percentage,
    required this.isActive,
    this.startsAt,
    this.endsAt,
    this.childrenCount,
  });

  final String id;
  final String code;
  final DiscountCodeType type;
  final num percentage;
  final bool isActive;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final int? childrenCount;

  factory DiscountCodeModel.fromJson(Map<String, dynamic> json) {
    return DiscountCodeModel(
      id: _text(json['_id'] ?? json['id']),
      code: _text(json['code']),
      type: DiscountCodeType.fromValue(json['type']),
      percentage: _number(json['percentage']) ?? 0,
      isActive: _boolean(json['isActive']),
      startsAt: DateTime.tryParse(_text(json['startsAt'])),
      endsAt: DateTime.tryParse(_text(json['endsAt'])),
      childrenCount: _number(json['childrenCount'])?.toInt(),
    );
  }

  DiscountCodeModel withId(String value) => DiscountCodeModel(
    id: value,
    code: code,
    type: type,
    percentage: percentage,
    isActive: isActive,
    startsAt: startsAt,
    endsAt: endsAt,
    childrenCount: childrenCount,
  );
}

String _text(dynamic value) => value?.toString().trim() ?? '';
num? _number(dynamic value) =>
    value is num ? value : num.tryParse(_text(value));
bool _boolean(dynamic value) =>
    value == true || value == 1 || _text(value).toLowerCase() == 'true';
