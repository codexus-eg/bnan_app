import 'dart:async';
import 'dart:io';

import 'package:bnan_app/core/helper/file_url_launcher.dart';
import 'package:bnan_app/features/payments/presentation/views/tamara_sdk_checkout_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TamaraCheckoutLaunchResult {
  const TamaraCheckoutLaunchResult({required this.opened, this.outcome});

  final bool opened;
  final TamaraSdkOutcome? outcome;
}

abstract class TamaraCheckoutLauncher {
  static Future<TamaraCheckoutLaunchResult> open(
    BuildContext context,
    String checkoutUrl, {
    Future<void> Function()? onOpened,
    Stream<bool>? completionStream,
    bool Function()? isCompleted,
    Future<void> Function()? onPaymentSuccess,
  }) async {
    if (!FileUrlLauncher.isValidWebUrl(checkoutUrl)) {
      return const TamaraCheckoutLaunchResult(opened: false);
    }
    if (!Platform.isAndroid && !Platform.isIOS) {
      return TamaraCheckoutLaunchResult(
        opened: await FileUrlLauncher.open(checkoutUrl),
      );
    }
    try {
      final checkout = Navigator.of(context).push<TamaraSdkOutcome>(
        MaterialPageRoute(
          builder: (_) => TamaraSdkCheckoutView(
            checkoutUrl: checkoutUrl,
            completionStream: completionStream,
            isCompleted: isCompleted,
            onPaymentSuccess: onPaymentSuccess,
          ),
        ),
      );
      if (onOpened != null) unawaited(_notifyOpened(onOpened));
      final outcome = await checkout;
      return TamaraCheckoutLaunchResult(
        opened: true,
        outcome: outcome ?? TamaraSdkOutcome.cancel,
      );
    } catch (error) {
      if (kDebugMode) {
        debugPrint('[TamaraCheckout] SDK unavailable: ${error.runtimeType}');
      }
      return TamaraCheckoutLaunchResult(
        opened: await FileUrlLauncher.open(checkoutUrl),
      );
    }
  }

  static Future<void> _notifyOpened(Future<void> Function() callback) async {
    try {
      await callback();
    } catch (error) {
      if (kDebugMode) {
        debugPrint('[TamaraCheckout] status check failed: $error');
      }
    }
  }
}
