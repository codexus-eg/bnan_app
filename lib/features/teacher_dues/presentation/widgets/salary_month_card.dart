import 'package:bnan_app/core/shared_widget/custom_second_background.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_dues/data/enums/salary_status_type.dart';
import 'package:flutter/material.dart';
import 'salary_details_row.dart';
import 'salary_status_badge.dart';
import 'salary_total_section.dart';

class SalaryMonthCard extends StatelessWidget {
  const SalaryMonthCard({
    super.key,
    required this.month,
    required this.statusText,
    required this.statusType,
    this.paidAt,
  });

  final String month;
  final String statusText;
  final SalaryStatusType statusType;
  final String? paidAt;

  @override
  Widget build(BuildContext context) {
    return CustomSecondBackground(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                month,
                style: StylesManager.styleBold16(
                  context,
                ).copyWith(color: ColorManager.mainColor14),
              ),
              const Spacer(),
              SalaryStatusBadge(text: statusText, type: statusType),
            ],
          ),
          const SizedBox(height: 4),
          const SalaryDetailsRow(title: '48 حصة', value: ''),
          const SalaryDetailsRow(title: 'إجمالي الحصص', value: '2400 ج.م'),
          SalaryDetailsRow(
            title: 'مكافآت',
            value: '200 ج.م',
            icon: ImageManager.arrowGrowthIcon,
            valueColor: ColorManager.green23,
          ),
          SalaryDetailsRow(
            title: 'خصومات',
            value: '100- ج.م',
            icon: ImageManager.arrowGrowthDownIcon,
            valueColor: ColorManager.red,
          ),
          const Divider(height: 14, color: ColorManager.greyE8E9),
          SalaryTotalSection(total: '2600 ج.م', paidAt: paidAt),
          if (SalaryStatusType.paid == statusType) ...[
            const SalaryDetailsRow(
              title: 'تم الدفع في: 2026-02-05',
              value: '2400 ج.م',
            ),
          ],
        ],
      ),
    );
  }
}
