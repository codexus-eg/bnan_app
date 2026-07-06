import 'package:bnan_app/features/student_auth/data/models/grade_model.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_cubit.dart';
import 'package:bnan_app/core/shared_widget/custom_option.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_grades_subjects_data/teacher_subjects_options_list.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_shared_widgets/teacher_yes_no_question/teacher_question_title.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherGradesOptionsListView extends StatelessWidget {
  const TeacherGradesOptionsListView({
    super.key,
    required this.grades,
    required this.teacherCubit,
    required this.onGradeTap,
  });

  final List<GradeModel> grades;
  final TeacherRegistrationCubit teacherCubit;
  final void Function(GradeModel grade) onGradeTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TeacherQuestionTitle(
          question: S
              .of(context)
              .pleaseChooseCurriculumGrades(
                teacherCubit.selectedCurriculumName ?? '',
              ),
          isRequired: true,
        ),
        const SizedBox(height: 12),
        Column(
          children: List.generate(grades.length, (index) {
            final grade = grades[index];
            final isActiveGrade = teacherCubit.activeGradeId == grade.id;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  CustomOption(
                    title: grade.name,
                    isSelected: teacherCubit.isGradeSelected(grade.id),
                    onTap: () => onGradeTap(grade),
                  ),
                  if (isActiveGrade) ...[
                    const SizedBox(height: 12),
                    TeacherSubjectsOptionsList(
                      gradeId: grade.id,
                      subjects: grade.subjects,
                    ),
                  ],
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
