import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/academic_selection_widgets/academic_curriculum_dropdown.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/academic_selection_widgets/academic_grade_dropdown.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/academic_selection_widgets/academic_package_dropdown.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/academic_selection_widgets/academic_subjects_section.dart';
import 'package:flutter/material.dart';

class AcademicSelectionStep extends StatelessWidget {
  const AcademicSelectionStep({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AcademicCurriculumDropdown(),
        SizedBox(height: 16),
        AcademicGradeDropdown(),
        SizedBox(height: 16),
        AcademicPackageDropdown(),
        AcademicSubjectsSection(),
      ],
    );
  }
}
