import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payout_profile_model.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/details/teacher_payroll_details_cubit.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/payout/teacher_payout_profile_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'payout_profile_details.dart';
import 'payout_profile_form.dart';
import 'payroll_section.dart';

class PayrollPayoutSection extends StatelessWidget {
  const PayrollPayoutSection({
    super.key,
    required this.teacherId,
    required this.profile,
  });
  final String teacherId;
  final PayoutProfileModel? profile;
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return PayrollSection(
      title: s.payrollPayoutDetails,
      child: Column(
        children: [
          if (profile == null)
            Text(s.payrollNoPayoutProfile)
          else
            PayoutProfileDetails(profile: profile!),
          const SizedBox(height: 12),
          CustomAppButton(
            text: profile == null
                ? s.payrollAddPayoutProfile
                : s.payrollEditPayoutProfile,
            onPressed: () => _open(context),
          ),
        ],
      ),
    );
  }

  Future<void> _open(BuildContext context) async {
    final cubit = context.read<TeacherPayoutProfileCubit>();
    final result = await showDialog<PayoutProfileModel>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: CustomAppDialog(
          child: PayoutProfileForm(teacherId: teacherId, initial: profile),
        ),
      ),
    );
    if (result != null && context.mounted) {
      context.read<TeacherPayrollDetailsCubit>().updateProfile(result);
    }
  }
}
