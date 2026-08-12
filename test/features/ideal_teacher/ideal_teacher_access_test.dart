import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/policies/ideal_teacher_access_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('only supervisors can access ideal teacher selection', () {
    expect(IdealTeacherAccessPolicy.canAccess(UserRole.supervisor), isTrue);
    for (final role in [
      UserRole.admin,
      UserRole.teacher,
      UserRole.student,
      UserRole.parent,
      null,
    ]) {
      expect(IdealTeacherAccessPolicy.canAccess(role), isFalse);
    }
  });
}
