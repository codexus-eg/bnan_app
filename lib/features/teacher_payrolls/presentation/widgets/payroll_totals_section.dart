import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_work_item_model.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/utils/payroll_amount_formatter.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/utils/payroll_calculator.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'payroll_info_row.dart';
import 'payroll_section.dart';

class PayrollTotalsSection extends StatelessWidget {
  const PayrollTotalsSection({
    super.key,
    required this.items,
    required this.rates,
    required this.bonus,
    required this.deduction,
    required this.currency,
    this.backendTotal,
  });
  final List<PayrollWorkItemModel> items;
  final Map<String, double> rates;
  final double bonus, deduction;
  final String currency;
  final double? backendTotal;
  @override
  Widget build(BuildContext context) {
    final total =
        backendTotal ?? PayrollCalculator.total(items, rates, bonus, deduction);
    return PayrollSection(
      title: S.of(context).payrollTotal,
      child: PayrollInfoRow(
        label: S.of(context).payrollNetTotal,
        value: '${PayrollAmountFormatter.format(total)} $currency',
      ),
    );
  }
}
