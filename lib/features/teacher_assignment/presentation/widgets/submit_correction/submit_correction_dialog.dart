import 'package:bnan_app/features/teacher_assignment/presentation/widgets/dialogs/custom_app_dialog.dart';
import 'package:flutter/material.dart';

import 'submit_correction_form.dart';

class SubmitCorrectionDialog extends StatelessWidget {
  const SubmitCorrectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAppDialog(
      child: SubmitCorrectionForm(),
    );
  }
}