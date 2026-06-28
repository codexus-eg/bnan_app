import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/weekly_evaluation_model.dart';
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
  String? selectedClass;

  @override
  void initState() {
    super.initState();
    selectedStudent = widget.evaluation?.studentName;
    selectedClass = widget.evaluation?.classLabel;
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Column(
      children: [
        CustomDropdown(
          label: s.student,
          backgroundColor: ColorManager.white,
          isRequired: true,
          value: selectedStudent,
          items: const ['شهد أحمد', 'محمد جمال'],
          onChanged: (value) {
            setState(() => selectedStudent = value);
          },
        ),
        const SizedBox(height: 16),
        CustomDropdown(
          label: s.classRoom,
          isRequired: true,
          value: selectedClass,
          hint: s.chooseClassRoom,
          items: const ['الصف الثالث الإعدادي', 'الصف الثاني الإعدادي'],
          onChanged: (value) {
            setState(() => selectedClass = value);
          },
        ),
      ],
    );
  }
}