import 'package:bnan_app/features/teacher_subject_assignment/data/teacher_subject_mock_data.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/views/widgets/teacher_assignment_card.dart';
import 'package:flutter/material.dart';

class TeacherSubjectAssignmentBody extends StatelessWidget {
  const TeacherSubjectAssignmentBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 24),
      itemCount: teacherSubjectAssignments.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return TeacherAssignmentCard(item: teacherSubjectAssignments[index]);
      },
    );
  }
}
