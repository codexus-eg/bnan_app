import 'package:bnan_app/features/discount_codes/data/models/discount_code_model.dart';

List<DiscountCodeModel> parseDiscountCodes(dynamic response) {
  dynamic raw = response;
  if (raw is Map) raw = raw['data'] ?? raw;
  if (raw is Map) {
    raw = raw['discountCodes'] ?? raw['codes'] ?? raw['items'] ?? const [];
  }
  if (raw is! List) return const [];
  return raw
      .whereType<Map>()
      .map(
        (item) => DiscountCodeModel.fromJson(Map<String, dynamic>.from(item)),
      )
      .toList();
}

DiscountCodeModel parseDiscountCode(dynamic response) {
  dynamic raw = response;
  if (raw is Map) raw = raw['data'] ?? raw;
  if (raw is Map) raw = raw['discountCode'] ?? raw['code'] ?? raw;
  return DiscountCodeModel.fromJson(
    raw is Map ? Map<String, dynamic>.from(raw) : const {},
  );
}
