import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

Future<bool> showPaymentConfirmation(
  BuildContext context,
  String total,
  String currency,
) async =>
    await showDialog<bool>(
      context: context,
      builder: (_) => CustomAppDialog(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.of(context).payrollPaymentConfirmationTitle,
                style: StylesManager.styleBold18(context),
              ),
              const SizedBox(height: 12),
              Text(
                S.of(context).payrollPaymentConfirmationBody(total, currency),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              CustomAppButton(
                text: S.of(context).payrollConfirmPayment,
                onPressed: () => Navigator.pop(context, true),
              ),
              const SizedBox(height: 8),
              CustomAppButton(
                text: S.of(context).back,
                backgroundColor: Colors.white,
                textColor: Colors.black,
                onPressed: () => Navigator.pop(context, false),
              ),
            ],
          ),
        ),
      ),
    ) ??
    false;
