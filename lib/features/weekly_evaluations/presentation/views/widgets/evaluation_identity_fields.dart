import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/evaluation_subject_model.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/models/evaluation_dialog_context.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class EvaluationIdentityFields extends StatelessWidget {
  const EvaluationIdentityFields({
    super.key,
    required this.data,
    required this.studentId,
    required this.subjectId,
    required this.subjects,
    required this.onStudentChanged,
    required this.onSubjectChanged,
  });
  final EvaluationDialogContext data;
  final String? studentId, subjectId;
  final List<EvaluationSubjectModel> subjects;
  final ValueChanged<String?> onStudentChanged, onSubjectChanged;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      children: [
        data.isEdit ? _fixed(s.student, studentId!, _studentName) : _student(s),
        const SizedBox(height: 12),
        _fixed(s.classRoom, data.classroomId, data.classroomName),
        const SizedBox(height: 12),
        data.isEdit ? _fixed(s.subject, subjectId!, _subjectName) : _subject(s),
        const SizedBox(height: 12),
        _fixed(s.week, '${data.week}', '${s.week} ${data.week}'),
      ],
    );
  }

  Widget _student(S s) => CustomDropdown(
    label: s.student,
    value: studentId,
    hint: s.selectStudent,
    items: data.students.map((item) => item.id).toList(),
    itemsLabels: {for (final item in data.students) item.id: item.fullName},
    isRequired: true,
    backgroundColor: ColorManager.white,
    onChanged: onStudentChanged,
  );

  Widget _subject(S s) => CustomDropdown(
    label: s.subject,
    value: subjectId,
    hint: s.selectSubject,
    items: subjects.map((item) => item.id).toList(),
    itemsLabels: {for (final item in subjects) item.id: item.name},
    isRequired: true,
    backgroundColor: ColorManager.white,
    onChanged: onSubjectChanged,
  );

  Widget _fixed(String label, String value, String displayed) => CustomDropdown(
    label: label,
    value: null,
    hint: displayed,
    items: null,
    isRequired: true,
    backgroundColor: ColorManager.white,
    onChanged: null,
  );

  String get _studentName => data.editor!.studentName;
  String get _subjectName => data.editor!.subject.name;
}
