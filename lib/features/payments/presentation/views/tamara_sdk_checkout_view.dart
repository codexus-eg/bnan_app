import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/payments/data/models/tamara_return.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:tamara_flutter_sdk/tamara_checkout.dart';

enum TamaraSdkOutcome { success, failure, cancel }

class TamaraSdkCheckoutView extends StatelessWidget {
  const TamaraSdkCheckoutView({super.key, required this.checkoutUrl});

  final String checkoutUrl;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: CustomAppbar(headerText: S.of(context).tabbyTamara),
    body: SafeArea(
      child: SizedBox.expand(
        child: TamaraCheckout(
          checkoutUrl,
          _returnUrl(TamaraReturnOutcome.success),
          _returnUrl(TamaraReturnOutcome.failure),
          _returnUrl(TamaraReturnOutcome.cancel),
          onPaymentSuccess: () => _close(context, TamaraSdkOutcome.success),
          onPaymentFailed: () => _close(context, TamaraSdkOutcome.failure),
          onPaymentCanceled: () => _close(context, TamaraSdkOutcome.cancel),
        ),
      ),
    ),
  );

  String _returnUrl(TamaraReturnOutcome outcome) =>
      '${TamaraReturn.scheme}://${TamaraReturn.host}/tamara/${outcome.name}';

  void _close(BuildContext context, TamaraSdkOutcome outcome) {
    if (context.mounted) Navigator.of(context).pop(outcome);
  }
}
