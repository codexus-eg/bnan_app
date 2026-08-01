import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/weekly_evaluation_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class EvaluationScoreFields extends StatefulWidget {
  const EvaluationScoreFields({super.key, this.evaluation});

  final WeeklyEvaluationModel? evaluation;

  @override
  State<EvaluationScoreFields> createState() => _EvaluationScoreFieldsState();
}

class _EvaluationScoreFieldsState extends State<EvaluationScoreFields> {
  String? attendance;
  String? participation;
  String? assignments;
  String? behavior;

  @override
  void initState() {
    super.initState();
    attendance = widget.evaluation?.attendance;
    participation = widget.evaluation?.participation;
    assignments = widget.evaluation?.assignments;
    behavior = widget.evaluation?.behavior;
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final scores = [s.excellent, s.veryGood, s.good];
    return Column(
      children: [
        _pair(
          context,
          _field(s.attendance, attendance, [
            ...scores,
            s.absent,
          ], (value) => setState(() => attendance = value)),
          _field(
            s.participation,
            participation,
            scores,
            (value) => setState(() => participation = value),
          ),
        ),
        const SizedBox(height: 16),
        _pair(
          context,
          _field(
            s.assignments,
            assignments,
            scores,
            (value) => setState(() => assignments = value),
          ),
          _field(
            s.behavior,
            behavior,
            scores,
            (value) => setState(() => behavior = value),
          ),
        ),
      ],
    );
  }

  Widget _pair(BuildContext context, Widget first, Widget second) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 300) {
          return Column(children: [first, const SizedBox(height: 16), second]);
        }
        return Row(
          children: [
            Expanded(child: first),
            const SizedBox(width: 12),
            Expanded(child: second),
          ],
        );
      },
    );
  }

  Widget _field(
    String label,
    String? value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    final items = {if (value != null) value, ...options}.toList();
    return CustomDropdown(
      label: label,
      value: value,
      hint: label,
      items: items,
      isRequired: true,
      backgroundColor: ColorManager.white,
      onChanged: onChanged,
    );
  }
}
