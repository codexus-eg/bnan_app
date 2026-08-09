import 'package:bnan_app/core/helper/phone_number_normalizer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const saudi = '+966551234567';
  test('normalizes supported Saudi formats without duplicating code', () {
    for (final input in [
      '0551234567',
      '551234567',
      '966551234567',
      saudi,
      '05 5123 4567',
      '055-123-4567',
      '(055) 123-4567',
    ]) {
      expect(PhoneNumberNormalizer.normalize(input, currency: 'SAR'), saudi);
    }
  });

  test('rejects malformed and mismatched Saudi numbers', () {
    for (final input in ['05512', '055ABC4567', '+971501234567']) {
      expect(PhoneNumberNormalizer.normalize(input, currency: 'SAR'), isNull);
    }
  });

  test('normalizes every currently supported country currency', () {
    const cases = {
      'EGP': ('01012345678', '+201012345678'),
      'AED': ('0501234567', '+971501234567'),
      'KWD': ('51234567', '+96551234567'),
      'QAR': ('33123456', '+97433123456'),
      'BHD': ('36123456', '+97336123456'),
      'OMR': ('92123456', '+96892123456'),
    };
    for (final entry in cases.entries) {
      expect(
        PhoneNumberNormalizer.normalize(entry.value.$1, currency: entry.key),
        entry.value.$2,
      );
    }
  });
}
