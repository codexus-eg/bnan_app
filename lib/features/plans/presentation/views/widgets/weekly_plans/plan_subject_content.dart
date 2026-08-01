import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_subject_ui_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PlanSubjectContent extends StatelessWidget {
  const PlanSubjectContent({super.key, required this.subject});

  final PlanSubjectUiModel subject;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _contentLine(context, s.lessonLabel, subject.lesson),
        const SizedBox(height: 6),
        _contentLine(context, s.homeworkLabel, subject.homework),
      ],
    );
  }

  Widget _contentLine(BuildContext context, String label, String value) {
    final color = ColorManager.mainColor14;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: StylesManager.styleBold10(
              context,
            ).copyWith(color: color, height: 1.35),
          ),
          TextSpan(
            text: value,
            style: StylesManager.styleRegular10(
              context,
            ).copyWith(color: color, height: 1.35),
          ),
        ],
      ),
      softWrap: true,
    );
  }
}
