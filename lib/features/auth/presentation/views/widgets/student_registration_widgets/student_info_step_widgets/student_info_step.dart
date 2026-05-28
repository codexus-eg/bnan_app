import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/shared_widgets/custom_auth_text_field.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/student_registration_widgets/custom_auth_dropdown.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/student_registration_widgets/student_info_step_widgets/schedule_fields.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/student_registration_widgets/student_info_step_widgets/student_notes_widget.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/student_registration_widgets/student_info_step_widgets/subjects_list.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class StudentInfoStep extends StatefulWidget {
  const StudentInfoStep({super.key});

  @override
  State<StudentInfoStep> createState() => _StudentInfoStepState();
}

class _StudentInfoStepState extends State<StudentInfoStep> {
  String? selectedGrade;

  @override
  Widget build(BuildContext context) {
    final grades = ['الصف الأول', 'الصف الثاني', 'الصف الثالث'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          S.of(context).studentInfo,
          style: StylesManager.styleBold16(
            context,
          ).copyWith(color: ColorManager.mainColor15),
        ),
        const SizedBox(height: 16),
        CustomAuthTextField(
          label: S.of(context).studentName,
          hintText: '',
          isRequired: true,
        ),
        const SizedBox(height: 16),
        CustomAuthDropdown(
          label: S.of(context).curriculum,
          value: selectedGrade,
          hint: S.of(context).selectGrade,
          items: grades,
          isRequired: true,
          onChanged: (value) {
            if (value == null) return;
            setState(() => selectedGrade = value);
          },
        ),
        const SizedBox(height: 16),
        const SubjectsList(),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomAuthTextField(
                label: S.of(context).studentUsername,
                hintText: '',
                isRequired: true,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: CustomAuthTextField(
                label: S.of(context).studentPasswordField,
                hintText: S.of(context).passwordHint,
                isRequired: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const StudentNotesWidget(),
                const SizedBox(height: 16),

        const ScheduleFields(),
      ],
    );
  }
}
