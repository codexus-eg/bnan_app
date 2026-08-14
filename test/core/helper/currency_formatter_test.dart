import 'package:bnan_app/core/helper/currency_formatter.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('uses localized EGP, SAR, and QAR symbols', () async {
    await S.load(const Locale('ar'));
    expect(CurrencyFormatter.symbolWith(S.current, 'EGP'), 'ج.م');
    expect(CurrencyFormatter.symbolWith(S.current, 'SAR'), 'ريال');
    expect(CurrencyFormatter.symbolWith(S.current, 'QAR'), S.current.qarShort);
  });

  test('falls back to the backend currency code', () async {
    await S.load(const Locale('en'));
    expect(CurrencyFormatter.symbolWith(S.current, 'AED'), 'AED');
  });
}
