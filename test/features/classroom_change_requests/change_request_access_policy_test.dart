import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/features/classroom_change_requests/presentation/policies/change_request_access_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final item in const [
    ('Gulf', 'private', true, true),
    ('Egyptian private', 'private', true, true),
    ('Egyptian group', 'shared_group', false, false),
  ]) {
    test('${item.$1} eligibility matrix', () {
      expect(_can(UserRole.student, item.$2, true), item.$3);
      expect(_can(UserRole.teacher, item.$2, true), item.$4);
    });
  }

  test('shared group stays hidden for a teacher with a true backend flag', () {
    expect(_can(UserRole.teacher, 'shared_group', true), isFalse);
  });

  test('missing metadata is hidden safely', () {
    expect(_can(UserRole.student, null, null), isFalse);
    expect(_can(UserRole.teacher, null, null), isFalse);
  });

  test('ambiguous classroom subject hides teacher action', () {
    expect(_can(UserRole.teacher, 'private', true, ambiguous: true), isFalse);
  });
}

bool _can(
  UserRole role,
  String? scope,
  bool? withdrawal, {
  bool ambiguous = false,
}) => ChangeRequestAccessPolicy.canShow(
  role: role,
  roomType: 'classroom',
  accessScope: scope,
  classroomSubjectId: 'subject-id',
  canRequestTeacherWithdrawal: withdrawal,
  classroomSubjectAmbiguous: ambiguous,
);
