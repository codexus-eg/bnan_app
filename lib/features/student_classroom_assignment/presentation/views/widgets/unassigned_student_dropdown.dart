import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/features/student_classroom_assignment/data/models/unassigned_student_model.dart';
import 'package:bnan_app/features/student_classroom_assignment/presentation/manager/get_available_classrooms_cubit/get_available_classrooms_cubit.dart';
import 'package:bnan_app/features/student_classroom_assignment/presentation/manager/get_unassigned_students_cubit/get_unassigned_students_cubit.dart';
import 'package:bnan_app/features/student_classroom_assignment/presentation/manager/get_unassigned_students_cubit/get_unassigned_students_state.dart';
import 'package:bnan_app/features/student_classroom_assignment/presentation/views/widgets/student_picker_sheet.dart';
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
    return CustomTextField(
      key: ValueKey(value?.id ?? isLoading),
      label: S.of(context).student,
      hintText: _getHint(context, students, isLoading),
      isRequired: true,
      initialValue: isLoading ? null : value?.fullName,
      readOnly: true,
      suffixIcon: const Icon(Icons.keyboard_arrow_down),
      onTap: isLoading || students.isEmpty
          ? null
          : () => _pickStudent(context, students),
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

  Future<void> _pickStudent(
    BuildContext context,
    List<UnassignedStudentModel> students,
  ) async {
    final student = await showModalBottomSheet<UnassignedStudentModel>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => FractionallySizedBox(
        heightFactor: .7,
        child: StudentPickerSheet(students: students),
      ),
    );
    if (student == null || !context.mounted) return;
    onChanged(student);
    context.read<GetAvailableClassroomsCubit>().getAvailableClassrooms(
      student.id,
    );
  }
}
