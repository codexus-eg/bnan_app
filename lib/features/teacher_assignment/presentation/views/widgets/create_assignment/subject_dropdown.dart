import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/subject_details_model.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/create_assignment/create_assignment_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_classroom_subjects/get_classroom_subjects_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_classroom_subjects/get_classroom_subjects_state.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/views/widgets/create_assignment/dropdown_hint_style.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubjectDropdown extends StatelessWidget {
  const SubjectDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final createCubit = context.watch<CreateAssignmentCubit>();

    return BlocBuilder<GetClassroomSubjectsCubit, GetClassroomSubjectsState>(
      builder: (context, state) {
        final subjects = state is GetClassroomSubjectsSuccess
            ? state.classroomSubjects.subjects
            : <SubjectDetailsModel>[];
        final subjectIds = subjects.map((item) => item.id).toList();
        final selectedSubjectId =
            subjectIds.contains(createCubit.selectedSubjectId)
            ? createCubit.selectedSubjectId
            : null;
        final canSelect =
            createCubit.selectedClassroomId != null &&
            state is GetClassroomSubjectsSuccess &&
            subjects.isNotEmpty;

        return CustomDropdown(
          label: S.of(context).subject,
          isRequired: true,
          hint: _hint(
            context,
            state,
            subjects,
            createCubit.selectedClassroomId != null,
          ),
          hintStyle: dropdownHintStyle(context),
          value: selectedSubjectId,
          items: canSelect ? subjectIds : null,
          itemsLabels: {for (final item in subjects) item.id: item.name},
          onChanged: !canSelect
              ? null
              : (subjectId) {
                  createCubit.changeClassroomSubject(
                    subjectId: subjectId,
                    classroomSubjectId: null,
                  );
                },
        );
      },
    );
  }

  String _hint(
    BuildContext context,
    GetClassroomSubjectsState state,
    List<SubjectDetailsModel> subjects,
    bool hasClassroom,
  ) {
    if (!hasClassroom) return S.of(context).selectClassroomFirst;
    if (state is GetClassroomSubjectsLoading) return S.of(context).loading;
    if (state is GetClassroomSubjectsFailure) {
      return S.of(context).unexpectedError;
    }
    if (state is GetClassroomSubjectsSuccess && subjects.isEmpty) {
      return S.of(context).noSubjectsAvailableForClassroom;
    }
    return S.of(context).chooseSubject;
  }
}
