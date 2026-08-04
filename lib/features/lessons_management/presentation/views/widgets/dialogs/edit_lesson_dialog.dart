import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/dialogs/lesson_form.dart';
import 'package:bnan_app/features/lessons_management/data/models/lesson_ui_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class EditLessonDialog extends StatelessWidget {
  const EditLessonDialog({
    super.key,
    required this.classroom,
    required this.lesson,
    required this.blockedDays,
    required this.onSave,
    required this.onDelete,
  });

  final LessonClassroomUiModel classroom;
  final LessonUiModel lesson;
  final Set<String> blockedDays;
  final Future<bool> Function({required String day, required String startTime})
  onSave;
  final Future<bool> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return CustomAppDialog(
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomDialogHeader(title: S.of(context).editScheduleEntry),
            const SizedBox(height: 16),
            LessonForm(
              classroom: classroom,
              initialDay: lesson.day,
              initialTime: lesson.startTime,
              blockedDays: blockedDays,
              actionText: S.of(context).saveChanges,
              onSave: onSave,
              onDelete: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
