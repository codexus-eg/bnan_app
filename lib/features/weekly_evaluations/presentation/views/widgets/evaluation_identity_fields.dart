import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/evaluation_subject_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/weekly_evaluations_response_model.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/models/evaluation_dialog_context.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EvaluationIdentityFields extends StatelessWidget {
  const EvaluationIdentityFields({
    super.key,
    required this.data,
    required this.classroomId,
    required this.studentId,
    required this.subjectId,
    required this.students,
    required this.subjects,
    required this.weekController,
    required this.emptySubjectsMessage,
    required this.showAvailabilityMessages,
    required this.onClassroomChanged,
    required this.onStudentChanged,
    required this.onSubjectChanged,
    required this.onWeekChanged,
  });

  final EvaluationDialogContext data;
  final String? classroomId, studentId, subjectId;
  final List<WeeklyEvaluationStudentModel> students;
  final List<EvaluationSubjectModel> subjects;
  final TextEditingController weekController;
  final String emptySubjectsMessage;
  final bool showAvailabilityMessages;
  final ValueChanged<String?> onClassroomChanged;
  final ValueChanged<String?> onStudentChanged, onSubjectChanged;
  final ValueChanged<String> onWeekChanged;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      children: [
        data.isEdit ? _fixed(s.classRoom, data.classroomName) : _classroom(s),
        const SizedBox(height: 12),
        data.isEdit ? _fixed(s.student, data.editor!.studentName) : _student(s),
        if (showAvailabilityMessages &&
            !data.isEdit &&
            classroomId != null &&
            students.isEmpty)
          _message(s.noStudentsInClass),
        const SizedBox(height: 12),
        data.isEdit
            ? _fixed(s.subject, data.editor!.subject.name)
            : _subject(s),
        if (showAvailabilityMessages &&
            !data.isEdit &&
            studentId != null &&
            subjects.isEmpty)
          _message(emptySubjectsMessage),
        const SizedBox(height: 12),
        CustomTextField(
          label: s.week,
          controller: weekController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: onWeekChanged,
          isRequired: true,
          backgroundColor: ColorManager.white,
          validator: (value) {
            final week = int.tryParse(value ?? '');
            return week != null && week > 0 ? null : s.positiveWeekRequired;
          },
        ),
      ],
    );
  }

  Widget _classroom(S s) => CustomDropdown(
    label: s.classRoom,
    value: classroomId,
    hint: s.selectClassroom,
    items: data.classrooms.map((item) => item.id).toList(),
    itemsLabels: {for (final item in data.classrooms) item.id: item.name},
    isRequired: true,
    backgroundColor: ColorManager.white,
    onChanged: onClassroomChanged,
  );

  Widget _student(S s) => CustomDropdown(
    label: s.student,
    value: studentId,
    hint: s.selectStudent,
    items: classroomId == null ? null : students.map((e) => e.id).toList(),
    itemsLabels: {for (final item in students) item.id: item.fullName},
    isRequired: true,
    backgroundColor: ColorManager.white,
    onChanged: onStudentChanged,
  );

  Widget _subject(S s) => CustomDropdown(
    label: s.subject,
    value: subjectId,
    hint: s.selectSubject,
    items: studentId == null ? null : subjects.map((e) => e.id).toList(),
    itemsLabels: {for (final item in subjects) item.id: item.name},
    isRequired: true,
    backgroundColor: ColorManager.white,
    onChanged: onSubjectChanged,
  );

  Widget _fixed(String label, String displayed) => CustomDropdown(
    label: label,
    hint: displayed,
    items: null,
    isRequired: true,
    backgroundColor: ColorManager.white,
    onChanged: null,
  );

  Widget _message(String text) => Padding(
    padding: const EdgeInsetsDirectional.only(top: 8),
    child: Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text(text),
    ),
  );
}
