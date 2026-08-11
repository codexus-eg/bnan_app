import 'package:bnan_app/features/teacher_payrolls/presentation/utils/payroll_date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(initializeDateFormatting);
  testWidgets('summary displays a readable English range instead of ISO', (
    tester,
  ) async {
    late String value;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        home: Builder(
          builder: (context) {
            value = PayrollDateFormatter.range(
              context,
              DateTime(2026, 8, 1),
              DateTime(2026, 8, 8),
            );
            return const SizedBox();
          },
        ),
      ),
    );
    expect(value, 'Aug 1, 2026 — Aug 8, 2026');
    expect(value, isNot(contains('2026-08')));
  });
  test('filter field format distinguishes start and end clearly', () {
    expect(PayrollDateFormatter.field(DateTime(2026, 8, 1)), '01/08/2026');
  });
}
