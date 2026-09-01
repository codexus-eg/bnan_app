import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_work_item_model.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/utils/payroll_amount_formatter.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/utils/payroll_calculator.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'payroll_info_row.dart';
import 'payroll_section.dart';

class PayrollWorkItemCard extends StatelessWidget {
  const PayrollWorkItemCard({
    super.key,
    required this.item,
    required this.teacherId,
    required this.from,
    required this.to,
    required this.controller,
    required this.currency,
    required this.readOnly,
    this.onChanged,
  });
  final PayrollWorkItemModel item;
  final String teacherId, from, to, currency;
  final TextEditingController controller;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final rate = double.tryParse(controller.text) ?? item.rate;
    final amount = readOnly ? item.amount : PayrollCalculator.item(item, rate);
    return PayrollSection(
      title: '${item.curriculumName} - ${item.gradeName}',
      child: Column(
        children: [
          PayrollInfoRow(
            label: s.payrollSystem,
            value: item.system == 'gulf' ? s.payrollGulf : s.payrollEgyptian,
          ),
          PayrollInfoRow(label: s.payrollDuration, value: item.displayDuration),
          PayrollInfoRow(
            label: s.payrollSessionsCount,
            value: '${item.sessionsCount}',
          ),
          if (!readOnly)
            CustomTextField(
              label: s.payrollHourlyRate,
              controller: controller,
              onChanged: onChanged,
              isRequired: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              validator: _rateValidator,
            ),
          PayrollInfoRow(
            label: s.payrollAmount,
            value: '${PayrollAmountFormatter.format(amount)} $currency',
          ),
          CustomAppButton(
            text: s.payrollReviewSessions,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            onPressed: () => MyNavigator.goTo(
              context,
              Uri(
                path: Routes.teacherPayrollSessionsPath(
                  teacherId,
                  item.curriculumId,
                ),
                queryParameters: {
                  'from': from,
                  'to': to,
                  'system': item.system,
                },
              ).toString(),
            ),
          ),
        ],
      ),
    );
  }

  String? _rateValidator(String? value) {
    if (value == null || value.trim().isEmpty) return S.current.fieldRequired;
    final number = double.tryParse(value);
    return number == null || number < 0 ? S.current.payrollInvalidAmount : null;
  }
}
