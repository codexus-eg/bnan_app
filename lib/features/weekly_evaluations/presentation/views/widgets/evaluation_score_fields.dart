import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/mappers/evaluation_value_ui_mapper.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/models/evaluation_options.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class EvaluationScoreFields extends StatelessWidget {
  const EvaluationScoreFields({
    super.key,
    this.attendance,
    required this.participation,
    this.homework,
    required this.behavior,
    this.onAttendanceChanged,
    required this.onParticipationChanged,
    this.onHomeworkChanged,
    required this.onBehaviorChanged,
  });
  final String? attendance, participation, homework, behavior;
  final ValueChanged<String>? onAttendanceChanged;
  final ValueChanged<String> onParticipationChanged;
  final ValueChanged<String>? onHomeworkChanged;
  final ValueChanged<String> onBehaviorChanged;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      children: [
        _pair(
          context,
          _field(
            context,
            s.attendance,
            null,
            const [],
            null,
            isRequired: false,
            enabled: false,
            hint: s.calculatedAutomatically,
          ),
          _field(
            context,
            s.participation,
            participation,
            EvaluationOptions.performance,
            onParticipationChanged,
          ),
        ),
        const SizedBox(height: 16),
        _pair(
          context,
          _field(
            context,
            s.homeworkLabel,
            null,
            const [],
            null,
            isRequired: false,
            enabled: false,
            hint: s.calculatedAutomatically,
          ),
          _field(
            context,
            s.behavior,
            behavior,
            EvaluationOptions.performance,
            onBehaviorChanged,
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
    BuildContext context,
    String label,
    String? value,
    List<String> options,
    ValueChanged<String>? onChanged, {
    bool isRequired = true,
    bool enabled = true,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: StylesManager.styleBold14(
              context,
            ).copyWith(color: ColorManager.mainColor15),
            children: [
              if (isRequired)
                const TextSpan(text: '*', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        CustomDropdown(
          label: label,
          value: value,
          hint: hint ?? label,
          items: options,
          itemsLabels: {
            for (final option in options)
              option: evaluationValueLabel(context, option),
          },
          isRequired: isRequired,
          enabled: enabled,
          showLabel: false,
          backgroundColor: ColorManager.white,
          onChanged: (value) {
            if (value != null && onChanged != null) onChanged(value);
          },
        ),
      ],
    );
  }
}
