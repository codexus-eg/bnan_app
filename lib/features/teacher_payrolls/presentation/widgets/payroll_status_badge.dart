import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PayrollStatusBadge extends StatelessWidget {
  const PayrollStatusBadge({
    super.key,
    required this.status,
    this.displayLabel,
  });
  final String status;
  final String? displayLabel;
  @override
  Widget build(BuildContext context) {
    final (label, background, foreground) = switch (status) {
      'draft' => (
        S.of(context).payrollDraft,
        ColorManager.orangeFFE,
        ColorManager.orangeED,
      ),
      'sent' => (
        S.of(context).payrollSent,
        ColorManager.blueE3,
        ColorManager.mainColor15,
      ),
      'payment_pending' => (
        S.of(context).payrollPaymentPending,
        ColorManager.orangeFFE,
        ColorManager.orangeED,
      ),
      'paid' => (
        S.of(context).payrollPaid,
        ColorManager.greenE9,
        ColorManager.green23,
      ),
      'cancelled' => (
        S.of(context).payrollCancelled,
        ColorManager.redFFF,
        ColorManager.redD8,
      ),
      _ => (
        S.of(context).payrollUnprepared,
        ColorManager.greyE8E9,
        ColorManager.grey6F6F,
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        displayLabel ?? label,
        style: StylesManager.styleBold12(context).copyWith(color: foreground),
      ),
    );
  }
}
