import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:flutter/material.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payout_profile_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'payout_profile_details.dart';
import 'payroll_section.dart';

class TeacherPayoutProfileCard extends StatelessWidget {
  const TeacherPayoutProfileCard({
    super.key,
    this.profile,
    required this.onOpen,
  });
  final PayoutProfileModel? profile;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context), p = profile;
    return PayrollSection(
      title: s.teacherPayrollPayoutDetails,
      child: Column(
        children: [
          if (p == null)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(s.payoutProfileEmpty),
            )
          else
            PayoutProfileDetails(profile: p),
          const SizedBox(height: 12),
          CustomAppButton(
            text: p == null ? s.payoutProfileAdd : s.payoutProfileEdit,
            onPressed: onOpen,
          ),
        ],
      ),
    );
  }
}
