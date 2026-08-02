import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/mappers/evaluation_value_ui_mapper.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class EvaluationScoreFields extends StatelessWidget {
  const EvaluationScoreFields({
    super.key,
    required this.attendance,
    required this.participation,
    required this.homework,
    required this.behavior,
    required this.onAttendanceChanged,
    required this.onParticipationChanged,
    required this.onHomeworkChanged,
    required this.onBehaviorChanged,
  });
  final String attendance, participation, homework, behavior;
  final ValueChanged<String> onAttendanceChanged, onParticipationChanged;
  final ValueChanged<String> onHomeworkChanged, onBehaviorChanged;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    const performance = [
      'excellent',
      'very_good',
      'good',
      'acceptable',
      'weak',
    ];
    return Column(
      children: [
        _pair(
          context,
          _field(context, s.attendance, attendance, const [
            'present',
            'absent',
            'late',
            'excused',
          ], onAttendanceChanged),
          _field(
            context,
            s.participation,
            participation,
            performance,
            onParticipationChanged,
          ),
        ),
        const SizedBox(height: 16),
        _pair(
          context,
          _field(
            context,
            s.assignments,
            homework,
            performance,
            onHomeworkChanged,
          ),
          _field(context, s.behavior, behavior, performance, onBehaviorChanged),
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
    BuildContext context,
    String label,
    String value,
    List<String> options,
    ValueChanged<String> onChanged,
  ) {
    return CustomDropdown(
      label: label,
      value: value,
      hint: label,
      items: options,
      itemsLabels: {
        for (final option in options)
          option: evaluationValueLabel(context, option),
      },
      isRequired: true,
      backgroundColor: ColorManager.white,
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}
