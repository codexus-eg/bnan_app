import 'package:bnan_app/features/teacher_assignment/presentation/widgets/correct_assignment/correct_assignment_dialog.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/widgets/create_assignment/create_assignment_dialog.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/widgets/submit_correction/submit_correction_dialog.dart';
import 'package:flutter/material.dart';

class TeacherAssignmentDialogs {
  const TeacherAssignmentDialogs._();

  static Future<void> showCreateAssignment(BuildContext context) {
    return showDialog(
      context: context,
      // barrierDismissible: false,
      builder: (_) => const CreateAssignmentDialog(),
    );
  }

  static Future<void> showCorrectAssignment(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const CorrectAssignmentDialog(),
    );
  }

  static Future<void> showSubmitCorrection(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const SubmitCorrectionDialog(),
    );
  }
}