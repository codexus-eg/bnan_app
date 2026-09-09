import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/payments/data/models/gulf_payment_provider.dart';
import 'package:bnan_app/features/payments/presentation/views/payment_checkout_launcher.dart';
import 'package:bnan_app/features/payments/presentation/views/paymob_checkout_view.dart';
import 'package:bnan_app/features/payments/presentation/views/paymob_navigation_policy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tamara_flutter_sdk/tamara_navigation_policy.dart';

void main() {
  group('Payment Navigation Policies - Success & Host Protection', () {
    final baseUrl = EndPoints.baseUrl;
    final socketUrl = EndPoints.socketUrl;

    test('PaymobNavigationPolicy matches all valid backend callback paths for official host only', () {
      expect(PaymobNavigationPolicy.isSuccessReturnUrl('$baseUrl/payment/paymob/success'), isTrue);
      expect(PaymobNavigationPolicy.isSuccessReturnUrl('$baseUrl/payment/paymob/callback'), isTrue);
      expect(PaymobNavigationPolicy.isSuccessReturnUrl('$baseUrl/payment/callback'), isTrue);
      expect(PaymobNavigationPolicy.isSuccessReturnUrl('$socketUrl/payment/paymob/success'), isTrue);
      expect(PaymobNavigationPolicy.isSuccessReturnUrl('$socketUrl/payment/paymob/callback'), isTrue);
      expect(PaymobNavigationPolicy.isSuccessReturnUrl('$baseUrl/payment/paymob/success?status=completed'), isTrue);

      // Protect against foreign hosts even if they have matching path
      expect(PaymobNavigationPolicy.isSuccessReturnUrl('https://evil.com/api/v1/payment/paymob/success'), isFalse);
      expect(PaymobNavigationPolicy.isSuccessReturnUrl('https://evil.com/payment/callback'), isFalse);
    });

    test('TamaraNavigationPolicy matches with and without /api/v1 prefix for official host only', () {
      expect(TamaraNavigationPolicy.matches('$baseUrl/payment/tamara/success', '$baseUrl/payment/tamara/success'), isTrue);
      expect(TamaraNavigationPolicy.matches('$socketUrl/payment/tamara/success', '$baseUrl/payment/tamara/success'), isTrue);
      expect(TamaraNavigationPolicy.matches('https://evil.com/payment/tamara/success', '$baseUrl/payment/tamara/success'), isFalse);
    });
  });

  group('PaymentCheckoutLauncher Integration', () {
    testWidgets('PaymentCheckoutLauncher opens Paymob page and handles Back as closed', (tester) async {
      PaymentCheckoutLaunchResult? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                result = await PaymentCheckoutLauncher.open(
                  context: context,
                  provider: GulfPaymentProvider.paymob,
                  checkoutUrl: 'https://accept.paymob.com/checkout',
                  paymobPageBuilder: (_) => const Scaffold(body: Text('Custom Paymob Page')),
                );
              },
              child: const Text('Open Paymob'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Paymob'));
      await tester.pumpAndSettle();

      expect(find.text('Custom Paymob Page'), findsOneWidget);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.text('Custom Paymob Page'), findsNothing);
      expect(result?.opened, isTrue);
      expect(result?.paymobOutcome, PaymobCheckoutOutcome.closed);
    });
  });
}
