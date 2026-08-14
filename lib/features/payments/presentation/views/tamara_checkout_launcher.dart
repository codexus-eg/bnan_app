import 'dart:async';
import 'dart:io';

import 'package:bnan_app/core/helper/file_url_launcher.dart';
import 'package:bnan_app/features/payments/presentation/views/tamara_sdk_checkout_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TamaraCheckoutLaunchResult {
  const TamaraCheckoutLaunchResult({required this.opened});

  final bool opened;
}

abstract class TamaraCheckoutLauncher {
  static Future<TamaraCheckoutLaunchResult> open(
    BuildContext context,
    String checkoutUrl, {
    Future<void> Function()? onOpened,
    Stream<bool>? completionStream,
    bool Function()? isCompleted,
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
          ),
        ),
      );
      if (onOpened != null) unawaited(_notifyOpened(onOpened));
      await checkout;
      return const TamaraCheckoutLaunchResult(opened: true);
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
