import 'package:bnan_app/features/weekly_evaluations/presentation/mappers/evaluation_value_ui_mapper.dart';
import 'package:flutter/widgets.dart';

String readOnlyEvaluationValueLabel(BuildContext context, String? raw) {
  const supported = {
    'present',
    'absent',
    'late',
    'excused',
    'excellent',
    'very_good',
    'good',
    'acceptable',
    'weak',
    '-',
  };
  final value = raw?.trim().toLowerCase() ?? '';
  return supported.contains(value) ? evaluationValueLabel(context, value) : '-';
}
