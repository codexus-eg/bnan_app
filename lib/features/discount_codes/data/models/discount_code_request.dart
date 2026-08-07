import 'package:bnan_app/features/discount_codes/data/models/discount_code_model.dart';

class DiscountCodeRequest {
  const DiscountCodeRequest({
    required this.code,
    required this.type,
    required this.percentage,
    required this.isActive,
    this.startsAt,
    this.endsAt,
    this.childrenCount,
  });

  final String code;
  final DiscountCodeType type;
  final num percentage;
  final bool isActive;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final int? childrenCount;

  Map<String, dynamic> toJson() => {
    'code': code.trim(),
    'type': type.apiValue,
    'percentage': percentage,
    'isActive': isActive,
    if (type == DiscountCodeType.dateRange) ...{
      'startsAt': startsAt?.toUtc().toIso8601String(),
      'endsAt': endsAt?.toUtc().toIso8601String(),
    },
    if (type == DiscountCodeType.children) 'childrenCount': childrenCount,
  };

  DiscountCodeModel toModel({String id = ''}) => DiscountCodeModel(
    id: id,
    code: code.trim(),
    type: type,
    percentage: percentage,
    isActive: isActive,
    startsAt: type == DiscountCodeType.dateRange ? startsAt : null,
    endsAt: type == DiscountCodeType.dateRange ? endsAt : null,
    childrenCount: type == DiscountCodeType.children ? childrenCount : null,
  );
}
