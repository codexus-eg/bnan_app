import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/teacher_assigned_subject_model.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/create_assignment/create_assignment_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_assigned_subjects/get_teacher_assigned_subjects_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_assigned_subjects/get_teacher_assigned_subjects_state.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/views/widgets/create_assignment/dropdown_hint_style.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubjectDropdown extends StatelessWidget {
  const SubjectDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final createCubit = context.watch<CreateAssignmentCubit>();

    return BlocBuilder<
      GetTeacherAssignedSubjectsCubit,
      GetTeacherAssignedSubjectsState
    >(
      builder: (context, state) {
        final subjects = state is GetTeacherAssignedSubjectsSuccess
            ? state.response.data.subjects
            : <TeacherAssignedSubjectModel>[];
        final subjectIds = subjects.map((item) => item.id).toList();
        final selectedSubjectId =
            subjectIds.contains(createCubit.selectedSubjectId)
            ? createCubit.selectedSubjectId
            : null;
        final canSelect =
            createCubit.selectedClassroomId != null &&
            state is GetTeacherAssignedSubjectsSuccess &&
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
                  if (subjectId == null) {
                    createCubit.changeClassroomSubject(
                      subjectId: null,
                      classroomSubjectId: null,
                    );
                    return;
                  }

                  final selectedSubject = subjects.firstWhere(
                    (subject) => subject.id == subjectId,
                  );
                  createCubit.changeClassroomSubject(
                    subjectId: selectedSubject.id,
                    classroomSubjectId: selectedSubject.classroomSubjectId,
                  );
                },
        );
      },
    );
  }

  String _hint(
    BuildContext context,
    GetTeacherAssignedSubjectsState state,
    List<TeacherAssignedSubjectModel> subjects,
    bool hasClassroom,
  ) {
    if (!hasClassroom) return S.of(context).selectClassroomFirst;
    if (state is GetTeacherAssignedSubjectsLoading) {
      return S.of(context).loading;
    }
    if (state is GetTeacherAssignedSubjectsFailure) {
      return S.of(context).unexpectedError;
    }
    if (state is GetTeacherAssignedSubjectsSuccess && subjects.isEmpty) {
      return S.of(context).noAssignedSubjectsForClassroom;
    }
    return S.of(context).chooseSubject;
  }
}
