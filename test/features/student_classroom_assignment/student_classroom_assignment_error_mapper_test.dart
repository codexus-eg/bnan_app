import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/student_classroom_assignment/presentation/policies/student_classroom_assignment_error_mapper.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() => S.load(const Locale('ar')));

  test('maps classroom business codes to localized messages', () {
    expect(
      _map('STUDENT_NOT_APPROVED', statusCode: 403),
      'لا يمكن تعيين هذا الطالب لأنه لم يتم اعتماد حسابه بعد',
    );
    expect(_map('NO_AVAILABLE_CLASSROOMS'), 'لا توجد فصول متاحة لهذا الطالب');
    expect(_map('STUDENT_ALREADY_ASSIGNED'), 'هذا الطالب مُعيّن بالفعل');
  });

  test('maps authorization, network and unknown failures safely', () {
    expect(_map('TOKEN_EXPIRED', statusCode: 401), contains('انتهت الجلسة'));
    expect(_map('network', responseReceived: false), contains('الإنترنت'));
    expect(_map('TECHNICAL_CODE'), 'تعذر تحميل الفصول، حاول مرة أخرى');
  });
}

String _map(String code, {int? statusCode, bool responseReceived = true}) =>
    mapStudentClassroomsFailure(
      Failure(
        message: code,
        code: code,
        statusCode: statusCode,
        responseReceived: responseReceived,
      ),
    );
