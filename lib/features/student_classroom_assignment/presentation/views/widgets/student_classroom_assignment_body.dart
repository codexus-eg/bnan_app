import 'package:bnan_app/features/student_classroom_assignment/data/models/available_classrooms_response_model.dart';
import 'package:bnan_app/features/student_classroom_assignment/data/models/unassigned_student_model.dart';
import 'package:bnan_app/features/student_classroom_assignment/presentation/views/widgets/student_assignment_form.dart';
import 'package:flutter/material.dart';

class StudentClassroomAssignmentBody extends StatefulWidget {
  const StudentClassroomAssignmentBody({super.key});

  @override
  State<StudentClassroomAssignmentBody> createState() =>
      _StudentClassroomAssignmentBodyState();
}

class _StudentClassroomAssignmentBodyState
    extends State<StudentClassroomAssignmentBody> {
  UnassignedStudentModel? selectedStudent;
  AvailableClassroomModel? selectedClassroom;

  void onStudentChanged(UnassignedStudentModel? student) {
    setState(() {
      selectedStudent = student;
      selectedClassroom = null;
    });
  }

  void onClassroomChanged(AvailableClassroomModel? classroom) {
    setState(() {
      selectedClassroom = classroom;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 16,end: 16,bottom: 16),
      child: StudentAssignmentForm(
        selectedStudent: selectedStudent,
        selectedClassroom: selectedClassroom,
        onStudentChanged: onStudentChanged,
        onClassroomChanged: onClassroomChanged,
      ),
    );
  }
}