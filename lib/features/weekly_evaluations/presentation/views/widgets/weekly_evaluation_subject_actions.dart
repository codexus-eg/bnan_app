import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/evaluation_subject_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WeeklyEvaluationSubjectActions extends StatelessWidget {
  const WeeklyEvaluationSubjectActions({
    super.key,
    required this.subjects,
    required this.onPressed,
  });
  final List<EvaluationSubjectModel> subjects;
  final ValueChanged<EvaluationSubjectModel> onPressed;

  @override
  Widget build(BuildContext context) {
    final evaluated = subjects.where((item) => item.isEvaluated);
    return Wrap(
      spacing: 2,
      children: evaluated.map((subject) {
        return IconButton(
          visualDensity: VisualDensity.compact,
          tooltip: '${S.of(context).editEvaluation} - ${subject.name}',
          onPressed: () => onPressed(subject),
          icon: SvgPicture.asset(ImageManager.edit, width: 18),
        );
      }).toList(),
    );
  }
}
