import 'package:bnan_app/features/payments/data/models/payment_amount_summary.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/payment_discount_summary.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows backend final amount and positive discount only', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const PaymentAmountSummary(
          originalAmount: 500,
          discountAmount: 50,
          finalAmount: 450,
          currency: 'SAR',
        ),
      ),
    );
    expect(find.text(S.current.originalAmount), findsOneWidget);
    expect(find.text(S.current.discountAmount), findsOneWidget);
    expect(find.text(S.current.finalAmount), findsOneWidget);
    expect(find.text('450 SAR'), findsOneWidget);
  });

  testWidgets('does not show a zero discount row', (tester) async {
    await tester.pumpWidget(
      _app(
        const PaymentAmountSummary(
          originalAmount: 500,
          discountAmount: 0,
          finalAmount: 500,
          currency: 'SAR',
        ),
      ),
    );
    expect(find.text(S.current.discountAmount), findsNothing);
    expect(find.text('500 SAR'), findsNWidgets(2));
  });

  testWidgets('shows a backend final amount without inventing a discount', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(const PaymentAmountSummary(finalAmount: 450, currency: 'SAR')),
    );
    expect(find.text(S.current.discountAmount), findsNothing);
    expect(find.text('450 SAR'), findsOneWidget);
  });

  testWidgets('shows no amount when the backend returned none', (tester) async {
    await tester.pumpWidget(_app(const PaymentAmountSummary()));
    expect(find.text(S.current.finalAmount), findsNothing);
  });
}

Widget _app(PaymentAmountSummary summary) => MaterialApp(
  locale: const Locale('en'),
  localizationsDelegates: const [
    S.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: S.delegate.supportedLocales,
  home: Scaffold(body: PaymentDiscountSummary(summary: summary)),
);
