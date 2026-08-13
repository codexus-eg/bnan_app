import 'package:bnan_app/core/helper/validator_form_field.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown_form_field.dart';
import 'package:bnan_app/features/plans/presentation/policies/plans_access_policy.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_classroom_option.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plan_date_field.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_classroom_subjects/get_classroom_subjects_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_classroom_subjects/get_classroom_subjects_state.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_assigned_subjects/get_teacher_assigned_subjects_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_assigned_subjects/get_teacher_assigned_subjects_state.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classroom_details_cubit/classroom_details_cubit.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classroom_details_cubit/classroom_details_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddDailyPlanSelectFields extends StatelessWidget {
  const AddDailyPlanSelectFields({
    super.key,
    required this.policy,
    required this.classroom,
    required this.dateController,
    required this.selectedDate,
    required this.onDateChanged,
    required this.onTeacherChanged,
    required this.onSubjectChanged,
  });

  final PlansAccessPolicy policy;
  final PlanClassroomOption classroom;
  final TextEditingController dateController;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<String?> onTeacherChanged;
  final ValueChanged<String?> onSubjectChanged;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final subjects = _subjects(context);
    return Column(
      children: [
        CustomDropdownFormField(
          label: s.classRoom,
          value: classroom.id,
          hint: s.chooseClassRoom,
          items: [classroom.id],
          itemsLabels: {classroom.id: classroom.name},
          isRequired: true,
          onChanged: (_) {},
        ),
        if (policy.showTeacherFieldInAddDialog) ...[
          const SizedBox(height: 12),
          _dropdown(
            s.teacher,
            _teachers(context).$1,
            onTeacherChanged,
            _teachers(context).$2,
          ),
        ],
        const SizedBox(height: 12),
        PlanDateField(
          controller: dateController,
          selectedDate: selectedDate,
          onDateChanged: onDateChanged,
        ),
        const SizedBox(height: 12),
        _dropdown(s.subject, subjects.$1, onSubjectChanged, subjects.$2),
      ],
    );
  }

  (String, Map<String, String>) _subjects(BuildContext context) {
    final s = S.of(context);
    if (policy.usesClassroomSubjectsInAddDialog) {
      final state = context.watch<GetClassroomSubjectsCubit>().state;
      if (state is GetClassroomSubjectsLoading) return (s.loading, const {});
      if (state is GetClassroomSubjectsFailure) {
        return (state.errorMessage, const {});
      }
      final items = state is GetClassroomSubjectsSuccess
          ? state.classroomSubjects.subjects
          : const [];
      return (s.selectSubject, {for (final item in items) item.id: item.name});
    }
    final state = context.watch<GetTeacherAssignedSubjectsCubit>().state;
    if (state is GetTeacherAssignedSubjectsLoading) {
      return (s.loading, const {});
    }
    if (state is GetTeacherAssignedSubjectsFailure) {
      return (state.errorMessage, const {});
    }
    final items = state is GetTeacherAssignedSubjectsSuccess
        ? state.response.data.subjects
        : const [];
    return (s.selectSubject, {for (final item in items) item.id: item.name});
  }

  (String, Map<String, String>) _teachers(BuildContext context) {
    final state = context.watch<ClassroomDetailsCubit>().state;
    if (state is ClassroomDetailsLoading) {
      return (S.of(context).loading, const {});
    }
    if (state is ClassroomDetailsFailure) return (state.message, const {});
    final teachers = state is ClassroomDetailsSuccess
        ? state.response.data.teachers
        : const [];
    return (
      S.of(context).selectTeacher,
      {for (final teacher in teachers) teacher.id: teacher.fullName},
    );
  }

  Widget _dropdown(
    String label,
    String hint,
    ValueChanged<String?> onChanged,
    Map<String, String> labels,
  ) {
    return CustomDropdownFormField(
      label: label,
      hint: hint,
      items: labels.keys.toList(),
      itemsLabels: labels,
      isRequired: true,
      onChanged: onChanged,
      validator: (value) => MyValidator.requiredField(value, label),
    );
  }
}
