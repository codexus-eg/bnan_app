import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'payroll_section.dart';

class PayrollAdjustmentsSection extends StatelessWidget {
  const PayrollAdjustmentsSection({
    super.key,
    required this.bonus,
    required this.deduction,
    required this.adjustmentNote,
    required this.notes,
    this.onChanged,
  });
  final TextEditingController bonus, deduction, adjustmentNote, notes;
  final ValueChanged<String>? onChanged;
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final input = [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))];
    return PayrollSection(
      title: s.payrollAdjustments,
      child: Column(
        children: [
          CustomTextField(
            label: s.payrollBonus,
            controller: bonus,
            onChanged: onChanged,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: input,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            label: s.payrollDeduction,
            controller: deduction,
            onChanged: onChanged,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: input,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            label: s.payrollAdjustmentNote,
            controller: adjustmentNote,
          ),
          const SizedBox(height: 12),
          CustomTextField(label: s.notes, controller: notes, maxLine: 3),
        ],
      ),
    );
  }
}
