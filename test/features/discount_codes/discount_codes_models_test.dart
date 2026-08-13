import 'package:bnan_app/features/discount_codes/data/models/discount_code_model.dart';
import 'package:bnan_app/features/discount_codes/data/models/discount_code_request.dart';
import 'package:bnan_app/features/discount_codes/data/models/discount_codes_parser.dart';
import 'package:bnan_app/features/discount_codes/data/models/discount_date_range_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses nested list with flexible primitive values', () {
    final codes = parseDiscountCodes({
      'data': {
        'discountCodes': [
          {
            '_id': '1',
            'code': 'FAMILY25',
            'type': 'children',
            'percentage': '25.5',
            'childrenCount': 3.0,
            'isActive': 1,
          },
        ],
      },
    });
    expect(codes.single.percentage, 25.5);
    expect(codes.single.childrenCount, 3);
    expect(codes.single.isActive, isTrue);
  });

  test('date request never sends childrenCount', () {
    final json = DiscountCodeRequest(
      code: 'SUMMER20',
      type: DiscountCodeType.dateRange,
      percentage: 20,
      isActive: true,
      startsAt: DateTime.utc(2026, 8),
      endsAt: DateTime.utc(2026, 8, 31),
      childrenCount: 3,
    ).toJson();
    expect(json, isNot(contains('childrenCount')));
    expect(json, containsPair('type', 'date_range'));
  });

  test('children request never sends dates', () {
    final json = DiscountCodeRequest(
      code: 'FAMILY25',
      type: DiscountCodeType.children,
      percentage: 25,
      isActive: true,
      childrenCount: 3,
      startsAt: DateTime.utc(2026),
      endsAt: DateTime.utc(2027),
    ).toJson();
    expect(json, isNot(contains('startsAt')));
    expect(json, isNot(contains('endsAt')));
  });

  test('expired active code is not effectively active', () {
    const code = DiscountCodeModel(
      id: 'expired',
      code: 'OLD',
      type: DiscountCodeType.dateRange,
      percentage: 10,
      isActive: true,
      endsAt: null,
    );
    final expired = DiscountCodeModel(
      id: code.id,
      code: code.code,
      type: code.type,
      percentage: code.percentage,
      isActive: code.isActive,
      endsAt: DateTime(2026, 8, 12, 23, 59),
    );

    expect(expired.isEffectivelyActiveAt(DateTime(2026, 8, 13)), isFalse);
  });

  test('today is valid and date comparisons ignore time of day', () {
    final today = DateTime(2026, 8, 13);
    expect(
      DiscountDateRangePolicy.isExpired(
        DateTime(2026, 8, 13, 0, 1),
        now: DateTime(2026, 8, 13, 23, 59),
      ),
      isFalse,
    );
    expect(
      DiscountDateRangePolicy.endsBeforeStart(DateTime(2026, 8, 14), today),
      isTrue,
    );
  });
}
