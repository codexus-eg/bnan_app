import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/policies/ideal_teacher_access_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('only supervisor and admin can access ideal teacher ranking page while teacher is restricted', () {
    expect(IdealTeacherAccessPolicy.canAccess(UserRole.supervisor), isTrue);
    expect(IdealTeacherAccessPolicy.canAccess(UserRole.admin), isTrue);
    for (final role in [
      UserRole.teacher,
      UserRole.student,
      UserRole.parent,
      null,
    ]) {
      expect(IdealTeacherAccessPolicy.canAccess(role), isFalse);
    }
  });

  test('only supervisor and admin can modify points while teacher is read-only', () {
    expect(IdealTeacherAccessPolicy.canModify(UserRole.supervisor), isTrue);
    expect(IdealTeacherAccessPolicy.canModify(UserRole.admin), isTrue);
    expect(IdealTeacherAccessPolicy.canModify(UserRole.teacher), isFalse);
    expect(IdealTeacherAccessPolicy.canModify(UserRole.student), isFalse);
    expect(IdealTeacherAccessPolicy.canModify(null), isFalse);
  });

  test('supervisor and admin can select teachers and issue ideal teacher certificates', () {
    expect(
      IdealTeacherAccessPolicy.canSelectTeachers(UserRole.supervisor),
      isTrue,
    );
    expect(
      IdealTeacherAccessPolicy.canSelectTeachers(UserRole.admin),
      isTrue,
    );
    expect(
      IdealTeacherAccessPolicy.canSelectTeachers(UserRole.teacher),
      isFalse,
    );
    expect(
      IdealTeacherAccessPolicy.canIssueCertificate(UserRole.supervisor),
      isTrue,
    );
    expect(
      IdealTeacherAccessPolicy.canIssueCertificate(UserRole.admin),
      isTrue,
    );
    expect(
      IdealTeacherAccessPolicy.canIssueCertificate(UserRole.teacher),
      isFalse,
    );
    expect(
      IdealTeacherAccessPolicy.canIssueCertificate(null),
      isFalse,
    );
  });
}

