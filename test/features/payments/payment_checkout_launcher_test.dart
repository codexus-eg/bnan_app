import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/payments/data/models/gulf_payment_provider.dart';
import 'package:bnan_app/features/payments/presentation/views/payment_checkout_launcher.dart';
import 'package:bnan_app/features/payments/presentation/views/paymob_checkout_view.dart';
import 'package:bnan_app/features/payments/presentation/views/paymob_navigation_policy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tamara_flutter_sdk/tamara_navigation_policy.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  test('providers route to their dedicated checkout implementation', () {
    expect(
      PaymentCheckoutLauncher.kindFor(GulfPaymentProvider.tamara),
      PaymentCheckoutKind.tamaraSdk,
    );
    expect(
      PaymentCheckoutLauncher.kindFor(GulfPaymentProvider.paymob),
      PaymentCheckoutKind.paymobWebView,
    );
  });

  test('Paymob keeps HTTP redirects in-app', () async {
    var externalCalls = 0;
    Future<bool> external(Uri _) async {
      externalCalls++;
      return true;
    }

    expect(
      await PaymobNavigationPolicy.decide(
        'https://accept.paymob.com/redirect?success=true',
        openExternal: external,
      ),
      NavigationDecision.navigate,
    );
    expect(externalCalls, 0);
    expect(PaymobCheckoutOutcome.values, [PaymobCheckoutOutcome.closed]);
  });

  test('provider backend return URLs are intercepted by host and path', () {
    final baseUrl = EndPoints.baseUrl;
    expect(
      PaymobNavigationPolicy.isSuccessReturnUrl(
        '$baseUrl/payment/paymob/success?paymentStatus=approved',
      ),
      isTrue,
    );
    expect(
      TamaraNavigationPolicy.matches(
        '$baseUrl/payment/tamara/success/?paymentStatus=approved',
        '$baseUrl/payment/tamara/success',
      ),
      isTrue,
    );
    expect(
      PaymobNavigationPolicy.isSuccessReturnUrl(
        'https://example.com/api/v1/payment/paymob/success',
      ),
      isFalse,
    );
  });

  test(
    'Paymob prevents custom schemes in WebView and delegates them',
    () async {
      Uri? opened;
      final decision = await PaymobNavigationPolicy.decide(
        'banking-app://approve',
        openExternal: (uri) async {
          opened = uri;
          return true;
        },
      );
      expect(decision, NavigationDecision.prevent);
      expect(opened?.scheme, 'banking-app');
    },
  );

  test('Paymob keeps WebView open when an external app cannot open', () async {
    final decision = await PaymobNavigationPolicy.decide(
      'banking-app://approve',
      openExternal: (_) async => throw StateError('unavailable'),
    );
    expect(decision, NavigationDecision.prevent);
  });

  testWidgets('Paymob launcher opens an in-app route and Back is closed', (
    tester,
  ) async {
    PaymentCheckoutLaunchResult? result;
    var opened = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              result = await PaymentCheckoutLauncher.open(
                context: context,
                provider: GulfPaymentProvider.paymob,
                checkoutUrl: 'https://accept.paymob.com/checkout',
                onOpened: () async => opened = true,
                paymobPageBuilder: (_) => const Scaffold(body: Text('Paymob')),
              );
            },
            child: const Text('Open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('Paymob'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(opened, isTrue);
    expect(result?.opened, isTrue);
    expect(result?.paymobOutcome, PaymobCheckoutOutcome.closed);
    expect(result?.tamaraOutcome, isNull);
  });
}
