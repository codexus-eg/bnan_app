import 'package:bnan_app/core/network/end_points.dart';
import 'package:flutter/foundation.dart';

void logReadOnlyEvaluationsRequest({
  required String role,
  String? studentProfileId,
  String? userId,
  int? week,
}) {
  assert(() {
    final keys = [
      if (studentProfileId?.isNotEmpty == true) 'studentId',
      if (week != null) 'week',
    ];
    debugPrint(
      'Weekly evaluations request: role=$role, '
      'studentProfileId=$studentProfileId, userId=$userId, week=$week, '
      'endpoint=${EndPoints.myEvaluations}, queryKeys=$keys',
    );
    return true;
  }());
}
