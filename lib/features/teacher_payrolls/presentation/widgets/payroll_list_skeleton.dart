import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_list_item_model.dart';
import 'package:flutter/material.dart';
import 'payroll_list_card.dart';

const _mockPayroll = PayrollListItemModel(
  teacherId: '',
  fullName: 'Teacher name placeholder',
  email: 'teacher@example.com',
  status: 'unprepared',
  payrollId: '',
  gulfDuration: '12 h 30 m',
  egyptianSessions: 10,
  curriculumsCount: 3,
  excludedSessions: 0,
);

class PayrollListSkeleton extends StatelessWidget {
  const PayrollListSkeleton({super.key});
  @override
  Widget build(BuildContext context) => ListView.separated(
    itemCount: 3,
    separatorBuilder: (_, _) => const SizedBox(height: 12),
    itemBuilder: (_, _) => const PayrollListCard(
      item: _mockPayroll,
      from: '',
      to: '',
      enabled: false,
    ),
  );
}
