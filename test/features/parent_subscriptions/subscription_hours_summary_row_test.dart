import 'package:bnan_app/features/parent_subscriptions/presentation/widgets/subscription_hours_summary_row.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _buildWrapper({required Widget child, Locale locale = const Locale('ar')}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('renders three boxes with formatted hours in Arabic', (tester) async {
    await tester.pumpWidget(
      _buildWrapper(
        child: const SubscriptionHoursSummaryRow(
          purchasedHours: 20,
          usedHours: 0.068,
          remainingHours: 19.932,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('20'), findsOneWidget);
    expect(find.text('4 دقيقة'), findsOneWidget);
    expect(find.text('19 ساعة و56 دقيقة'), findsOneWidget);
  });

  testWidgets('renders three boxes in English correctly', (tester) async {
    await tester.pumpWidget(
      _buildWrapper(
        locale: const Locale('en'),
        child: const SubscriptionHoursSummaryRow(
          purchasedHours: 10,
          usedHours: 2.5,
          remainingHours: 7.5,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('10'), findsOneWidget);
    expect(find.text('2 hr 30 min'), findsOneWidget);
    expect(find.text('7 hr 30 min'), findsOneWidget);
  });
}
