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
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (!subjects.any((item) => item.isEvaluated)) {
      return const SizedBox.shrink();
    }
    return IconButton(
      visualDensity: VisualDensity.compact,
      tooltip: S.of(context).editEvaluation,
      onPressed: onPressed,
      icon: SvgPicture.asset(ImageManager.edit, width: 18),
    );
  }
}
