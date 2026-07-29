import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/dialogs/lesson_form.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class EditLessonDialog extends StatelessWidget {
  const EditLessonDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAppDialog(
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomDialogHeader(title: S.of(context).editLesson),
            const SizedBox(height: 16),
            const LessonForm(),
          ],
        ),
      ),
    );
  }
}
