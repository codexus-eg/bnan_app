import 'package:bnan_app/features/payments/data/models/gulf_payment_provider.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/payment_methods_options.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('selected provider is exposed visually and semantically', (
    tester,
  ) async {
    var provider = GulfPaymentProvider.tamara;
    await tester.pumpWidget(
      _app(
        StatefulBuilder(
          builder: (context, setState) {
            return PaymentMethodsOptions(
              selectedProvider: provider,
              onChanged: (value) => setState(() => provider = value),
            );
          },
        ),
      ),
    );
    await tester.tap(find.text(S.current.paymob));
    await tester.pump();
    final semantics = tester.widget<Semantics>(
      find
          .ancestor(
            of: find.text(S.current.paymob),
            matching: find.byType(Semantics),
          )
          .first,
    );
    expect(provider, GulfPaymentProvider.paymob);
    expect(semantics.properties.selected, isTrue);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(find.byIcon(Icons.radio_button_unchecked), findsOneWidget);

    await tester.tap(find.text(S.current.tabbyTamara));
    await tester.pump();
    expect(provider, GulfPaymentProvider.tamara);
  });
}

Widget _app(Widget child) => MaterialApp(
  locale: const Locale('en'),
  localizationsDelegates: const [
    S.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: S.delegate.supportedLocales,
  home: Scaffold(body: child),
);
