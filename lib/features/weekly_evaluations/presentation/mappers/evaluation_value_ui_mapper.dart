import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/widgets.dart';

String evaluationValueLabel(BuildContext context, String value) {
  final s = S.of(context);
  return switch (value) {
    'present' => s.evaluationPresent,
    'absent' => s.evaluationAbsent,
    'late' => s.evaluationLate,
    'excused' => s.evaluationExcused,
    'excellent' => s.excellent,
    'very_good' => s.veryGood,
    'good' => s.good,
    'acceptable' => s.evaluationAcceptable,
    'weak' => s.evaluationWeak,
    '-' => '-',
    _ => value,
  };
}

String evaluationStatusLabel(BuildContext context, bool isEvaluated) {
  final s = S.of(context);
  return isEvaluated ? s.evaluationEvaluated : s.evaluationNotEvaluated;
}

String formatAttendanceWithCount({
  required BuildContext context,
  required String attendanceStatus,
  int? attended,
  int? total,
}) {
  final statusLabel = evaluationValueLabel(context, attendanceStatus);
  if (attended != null && total != null) {
    if (statusLabel.isNotEmpty && statusLabel != '-') {
      return '$statusLabel ($attended/$total)';
    }
    return '$attended/$total';
  }
  return statusLabel;
}
