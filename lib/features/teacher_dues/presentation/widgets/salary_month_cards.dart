import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/features/teacher_dues/data/enums/salary_status_type.dart';
import 'package:bnan_app/features/teacher_dues/presentation/widgets/salary_month_card.dart';
import 'package:flutter/material.dart';

class SalaryMonthCards extends StatelessWidget {
  const SalaryMonthCards({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDetailsWidgetBackground(
      shadow: false,
      child: Column(
        children: const [
          SalaryMonthCard(
            month: 'يناير 2026',
            statusText: 'تم الدفع',
            statusType: SalaryStatusType.paid,
          ),
          SizedBox(height: 16),
          SalaryMonthCard(
            month: 'فبراير 2026',
            statusText: 'قيد المعالجة',
            statusType: SalaryStatusType.processing,
          ),
          SizedBox(height: 16),
          SalaryMonthCard(
            month: 'مارس 2026',
            statusText: 'قيد الانتظار',
            statusType: SalaryStatusType.waiting,
          ),
        ],
      ),
    );
  }
}
