import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/dialogs/lesson_classroom_dropdown.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/dialogs/lesson_date_field.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/dialogs/lesson_subject_dropdown.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/dialogs/lesson_time_fields.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class LessonForm extends StatelessWidget {
  const LessonForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const LessonClassroomDropdown(),
        const SizedBox(height: 16),
        const LessonSubjectDropdown(),
        const SizedBox(height: 16),
        const LessonDateField(),
        const SizedBox(height: 16),
        const LessonTimeFields(),
        const SizedBox(height: 16),
        CustomAppButton(text: S.of(context).save),
      ],
    );
  }
}
