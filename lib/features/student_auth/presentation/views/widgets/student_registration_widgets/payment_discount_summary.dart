import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/payments/data/models/payment_amount_summary.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PaymentDiscountSummary extends StatelessWidget {
  const PaymentDiscountSummary({
    super.key,
    required this.summary,
    this.highlightFinalAmount = false,
  });
  final PaymentAmountSummary summary;
  final bool highlightFinalAmount;

  @override
  Widget build(BuildContext context) {
    if (!summary.canDisplay) return const SizedBox.shrink();
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
          if (summary.originalAmount != null) ...[
            _row(context, s.originalAmount, summary.originalAmount!),
            const SizedBox(height: 8),
          ],
          if (summary.hasDiscount) ...[
            _row(
              context,
              s.discountAmount,
              summary.discountAmount!,
              suffix: summary.discount?.percentage == null
                  ? null
                  : '(${_format(summary.discount!.percentage!)}%)',
            ),
            Divider(height: highlightFinalAmount ? 24 : null),
          ],
          _row(context, s.finalAmount, summary.finalAmount!, strong: true),
        ],
      ),
    );
  }

  Widget _row(
    BuildContext context,
    String label,
    num value, {
    bool strong = false,
    String? suffix,
  }) {
    final style = strong
        ? highlightFinalAmount
              ? StylesManager.styleBold16(
                  context,
                ).copyWith(fontSize: 18, color: ColorManager.mainColor15)
              : StylesManager.styleBold16(context)
        : StylesManager.styleRegular14(context);
    final amount = _format(value);
    return Row(
      children: [
        Expanded(child: Text(label, style: style)),
        Text(
          '$amount ${summary.currency ?? ''}${suffix == null ? '' : ' $suffix'}',
          style: style,
          textDirection: highlightFinalAmount ? TextDirection.ltr : null,
          maxLines: highlightFinalAmount ? 1 : null,
        ),
      ],
    );
  }

  String _format(num value) =>
      value % 1 == 0 ? value.toInt().toString() : value.toString();
}
