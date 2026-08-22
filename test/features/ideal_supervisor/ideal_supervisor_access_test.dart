import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/features/ideal_supervisor/presentation/policies/ideal_supervisor_access_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('only admins can access ideal supervisor selection', () {
    expect(IdealSupervisorAccessPolicy.canAccess(UserRole.admin), isTrue);
    expect(IdealSupervisorAccessPolicy.canAccess(UserRole.supervisor), isFalse);
    expect(IdealSupervisorAccessPolicy.canAccess(UserRole.teacher), isFalse);
    expect(IdealSupervisorAccessPolicy.canAccess(UserRole.student), isFalse);
    expect(IdealSupervisorAccessPolicy.canAccess(UserRole.parent), isFalse);
    expect(IdealSupervisorAccessPolicy.canAccess(null), isFalse);
  });
}
