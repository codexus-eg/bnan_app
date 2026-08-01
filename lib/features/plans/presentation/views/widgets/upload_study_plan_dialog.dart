import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/features/plans/presentation/manager/plans_actions/plans_actions_cubit.dart';
import 'package:bnan_app/features/plans/presentation/manager/plans_actions/plans_actions_state.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_classroom_option.dart';
import 'package:bnan_app/features/plans/presentation/policies/plans_access_policy.dart';
import 'package:bnan_app/features/plans/presentation/utils/plans_file_picker.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/upload_study_plan_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UploadStudyPlanDialog extends StatelessWidget {
  const UploadStudyPlanDialog({
    super.key,
    required this.policy,
    required this.classrooms,
    this.initialClassroom,
    this.filePicker,
  });

  final PlansAccessPolicy policy;
  final List<PlanClassroomOption> classrooms;
  final PlanClassroomOption? initialClassroom;
  final PlansFilePicker? filePicker;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PlansActionsCubit, PlansActionsState, bool>(
      selector: (state) => state is UploadTermPlanLoading,
      builder: (context, isLoading) => PopScope(
        canPop: !isLoading,
        child: CustomAppDialog(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: UploadStudyPlanForm(
                policy: policy,
                classrooms: classrooms,
                initialClassroom: initialClassroom,
                filePicker: filePicker,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
