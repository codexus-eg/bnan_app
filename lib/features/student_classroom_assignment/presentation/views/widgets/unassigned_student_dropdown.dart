import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/features/student_classroom_assignment/data/models/unassigned_student_model.dart';
import 'package:bnan_app/features/student_classroom_assignment/presentation/manager/get_available_classrooms_cubit/get_available_classrooms_cubit.dart';
import 'package:bnan_app/features/student_classroom_assignment/presentation/manager/get_unassigned_students_cubit/get_unassigned_students_cubit.dart';
import 'package:bnan_app/features/student_classroom_assignment/presentation/manager/get_unassigned_students_cubit/get_unassigned_students_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnassignedStudentDropdown extends StatelessWidget {
  const UnassignedStudentDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final UnassignedStudentModel? value;
  final ValueChanged<UnassignedStudentModel?> onChanged;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetUnassignedStudentsCubit, GetUnassignedStudentsState>(
      builder: (context, state) {
        if (state is GetUnassignedStudentsFailure) {
          return Text(state.message);
        }

        final isLoading = state is GetUnassignedStudentsLoading;

        final students = state is GetUnassignedStudentsSuccess
            ? state.students
            : <UnassignedStudentModel>[];

        return AppSkeletonizer(
          isLoading: isLoading,
          child: _buildDropdown(
            context,
            students: students,
            isLoading: isLoading,
          ),
        );
      },
    );
  }

  Widget _buildDropdown(
    BuildContext context, {
    required List<UnassignedStudentModel> students,
    required bool isLoading,
  }) {
    final displayStudents = isLoading
        ? const [
            UnassignedStudentModel(id: 'loading', fullName: 'Loading student'),
          ]
        : students;

    final items = displayStudents.map((student) => student.id).toList();

    final labels = {
      for (final student in displayStudents) student.id: student.fullName,
    };

    return CustomDropdown(
      label: S.of(context).student,
      hint: _getHint(context, students, isLoading),
      isRequired: true,
      items: items,
      itemsLabels: labels,
      value: isLoading ? null : value?.id,
      onChanged: isLoading
          ? null
          : (studentId) => _onStudentChanged(context, studentId, students),
    );
  }

  String _getHint(
    BuildContext context,
    List<UnassignedStudentModel> students,
    bool isLoading,
  ) {
    if (isLoading) {
      return S.of(context).loadingStudents;
    }

    if (students.isEmpty) {
      return S.of(context).noUnassignedStudents;
    }

    return S.of(context).selectStudent;
  }

  void _onStudentChanged(
    BuildContext context,
    String? studentId,
    List<UnassignedStudentModel> students,
  ) {
    if (studentId == null) {
      onChanged(null);
      context.read<GetAvailableClassroomsCubit>().reset();
      return;
    }

    final student = students.firstWhere((student) => student.id == studentId);

    onChanged(student);

    context.read<GetAvailableClassroomsCubit>().getAvailableClassrooms(
      student.id,
    );
  }
}
