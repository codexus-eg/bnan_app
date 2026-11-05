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

String formatReadOnlyAttendance({
  required BuildContext context,
  String? attendanceStatus,
  int? attended,
  int? total,
}) {
  final statusLabel = readOnlyEvaluationValueLabel(context, attendanceStatus);
  if (attended != null && total != null) {
    if (statusLabel.isNotEmpty && statusLabel != '-') {
      return '$statusLabel ($attended/$total)';
    }
    return '$attended/$total';
  }
  return statusLabel;
}
