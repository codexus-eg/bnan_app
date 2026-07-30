import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/upload_study_plan_form.dart';
import 'package:flutter/material.dart';

class UploadStudyPlanDialog extends StatelessWidget {
  const UploadStudyPlanDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAppDialog(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: UploadStudyPlanForm(),
        ),
      ),
    );
  }
}
