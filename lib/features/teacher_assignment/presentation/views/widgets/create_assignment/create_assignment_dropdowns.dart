import 'package:bnan_app/features/teacher_assignment/presentation/views/widgets/create_assignment/classroom_dropdown.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/views/widgets/create_assignment/subject_dropdown.dart';
import 'package:flutter/material.dart';

class CreateAssignmentDropdowns extends StatelessWidget {
  const CreateAssignmentDropdowns({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // CurriculumDropdown(),
        // SizedBox(height: 16),
        // GradeDropdown(),
        // SizedBox(height: 16),
        ClassroomDropdown(),
        SizedBox(height: 16),
        SubjectDropdown(),
      ],
    );
  }
}
