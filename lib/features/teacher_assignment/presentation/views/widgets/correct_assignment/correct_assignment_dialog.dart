import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:flutter/material.dart';

import 'correct_assignment_body.dart';

class CorrectAssignmentDialog extends StatelessWidget {
  const CorrectAssignmentDialog({
    super.key,
    required this.assignmentId,
    required this.assignmentTitle,
    required this.totalPoints,
  });

  final String assignmentId;
  final String assignmentTitle;
  final num totalPoints;

  @override
  Widget build(BuildContext context) {
    return CustomAppDialog(
      child: CorrectAssignmentBody(
        assignmentId: assignmentId,
        assignmentTitle: assignmentTitle,
        totalPoints: totalPoints,
      ),
    );
  }
}
