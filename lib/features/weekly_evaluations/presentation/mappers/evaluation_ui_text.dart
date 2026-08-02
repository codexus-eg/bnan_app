import 'package:flutter/widgets.dart';

abstract final class EvaluationUiText {
  static bool _ar(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar';

  static String studentTitle(BuildContext context, String name) => _ar(context)
      ? '\u0627\u0644\u0637\u0627\u0644\u0628/\u0629: $name'
      : 'Student: $name';

  static String noWeeks(BuildContext context) => _ar(context)
      ? '\u0644\u0627 \u062a\u0648\u062c\u062f \u0623\u0633\u0627\u0628\u064a\u0639 \u0645\u062a\u0627\u062d\u0629 \u0644\u0644\u062a\u0642\u064a\u064a\u0645'
      : 'No evaluation weeks are available';

  static String noWeekEvaluations(BuildContext context) => _ar(context)
      ? '\u0644\u0627 \u062a\u0648\u062c\u062f \u062a\u0642\u064a\u064a\u0645\u0627\u062a \u0644\u0647\u0630\u0627 \u0627\u0644\u0623\u0633\u0628\u0648\u0639'
      : 'No evaluations for this week';

  static String noStudentEvaluation(BuildContext context) => _ar(context)
      ? '\u0644\u0627 \u064a\u0648\u062c\u062f \u062a\u0642\u064a\u064a\u0645 \u0644\u0647\u0630\u0627 \u0627\u0644\u0637\u0627\u0644\u0628'
      : 'No evaluation for this student';

  static String saved(BuildContext context) => _ar(context)
      ? '\u062a\u0645 \u062d\u0641\u0638 \u0627\u0644\u062a\u0642\u064a\u064a\u0645 \u0628\u0646\u062c\u0627\u062d'
      : 'Evaluation saved successfully';
}
