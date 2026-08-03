import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/views/widgets/dialogs/delete_assignment_dialog_actions.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/views/widgets/dialogs/teacher_assignment_dialog_error.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class DeleteAssignmentDialogContent extends StatelessWidget {
  const DeleteAssignmentDialogContent({
    super.key,
    required this.classroomName,
    required this.loading,
    required this.errorMessage,
    required this.onConfirm,
  });

  final String classroomName;
  final bool loading;
  final String? errorMessage;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return CustomAppDialog(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomDialogHeader(title: s.cancelAssignment),
            const SizedBox(height: 16),
            Text(
              s.cancelTeacherAssignmentQuestion(classroomName),
              textAlign: TextAlign.center,
              style: StylesManager.styleBold14(
                context,
              ).copyWith(color: ColorManager.mainColor14),
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: 12),
              TeacherAssignmentDialogError(message: errorMessage!),
            ],
            const SizedBox(height: 16),
            DeleteAssignmentDialogActions(
              loading: loading,
              onConfirm: onConfirm,
            ),
          ],
        ),
      ),
    );
  }
}
