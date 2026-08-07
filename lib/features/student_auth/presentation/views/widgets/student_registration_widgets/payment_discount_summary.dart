import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/payments/data/models/payment_amount_summary.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PaymentDiscountSummary extends StatelessWidget {
  const PaymentDiscountSummary({super.key, required this.summary});
  final PaymentAmountSummary summary;

  @override
  Widget build(BuildContext context) {
    if (!summary.hasDiscount) return const SizedBox.shrink();
    final s = S.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorManager.white,
        border: Border.all(color: ColorManager.borderColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _row(context, s.originalAmount, summary.originalAmount),
          const SizedBox(height: 8),
          _row(
            context,
            s.discountAmount,
            summary.discountAmount,
            discount: true,
          ),
          const Divider(),
          _row(context, s.finalAmount, summary.finalAmount, strong: true),
        ],
      ),
    );
  }

  Widget _row(
    BuildContext context,
    String label,
    num? value, {
    bool discount = false,
    bool strong = false,
  }) {
    final style = strong
        ? StylesManager.styleBold16(context)
        : StylesManager.styleRegular14(context);
    final amount = value == null ? '-' : _format(value);
    final prefix = discount && value != null && !value.isNegative ? '-' : '';
    return Row(
      children: [
        Expanded(child: Text(label, style: style)),
        Text('$prefix$amount ${summary.currency ?? ''}', style: style),
      ],
    );
  }

  String _format(num value) =>
      value % 1 == 0 ? value.toInt().toString() : value.toString();
}
