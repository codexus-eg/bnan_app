import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/teacher_class_room_model.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/create_assignment/create_assignment_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_assigned_subjects/get_teacher_assigned_subjects_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_classrooms/get_teacher_classrooms_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_classrooms/get_teacher_classrooms_state.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/views/widgets/create_assignment/dropdown_hint_style.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassroomDropdown extends StatelessWidget {
  const ClassroomDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final createCubit = context.watch<CreateAssignmentCubit>();

    return BlocBuilder<GetTeacherClassroomsCubit, GetTeacherClassroomsState>(
      builder: (context, state) {
        final List<TeacherClassroomModel> classrooms =
            state is GetTeacherClassroomsSuccess
            ? state.classrooms.classrooms
            : const [];
        final classroomIds = classrooms.map((item) => item.id).toList();
        final selectedClassroomId =
            classroomIds.contains(createCubit.selectedClassroomId)
            ? createCubit.selectedClassroomId
            : null;

        return CustomDropdown(
          label: S.of(context).classRoom,
          isRequired: true,
          hint: _hint(context, state, classrooms),
          hintStyle: dropdownHintStyle(context),
          value: selectedClassroomId,
          items: state is GetTeacherClassroomsSuccess ? classroomIds : null,
          itemsLabels: {for (final item in classrooms) item.id: item.name},
          onChanged: (classroomId) {
            createCubit.changeClassroom(classroomId);

            if (classroomId != null) {
              context
                  .read<GetTeacherAssignedSubjectsCubit>()
                  .getTeacherAssignedSubjects(classroomId: classroomId);
            } else {
              context.read<GetTeacherAssignedSubjectsCubit>().clear();
            }
          },
        );
      },
    );
  }

  String _hint(
    BuildContext context,
    GetTeacherClassroomsState state,
    List<TeacherClassroomModel> classrooms,
  ) {
    if (state is GetTeacherClassroomsLoading) return S.of(context).loading;
    if (state is GetTeacherClassroomsFailure) {
      return S.of(context).unexpectedError;
    }
    if (state is GetTeacherClassroomsSuccess && classrooms.isEmpty) {
      return S.of(context).noClassroomsAvailable;
    }
    return S.of(context).chooseClassRoom;
  }
}
