import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/features/student_classroom_assignment/data/models/available_classrooms_response_model.dart';
import 'package:bnan_app/features/student_classroom_assignment/data/models/unassigned_student_model.dart';
import 'package:bnan_app/features/student_classroom_assignment/presentation/manager/assign_student_cubit/assign_student_cubit.dart';
import 'package:bnan_app/features/student_classroom_assignment/presentation/manager/assign_student_cubit/assign_student_state.dart';
import 'package:bnan_app/features/student_classroom_assignment/presentation/manager/get_available_classrooms_cubit/get_available_classrooms_cubit.dart';
import 'package:bnan_app/features/student_classroom_assignment/presentation/manager/get_unassigned_students_cubit/get_unassigned_students_cubit.dart';
import 'package:bnan_app/features/student_classroom_assignment/presentation/views/widgets/student_assignment_form.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssignStudentCubit, AssignStudentState>(
      listener: _assignStudentListener,
      child: StudentAssignmentForm(
        selectedStudent: selectedStudent,
        selectedClassroom: selectedClassroom,
        onStudentChanged: _onStudentChanged,
        onClassroomChanged: _onClassroomChanged,
      ),
    );
  }

  void _onStudentChanged(UnassignedStudentModel? student) {
    setState(() {
      selectedStudent = student;
      selectedClassroom = null;
    });
  }

  void _onClassroomChanged(
    AvailableClassroomModel? classroom,
  ) {
    setState(() {
      selectedClassroom = classroom;
    });
  }

  void _assignStudentListener(
    BuildContext context,
    AssignStudentState state,
  ) {
    if (state is AssignStudentFailure) {
      showCustomSnackBar(
        context,
        state.message,
        false,
      );
      return;
    }

    if (state is AssignStudentSuccess) {
      _resetForm();

      context
          .read<GetUnassignedStudentsCubit>()
          .getUnassignedStudents();

      showCustomSnackBar(
        context,
        S.of(context).studentAssignedSuccessfully,
        true,
      );
    }
  }

  void _resetForm() {
    setState(() {
      selectedStudent = null;
      selectedClassroom = null;
    });

    context.read<GetAvailableClassroomsCubit>().reset();
    context.read<AssignStudentCubit>().reset();
  }
}