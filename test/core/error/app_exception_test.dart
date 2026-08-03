import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() => S.load(const Locale('en')));

  const backendMessage =
      'يوجد معلم معيّن بالفعل لهذا الفصل الخليجي. يجب إلغاء تعيين المعلم '
      'الحالي أولاً قبل تعيين معلم جديد.';

  test('409 uses the non-empty backend message before errors', () {
    final exception = AppException.fromDio(_conflict(backendMessage));
    expect(exception.message, backendMessage);
  });

  test('technical identifiers never become the user-facing message', () {
    final exception = AppException.fromDio(_conflict(null));
    expect(exception.message, isNot('6a39bb71441c9c5929b4ed9c'));
    expect(exception.message, isNot(contains('teacherId')));
  });
}

DioException _conflict(String? message) {
  final request = RequestOptions(path: '/teachers/t/teaching-assignment');
  return DioException(
    requestOptions: request,
    type: DioExceptionType.badResponse,
    response: Response<Map<String, dynamic>>(
      requestOptions: request,
      statusCode: 409,
      data: {
        'status': 'error',
        if (message != null) 'message': message,
        'errors': {
          'teacherId': '6a39bb71441c9c5929b4ed9c',
          'classroomId': 'classroom-id',
          'subjectId': 'subject-id',
          'classroomSubjectId': 'classroom-subject-id',
        },
      },
    ),
  );
}
