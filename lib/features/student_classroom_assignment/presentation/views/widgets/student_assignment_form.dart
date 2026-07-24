import 'package:bnan_app/features/student_classroom_assignment/data/models/available_classrooms_response_model.dart';
import 'package:bnan_app/features/student_classroom_assignment/data/models/unassigned_student_model.dart';
import 'package:bnan_app/features/student_classroom_assignment/presentation/views/widgets/assign_student_button.dart';
import 'package:bnan_app/features/student_classroom_assignment/presentation/views/widgets/available_classroom_dropdown.dart';
import 'package:bnan_app/features/student_classroom_assignment/presentation/views/widgets/unassigned_student_dropdown.dart';
import 'package:flutter/material.dart';

class StudentAssignmentForm extends StatelessWidget {
  const StudentAssignmentForm({
    super.key,
    required this.selectedStudent,
    required this.selectedClassroom,
    required this.onStudentChanged,
    required this.onClassroomChanged,
  });

  final UnassignedStudentModel? selectedStudent;
  final AvailableClassroomModel? selectedClassroom;
  final ValueChanged<UnassignedStudentModel?> onStudentChanged;
  final ValueChanged<AvailableClassroomModel?> onClassroomChanged;
@override
Widget build(BuildContext context) {
  return Column(
    children: [
      UnassignedStudentDropdown(
        value: selectedStudent,
        onChanged: onStudentChanged,
      ),
      const SizedBox(height: 16),
      AvailableClassroomDropdown(
        student: selectedStudent,
        value: selectedClassroom,
        onChanged: onClassroomChanged,
      ),
      const SizedBox(height: 16),
      AssignStudentButton(
        student: selectedStudent,
        classroom: selectedClassroom,
      ),
    ],
  );
}
}