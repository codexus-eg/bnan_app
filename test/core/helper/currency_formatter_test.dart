import 'package:bnan_app/core/helper/currency_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('keeps backend package currency codes unchanged', () {
    expect(CurrencyFormatter.code('EGP'), 'EGP');
    expect(CurrencyFormatter.code('SAR'), 'SAR');
    expect(CurrencyFormatter.code('QAR'), 'QAR');
    expect(CurrencyFormatter.code('AED'), 'AED');
    expect(CurrencyFormatter.code(' sar '), 'sar');
  });
}
