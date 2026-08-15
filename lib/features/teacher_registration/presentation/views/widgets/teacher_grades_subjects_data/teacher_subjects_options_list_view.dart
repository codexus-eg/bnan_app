import 'package:bnan_app/features/grades_management/data/models/grade_model.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_cubit.dart';
import 'package:bnan_app/core/shared_widget/custom_option.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_shared_widgets/teacher_yes_no_question/teacher_question_title.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherSubjectsOptionsListView extends StatelessWidget {
  const TeacherSubjectsOptionsListView({
    super.key,
    required this.gradeId,
    required this.subjects,
    required this.teacherCubit,
    required this.curriculumName,
  });
  final String gradeId;
  final List<GradeSubjectModel> subjects;
  final TeacherRegistrationCubit teacherCubit;
  final String curriculumName;

  @override
  Widget build(BuildContext context) {
    if (subjects.isEmpty) {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TeacherQuestionTitle(
          question: S
              .of(context)
              .pleaseChooseCurriculumSubjects(curriculumName),
          isRequired: true,
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: subjects.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 12,
            childAspectRatio: 3.6,
          ),
          itemBuilder: (context, index) {
            final subject = subjects[index];
            return CustomOption(
              title: subject.name,
              isSelected: teacherCubit.isSubjectSelected(
                gradeId: gradeId,
                subjectId: subject.id,
              ),
              onTap: () {
                teacherCubit.toggleTeachingSubject(
                  gradeId: gradeId,
                  subjectId: subject.id,
                );
              },
            );
          },
        ),
      ],
    );
  }
}
