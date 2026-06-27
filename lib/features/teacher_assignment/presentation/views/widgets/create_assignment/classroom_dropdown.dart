import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/teacher_class_room_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/teacher_classrooms_response_model.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/create_assignment/create_assignment_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_classroom_subjects/get_classroom_subjects_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_subject_details/get_subject_details_cubit.dart';
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
            : TeacherClassroomsResponseModel.placeholder().classrooms;

        return CustomDropdown(
          label: S.of(context).classRoom,
          isRequired: true,
          hint: S.of(context).chooseClassRoom,
          hintStyle: dropdownHintStyle(context),
          value: createCubit.selectedClassroomId,
          items: classrooms.map((item) => item.id).toList(),
          itemsLabels: {for (final item in classrooms) item.id: item.name},
          onChanged: (classroomId) {
            context.read<CreateAssignmentCubit>().changeClassroom(classroomId);
            if (classroomId != null) {
              context.read<GetClassroomSubjectsCubit>().getClassroomSubjects(
                classroomId: classroomId,
              );
            }
            context.read<GetSubjectDetailsCubit>().clear();
          },
        );
      },
    );
  }
}
