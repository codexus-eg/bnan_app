import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/attendance/presentation/manager/attendance_cubit.dart';
import 'package:bnan_app/features/attendance/presentation/manager/attendance_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceFilters extends StatelessWidget {
  const AttendanceFilters({super.key, required this.state});
  final AttendanceState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AttendanceCubit>();
    final classrooms = state.classrooms
        .where((item) => item.grade.id == state.selectedGradeId)
        .toList();
    return Column(
      children: [
        CustomDropdown(
          label: S.of(context).selectGrade,
          hint: S.of(context).selectGrade,
          value: state.selectedGradeId,
          items: state.grades.map((item) => item.id).toList(),
          itemsLabels: {for (final item in state.grades) item.id: item.name},
          backgroundColor: ColorManager.white,
          onChanged: cubit.selectGrade,
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomDropdown(
                label: S.of(context).classRoom,
                hint: S.of(context).selectClassroom,
                value: state.selectedClassroomId,
                items: classrooms.map((item) => item.id).toList(),
                itemsLabels: {
                  for (final item in classrooms) item.id: item.name,
                },
                onChanged: state.selectedGradeId == null
                    ? null
                    : cubit.selectClassroom,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomDropdown(
                label: S.of(context).lessons,
                hint: S.of(context).selectLesson,
                value: state.selectedSessionId,
                items: state.sessions.map((item) => item.id).toList(),
                itemsLabels: {
                  for (final item in state.sessions)
                    item.id: item.name.isEmpty ? item.id : item.name,
                },
                onChanged: state.selectedClassroomId == null
                    ? null
                    : cubit.selectSession,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
