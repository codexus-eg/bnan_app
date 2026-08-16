import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/add_classroom_subject/presentation/manager/add_classroom_subject_cubit.dart';
import 'package:bnan_app/features/add_classroom_subject/presentation/manager/add_classroom_subject_state.dart';
import 'package:bnan_app/features/add_classroom_subject/presentation/views/widgets/add_classroom_subject_dropdown.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddClassroomSubjectForm extends StatelessWidget {
  const AddClassroomSubjectForm({super.key, required this.state});

  final AddClassroomSubjectState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddClassroomSubjectCubit>();
    final s = S.of(context);
    final available = state.availableSubjects;
    return Column(
      children: [
        AddClassroomSubjectDropdown(
          label: s.curriculum,
          hint: s.chooseNewCurriculum,
          items: state.curriculums.map((item) => item.id).toList(),
          labels: {for (final item in state.curriculums) item.id: item.name},
          value: state.selectedCurriculum?.id,
          loading: state.loadingCurriculums,
          enabled: !state.submitting,
          onChanged: (id) => cubit.selectCurriculum(
            state.curriculums.where((item) => item.id == id).firstOrNull,
          ),
        ),
        const SizedBox(height: 16),
        AddClassroomSubjectDropdown(
          label: s.grade,
          hint: s.selectGrade,
          items: state.grades.map((item) => item.id).toList(),
          labels: {for (final item in state.grades) item.id: item.name},
          value: state.selectedGrade?.id,
          loading: state.loadingGrades,
          enabled: state.selectedCurriculum != null && !state.submitting,
          onChanged: (id) => cubit.selectGrade(
            state.grades.where((item) => item.id == id).firstOrNull,
          ),
        ),
        const SizedBox(height: 16),
        AddClassroomSubjectDropdown(
          label: s.classRoom,
          hint: s.chooseClassRoom,
          items: state.classrooms.map((item) => item.id).toList(),
          labels: {for (final item in state.classrooms) item.id: item.name},
          value: state.selectedClassroom?.id,
          loading: state.loadingClassrooms,
          enabled: state.selectedGrade != null && !state.submitting,
          onChanged: (id) => cubit.selectClassroom(
            state.classrooms.where((item) => item.id == id).firstOrNull,
          ),
        ),
        const SizedBox(height: 16),
        AddClassroomSubjectDropdown(
          label: s.subject,
          hint: s.chooseSubject,
          items: available.map((item) => item.id).toList(),
          labels: {for (final item in available) item.id: item.name},
          value: state.selectedSubject?.id,
          loading: state.loadingGradeSubjects || state.loadingClassroomSubjects,
          enabled: state.selectedClassroom != null && !state.submitting,
          onChanged: (id) => cubit.selectSubject(
            available.where((item) => item.id == id).firstOrNull,
          ),
        ),
        if (_allAdded) ...[
          const SizedBox(height: 8),
          Text(
            s.allGradeSubjectsAddedToClassroom,
            style: StylesManager.styleRegular12(
              context,
            ).copyWith(color: ColorManager.mainColor14),
          ),
        ],
        if (state.lookupError != null) ...[
          const SizedBox(height: 8),
          Text(
            state.lookupError!,
            style: StylesManager.styleRegular12(
              context,
            ).copyWith(color: ColorManager.red),
          ),
        ],
        const SizedBox(height: 24),
        CustomAppButton(
          text: s.addSubject,
          isLoading: state.submitting,
          onPressed: state.canSubmit ? cubit.submit : null,
        ),
      ],
    );
  }

  bool get _allAdded =>
      state.selectedClassroom != null &&
      !state.loadingGradeSubjects &&
      !state.loadingClassroomSubjects &&
      state.gradeSubjects.isNotEmpty &&
      state.availableSubjects.isEmpty;
}
