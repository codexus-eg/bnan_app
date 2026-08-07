import 'package:bnan_app/features/student_subjects/data/models/student_subject_model.dart';
import 'package:bnan_app/features/student_subjects/presentation/views/widgets/student_subject_card.dart';
import 'package:flutter/material.dart';

class StudentSubjectsList extends StatelessWidget {
  const StudentSubjectsList({super.key, required this.subjects});

  final List<StudentSubjectModel> subjects;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsetsDirectional.only(bottom: 24),
      itemCount: subjects.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, index) => StudentSubjectCard(
        subject: subjects[index],
      ),
    );
  }
}
