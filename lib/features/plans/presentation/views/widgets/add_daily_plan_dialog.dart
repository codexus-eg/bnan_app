import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/features/plans/presentation/policies/plans_access_policy.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_classroom_option.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/add_daily_plan_form.dart';
import 'package:flutter/material.dart';

class AddDailyPlanDialog extends StatelessWidget {
  const AddDailyPlanDialog({
    super.key,
    required this.policy,
    required this.classroom,
    required this.selectedWeek,
  });

  final PlansAccessPolicy policy;
  final PlanClassroomOption classroom;
  final int selectedWeek;

  @override
  Widget build(BuildContext context) {
    return CustomAppDialog(
      child: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * .82,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: AddDailyPlanForm(
              policy: policy,
              classroom: classroom,
              selectedWeek: selectedWeek,
            ),
          ),
        ),
      ),
    );
  }
}
