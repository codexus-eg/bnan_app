import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/features/student_classroom_assignment/data/models/available_classrooms_response_model.dart';
import 'package:bnan_app/features/student_classroom_assignment/data/models/unassigned_student_model.dart';
import 'package:bnan_app/features/student_classroom_assignment/presentation/manager/get_available_classrooms_cubit/get_available_classrooms_cubit.dart';
import 'package:bnan_app/features/student_classroom_assignment/presentation/manager/get_available_classrooms_cubit/get_available_classrooms_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AvailableClassroomDropdown extends StatelessWidget {
  const AvailableClassroomDropdown({
    super.key,
    required this.student,
    required this.value,
    required this.onChanged,
  });

  final UnassignedStudentModel? student;
  final AvailableClassroomModel? value;
  final ValueChanged<AvailableClassroomModel?> onChanged;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
        GetAvailableClassroomsCubit,
        GetAvailableClassroomsState>(
      builder: (context, state) {
        if (state is GetAvailableClassroomsFailure) {
          return Text(state.message);
        }

        final isLoading = state is GetAvailableClassroomsLoading;

        final classrooms = state is GetAvailableClassroomsSuccess
            ? state.response.classrooms
            : <AvailableClassroomModel>[];

        return AppSkeletonizer(
          isLoading: isLoading,
          child: _buildDropdown(
            context,
            classrooms: classrooms,
            isLoading: isLoading,
          ),
        );
      },
    );
  }

  Widget _buildDropdown(
    BuildContext context, {
    required List<AvailableClassroomModel> classrooms,
    required bool isLoading,
  }) {
    final displayClassrooms = isLoading
        ? const [
            AvailableClassroomModel(
              id: 'loading',
              name: 'Loading classroom',
            ),
          ]
        : classrooms;

    final items = displayClassrooms.map((e) => e.id).toList();

    final labels = {
      for (final classroom in displayClassrooms)
        classroom.id: classroom.name,
    };

    return CustomDropdown(
      label: S.of(context).classroom,
      hint: _getHint(
        context,
        classrooms: classrooms,
        isLoading: isLoading,
      ),
      isRequired: true,
      items: student == null ? const [] : items,
      itemsLabels: labels,
      value: isLoading ? null : value?.id,
      onChanged: student == null || isLoading
          ? null
          : (classroomId) {
              _onClassroomChanged(
                classroomId,
                classrooms,
              );
            },
    );
  }

  String _getHint(
    BuildContext context, {
    required List<AvailableClassroomModel> classrooms,
    required bool isLoading,
  }) {
    if (student == null) {
      return S.of(context).selectStudentFirst;
    }

    if (isLoading) {
      return S.of(context).loadingClassrooms;
    }

    if (classrooms.isEmpty) {
      return S.of(context).noAvailableClassrooms;
    }

    return S.of(context).selectClassroom;
  }

  void _onClassroomChanged(
    String? classroomId,
    List<AvailableClassroomModel> classrooms,
  ) {
    if (classroomId == null) {
      onChanged(null);
      return;
    }

    final classroom = classrooms.firstWhere(
      (classroom) => classroom.id == classroomId,
    );

    onChanged(classroom);
  }
}