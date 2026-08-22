import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/dialogs/lesson_form.dart';
import 'package:bnan_app/features/lessons_management/data/models/lesson_ui_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AddLessonDialog extends StatelessWidget {
  const AddLessonDialog({
    super.key,
    required this.classroom,
    required this.initialDay,
    required this.blockedDays,
    required this.onSave,
  });

  final LessonClassroomUiModel classroom;
  final String initialDay;
  final Set<String> blockedDays;
  final Future<bool> Function({
    required String day,
    required String startTime,
    required String endTime,
  })
  onSave;

  @override
  Widget build(BuildContext context) {
    return CustomAppDialog(
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomDialogHeader(title: S.of(context).addLesson),
            const SizedBox(height: 16),
            LessonForm(
              classroom: classroom,
              initialDay: initialDay,
              blockedDays: blockedDays,
              actionText: S.of(context).addScheduleEntry,
              onSave: onSave,
            ),
          ],
        ),
      ),
    );
  }
}
