import 'dart:async';

import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/payments/data/models/tamara_return.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:tamara_flutter_sdk/tamara_checkout.dart';

enum TamaraSdkOutcome { success, failure, cancel }

class TamaraSdkCheckoutView extends StatefulWidget {
  const TamaraSdkCheckoutView({
    super.key,
    required this.checkoutUrl,
    this.completionStream,
    this.isCompleted,
    this.onPaymentSuccess,
  });

  final String checkoutUrl;
  final Stream<bool>? completionStream;
  final bool Function()? isCompleted;
  final Future<void> Function()? onPaymentSuccess;

  @override
  State<TamaraSdkCheckoutView> createState() => _TamaraSdkCheckoutViewState();
}

class _TamaraSdkCheckoutViewState extends State<TamaraSdkCheckoutView> {
  StreamSubscription<bool>? _completionSubscription;
  bool _paymentCompletionHandled = false;
  bool _providerSuccessHandled = false;

  @override
  void initState() {
    super.initState();
    _completionSubscription = widget.completionStream?.listen((completed) {
      if (completed) _close(TamaraSdkOutcome.success);
    });
    if (widget.isCompleted?.call() == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _close(TamaraSdkOutcome.success);
      });
    }
  }

  @override
  void dispose() {
    _completionSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: CustomAppbar(headerText: S.of(context).tabbyTamara),
    body: SafeArea(
      child: SizedBox.expand(
        child: TamaraCheckout(
          widget.checkoutUrl,
          _returnUrl(TamaraReturnOutcome.success),
          _returnUrl(TamaraReturnOutcome.failure),
          _returnUrl(TamaraReturnOutcome.cancel),
          onPaymentSuccess: _onPaymentSuccess,
          onPaymentFailed: () => _close(TamaraSdkOutcome.failure),
          onPaymentCanceled: () => _close(TamaraSdkOutcome.cancel),
        ),
      ),
    ),
  );

  String _returnUrl(TamaraReturnOutcome outcome) =>
      '${EndPoints.baseUrl}/payment/tamara/${outcome.name}';

  void _onPaymentSuccess() {
    if (_providerSuccessHandled) return;
    _providerSuccessHandled = true;
    final callback = widget.onPaymentSuccess;
    if (callback != null) unawaited(callback());
    _close(TamaraSdkOutcome.success);
  }

  void _close(TamaraSdkOutcome outcome) {
    if (_paymentCompletionHandled || !mounted) return;
    _paymentCompletionHandled = true;
    Navigator.of(context).pop(outcome);
  }
}
