import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/utils/payroll_date_formatter.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PayrollFilterSummary extends StatelessWidget {
  const PayrollFilterSummary({
    super.key,
    required this.from,
    required this.to,
    required this.status,
    required this.teacher,
    required this.onTap,
    this.curriculum = '',
  });
  final DateTime from, to;
  final String status, teacher, curriculum;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => CustomDetailsWidgetBackground(
    shadow: false,
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                S.of(context).payrollCurrentPeriod,
                style: StylesManager.styleBold14(context),
              ),
            ),
            _FilterAction(onTap: onTap),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          PayrollDateFormatter.range(context, from, to),
          style: StylesManager.styleRegular14(
            context,
          ).copyWith(color: ColorManager.mainColor14),
        ),
        const SizedBox(height: 8),
        Text(
          curriculum.isNotEmpty
              ? '$curriculum • $status • $teacher'
              : '$status • $teacher',
          style: StylesManager.styleRegular12(context),
        ),
      ],
    ),
  );
}

class _FilterAction extends StatelessWidget {
  const _FilterAction({required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.tune, size: 18, color: ColorManager.mainColor15),
          const SizedBox(width: 4),
          Text(
            S.of(context).payrollFilterAction,
            style: StylesManager.styleBold12(
              context,
            ).copyWith(color: ColorManager.mainColor15),
          ),
        ],
      ),
    ),
  );
}
