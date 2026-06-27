import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/subject_details_model.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/create_assignment/create_assignment_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_classroom_subjects/get_classroom_subjects_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_classroom_subjects/get_classroom_subjects_state.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_subject_details/get_subject_details_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_subject_details/get_subject_details_state.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/views/widgets/create_assignment/dropdown_hint_style.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubjectDropdown extends StatelessWidget {
  const SubjectDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final createCubit = context.watch<CreateAssignmentCubit>();

    return BlocListener<GetClassroomSubjectsCubit, GetClassroomSubjectsState>(
      listener: (context, state) {
        if (state is GetClassroomSubjectsSuccess) {
          context.read<GetSubjectDetailsCubit>().getSubjectsDetails(
                subjectIds: state.classroomSubjects.subjectIds,
              );
        }
      },
      child: BlocBuilder<GetSubjectDetailsCubit, GetSubjectDetailsState>(
        builder: (context, state) {
          final subjects = state is GetSubjectDetailsSuccess
              ? state.subjects
              : <SubjectDetailsModel>[];

          return CustomDropdown(
            label: S.of(context).subject,
            isRequired: true,
            hint: state is GetSubjectDetailsLoading
                ? S.of(context).loading
                : S.of(context).chooseSubject,
            hintStyle: dropdownHintStyle(context),
            value: createCubit.selectedSubjectId,
            items: subjects.map((item) => item.id).toList(),
            itemsLabels: {
              for (final item in subjects) item.id: item.name,
            },
            onChanged: state is GetSubjectDetailsLoading
                ? null
                : (subjectId) {
                    createCubit.changeClassroomSubject(
                      subjectId: subjectId,
                      classroomSubjectId: null,
                    );
                  },
          );
        },
      ),
    );
  }
}