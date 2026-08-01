import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/weekly_evaluation_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/weekly_evaluations_dummy_data.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class WeeklyEvaluationSelectFields extends StatefulWidget {
  const WeeklyEvaluationSelectFields({super.key, this.evaluation});

  final WeeklyEvaluationModel? evaluation;

  @override
  State<WeeklyEvaluationSelectFields> createState() =>
      _WeeklyEvaluationSelectFieldsState();
}

class _WeeklyEvaluationSelectFieldsState
    extends State<WeeklyEvaluationSelectFields> {
  String? selectedStudent;
  String? selectedClassroom;
  String? selectedSubject;

  @override
  void initState() {
    super.initState();
    selectedStudent = widget.evaluation?.studentName;
    selectedClassroom = widget.evaluation?.classLabel;
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      children: [
        _dropdown(
          label: s.student,
          value: selectedStudent,
          hint: s.selectStudent,
          items: _students,
          onChanged: (value) => setState(() => selectedStudent = value),
        ),
        const SizedBox(height: 16),
        _dropdown(
          label: s.classRoom,
          value: selectedClassroom,
          hint: s.chooseClassRoom,
          items: _classrooms,
          onChanged: (value) => setState(() => selectedClassroom = value),
        ),
        const SizedBox(height: 16),
        _dropdown(
          label: s.subject,
          value: selectedSubject,
          hint: s.chooseSubject,
          items: [s.arabic, s.math],
          onChanged: (value) => setState(() => selectedSubject = value),
        ),
      ],
    );
  }

  List<String> get _students => weeklyEvaluationsDummyData
      .map((item) => item.studentName)
      .toSet()
      .toList(growable: false);

  List<String> get _classrooms => weeklyEvaluationsDummyData
      .map((item) => item.classLabel)
      .toSet()
      .toList(growable: false);

  Widget _dropdown({
    required String label,
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return CustomDropdown(
      label: label,
      value: value,
      hint: hint,
      items: items,
      isRequired: true,
      backgroundColor: ColorManager.white,
      onChanged: onChanged,
    );
  }
}
