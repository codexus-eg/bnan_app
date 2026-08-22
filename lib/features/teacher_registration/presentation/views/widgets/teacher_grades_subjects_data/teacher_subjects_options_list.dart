import 'package:bnan_app/features/grades_management/data/models/grade_model.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_cubit.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_grades_subjects_data/teacher_subjects_options_list_view.dart';
import 'package:flutter/material.dart';

class TeacherSubjectsOptionsList extends StatelessWidget {
  const TeacherSubjectsOptionsList({
    super.key,
    required this.gradeId,
    required this.subjects,
  });

  final String gradeId;
  final List<GradeSubjectModel> subjects;

  @override
  Widget build(BuildContext context) {
    final teacherCubit = TeacherRegistrationCubit.get(context);

    return TeacherSubjectsOptionsListView(
      gradeId: gradeId,
      subjects: subjects,
      teacherCubit: teacherCubit,
      curriculumName: teacherCubit.selectedCurriculumName ?? '',
    );
  }
}
