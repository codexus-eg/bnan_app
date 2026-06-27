import 'package:bnan_app/core/helper/app_dialogs.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/views/widgets/correct_assignment/correct_assignment_dialog.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/views/widgets/create_assignment/create_assignment_dialog.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/views/widgets/submit_correction/submit_correction_dialog.dart';
import 'package:flutter/material.dart';

class TeacherAssignmentDialogs {
  const TeacherAssignmentDialogs._();

  static Future<bool?> showCreateAssignment(BuildContext context) {
    return AppDialogs.show<bool>(
      context: context,
      child: const CreateAssignmentDialog(),
    );
  }

  static Future<void> showCorrectAssignment(BuildContext context) {
    return AppDialogs.show(
      context: context,
      child: const CorrectAssignmentDialog(),
    );
  }

  static Future<void> showSubmitCorrection(BuildContext context) {
    return AppDialogs.show(
      context: context,
      child: const SubmitCorrectionDialog(),
    );
  }
}
