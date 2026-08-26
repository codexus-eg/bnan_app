import 'dart:async';

import 'package:bnan_app/core/helper/file_url_launcher.dart';
import 'package:bnan_app/features/payments/data/models/gulf_payment_provider.dart';
import 'package:bnan_app/features/payments/presentation/views/paymob_checkout_view.dart';
import 'package:bnan_app/features/payments/presentation/views/tamara_checkout_launcher.dart';
import 'package:bnan_app/features/payments/presentation/views/tamara_sdk_checkout_view.dart';
import 'package:flutter/material.dart';

enum PaymentCheckoutKind { tamaraSdk, paymobWebView }

class PaymentCheckoutLaunchResult {
  const PaymentCheckoutLaunchResult({
    required this.provider,
    required this.opened,
    this.tamaraOutcome,
    this.paymobOutcome,
  });

  final GulfPaymentProvider provider;
  final bool opened;
  final TamaraSdkOutcome? tamaraOutcome;
  final PaymobCheckoutOutcome? paymobOutcome;
}

abstract final class PaymentCheckoutLauncher {
  static PaymentCheckoutKind kindFor(GulfPaymentProvider provider) =>
      provider == GulfPaymentProvider.tamara
      ? PaymentCheckoutKind.tamaraSdk
      : PaymentCheckoutKind.paymobWebView;

  static Future<PaymentCheckoutLaunchResult> open({
    required BuildContext context,
    required GulfPaymentProvider provider,
    required String checkoutUrl,
    Future<void> Function()? onOpened,
    Stream<bool>? completionStream,
    bool Function()? isCompleted,
    Future<void> Function()? onPaymentSuccess,
    WidgetBuilder? paymobPageBuilder,
  }) async {
    if (provider == GulfPaymentProvider.tamara) {
      final result = await TamaraCheckoutLauncher.open(
        context,
        checkoutUrl,
        onOpened: onOpened,
        completionStream: completionStream,
        isCompleted: isCompleted,
        onPaymentSuccess: onPaymentSuccess,
      );
      return PaymentCheckoutLaunchResult(
        provider: provider,
        opened: result.opened,
        tamaraOutcome: result.outcome,
      );
    }
    if (!FileUrlLauncher.isValidWebUrl(checkoutUrl)) {
      return PaymentCheckoutLaunchResult(provider: provider, opened: false);
    }
    try {
      final route = Navigator.of(context).push<PaymobCheckoutOutcome>(
        MaterialPageRoute(
          builder:
              paymobPageBuilder ??
              (_) => PaymobCheckoutView(checkoutUrl: checkoutUrl),
        ),
      );
      if (onOpened != null) unawaited(_notifyOpened(onOpened));
      return PaymentCheckoutLaunchResult(
        provider: provider,
        opened: true,
        paymobOutcome: await route ?? PaymobCheckoutOutcome.closed,
      );
    } catch (_) {
      return PaymentCheckoutLaunchResult(provider: provider, opened: false);
    }
  }

  static Future<void> _notifyOpened(Future<void> Function() callback) async {
    try {
      await callback();
    } catch (_) {}
  }
}
