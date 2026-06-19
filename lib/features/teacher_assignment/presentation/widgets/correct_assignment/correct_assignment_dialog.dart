import 'package:bnan_app/features/teacher_assignment/presentation/widgets/dialogs/custom_app_dialog.dart';
import 'package:flutter/material.dart';

import 'correct_assignment_body.dart';

class CorrectAssignmentDialog extends StatelessWidget {
  const CorrectAssignmentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomAppDialog(
      child: CorrectAssignmentBody(),
    );
  }
}