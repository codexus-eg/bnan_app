import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/classroom_change_requests/presentation/policies/classroom_change_request_error_mapper.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps pending teacher change code to the localized message', () async {
    final failure = Failure(
      message: 'backend message',
      code: 'CHANGE_TEACHER_REQUEST_ALREADY_PENDING',
    );

    await S.load(const Locale('ar'));
    expect(
      mapClassroomChangeRequestFailure(failure),
      'لديك طلب تغيير معلم قيد المراجعة بالفعل',
    );

    await S.load(const Locale('en'));
    expect(
      mapClassroomChangeRequestFailure(failure),
      'You already have a teacher change request under review',
    );
  });

  test('keeps the backend message for unrelated errors', () {
    final failure = Failure(message: 'fallback', code: 'OTHER_CODE');
    expect(mapClassroomChangeRequestFailure(failure), 'fallback');
  });
}
